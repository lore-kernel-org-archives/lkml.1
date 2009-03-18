Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbZCRNAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbZCRNAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757973AbZCRM7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:59:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:58555 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757670AbZCRM7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:59:06 -0400
Date: Wed, 18 Mar 2009 12:57:53 GMT
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, rusty@rustcorp.com.au, sfr@canb.auug.org.au,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, akpm@linux-foundation.org, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <200903111631.29787.rusty@rustcorp.com.au>
References: <200903111631.29787.rusty@rustcorp.com.au>
Subject: [tip:cpus4096] x86: cpumask: update 32-bit APM not to mug current->cpus_allowed
Message-ID: <tip-89bd55d1855f8e9a4e9add8e93f3144d049c469e@git.kernel.org>
Git-Commit-ID: 89bd55d1855f8e9a4e9add8e93f3144d049c469e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 12:57:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89bd55d1855f8e9a4e9add8e93f3144d049c469e
Gitweb:     http://git.kernel.org/tip/89bd55d1855f8e9a4e9add8e93f3144d049c469e
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Wed, 11 Mar 2009 16:31:29 +1030
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 13:51:45 +0100

x86: cpumask: update 32-bit APM not to mug current->cpus_allowed

Impact: cleanup, avoid cpumask games

The APM code wants to run on CPU 0: we create an "on_cpu0" wrapper
which uses work_on_cpu() if we're not already on cpu 0.

This introduces a new failure mode: -ENOMEM, so we add an explicit
err arg and handle Linux-style errnos in apm_err().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
LKML-Reference: <200903111631.29787.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apm_32.c |  248 +++++++++++++++++++++++++++-------------------
 1 files changed, 145 insertions(+), 103 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 10033fe..c1941be 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -466,7 +466,7 @@ static const lookup_t error_table[] = {
  *	@err: APM BIOS return code
  *
  *	Write a meaningful log entry to the kernel log in the event of
- *	an APM error.
+ *	an APM error.  Note that this also handles (negative) kernel errors.
  */
 
 static void apm_error(char *str, int err)
@@ -478,43 +478,14 @@ static void apm_error(char *str, int err)
 			break;
 	if (i < ERROR_COUNT)
 		printk(KERN_NOTICE "apm: %s: %s\n", str, error_table[i].msg);
+	else if (err < 0)
+		printk(KERN_NOTICE "apm: %s: linux error code %i\n", str, err);
 	else
 		printk(KERN_NOTICE "apm: %s: unknown error code %#2.2x\n",
 		       str, err);
 }
 
 /*
- * Lock APM functionality to physical CPU 0
- */
-
-#ifdef CONFIG_SMP
-
-static cpumask_t apm_save_cpus(void)
-{
-	cpumask_t x = current->cpus_allowed;
-	/* Some bioses don't like being called from CPU != 0 */
-	set_cpus_allowed(current, cpumask_of_cpu(0));
-	BUG_ON(smp_processor_id() != 0);
-	return x;
-}
-
-static inline void apm_restore_cpus(cpumask_t mask)
-{
-	set_cpus_allowed(current, mask);
-}
-
-#else
-
-/*
- *	No CPU lockdown needed on a uniprocessor
- */
-
-#define apm_save_cpus()		(current->cpus_allowed)
-#define apm_restore_cpus(x)	(void)(x)
-
-#endif
-
-/*
  * These are the actual BIOS calls.  Depending on APM_ZERO_SEGS and
  * apm_info.allow_ints, we are being really paranoid here!  Not only
  * are interrupts disabled, but all the segment registers (except SS)
@@ -568,16 +539,23 @@ static inline void apm_irq_restore(unsigned long flags)
 #	define APM_DO_RESTORE_SEGS
 #endif
 
+struct apm_bios_call {
+	u32 func;
+	/* In and out */
+	u32 ebx;
+	u32 ecx;
+	/* Out only */
+	u32 eax;
+	u32 edx;
+	u32 esi;
+
+	/* Error: -ENOMEM, or bits 8-15 of eax */
+	int err;
+};
+
 /**
- *	apm_bios_call	-	Make an APM BIOS 32bit call
- *	@func: APM function to execute
- *	@ebx_in: EBX register for call entry
- *	@ecx_in: ECX register for call entry
- *	@eax: EAX register return
- *	@ebx: EBX register return
- *	@ecx: ECX register return
- *	@edx: EDX register return
- *	@esi: ESI register return
+ *	__apm_bios_call - Make an APM BIOS 32bit call
+ *	@_call: pointer to struct apm_bios_call.
  *
  *	Make an APM call using the 32bit protected mode interface. The
  *	caller is responsible for knowing if APM BIOS is configured and
@@ -586,80 +564,142 @@ static inline void apm_irq_restore(unsigned long flags)
  *	flag is loaded into AL.  If there is an error, then the error
  *	code is returned in AH (bits 8-15 of eax) and this function
  *	returns non-zero.
+ *
+ *	Note: this makes the call on the current CPU.
  */
-
-static u8 apm_bios_call(u32 func, u32 ebx_in, u32 ecx_in,
-	u32 *eax, u32 *ebx, u32 *ecx, u32 *edx, u32 *esi)
+static long __apm_bios_call(void *_call)
 {
 	APM_DECL_SEGS
 	unsigned long		flags;
-	cpumask_t		cpus;
 	int			cpu;
 	struct desc_struct	save_desc_40;
 	struct desc_struct	*gdt;
-
-	cpus = apm_save_cpus();
+	struct apm_bios_call	*call = _call;
 
 	cpu = get_cpu();
+	BUG_ON(cpu != 0);
 	gdt = get_cpu_gdt_table(cpu);
 	save_desc_40 = gdt[0x40 / 8];
 	gdt[0x40 / 8] = bad_bios_desc;
 
 	apm_irq_save(flags);
 	APM_DO_SAVE_SEGS;
-	apm_bios_call_asm(func, ebx_in, ecx_in, eax, ebx, ecx, edx, esi);
+	apm_bios_call_asm(call->func, call->ebx, call->ecx,
+			  &call->eax, &call->ebx, &call->ecx, &call->edx,
+			  &call->esi);
 	APM_DO_RESTORE_SEGS;
 	apm_irq_restore(flags);
 	gdt[0x40 / 8] = save_desc_40;
 	put_cpu();
-	apm_restore_cpus(cpus);
 
-	return *eax & 0xff;
+	return call->eax & 0xff;
+}
+
+/* Run __apm_bios_call or __apm_bios_call_simple on CPU 0 */
+static int on_cpu0(long (*fn)(void *), struct apm_bios_call *call)
+{
+	int ret;
+
+	/* Don't bother with work_on_cpu in the common case, so we don't
+	 * have to worry about OOM or overhead. */
+	if (get_cpu() == 0) {
+		ret = fn(call);
+		put_cpu();
+	} else {
+		put_cpu();
+		ret = work_on_cpu(0, fn, call);
+	}
+
+	/* work_on_cpu can fail with -ENOMEM */
+	if (ret < 0)
+		call->err = ret;
+	else
+		call->err = (call->eax >> 8) & 0xff;
+
+	return ret;
 }
 
 /**
- *	apm_bios_call_simple	-	make a simple APM BIOS 32bit call
- *	@func: APM function to invoke
- *	@ebx_in: EBX register value for BIOS call
- *	@ecx_in: ECX register value for BIOS call
- *	@eax: EAX register on return from the BIOS call
+ *	apm_bios_call	-	Make an APM BIOS 32bit call (on CPU 0)
+ *	@call: the apm_bios_call registers.
+ *
+ *	If there is an error, it is returned in @call.err.
+ */
+static int apm_bios_call(struct apm_bios_call *call)
+{
+	return on_cpu0(__apm_bios_call, call);
+}
+
+/**
+ *	__apm_bios_call_simple - Make an APM BIOS 32bit call (on CPU 0)
+ *	@_call: pointer to struct apm_bios_call.
  *
  *	Make a BIOS call that returns one value only, or just status.
  *	If there is an error, then the error code is returned in AH
- *	(bits 8-15 of eax) and this function returns non-zero. This is
- *	used for simpler BIOS operations. This call may hold interrupts
- *	off for a long time on some laptops.
+ *	(bits 8-15 of eax) and this function returns non-zero (it can
+ *	also return -ENOMEM). This is used for simpler BIOS operations.
+ *	This call may hold interrupts off for a long time on some laptops.
+ *
+ *	Note: this makes the call on the current CPU.
  */
-
-static u8 apm_bios_call_simple(u32 func, u32 ebx_in, u32 ecx_in, u32 *eax)
+static long __apm_bios_call_simple(void *_call)
 {
 	u8			error;
 	APM_DECL_SEGS
 	unsigned long		flags;
-	cpumask_t		cpus;
 	int			cpu;
 	struct desc_struct	save_desc_40;
 	struct desc_struct	*gdt;
-
-	cpus = apm_save_cpus();
+	struct apm_bios_call	*call = _call;
 
 	cpu = get_cpu();
+	BUG_ON(cpu != 0);
 	gdt = get_cpu_gdt_table(cpu);
 	save_desc_40 = gdt[0x40 / 8];
 	gdt[0x40 / 8] = bad_bios_desc;
 
 	apm_irq_save(flags);
 	APM_DO_SAVE_SEGS;
-	error = apm_bios_call_simple_asm(func, ebx_in, ecx_in, eax);
+	error = apm_bios_call_simple_asm(call->func, call->ebx, call->ecx,
+					 &call->eax);
 	APM_DO_RESTORE_SEGS;
 	apm_irq_restore(flags);
 	gdt[0x40 / 8] = save_desc_40;
 	put_cpu();
-	apm_restore_cpus(cpus);
 	return error;
 }
 
 /**
+ *	apm_bios_call_simple	-	make a simple APM BIOS 32bit call
+ *	@func: APM function to invoke
+ *	@ebx_in: EBX register value for BIOS call
+ *	@ecx_in: ECX register value for BIOS call
+ *	@eax: EAX register on return from the BIOS call
+ *	@err: bits
+ *
+ *	Make a BIOS call that returns one value only, or just status.
+ *	If there is an error, then the error code is returned in @err
+ *	and this function returns non-zero. This is used for simpler
+ *	BIOS operations.  This call may hold interrupts off for a long
+ *	time on some laptops.
+ */
+static int apm_bios_call_simple(u32 func, u32 ebx_in, u32 ecx_in, u32 *eax,
+				int *err)
+{
+	struct apm_bios_call call;
+	int ret;
+
+	call.func = func;
+	call.ebx = ebx_in;
+	call.ecx = ecx_in;
+
+	ret = on_cpu0(__apm_bios_call_simple, &call);
+	*eax = call.eax;
+	*err = call.err;
+	return ret;
+}
+
+/**
  *	apm_driver_version	-	APM driver version
  *	@val:	loaded with the APM version on return
  *
@@ -678,9 +718,10 @@ static u8 apm_bios_call_simple(u32 func, u32 ebx_in, u32 ecx_in, u32 *eax)
 static int apm_driver_version(u_short *val)
 {
 	u32 eax;
+	int err;
 
-	if (apm_bios_call_simple(APM_FUNC_VERSION, 0, *val, &eax))
-		return (eax >> 8) & 0xff;
+	if (apm_bios_call_simple(APM_FUNC_VERSION, 0, *val, &eax, &err))
+		return err;
 	*val = eax;
 	return APM_SUCCESS;
 }
@@ -701,22 +742,21 @@ static int apm_driver_version(u_short *val)
  *	that APM 1.2 is in use. If no messges are pending the value 0x80
  *	is returned (No power management events pending).
  */
-
 static int apm_get_event(apm_event_t *event, apm_eventinfo_t *info)
 {
-	u32 eax;
-	u32 ebx;
-	u32 ecx;
-	u32 dummy;
+	struct apm_bios_call call;
 
-	if (apm_bios_call(APM_FUNC_GET_EVENT, 0, 0, &eax, &ebx, &ecx,
-			  &dummy, &dummy))
-		return (eax >> 8) & 0xff;
-	*event = ebx;
+	call.func = APM_FUNC_GET_EVENT;
+	call.ebx = call.ecx = 0;
+
+	if (apm_bios_call(&call))
+		return call.err;
+
+	*event = call.ebx;
 	if (apm_info.connection_version < 0x0102)
 		*info = ~0; /* indicate info not valid */
 	else
-		*info = ecx;
+		*info = call.ecx;
 	return APM_SUCCESS;
 }
 
@@ -737,9 +777,10 @@ static int apm_get_event(apm_event_t *event, apm_eventinfo_t *info)
 static int set_power_state(u_short what, u_short state)
 {
 	u32 eax;
+	int err;
 
-	if (apm_bios_call_simple(APM_FUNC_SET_STATE, what, state, &eax))
-		return (eax >> 8) & 0xff;
+	if (apm_bios_call_simple(APM_FUNC_SET_STATE, what, state, &eax, &err))
+		return err;
 	return APM_SUCCESS;
 }
 
@@ -770,6 +811,7 @@ static int apm_do_idle(void)
 	u8 ret = 0;
 	int idled = 0;
 	int polling;
+	int err;
 
 	polling = !!(current_thread_info()->status & TS_POLLING);
 	if (polling) {
@@ -782,7 +824,7 @@ static int apm_do_idle(void)
 	}
 	if (!need_resched()) {
 		idled = 1;
-		ret = apm_bios_call_simple(APM_FUNC_IDLE, 0, 0, &eax);
+		ret = apm_bios_call_simple(APM_FUNC_IDLE, 0, 0, &eax, &err);
 	}
 	if (polling)
 		current_thread_info()->status |= TS_POLLING;
@@ -797,8 +839,7 @@ static int apm_do_idle(void)
 		 * Only report the failure the first 5 times.
 		 */
 		if (++t < 5) {
-			printk(KERN_DEBUG "apm_do_idle failed (%d)\n",
-			       (eax >> 8) & 0xff);
+			printk(KERN_DEBUG "apm_do_idle failed (%d)\n", err);
 			t = jiffies;
 		}
 		return -1;
@@ -816,9 +857,10 @@ static int apm_do_idle(void)
 static void apm_do_busy(void)
 {
 	u32 dummy;
+	int err;
 
 	if (clock_slowed || ALWAYS_CALL_BUSY) {
-		(void)apm_bios_call_simple(APM_FUNC_BUSY, 0, 0, &dummy);
+		(void)apm_bios_call_simple(APM_FUNC_BUSY, 0, 0, &dummy, &err);
 		clock_slowed = 0;
 	}
 }
@@ -937,7 +979,7 @@ static void apm_power_off(void)
 
 	/* Some bioses don't like being called from CPU != 0 */
 	if (apm_info.realmode_power_off) {
-		(void)apm_save_cpus();
+		set_cpus_allowed_ptr(current, cpumask_of(0));
 		machine_real_restart(po_bios_call, sizeof(po_bios_call));
 	} else {
 		(void)set_system_power_state(APM_STATE_OFF);
@@ -956,12 +998,13 @@ static void apm_power_off(void)
 static int apm_enable_power_management(int enable)
 {
 	u32 eax;
+	int err;
 
 	if ((enable == 0) && (apm_info.bios.flags & APM_BIOS_DISENGAGED))
 		return APM_NOT_ENGAGED;
 	if (apm_bios_call_simple(APM_FUNC_ENABLE_PM, APM_DEVICE_BALL,
-				 enable, &eax))
-		return (eax >> 8) & 0xff;
+				 enable, &eax, &err))
+		return err;
 	if (enable)
 		apm_info.bios.flags &= ~APM_BIOS_DISABLED;
 	else
@@ -986,24 +1029,23 @@ static int apm_enable_power_management(int enable)
 
 static int apm_get_power_status(u_short *status, u_short *bat, u_short *life)
 {
-	u32 eax;
-	u32 ebx;
-	u32 ecx;
-	u32 edx;
-	u32 dummy;
+	struct apm_bios_call call;
+
+	call.func = APM_FUNC_GET_STATUS;
+	call.ebx = APM_DEVICE_ALL;
+	call.ecx = 0;
 
 	if (apm_info.get_power_status_broken)
 		return APM_32_UNSUPPORTED;
-	if (apm_bios_call(APM_FUNC_GET_STATUS, APM_DEVICE_ALL, 0,
-			  &eax, &ebx, &ecx, &edx, &dummy))
-		return (eax >> 8) & 0xff;
-	*status = ebx;
-	*bat = ecx;
+	if (apm_bios_call(&call))
+		return call.err;
+	*status = call.ebx;
+	*bat = call.ecx;
 	if (apm_info.get_power_status_swabinminutes) {
-		*life = swab16((u16)edx);
+		*life = swab16((u16)call.edx);
 		*life |= 0x8000;
 	} else
-		*life = edx;
+		*life = call.edx;
 	return APM_SUCCESS;
 }
 
@@ -1048,12 +1090,14 @@ static int apm_get_battery_status(u_short which, u_short *status,
 static int apm_engage_power_management(u_short device, int enable)
 {
 	u32 eax;
+	int err;
 
 	if ((enable == 0) && (device == APM_DEVICE_ALL)
 	    && (apm_info.bios.flags & APM_BIOS_DISABLED))
 		return APM_DISABLED;
-	if (apm_bios_call_simple(APM_FUNC_ENGAGE_PM, device, enable, &eax))
-		return (eax >> 8) & 0xff;
+	if (apm_bios_call_simple(APM_FUNC_ENGAGE_PM, device, enable,
+				 &eax, &err))
+		return err;
 	if (device == APM_DEVICE_ALL) {
 		if (enable)
 			apm_info.bios.flags &= ~APM_BIOS_DISENGAGED;
@@ -1682,16 +1726,14 @@ static int apm(void *unused)
 	char 		*power_stat;
 	char 		*bat_stat;
 
-#ifdef CONFIG_SMP
 	/* 2002/08/01 - WT
 	 * This is to avoid random crashes at boot time during initialization
 	 * on SMP systems in case of "apm=power-off" mode. Seen on ASUS A7M266D.
 	 * Some bioses don't like being called from CPU != 0.
 	 * Method suggested by Ingo Molnar.
 	 */
-	set_cpus_allowed(current, cpumask_of_cpu(0));
+	set_cpus_allowed_ptr(current, cpumask_of(0));
 	BUG_ON(smp_processor_id() != 0);
-#endif
 
 	if (apm_info.connection_version == 0) {
 		apm_info.connection_version = apm_info.bios.version;

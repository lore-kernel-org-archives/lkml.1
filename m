Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbYKKMr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbYKKMr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 07:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbYKKMrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 07:47:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54408 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbYKKMru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:47:50 -0500
Message-ID: <49197ED9.6090906@redhat.com>
Date: Tue, 11 Nov 2008 13:47:21 +0100
From: Ivan Vecera <ivecera@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, nhorman@redhat.com, jmarchan@redhat.com, pavel@suse.cz
Subject: Re: [PATCH] x86: call machine_shutdown and stop all CPUs in	native_machine_halt
References: <1224504787-11403-1-git-send-email-ivecera@redhat.com> <20081020160058.GB22779@elte.hu> <48FDCCCB.2080103@redhat.com> <20081106204351.GG3578@elte.hu>
In-Reply-To: <20081106204351.GG3578@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> looks good. One small detail:
> 
>> +#ifdef CONFIG_X86_LOCAL_APIC
>> +	disable_local_APIC();
>> +#endif
> 
> could you please avoid this #ifdef by putting an inline void function 
> for disable_local_APIC() into arch/x86/include/asm/apic.h for the 
> !CONFIG_X86_LOCAL_APIC case?
> 
> 	Ingo
OK, here is the result.

Ivan

---
 arch/x86/include/asm/apic.h   |    1 +
 arch/x86/include/asm/system.h |    2 ++
 arch/x86/kernel/process.c     |   14 ++++++++++++++
 arch/x86/kernel/reboot.c      |    5 +++++
 arch/x86/kernel/smp.c         |   13 -------------
 5 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 3b1510b..25caa07 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -193,6 +193,7 @@ extern u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask);
 static inline void lapic_shutdown(void) { }
 #define local_apic_timer_c2_ok		1
 static inline void init_apic_mappings(void) { }
+static inline void disable_local_APIC(void) { }
 
 #endif /* !CONFIG_X86_LOCAL_APIC */
 
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 2ed3f0f..07c3e40 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -314,6 +314,8 @@ extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
 void default_idle(void);
 
+void stop_this_cpu(void *dummy);
+
 /*
  * Force strict CPU ordering.
  * And yes, this is required on UP too when we're talking
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c622772..3380458 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -8,6 +8,7 @@
 #include <linux/pm.h>
 #include <linux/clockchips.h>
 #include <asm/system.h>
+#include <asm/apic.h>
 
 unsigned long idle_halt;
 EXPORT_SYMBOL(idle_halt);
@@ -122,6 +123,19 @@ void default_idle(void)
 EXPORT_SYMBOL(default_idle);
 #endif
 
+void stop_this_cpu(void *dummy)
+{
+	local_irq_disable();
+	/*
+	 * Remove this CPU:
+	 */
+	cpu_clear(smp_processor_id(), cpu_online_map);
+	disable_local_APIC();
+	if (hlt_works(smp_processor_id()))
+		for (;;) halt();
+	for (;;);
+}
+
 static void do_nothing(void *unused)
 {
 }
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 724adfc..34f8d37 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -461,6 +461,11 @@ static void native_machine_restart(char *__unused)
 
 static void native_machine_halt(void)
 {
+	/* stop other cpus and apics */
+	machine_shutdown();
+
+	/* stop this cpu */
+	stop_this_cpu(NULL);
 }
 
 static void native_machine_power_off(void)
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 18f9b19..3f92b13 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -140,19 +140,6 @@ void native_send_call_func_ipi(cpumask_t mask)
 		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
 }
 
-static void stop_this_cpu(void *dummy)
-{
-	local_irq_disable();
-	/*
-	 * Remove this CPU:
-	 */
-	cpu_clear(smp_processor_id(), cpu_online_map);
-	disable_local_APIC();
-	if (hlt_works(smp_processor_id()))
-		for (;;) halt();
-	for (;;);
-}
-
 /*
  * this function calls the 'stop' function on all other CPUs in the system.
  */
-- 
1.5.6.3


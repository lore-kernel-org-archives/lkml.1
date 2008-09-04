Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYIDNHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYIDNHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYIDNHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 09:07:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbYIDNHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 09:07:10 -0400
Date: Thu, 4 Sep 2008 09:07:02 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, arozansk@redhat.com, dzickus@redhat.com,
       Thomas.Mingarelli@hp.com, ak@linux.intel.com, mingo@elte.hu
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20080904130048.31841.3329.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi and Ingo,

This patch is an RFC for the following changes.  If I get a positive review,
changes to the HP Watchdog timer (currently in the kernel) will also be
submitted along with this patch.

Thanks,

P.

The drivers/watchdog/hpwdt.c driver requires that all NMIs are processed
by the driver.  Currently the driver does not do this.  The first
step is to implement code to allow the default NMI handler to be replaced
by a custom NMI handler.

This patch re-implements a global set and unset NMI callback so that the
default NMI handler can be replaced with a custom NMI handler.  This
functionality was removed from the kernel a while ago and now must be
reintroduced into the kernel.

An existing unknown NMI callback already exists within the code.  This call
has been renamed to the more descriptive do_unknown_nmi_callback.

Patch was tested on x86 (32 and 64 bit) on Intel and AMD hardware.

Acked-by: Aris Rozanski <arozansk@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index abb78a2..917b351 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -510,7 +510,7 @@ int proc_nmi_enabled(struct ctl_table *table, int write, struct file *file,
 
 #endif /* CONFIG_SYSCTL */
 
-int do_nmi_callback(struct pt_regs *regs, int cpu)
+int do_unknown_nmi_callback(struct pt_regs *regs, int cpu)
 {
 #ifdef CONFIG_SYSCTL
 	if (unknown_nmi_panic)
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 03df8e4..f19e414 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -796,7 +796,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		 */
 		if (nmi_watchdog_tick(regs, reason))
 			return;
-		if (!do_nmi_callback(regs, cpu))
+		if (!do_unknown_nmi_callback(regs, cpu))
 			unknown_nmi_error(reason, regs);
 #else
 		unknown_nmi_error(reason, regs);
@@ -819,17 +819,61 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	reassert_nmi();
 }
 
+static __kprobes int dummy_nmi_callback(struct pt_regs * regs, int cpu)
+{
+	return 0;
+}
+
+static nmi_callback_t nmi_callback = dummy_nmi_callback;
+static int nmi_cb_status = 0;
+
+int set_nmi_callback(nmi_callback_t callback)
+{
+	if (nmi_callback != dummy_nmi_callback) {
+		printk(KERN_WARNING
+		       "WARNING: Only one NMI callback can be registered at a "
+		       "time.\n");
+		return -EBUSY;
+	}
+
+	nmi_cb_status = atomic_read(&nmi_active);
+	if (nmi_cb_status) {
+		if (nmi_watchdog == NMI_LOCAL_APIC) {
+			disable_lapic_nmi_watchdog();
+			vmalloc_sync_all();
+		} else {
+			printk(KERN_WARNING
+			       "WARNING: NMI watchdog can only be set on "
+			       "systems with status lapic NMI.\n");
+			return -ENODEV;
+		}
+	}
+	rcu_assign_pointer(nmi_callback, callback);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(set_nmi_callback);
+
+void unset_nmi_callback(void)
+{
+	if (nmi_cb_status && (nmi_watchdog == NMI_LOCAL_APIC))
+		enable_lapic_nmi_watchdog();
+	nmi_cb_status = 0;
+	nmi_callback = dummy_nmi_callback;
+}
+
+EXPORT_SYMBOL_GPL(unset_nmi_callback);
 notrace __kprobes void do_nmi(struct pt_regs *regs, long error_code)
 {
 	int cpu;
 
 	nmi_enter();
 
-	cpu = smp_processor_id();
+	cpu = safe_smp_processor_id();
 
 	++nmi_count(cpu);
 
-	if (!ignore_nmis)
+	if (!ignore_nmis && !rcu_dereference(nmi_callback)(regs,cpu))
 		default_do_nmi(regs);
 
 	nmi_exit();
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 513caac..0f3bd27 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -815,7 +815,7 @@ asmlinkage notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		 */
 		if (nmi_watchdog_tick(regs, reason))
 			return;
-		if (!do_nmi_callback(regs, cpu))
+		if (!do_unknown_nmi_callback(regs, cpu))
 			unknown_nmi_error(reason, regs);
 
 		return;
@@ -830,14 +830,62 @@ asmlinkage notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		io_check_error(reason, regs);
 }
 
+static __kprobes int dummy_nmi_callback(struct pt_regs * regs, int cpu)
+{
+	return 0;
+}
+
+static nmi_callback_t nmi_callback = dummy_nmi_callback;
+static int nmi_cb_status = 0;
+
+int set_nmi_callback(nmi_callback_t callback)
+{
+	if (nmi_callback != dummy_nmi_callback) {
+		printk(KERN_WARNING
+		       "WARNING: Only one NMI callback can be registered at a "
+		       "time.\n");
+		return -EBUSY;
+	}
+
+	nmi_cb_status = atomic_read(&nmi_active);
+	if (nmi_cb_status) {
+		if (nmi_watchdog == NMI_LOCAL_APIC) {
+			disable_lapic_nmi_watchdog();
+			vmalloc_sync_all();
+		} else {
+			printk(KERN_WARNING
+			       "WARNING: NMI watchdog can only be set on "
+			       "systems with status lapic NMI.\n");
+			return -ENODEV;
+		}
+	}
+	rcu_assign_pointer(nmi_callback, callback);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(set_nmi_callback);
+
+void unset_nmi_callback(void)
+{
+	if (nmi_cb_status && (nmi_watchdog == NMI_LOCAL_APIC))
+		enable_lapic_nmi_watchdog();
+	nmi_cb_status = 0;
+	nmi_callback = dummy_nmi_callback;
+}
+EXPORT_SYMBOL_GPL(unset_nmi_callback);
+
 asmlinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
+	int cpu;
+
 	nmi_enter();
 
+	cpu = safe_smp_processor_id();
+
 	add_pda(__nmi_count, 1);
 
-	if (!ignore_nmis)
+	if (!ignore_nmis && !rcu_dereference(nmi_callback)(regs,cpu))
 		default_do_nmi(regs);
 
 	nmi_exit();
diff --git a/include/asm-x86/nmi.h b/include/asm-x86/nmi.h
index 21f8d02..3c3901a 100644
--- a/include/asm-x86/nmi.h
+++ b/include/asm-x86/nmi.h
@@ -7,13 +7,30 @@
 
 #ifdef ARCH_HAS_NMI_WATCHDOG
 
+typedef int (*nmi_callback_t)(struct pt_regs * regs, int cpu);
+
+/**
+ * set_nmi_callback
+ *
+ * Set a global handler for an NMI. Only one handler may be
+ * set. Return 1 if the NMI was handled.
+ */
+int set_nmi_callback(nmi_callback_t callback);
+
+/**
+ * unset_nmi_callback
+ *
+ * Remove the global handler previously set.
+ */
+void unset_nmi_callback(void);
+
 /**
- * do_nmi_callback
+ * do_unknown_nmi_callback
  *
  * Check to see if a callback exists and execute it.  Return 1
- * if the handler exists and was handled successfully.
+ * if the unknown handler exists and was handled successfully.
  */
-int do_nmi_callback(struct pt_regs *regs, int cpu);
+int do_unknown_nmi_callback(struct pt_regs *regs, int cpu);
 
 #ifdef CONFIG_X86_64
 extern void default_do_nmi(struct pt_regs *);

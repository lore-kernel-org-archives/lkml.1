Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbXK0BuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbXK0BuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 20:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbXK0BuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 20:50:03 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:3985 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbXK0BuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 20:50:00 -0500
Date: Mon, 26 Nov 2007 20:47:40 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: kexec@lists.infradead.org
Cc: ak@suse.de, vgoyal@in.ibm.com, hbabu@us.ibm.com,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       nhorman@tuxdriver.com
Subject: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot
	cpu
Message-ID: <20071127014740.GA28622@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all-
	I've been working on an issue lately involving multi socket x86_64
systems connected via hypertransport bridges.  It appears that some systems,
disable the hypertransport connections during a kdump operation when all but the
crashing processor gets halted in machine_crash_shutdown.  This becomes a
problem when the ioapic attempts to route interrupts to the only remaining
processor.  Even though the active processor is targeted for interrupt
reception, the fact that the hypertransport connections are inactive result in
interrupts not getting delivered.  The effective result is that timer interrupts
are not delivered to the running cpu, and the system hangs on reboot into the
kdump kernel during calibrate_delay.  I've found that I've been able to avoid
this hang, by forcing a transition to the bios defined boot cpu during the
crashing kernel shutdown.  This patch accomplished that.  Tested by myself and
the origional reporter with successful results.

Regards,
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 arch/x86/kernel/crash.c |   46 ++++++++++++++++++++++++++++++++++++++--------
 include/linux/kexec.h   |    3 +++
 init/main.c             |    6 ++++++
 kernel/kexec.c          |    8 ++++++++
 4 files changed, 55 insertions(+), 8 deletions(-)


diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 8bb482f..0682e60 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -67,13 +67,36 @@ static int crash_nmi_callback(struct notifier_block *self,
 	}
 #endif
 	crash_save_cpu(regs, cpu);
-	disable_local_APIC();
-	atomic_dec(&waiting_for_crash_ipi);
-	/* Assume hlt works */
-	halt();
-	for (;;)
-		cpu_relax();
-
+	if (smp_processor_id() == kexec_boot_cpu) {
+		/*
+		 * This is the boot cpu.  We need to:
+		 * 1) Wait for the other processors to halt
+		 * 2) clear our nmi interrupt
+		 * 3) launch the new kernel
+		 */
+		unsigned long msecs = 1000;
+		while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
+			/*
+			 * Use udelay to avoid the warnings here
+			 * I know we shouldn't delay in an irq
+			 * but we're about to reboot the box during
+			 * a crash, a delay doesn't hurt here
+			 */
+			udelay(1000);
+			msecs--;
+		}
+		ack_APIC_irq(); 
+		disable_local_APIC();
+		disable_IO_APIC();
+		machine_kexec(kexec_crash_image);
+
+	} else {
+		disable_local_APIC();
+		atomic_dec(&waiting_for_crash_ipi);
+		/* Assume hlt works */
+		for(;;)
+			halt();
+	}
 	return 1;
 }
 
@@ -138,7 +161,14 @@ void machine_crash_shutdown(struct pt_regs *regs)
 	nmi_shootdown_cpus();
 	lapic_shutdown();
 #if defined(CONFIG_X86_IO_APIC)
-	disable_IO_APIC();
+	if (crashing_cpu == kexec_boot_cpu) 
+		disable_IO_APIC();
 #endif
 	crash_save_cpu(regs, safe_smp_processor_id());
+	if (crashing_cpu != kexec_boot_cpu) {
+		atomic_dec(&waiting_for_crash_ipi);
+		for(;;)
+			halt();
+	}
+
 }
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 2d9c448..b5c12d6 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -187,6 +187,9 @@ extern u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
 extern size_t vmcoreinfo_size;
 extern size_t vmcoreinfo_max_size;
 
+extern int kexec_boot_cpu;
+extern void kexec_record_boot_cpu();
+
 int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
 
diff --git a/init/main.c b/init/main.c
index 58f5a99..0f11ee0 100644
--- a/init/main.c
+++ b/init/main.c
@@ -58,6 +58,9 @@
 #include <linux/kthread.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
+#ifdef CONFIG_KEXEC
+#include <linux/kexec.h>
+#endif
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -538,6 +541,9 @@ asmlinkage void __init start_kernel(void)
 	unwind_setup();
 	setup_per_cpu_areas();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
+#ifdef CONFIG_KEXEC
+	kexec_record_boot_cpu();
+#endif
 
 	/*
 	 * Set up the scheduler prior starting any interrupts (such as the
diff --git a/kernel/kexec.c b/kernel/kexec.c
index aa74a1e..cb6b1f3 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -41,6 +41,14 @@ u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
 size_t vmcoreinfo_size;
 size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
 
+int kexec_boot_cpu = 0;
+
+void __init kexec_record_boot_cpu()
+{
+	kexec_boot_cpu = smp_processor_id();
+	printk(KERN_CRIT "kexec records boot cpu as %d\n",kexec_boot_cpu);
+}
+
 /* Location of the reserved area for the crash kernel */
 struct resource crashk_res = {
 	.name  = "Crash kernel",

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbYBOMhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbYBOMhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYBOMgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:36:52 -0500
Received: from lizzard.sbs.de ([194.138.37.39]:19322 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbYBOMgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:36:50 -0500
Message-ID: <47B58718.9020105@siemens.com>
Date: Fri, 15 Feb 2008 13:35:36 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       Jan Kiszka <jan.kiszka@web.de>
Subject: [RFC][PATCH] modular kgdb-light (was: Re: [git pull] kgdb-light -v10)
References: <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <20080212161152.GA3281@one.firstfloor.org> <alpine.LFD.1.00.0802120811010.2920@woody.linux-foundation.org> <20080212170711.GB4191@one.firstfloor.org>
In-Reply-To: <20080212170711.GB4191@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> This includes things like having "breakpoint reservations" (discussed 
>> earlier) and just generally trying to add lots of infrastructure to make 
>> kgdb "fit in" to the kernel.
> 
> I think that part is actually mostly ok now (old kgdb stubs were
> much worse in this regard) 
> 
> I still think the ultimative proof for this would be working
> "modprobe kgdb" though.

To pick up this idea again I did the experimental patch below. It
applies against Jason's latest kgdb-light patch queue:

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=for_ingo

The patch nicely demonstrates what deeper dependencies on kernel
services currently exist in kgdb-light. The following symbols were
unresolvable:

 o genapic - for send_IPI_allbutself, ie. CPU roundup
 o machine_emergency_restart - for implementing "R0" gdb packet
 o idle_task - kgdb tells the per-cpu idle tasks apart
 o clocksource_touch_watchdog - obvious

For simplicity reasons I just gpl-exported all of them. The result is
a fully modular kgdb that may help to reduce concerns regarding its
intrusiveness.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>

---
 arch/x86/kernel/Makefile               |    4 +++-
 arch/x86/kernel/genapic_64.c           |    1 +
 arch/x86/kernel/{kgdb.c => kgdb-x86.c} |    0 
 arch/x86/kernel/reboot.c               |    1 +
 arch/x86/mach-generic/probe.c          |    1 +
 kernel/Makefile                        |    1 -
 kernel/sched.c                         |    1 +
 kernel/time/clocksource.c              |    1 +
 lib/Kconfig.kgdb                       |    2 +-
 {kernel => lib}/kgdb.c                 |    8 ++++++--
 10 files changed, 15 insertions(+), 5 deletions(-)
 rename arch/x86/kernel/{kgdb.c => kgdb-x86.c} (100%)
 rename {kernel => lib}/kgdb.c (100%)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4cd39cd..2e733b1 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -58,7 +58,6 @@ obj-$(CONFIG_MODULES)		+= module_$(BITS).o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
-obj-$(CONFIG_KGDB)		+= kgdb.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
@@ -79,6 +78,9 @@ endif
 obj-$(CONFIG_SCx200)		+= scx200.o
 scx200-y			+= scx200_32.o
 
+kgdb-objs			:= ../../../lib/kgdb.o kgdb-x86.o
+obj-$(CONFIG_KGDB)		+= kgdb.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/genapic_64.c b/arch/x86/kernel/genapic_64.c
index 4ae7b64..d0518a7 100644
--- a/arch/x86/kernel/genapic_64.c
+++ b/arch/x86/kernel/genapic_64.c
@@ -32,6 +32,7 @@ DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
 struct genapic __read_mostly *genapic = &apic_flat;
+EXPORT_SYMBOL_GPL(genapic);
 
 /*
  * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb-x86.c
similarity index 100%
rename from arch/x86/kernel/kgdb.c
rename to arch/x86/kernel/kgdb-x86.c
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 5818dc2..66d7c27 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -375,6 +375,7 @@ void machine_emergency_restart(void)
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(machine_emergency_restart);
 
 void machine_shutdown(void)
 {
diff --git a/arch/x86/mach-generic/probe.c b/arch/x86/mach-generic/probe.c
index f410d3c..4156d64 100644
--- a/arch/x86/mach-generic/probe.c
+++ b/arch/x86/mach-generic/probe.c
@@ -21,6 +21,7 @@ extern struct genapic apic_es7000;
 extern struct genapic apic_default;
 
 struct genapic *genapic = &apic_default;
+EXPORT_SYMBOL_GPL(genapic);
 
 static struct genapic *apic_probe[] __initdata = {
 	&apic_summit,
diff --git a/kernel/Makefile b/kernel/Makefile
index 05c8003..6c584c5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -53,7 +53,6 @@ obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
-obj-$(CONFIG_KGDB) += kgdb.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
diff --git a/kernel/sched.c b/kernel/sched.c
index 3eedd52..e2ffff4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4463,6 +4463,7 @@ struct task_struct *idle_task(int cpu)
 {
 	return cpu_rq(cpu)->idle;
 }
+EXPORT_SYMBOL_GPL(idle_task);
 
 /**
  * find_process_by_pid - find a process with a matching PID value.
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index ace23d3..e83dc5d 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -238,6 +238,7 @@ void clocksource_touch_watchdog(void)
 {
 	clocksource_resume_watchdog();
 }
+EXPORT_SYMBOL_GPL(clocksource_touch_watchdog);
 
 /**
  * clocksource_get_next - Returns the selected clocksource
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 9631ba3..413e3b8 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -1,6 +1,6 @@
 
 menuconfig KGDB
-	bool "KGDB: kernel debugging with remote gdb"
+	tristate "KGDB: kernel debugging with remote gdb"
 	select FRAME_POINTER
 	depends on HAVE_ARCH_KGDB
 	depends on DEBUG_KERNEL && EXPERIMENTAL
diff --git a/kernel/kgdb.c b/lib/kgdb.c
similarity index 100%
rename from kernel/kgdb.c
rename to lib/kgdb.c
index b516de0..2ef8e9d 100644
--- a/kernel/kgdb.c
+++ b/lib/kgdb.c
@@ -91,13 +91,14 @@ static int kgdb_con_registered;
 /* determine if kgdb console output should be used */
 static int kgdb_use_con;
 
+#ifdef CONFIG_KGDB
 static int __init opt_kgdb_con(char *str)
 {
 	kgdb_use_con = 1;
 	return 0;
 }
-
 early_param("kgdbcon", opt_kgdb_con);
+#endif
 
 module_param(kgdb_use_con, int, 0644);
 
@@ -1667,6 +1668,7 @@ void kgdb_breakpoint(void)
 }
 EXPORT_SYMBOL_GPL(kgdb_breakpoint);
 
+#ifdef CONFIG_KGDB
 static int __init opt_kgdb_wait(char *str)
 {
 	kgdb_break_asap = 1;
@@ -1676,5 +1678,7 @@ static int __init opt_kgdb_wait(char *str)
 
 	return 0;
 }
-
 early_param("kgdbwait", opt_kgdb_wait);
+#endif
+
+MODULE_LICENSE("GPL");


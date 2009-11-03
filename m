Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZKCRKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZKCRKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZKCRKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:10:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbZKCRKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:10:39 -0500
Date: Tue, 3 Nov 2009 12:10:54 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: introduce NMI_AUTO as nmi_watchdog option
Message-ID: <20091103171054.GB25437@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NMI_AUTO is a new nmi_watchdog option that makes LAPIC be tried first and if
the CPU isn't supported, IOAPIC will be used. It's useful in cases where
NMI watchdog is enabled by default in a kernel built for different machines.
It can be configured by default or selected with nmi_watchdog=3 or
nmi_watchdog=auto parameters.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
---
 Documentation/kernel-parameters.txt    |   15 +++++++++------
 Documentation/nmi_watchdog.txt         |    4 +++-
 arch/x86/include/asm/nmi.h             |    5 ++++-
 arch/x86/kernel/apic/apic.c            |    1 +
 arch/x86/kernel/apic/nmi.c             |   21 +++++++++++++++++++++
 arch/x86/kernel/cpu/perfctr-watchdog.c |   12 +++++++++---
 lib/Kconfig.debug                      |    5 +++++
 7 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6d0a7c9..a3f382b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1520,19 +1520,22 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nmi_watchdog=	[KNL,BUGS=X86] Debugging features for SMP kernels
 			Format: [panic,][num]
-			Valid num: 0,1,2
+			Valid num: 0,1,2,3
 			0 - turn nmi_watchdog off
 			1 - use the IO-APIC timer for the NMI watchdog
 			2 - use the local APIC for the NMI watchdog using
-			a performance counter. Note: This will use one
-			performance counter and the local APIC's performance
-			vector.
+			    a performance counter. Note: This will use one
+			    performance counter and the local APIC's performance
+			    vector.
+			3 - "auto" mode: first checks if the CPU is supported
+			    by local APIC method and uses it in that case. If
+			    it's not, IOAPIC is tried.
 			When panic is specified, panic when an NMI watchdog
 			timeout occurs.
 			This is useful when you use a panic=... timeout and
 			need the box quickly up again.
-			Instead of 1 and 2 it is possible to use the following
-			symbolic names: lapic and ioapic
+			Instead of 1, 2 and 3 it is possible to use the following
+			symbolic names: ioapic, lapic, auto
 			Example: nmi_watchdog=2 or nmi_watchdog=panic,lapic
 
 	no387		[BUGS=X86-32] Tells the kernel to use the 387 maths
diff --git a/Documentation/nmi_watchdog.txt b/Documentation/nmi_watchdog.txt
index bf9f80a..3f163d2 100644
--- a/Documentation/nmi_watchdog.txt
+++ b/Documentation/nmi_watchdog.txt
@@ -40,7 +40,9 @@ for some processor types.  If in doubt, boot with nmi_watchdog=1 and
 check the NMI count in /proc/interrupts; if the count is zero then
 reboot with nmi_watchdog=2 and check the NMI count.  If it is still
 zero then log a problem, you probably have a processor that needs to be
-added to the nmi code.
+added to the nmi code. Another option is using "auto" mode (nmi_watchdog=3
+or nmi_watchdog=auto). On "auto" mode, it's first verified if the CPU is
+supported by LAPIC mode and if it's not, IOAPIC method is used.
 
 A 'lockup' is the following scenario: if any CPU in the system does not
 execute the period local timer interrupt for more than 5 seconds, then
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index c86e5ed..231d4cb 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -25,6 +25,7 @@ extern void release_perfctr_nmi(unsigned int);
 extern int reserve_evntsel_nmi(unsigned int);
 extern void release_evntsel_nmi(unsigned int);
 
+extern void default_nmi_watchdog(void);
 extern void setup_apic_nmi_watchdog(void *);
 extern void stop_apic_nmi_watchdog(void *);
 extern void disable_timer_nmi_watchdog(void);
@@ -37,7 +38,8 @@ extern unsigned int nmi_watchdog;
 #define NMI_NONE	0
 #define NMI_IO_APIC	1
 #define NMI_LOCAL_APIC	2
-#define NMI_INVALID	3
+#define NMI_AUTO	3
+#define NMI_INVALID	4
 
 struct ctl_table;
 struct file;
@@ -69,6 +71,7 @@ static inline int nmi_watchdog_active(void)
 #endif
 
 void lapic_watchdog_stop(void);
+int lapic_watchdog_detect(void);
 int lapic_watchdog_init(unsigned nmi_hz);
 int lapic_wd_event(unsigned nmi_hz);
 unsigned lapic_adjust_nmi_hz(unsigned hz);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 0a1c283..f30972b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1333,6 +1333,7 @@ void __cpuinit end_local_APIC_setup(void)
 	}
 #endif
 
+	default_nmi_watchdog();
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
 }
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index fd176e9..c157d4d 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -59,6 +59,9 @@ EXPORT_SYMBOL(nmi_active);
 #ifdef CONFIG_DEBUG_DEFAULT_NMI_LAPIC
 #define DEFAULT_NMI_WATCHDOG_VALUE NMI_LAPIC
 #endif
+#ifdef CONFIG_DEBUG_DEFAULT_NMI_AUTO
+#define DEFAULT_NMI_WATCHDOG_VALUE NMI_AUTO
+#endif
 unsigned int nmi_watchdog = DEFAULT_NMI_WATCHDOG_VALUE;
 EXPORT_SYMBOL(nmi_watchdog);
 
@@ -196,6 +199,22 @@ error:
 	return -1;
 }
 
+/* this function handles nmi_watchdog=NMI_AUTO */
+void __init default_nmi_watchdog(void)
+{
+	if (nmi_watchdog != NMI_AUTO)
+		return;
+
+	if (lapic_watchdog_detect() == 0)
+		nmi_watchdog = NMI_LOCAL_APIC;
+	else {
+		printk(KERN_INFO "NMI watchdog: LAPIC mode not available on this "
+			"CPU, using IOAPIC\n");
+		nmi_watchdog = NMI_IO_APIC;
+	}
+}
+
+
 static int __init setup_nmi_watchdog(char *str)
 {
 	unsigned int nmi;
@@ -212,6 +231,8 @@ static int __init setup_nmi_watchdog(char *str)
 		nmi_watchdog = NMI_LOCAL_APIC;
 	else if (!strncmp(str, "ioapic", 6))
 		nmi_watchdog = NMI_IO_APIC;
+	else if (!strncmp(str, "auto", 4))
+		nmi_watchdog = NMI_AUTO;
 	else {
 		get_option(&str, &nmi);
 		if (nmi >= NMI_INVALID)
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index e60ed74..bbd43b4 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -749,9 +749,7 @@ static void probe_nmi_watchdog(void)
 	}
 }
 
-/* Interface to nmi.c */
-
-int lapic_watchdog_init(unsigned nmi_hz)
+int lapic_watchdog_detect(void)
 {
 	if (!wd_ops) {
 		probe_nmi_watchdog();
@@ -766,6 +764,14 @@ int lapic_watchdog_init(unsigned nmi_hz)
 			return -1;
 		}
 	}
+	return 0;
+}
+
+/* Interface to nmi.c */
+int lapic_watchdog_init(unsigned nmi_hz)
+{
+	if (lapic_watchdog_detect())
+		return -1;
 
 	if (!(wd_ops->setup(nmi_hz))) {
 		printk(KERN_ERR "Cannot setup NMI watchdog on CPU %d\n",
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 0a3622a..3898c19 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -261,6 +261,8 @@ choice
 	  This allows to set the default NMI watchdog method to be used. The
 	  default can be changed using nmi_watchdog=. Only choose an option
 	  different from Disabled if you know the machine supports that method.
+	  "Auto" option will first try detecting a LAPIC supported processor
+	  then try IOAPIC if it fails.
 
 config DEBUG_DEFAULT_NMI_NONE
 	bool "Disabled"
@@ -271,6 +273,9 @@ config DEBUG_DEFAULT_NMI_IOAPIC
 config DEBUG_DEFAULT_NMI_LAPIC
 	bool "LAPIC"
 
+config DEBUG_DEFAULT_NMI_AUTO
+	bool "Auto"
+
 endchoice
 
 
-- 
1.5.5.6


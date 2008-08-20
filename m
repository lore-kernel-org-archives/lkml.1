Return-Path: <linux-kernel-owner+w=401wt.eu-S1760728AbYHTRCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbYHTRCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYHTRCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:02:11 -0400
Received: from ns2.suse.de ([195.135.220.15]:56291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583AbYHTRCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:02:08 -0400
From: Thomas Renninger <trenn@suse.de>
To: linux-kernel@vger.kernel.org
Cc: ak@linux.intel.com, len.brown@intel.com, arjan@linux.intel.com,
       bjorn.helgaas@hp.com, linux-acpi@vger.kernel.org,
       Christian Kornacker <ckornacker@suse.de>,
       Thomas Renninger <trenn@suse.de>
Subject: [PATCH 1/3] Introduce interface to report BIOS bugs
Date: Wed, 20 Aug 2008 19:02:04 +0200
Message-Id: <1219251726-24746-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219251726-24746-1-git-send-email-trenn@suse.de>
References: <1219251726-24746-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Kornacker <ckornacker@suse.de>

This is mostly needed for ACPI systems.
ACPI introduces an endless amount of possible BIOS
bugs like wrong values, missing functions, etc.
The kernel has to sanity check all of them and should
report BIOS bugs as such to the user.

ACPI is the main target, of course others, who already declare BIOS bugs,
also benefit from this, e.g. PCI:
arch/x86/pci/pcbios.c:
   printk(KERN_WARNING "bios32_service(0x%lx): returned 0x%x -- BIOS bug!\n",
   printk (KERN_ERR "PCI: BIOS BUG #%x[%08x] found\n",
...
This one I stumbled over recently (when >4GB BIOS sets up IO mem for this
device wrongly on some Dell notebooks):
   ohci_hcd 0000:00:02.0: USB HC takeover failed!  (BIOS/SMM bug)
...


There are two kind of BIOS bug messages introduced:
  - FW_PRINT_CRIT(..)
    Is intended to replace
    printk(KERN_ERR/KERN_CRIT/KERN_EMERG/KERN_WARN "BIOS bug...");
    messages. The string will always be compiled into the kernel and thus
    use some memory. Depending on the severity it may or may not pop up
    in the syslogs as:
    Jun 11 11:28:11 linux kernel: [BIOS] ...

  - FW_PRINT_WARN(..)
    Is intended to replace
    printk (KERN_WARN/KERN_INFO "BIOS bug...");
    messages which may result in minor malfunction of a device, less
    performance or just any kind of more or less harmless BIOS bug which
    vendors should still correct in the future.
    The only difference to above FW_PRINT_CRIT(..) is, that these
    messages could get compiled out on production kernels.

Advantage:

  - Be able to detect BIOS bugs as such through userspace programs, e.g.
    linuxfirmwarekit.

  - Easier testing for HW vendors for Linux compatibility.

  - Makes it easier for the ordinary user how to proceed when machine/device
    is not working: When a BIOS bug is shown in dmesg, first step should
    be to search for a BIOS update.

  - Makes it easier for certification and QA people testing Linux.
    Certification of BIOS/HW should always fail if BIOS bugs with a level
    of e.g. FW_ERR or FW_WARN happen. It's hard for people not being
    deeply involved in a subsystem to decide how critical a bug is. In general
    they need to ask a kernel developer searching in the code who will finally
    tell them that this is a BIOS bug and QA/Certification should poke the
    vendor to fix this up. The step to ask the kernel developer should not be
    needed anymore then.

Difference to printk:
    - No newline needed
    - Severity is an extra argument instead a string getting concatinated
      to the message


Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 include/linux/firmware_error.h |   36 ++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug              |   10 ++++++++++
 2 files changed, 46 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/firmware_error.h

diff --git a/include/linux/firmware_error.h b/include/linux/firmware_error.h
new file mode 100644
index 0000000..74d454e
--- /dev/null
+++ b/include/linux/firmware_error.h
@@ -0,0 +1,36 @@
+/*
+ * Firmware error reporting interface 
+ *
+ */
+
+#include <linux/kernel.h>
+
+#define 	FW_EMERG	KERN_EMERG  /* System cannot boot */
+#define 	FW_ALERT 	KERN_ALERT  /* Risk of HW or data damage, 
+					       e.g. overheating, dmraid */
+#define 	FW_CRIT 	KERN_CRIT   /* A major device is not functional
+					       e.g. hpet, lapic, network... */
+#define 	FW_ERR		KERN_ERR    /* A major device is not working
+					       as expected, e.g. cpufreq stuck
+					       to lowest freq, lowered
+					       performance, increased power
+					       consumption... */
+#define		FW_WARN		KERN_WARNING /* A minor device does not work
+						or is not fully functional,
+						e.g. backlight brightness,
+						Hotplug capabilities of a
+						device that should be
+						hot-plugable will not work */
+#define		FW_INFO		KERN_INFO    /* Anything else related to BIOS
+						that is worth mentioning */
+
+
+#ifdef CONFIG_REPORT_FIRMWARE_BUGS
+  #define FW_PRINT_WARN(severity, fmt, args...) printk("%s[BIOS]: " fmt "\n", \
+						       severity, ##args)
+#else
+  #define FW_PRINT_WARN(severity, fmt, args...) do { } while (0)
+#endif
+
+#define FW_PRINT_CRIT(severity, fmt, args...) printk("%s[BIOS]: " fmt "\n", \
+						     severity, ##args)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 800ac84..6743d09 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -143,6 +143,16 @@ config DEBUG_SHIRQ
 	  Drivers ought to be able to handle interrupts coming in at those
 	  points; some don't and need to be caught.
 
+config REPORT_FIRMWARE_BUGS
+	bool "Report Firmware Bugs"
+	default y
+	help
+	  This option will make the kernel print out all firmware bug messages
+	  it finds. This especially is very useful on ACPI systems where
+	  potentially a lot firmware bugs can happen and should be reported.
+	  
+	  Always say yes here unless memory really matters.
+
 config DETECT_SOFTLOCKUP
 	bool "Detect Soft Lockups"
 	depends on DEBUG_KERNEL && !S390
-- 
1.5.4.5


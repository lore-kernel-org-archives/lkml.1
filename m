Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbXIZSm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbXIZSm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757558AbXIZSmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:42:18 -0400
Received: from omr3.networksolutionsemail.com ([205.178.146.53]:48519 "EHLO
	omr3.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757543AbXIZSmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:42:17 -0400
Message-ID: <46FAA808.90004@nerdgrounds.com>
Date: Wed, 26 Sep 2007 11:42:16 -0700
From: Jonathan Campbell <jon@nerdgrounds.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Patches for tiny 386 kernels, again. Linux kernel 2.6.22.7
References: <46F77A85.6020202@nerdgrounds.com> <20070924104940.50a52cf3.randy.dunlap@oracle.com>
In-Reply-To: <20070924104940.50a52cf3.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the DMI patch again, written against linux-2.6.23-rc8,
with some of the #ifdef CONFIG_DMI's removed and moved
to include/linux/dmi.h. Putting them there in the way I've done
ensures that you don't have to put #ifdef CONFIG_DMI
around each dmi_check_machine() and that you don't
have to apply little patches to so many device drivers.

diff -u -r linux-2.6.23-rc8-old/arch/i386/Kconfig 
linux-2.6.23-rc8/arch/i386/Kconfig
--- linux-2.6.23-rc8-old/arch/i386/Kconfig    2007-09-21 
22:38:23.000000000 +0000
+++ linux-2.6.23-rc8/arch/i386/Kconfig    2007-09-26 00:01:48.000000000 
+0000
@@ -83,10 +83,6 @@
     bool
     default y
 
-config DMI
-    bool
-    default y
-
 source "init/Kconfig"
 
 menu "Processor type and features"
diff -u -r linux-2.6.23-rc8-old/arch/i386/kernel/acpi/boot.c 
linux-2.6.23-rc8/arch/i386/kernel/acpi/boot.c
--- linux-2.6.23-rc8-old/arch/i386/kernel/acpi/boot.c    2007-09-21 
22:38:23.000000000 +0000
+++ linux-2.6.23-rc8/arch/i386/kernel/acpi/boot.c    2007-09-26 
00:40:42.000000000 +0000
@@ -869,7 +869,7 @@
     return;
 }
 
-#ifdef __i386__
+#if defined(__i386__) && defined(CONFIG_DMI)
 
 static int __init disable_acpi_irq(struct dmi_system_id *d)
 {
@@ -1097,8 +1097,7 @@
      },
     {}
 };
-
-#endif                /* __i386__ */
+#endif /* CONFIG_DMI && __i386__ */
 
 /*
  * acpi_boot_table_init() and acpi_boot_init()
diff -u -r linux-2.6.23-rc8-old/arch/i386/kernel/acpi/sleep.c 
linux-2.6.23-rc8/arch/i386/kernel/acpi/sleep.c
--- linux-2.6.23-rc8-old/arch/i386/kernel/acpi/sleep.c    2007-09-21 
22:38:23.000000000 +0000
+++ linux-2.6.23-rc8/arch/i386/kernel/acpi/sleep.c    2007-09-25 
23:59:14.000000000 +0000
@@ -86,6 +86,7 @@
     return 0;
 }
 
+#ifdef CONFIG_DMI
 static __initdata struct dmi_system_id acpisleep_dmi_table[] = {
     {            /* Reset video mode after returning from ACPI S3 sleep */
      .callback = reset_videomode_after_s3,
@@ -104,3 +105,5 @@
 }
 
 core_initcall(acpisleep_dmi_init);
+#endif
+
diff -u -r 
linux-2.6.23-rc8-old/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c 
linux-2.6.23-rc8/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
--- linux-2.6.23-rc8-old/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c    
2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.23-rc8/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c    
2007-09-26 00:59:26.000000000 +0000
@@ -535,7 +535,7 @@
     return 0;
 }
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && defined(CONFIG_DMI)
 /*
  * Some BIOSes do SW_ANY coordination internally, either set it up in hw
  * or do it in BIOS firmware and won't inform about it to OS. If not
@@ -562,7 +562,9 @@
     },
     { }
 };
-#endif
+#else
+#  define bios_with_sw_any_bug 0
+#endif /* CONFIG_SMP && CONFIG_DMI */
 
 static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
diff -u -r linux-2.6.23-rc8-old/arch/i386/kernel/reboot.c 
linux-2.6.23-rc8/arch/i386/kernel/reboot.c
--- linux-2.6.23-rc8-old/arch/i386/kernel/reboot.c    2007-09-21 
22:38:23.000000000 +0000
+++ linux-2.6.23-rc8/arch/i386/kernel/reboot.c    2007-09-26 
01:00:08.000000000 +0000
@@ -71,6 +71,7 @@
 
 __setup("reboot=", reboot_setup);
 
+#ifdef CONFIG_DMI
 /*
  * Reboot options and system auto-detection code provided by
  * Dell Inc. so their systems "just work". :-)
@@ -131,6 +132,7 @@
     },
     { }
 };
+#endif /* CONFIG_DMI */
 
 static int __init reboot_init(void)
 {
diff -u -r linux-2.6.23-rc8-old/arch/i386/kernel/tsc.c 
linux-2.6.23-rc8/arch/i386/kernel/tsc.c
--- linux-2.6.23-rc8-old/arch/i386/kernel/tsc.c    2007-09-21 
22:38:23.000000000 +0000
+++ linux-2.6.23-rc8/arch/i386/kernel/tsc.c    2007-09-26 
00:39:52.000000000 +0000
@@ -290,6 +290,7 @@
 }
 EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
+#ifdef CONFIG_DMI
 static int __init dmi_mark_tsc_unstable(struct dmi_system_id *d)
 {
     printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
@@ -310,6 +311,7 @@
      },
      {}
 };
+#endif
 
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
diff -u -r linux-2.6.23-rc8-old/arch/i386/mach-generic/bigsmp.c 
linux-2.6.23-rc8/arch/i386/mach-generic/bigsmp.c
--- linux-2.6.23-rc8-old/arch/i386/mach-generic/bigsmp.c    2007-09-21 
22:38:23.000000000 +0000
+++ linux-2.6.23-rc8/arch/i386/mach-generic/bigsmp.c    2007-09-26 
00:57:13.000000000 +0000
@@ -21,6 +21,7 @@
 
 static int dmi_bigsmp; /* can be set by dmi scanners */
 
+#ifdef CONFIG_DMI
 static int hp_ht_bigsmp(struct dmi_system_id *d)
 {
 #ifdef CONFIG_X86_GENERICARCH
@@ -30,7 +31,6 @@
     return 0;
 }
 
-
 static struct dmi_system_id bigsmp_dmi_table[] = {
     { hp_ht_bigsmp, "HP ProLiant DL760 G2", {
         DMI_MATCH(DMI_BIOS_VENDOR, "HP"),
@@ -43,7 +43,7 @@
      }},
      { }
 };
-
+#endif /* CONFIG_DMI */
 
 static int probe_bigsmp(void)
 {
diff -u -r linux-2.6.23-rc8-old/arch/i386/pci/fixup.c 
linux-2.6.23-rc8/arch/i386/pci/fixup.c
--- linux-2.6.23-rc8-old/arch/i386/pci/fixup.c    2007-09-21 
22:38:23.000000000 +0000
+++ linux-2.6.23-rc8/arch/i386/pci/fixup.c    2007-09-26 
01:17:23.000000000 +0000
@@ -367,6 +367,7 @@
  */
 static u16 toshiba_line_size;
 
+#ifdef CONFIG_DMI
 static struct dmi_system_id __devinitdata toshiba_ohci1394_dmi_table[] = {
     {
         .ident = "Toshiba PS5 based laptop",
@@ -391,6 +392,7 @@
     },
     { }
 };
+#endif
 
 static void __devinit pci_pre_fixup_toshiba_ohci1394(struct pci_dev *dev)
 {
diff -u -r linux-2.6.23-rc8-old/drivers/acpi/Kconfig 
linux-2.6.23-rc8/drivers/acpi/Kconfig
--- linux-2.6.23-rc8-old/drivers/acpi/Kconfig    2007-09-21 
22:38:23.000000000 +0000
+++ linux-2.6.23-rc8/drivers/acpi/Kconfig    2007-09-25 
23:59:14.000000000 +0000
@@ -263,6 +263,7 @@
 
 config ACPI_BLACKLIST_YEAR
     int "Disable ACPI for systems before Jan 1st this year" if X86_32
+    depends on DMI
     default 0
     help
       enter a 4-digit year, eg. 2001 to disable ACPI by default
diff -u -r linux-2.6.23-rc8-old/drivers/acpi/blacklist.c 
linux-2.6.23-rc8/drivers/acpi/blacklist.c
--- linux-2.6.23-rc8-old/drivers/acpi/blacklist.c    2007-09-21 
22:38:23.000000000 +0000
+++ linux-2.6.23-rc8/drivers/acpi/blacklist.c    2007-09-26 
01:06:59.000000000 +0000
@@ -73,7 +73,7 @@
     {""}
 };
 
-#if    CONFIG_ACPI_BLACKLIST_YEAR
+#if defined(CONFIG_ACPI_BLACKLIST_YEAR) && CONFIG_ACPI_BLACKLIST_YEAR > 0
 
 static int __init blacklist_by_year(void)
 {
diff -u -r linux-2.6.23-rc8-old/drivers/acpi/processor_idle.c 
linux-2.6.23-rc8/drivers/acpi/processor_idle.c
--- linux-2.6.23-rc8-old/drivers/acpi/processor_idle.c    2007-09-21 
22:38:23.000000000 +0000
+++ linux-2.6.23-rc8/drivers/acpi/processor_idle.c    2007-09-26 
01:08:00.000000000 +0000
@@ -85,6 +85,7 @@
                                 Power Management
    
-------------------------------------------------------------------------- 
*/
 
+#ifdef CONFIG_DMI
 /*
  * IBM ThinkPad R40e crashes mysteriously when going into C2 or C3.
  * For now disable this. Probably a bug somewhere else.
@@ -165,6 +166,7 @@
      (void *)2},
     {},
 };
+#endif // CONFIG_DMI
 
 static inline u32 ticks_elapsed(u32 t1, u32 t2)
 {
diff -u -r linux-2.6.23-rc8-old/drivers/input/mouse/Kconfig 
linux-2.6.23-rc8/drivers/input/mouse/Kconfig
--- linux-2.6.23-rc8-old/drivers/input/mouse/Kconfig    2007-09-21 
22:38:23.000000000 +0000
+++ linux-2.6.23-rc8/drivers/input/mouse/Kconfig    2007-09-26 
01:12:13.000000000 +0000
@@ -60,7 +60,7 @@
 config MOUSE_PS2_SYNAPTICS
     bool "Synaptics PS/2 mouse protocol extension" if EMBEDDED
     default y
-    depends on MOUSE_PS2
+    depends on MOUSE_PS2 && DMI
     help
       Say Y here if you have a Synaptics PS/2 TouchPad connected to
       your system.
@@ -70,7 +70,7 @@
 config MOUSE_PS2_LIFEBOOK
     bool "Fujitsu Lifebook PS/2 mouse protocol extension" if EMBEDDED
     default y
-    depends on MOUSE_PS2
+    depends on MOUSE_PS2 && DMI
     help
       Say Y here if you have a Fujitsu B-series Lifebook PS/2
       TouchScreen connected to your system.
diff -u -r linux-2.6.23-rc8-old/drivers/input/serio/i8042-x86ia64io.h 
linux-2.6.23-rc8/drivers/input/serio/i8042-x86ia64io.h
--- linux-2.6.23-rc8-old/drivers/input/serio/i8042-x86ia64io.h    
2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.23-rc8/drivers/input/serio/i8042-x86ia64io.h    2007-09-26 
01:19:54.000000000 +0000
@@ -63,7 +63,7 @@
     outb(val, I8042_COMMAND_REG);
 }
 
-#if defined(__i386__)
+#if defined(__i386__) && defined(CONFIG_DMI)
 
 #include <linux/dmi.h>
 
@@ -472,7 +472,7 @@
         i8042_reset = 1;
 #endif
 
-#if defined(__i386__)
+#if defined(__i386__) && defined(CONFIG_DMI)
     if (dmi_check_system(i8042_dmi_noloop_table))
         i8042_noloop = 1;
 
diff -u -r linux-2.6.23-rc8-old/include/linux/dmi.h 
linux-2.6.23-rc8/include/linux/dmi.h
--- linux-2.6.23-rc8-old/include/linux/dmi.h    2007-09-21 
22:38:23.000000000 +0000
+++ linux-2.6.23-rc8/include/linux/dmi.h    2007-09-26 
01:34:13.000000000 +0000
@@ -73,12 +73,24 @@
 
 #else
 
-static inline int dmi_check_system(struct dmi_system_id *list) { return 
0; }
+/* use the C preprocessor to toss out the DMI id list, and redirect
+ * to an inline function that reduces down to 0 (failure). this
+ * satisfies code using this in if () ... else ... statements that
+ * do not use brackets where #define dmi_check_list(list) 0 would
+ * give many "statement reduces to nothing" errors. { } is a
+ * possibility except that many parts of the kernel do in fact
+ * check the return value, { } would result in a syntax error.
+ * we toss out the param because the list is included only if
+ * #ifdef CONFIG_DMI. without DMI the id list is not used, and
+ * a waste of memory, so it is #ifdef'd out. */
+#define dmi_check_system(list) dmi_check_system_NOTHING()
+static inline int dmi_check_system_NOTHING(void) { return 0; }
+
 static inline char * dmi_get_system_info(int field) { return NULL; }
-static inline struct dmi_device * dmi_find_device(int type, const char 
*name,
-    struct dmi_device *from) { return NULL; }
-static inline int dmi_get_year(int year) { return 0; }
-static inline int dmi_name_in_vendors(char *s) { return 0; }
+#define dmi_find_device(type,name,from) NULL
+#define dmi_scan_machine() { }
+static inline int dmi_get_year(int field) { return 0; }
+static inline int dmi_name_in_vendors(char *str) { return 0; }
 
 #endif
 
diff -u -r linux-2.6.23-rc8-old/init/Kconfig linux-2.6.23-rc8/init/Kconfig
--- linux-2.6.23-rc8-old/init/Kconfig    2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.23-rc8/init/Kconfig    2007-09-26 00:03:05.000000000 +0000
@@ -542,6 +542,18 @@
       on EMBEDDED systems.  /proc/vmstat will only show page counts
       if VM event counters are disabled.
 
+config DMI
+    default y
+    bool "Enable DMI support" if EMBEDDED
+    depends on X86
+    help
+      This enables support for processing the Desktop Management
+      Interface structures present in most modern BIOSes. If you are
+      building a kernel for an older Pentium, 486, or 386 system and
+      memory is tight, you can disable this to help reduce the size
+      of your kernel by about 6K.
+      If unsure, say Y.
+
 config SLUB_DEBUG
     default y
     bool "Enable SLUB debugging support" if EMBEDDED


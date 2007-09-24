Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbXIXJV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbXIXJV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 05:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbXIXJVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 05:21:20 -0400
Received: from omr4.networksolutionsemail.com ([205.178.146.54]:51305 "EHLO
	omr4.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225AbXIXJVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 05:21:19 -0400
X-Greylist: delayed 1802 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Sep 2007 05:21:19 EDT
Message-ID: <46F77A85.6020202@nerdgrounds.com>
Date: Mon, 24 Sep 2007 01:51:17 -0700
From: Jonathan Campbell <jon@nerdgrounds.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Patches for tiny 386 kernels, again. Linux kernel 2.6.22.7
Content-Type: multipart/mixed;
 boundary="------------020504050109050407060300"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020504050109050407060300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Sorry for the long delay, been very busy since I last posted the 386 
kernel patches back in July.
Now that I have more free time I remade the patches in a cleaner manner, 
broken down into
smaller patches, with fewer #ifdefs all over the place. most #ifdefs are 
in the include/asm-i386 headers
now.

linux-2.6.22.7-embedded-disable-rdtsc.patch:
    * Allows you to remove Pentium TSC register-based timing, which 
would never be used on
       a kernel targeting 386 and 486 boxes exclusively. Apparently 
there is already a
       CONFIG_X86_TSC out there, this patch makes it work as a means to 
disable TSC support
       entirely. Depends on CONFIG_EMBEDDED.

linux-2.6.22.7-embedded-dmi-disable-option.patch:
    * Allows you to remove DMI (Desktop Management Interface) parsing. 
Older computers do
       not have DMI structures in the BIOS, on these computers the DMI 
code is a waste of space.
       In my tests with applying this patch and disabling DMI removes 
6KB from
       arch/i386/boot/bzImage after compile. Apparently there is already 
a CONFIG_DMI out there,
       and #ifdef's in some parts to check this, so all this patch does 
is make CONFIG_DMI visible
       from "make menuconfig" while patching up other parts (like ACPI) 
that simply assume DMI
       functions are there. Depends on CONFIG_EMBEDDED.



--------------020504050109050407060300
Content-Type: text/plain;
 name="linux-2.6.22.7-embedded-dmi-disable-option.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.22.7-embedded-dmi-disable-option.patch"

diff -u -r linux-2.6.22.7-old/arch/i386/Kconfig linux-2.6.22.7/arch/i386/Kconfig
--- linux-2.6.22.7-old/arch/i386/Kconfig	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/arch/i386/Kconfig	2007-09-23 19:40:15.000000000 +0000
@@ -83,10 +83,6 @@
 	bool
 	default y
 
-config DMI
-	bool
-	default y
-
 source "init/Kconfig"
 
 menu "Processor type and features"
@@ -395,6 +391,19 @@
           XFree86 to initialize some video cards via BIOS. Disabling this
           option saves about 6k.
 
+config DMI
+	default y
+	bool "Enable DMI support" if EMBEDDED
+	depends on X86
+	help
+	  This enables support for processing the Desktop Management
+	  Interface structures present in most modern BIOSes. If you are
+	  building a kernel for an older Pentium, 486, or 386 system and
+	  memory is tight, you can disable this to help reduce the size
+	  of your kernel by about 6K.
+	  
+	  If unsure, say Y
+
 config TOSHIBA
 	tristate "Toshiba Laptop support"
 	---help---
diff -u -r linux-2.6.22.7-old/arch/i386/kernel/acpi/boot.c linux-2.6.22.7/arch/i386/kernel/acpi/boot.c
--- linux-2.6.22.7-old/arch/i386/kernel/acpi/boot.c	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/arch/i386/kernel/acpi/boot.c	2007-09-23 19:37:12.000000000 +0000
@@ -891,6 +891,7 @@
 	return 0;
 }
 
+#ifdef CONFIG_DMI
 static int __init dmi_disable_acpi(struct dmi_system_id *d)
 {
 	if (!acpi_force) {
@@ -1097,6 +1098,7 @@
 	 },
 	{}
 };
+#endif /* CONFIG_DMI */
 
 #endif				/* __i386__ */
 
@@ -1127,7 +1129,7 @@
 {
 	int error;
 
-#ifdef __i386__
+#if defined(__i386__) && defined(CONFIG_DMI)
 	dmi_check_system(acpi_dmi_table);
 #endif
 
diff -u -r linux-2.6.22.7-old/arch/i386/kernel/acpi/sleep.c linux-2.6.22.7/arch/i386/kernel/acpi/sleep.c
--- linux-2.6.22.7-old/arch/i386/kernel/acpi/sleep.c	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/arch/i386/kernel/acpi/sleep.c	2007-09-23 19:36:07.000000000 +0000
@@ -86,6 +86,7 @@
 	return 0;
 }
 
+#ifdef CONFIG_DMI
 static __initdata struct dmi_system_id acpisleep_dmi_table[] = {
 	{			/* Reset video mode after returning from ACPI S3 sleep */
 	 .callback = reset_videomode_after_s3,
@@ -104,3 +105,5 @@
 }
 
 core_initcall(acpisleep_dmi_init);
+#endif
+
diff -u -r linux-2.6.22.7-old/arch/i386/kernel/setup.c linux-2.6.22.7/arch/i386/kernel/setup.c
--- linux-2.6.22.7-old/arch/i386/kernel/setup.c	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/arch/i386/kernel/setup.c	2007-09-23 19:30:59.000000000 +0000
@@ -611,7 +611,9 @@
 	 * NOTE: at this point the bootmem allocator is fully available.
 	 */
 
+#ifdef CONFIG_DMI
 	dmi_scan_machine();
+#endif
 
 #ifdef CONFIG_X86_GENERICARCH
 	generic_apic_probe();
diff -u -r linux-2.6.22.7-old/arch/i386/kernel/tsc.c linux-2.6.22.7/arch/i386/kernel/tsc.c
--- linux-2.6.22.7-old/arch/i386/kernel/tsc.c	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/arch/i386/kernel/tsc.c	2007-09-23 19:36:37.000000000 +0000
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
@@ -369,8 +371,10 @@
 	set_cyc2ns_scale(cpu_khz);
 	use_tsc_delay();
 
+#ifdef CONFIG_DMI
 	/* Check and install the TSC clocksource */
 	dmi_check_system(bad_tsc_dmi_table);
+#endif
 
 	unsynchronized_tsc();
 	check_geode_tsc_reliable();
diff -u -r linux-2.6.22.7-old/drivers/acpi/Kconfig linux-2.6.22.7/drivers/acpi/Kconfig
--- linux-2.6.22.7-old/drivers/acpi/Kconfig	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/drivers/acpi/Kconfig	2007-09-23 19:48:07.000000000 +0000
@@ -263,6 +263,7 @@
 
 config ACPI_BLACKLIST_YEAR
 	int "Disable ACPI for systems before Jan 1st this year" if X86_32
+	depends on DMI
 	default 0
 	help
 	  enter a 4-digit year, eg. 2001 to disable ACPI by default
diff -u -r linux-2.6.22.7-old/drivers/acpi/osl.c linux-2.6.22.7/drivers/acpi/osl.c
--- linux-2.6.22.7-old/drivers/acpi/osl.c	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/drivers/acpi/osl.c	2007-09-23 19:24:27.000000000 +0000
@@ -139,7 +139,9 @@
 
 acpi_status __init acpi_os_initialize(void)
 {
+#ifdef CONFIG_DMI
 	dmi_check_system(acpi_osl_dmi_table);
+#endif
 	return AE_OK;
 }
 

--------------020504050109050407060300
Content-Type: text/plain;
 name="linux-2.6.22.7-embedded-disable-rdtsc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.22.7-embedded-disable-rdtsc.patch"

diff -u -r linux-2.6.22.7-old/arch/i386/Kconfig linux-2.6.22.7/arch/i386/Kconfig
--- linux-2.6.22.7-old/arch/i386/Kconfig	2007-09-23 20:44:10.000000000 +0000
+++ linux-2.6.22.7/arch/i386/Kconfig	2007-09-23 22:15:57.000000000 +0000
@@ -362,6 +362,18 @@
 	  to disable it.  MCE support simply ignores non-MCE processors like
 	  the 386 and 486, so nearly everyone can say Y here.
 
+config X86_TSC
+	bool "Use TSC as time source" if EMBEDDED
+	depends on X86
+	default y
+	help
+	  Uses the TSC (time stamp counter) in Pentium and newer systems as a
+	  high resolution timer. If you are compiling a kernel for older 386
+	  and 486 systems that do not have this counter, you can say N here
+	  to help reduce the size of your kernel.
+	  
+	  If unsure, say Y.
+
 config X86_MCE_NONFATAL
 	tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
 	depends on X86_MCE
diff -u -r linux-2.6.22.7-old/arch/i386/kernel/Makefile linux-2.6.22.7/arch/i386/kernel/Makefile
--- linux-2.6.22.7-old/arch/i386/kernel/Makefile	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/arch/i386/kernel/Makefile	2007-09-23 22:17:36.000000000 +0000
@@ -7,8 +7,9 @@
 obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_i386.o \
 		pci-dma.o i386_ksyms.o i387.o bootflag.o e820.o\
-		quirks.o i8237.o topology.o alternative.o i8253.o tsc.o
+		quirks.o i8237.o topology.o alternative.o i8253.o
 
+obj-$(CONFIG_X86_TSC)		+= tsc.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
diff -u -r linux-2.6.22.7-old/arch/i386/kernel/cpu/amd.c linux-2.6.22.7/arch/i386/kernel/cpu/amd.c
--- linux-2.6.22.7-old/arch/i386/kernel/cpu/amd.c	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/arch/i386/kernel/cpu/amd.c	2007-09-23 23:39:11.000000000 +0000
@@ -117,6 +117,7 @@
 				break;
 			}
 			
+#ifdef CONFIG_X86_TSC /* this test requires the presence of the TSC */
 			if ( c->x86_model == 6 && c->x86_mask == 1 ) {
 				const int K6_BUG_LOOP = 1000000;
 				int n;
@@ -144,6 +145,7 @@
 					printk("probably OK (after B9730xxxx).\n");
 				printk(KERN_INFO "Please see http://membres.lycos.fr/poulot/k6bug.html\n");
 			}
+#endif
 
 			/* K6 with old style WHCR */
 			if (c->x86_model < 8 ||
diff -u -r linux-2.6.22.7-old/arch/i386/lib/delay.c linux-2.6.22.7/arch/i386/lib/delay.c
--- linux-2.6.22.7-old/arch/i386/lib/delay.c	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/arch/i386/lib/delay.c	2007-09-23 23:15:42.000000000 +0000
@@ -37,6 +37,7 @@
 		:"0" (loops));
 }
 
+#ifdef CONFIG_X86_TSC
 /* TSC based delay: */
 static void delay_tsc(unsigned long loops)
 {
@@ -48,6 +49,7 @@
 		rdtscl(now);
 	} while ((now-bclock) < loops);
 }
+#endif
 
 /*
  * Since we calibrate only once at boot, this
@@ -55,6 +57,7 @@
  */
 static void (*delay_fn)(unsigned long) = delay_loop;
 
+#ifdef CONFIG_X86_TSC
 void use_tsc_delay(void)
 {
 	delay_fn = delay_tsc;
@@ -68,6 +71,7 @@
 	}
 	return -1;
 }
+#endif
 
 void __delay(unsigned long loops)
 {
diff -u -r linux-2.6.22.7-old/include/asm-i386/cpufeature.h linux-2.6.22.7/include/asm-i386/cpufeature.h
--- linux-2.6.22.7-old/include/asm-i386/cpufeature.h	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/include/asm-i386/cpufeature.h	2007-09-23 23:32:13.000000000 +0000
@@ -119,7 +119,11 @@
 #define cpu_has_vme		boot_cpu_has(X86_FEATURE_VME)
 #define cpu_has_de		boot_cpu_has(X86_FEATURE_DE)
 #define cpu_has_pse		boot_cpu_has(X86_FEATURE_PSE)
+#ifdef CONFIG_X86_TSC
 #define cpu_has_tsc		boot_cpu_has(X86_FEATURE_TSC)
+#else
+#define cpu_has_tsc		0
+#endif
 #define cpu_has_pae		boot_cpu_has(X86_FEATURE_PAE)
 #define cpu_has_pge		boot_cpu_has(X86_FEATURE_PGE)
 #define cpu_has_apic		boot_cpu_has(X86_FEATURE_APIC)
diff -u -r linux-2.6.22.7-old/include/asm-i386/delay.h linux-2.6.22.7/include/asm-i386/delay.h
--- linux-2.6.22.7-old/include/asm-i386/delay.h	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/include/asm-i386/delay.h	2007-09-23 23:16:25.000000000 +0000
@@ -26,6 +26,10 @@
 	((n) > 20000 ? __bad_ndelay() : __const_udelay((n) * 5ul)) : \
 	__ndelay(n))
 
+#ifdef CONFIG_X86_TSC
 void use_tsc_delay(void);
+#else
+static inline void use_tsc_delay(void) { }
+#endif
 
 #endif /* defined(_I386_DELAY_H) */
diff -u -r linux-2.6.22.7-old/include/asm-i386/msr.h linux-2.6.22.7/include/asm-i386/msr.h
--- linux-2.6.22.7-old/include/asm-i386/msr.h	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/include/asm-i386/msr.h	2007-09-23 23:41:08.000000000 +0000
@@ -60,12 +60,14 @@
 	return err;
 }
 
+#ifdef CONFIG_X86_TSC
 static inline unsigned long long native_read_tsc(void)
 {
 	unsigned long long val;
 	asm volatile("rdtsc" : "=A" (val));
 	return val;
 }
+#endif
 
 static inline unsigned long long native_read_pmc(void)
 {
@@ -117,6 +119,8 @@
 		__err;							\
 	})
 
+#ifdef CONFIG_X86_TSC
+
 #define rdtscl(low)						\
 	((low) = (u32)native_read_tsc())
 
@@ -125,6 +129,16 @@
 
 #define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
 
+#else /* CONFIG_X86_TSC */
+
+#define rdtscl(low) ((low) = 0)
+
+#define rdtscll(val) ((val) = 0)
+
+#define write_tsc(val1,val2)
+
+#endif /* CONFIG_X86_TSC */
+
 #define rdpmc(counter,low,high)					\
 	do {							\
 		u64 _l = native_read_pmc();			\
diff -u -r linux-2.6.22.7-old/include/asm-i386/processor.h linux-2.6.22.7/include/asm-i386/processor.h
--- linux-2.6.22.7-old/include/asm-i386/processor.h	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/include/asm-i386/processor.h	2007-09-23 22:58:59.000000000 +0000
@@ -24,7 +24,11 @@
 #include <asm/processor-flags.h>
 
 /* flag for disabling the tsc */
+#ifdef CONFIG_X86_TSC
 extern int tsc_disable;
+#else
+#  define tsc_disable 1
+#endif
 
 struct desc_struct {
 	unsigned long a,b;
diff -u -r linux-2.6.22.7-old/include/asm-i386/timer.h linux-2.6.22.7/include/asm-i386/timer.h
--- linux-2.6.22.7-old/include/asm-i386/timer.h	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/include/asm-i386/timer.h	2007-09-23 23:12:35.000000000 +0000
@@ -12,7 +12,12 @@
 extern int timer_ack;
 extern int no_timer_check;
 extern int no_sync_cmos_clock;
+
+#ifdef CONFIG_X86_TSC
 extern int recalibrate_cpu_khz(void);
+#else
+static inline int recalibrate_cpu_khz(void) { return -ENODEV; }
+#endif
 
 #ifndef CONFIG_PARAVIRT
 #define get_scheduled_cycles(val) rdtscll(val)
diff -u -r linux-2.6.22.7-old/include/asm-i386/timex.h linux-2.6.22.7/include/asm-i386/timex.h
--- linux-2.6.22.7-old/include/asm-i386/timex.h	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/include/asm-i386/timex.h	2007-09-23 23:20:42.000000000 +0000
@@ -15,8 +15,12 @@
 #  define CLOCK_TICK_RATE 1193182 /* Underlying HZ */
 #endif
 
-
+#ifdef CONFIG_X86_TSC
 extern int read_current_timer(unsigned long *timer_value);
+#else
+static inline int read_current_timer(unsigned long *timer_value) { return -1; }
+#endif
+
 #define ARCH_HAS_READ_CURRENT_TIMER	1
 
 #endif
diff -u -r linux-2.6.22.7-old/include/asm-i386/tsc.h linux-2.6.22.7/include/asm-i386/tsc.h
--- linux-2.6.22.7-old/include/asm-i386/tsc.h	2007-09-21 22:38:23.000000000 +0000
+++ linux-2.6.22.7/include/asm-i386/tsc.h	2007-09-23 23:36:29.000000000 +0000
@@ -25,7 +25,7 @@
 		return 0;
 #endif
 
-#if defined(CONFIG_X86_GENERIC) || defined(CONFIG_X86_TSC)
+#if defined(CONFIG_X86_GENERIC) && defined(CONFIG_X86_TSC)
 	rdtscll(ret);
 #endif
 	return ret;
@@ -34,6 +34,7 @@
 /* Like get_cycles, but make sure the CPU is synchronized. */
 static __always_inline cycles_t get_cycles_sync(void)
 {
+#ifdef CONFIG_X86_TSC
 	unsigned long long ret;
 	unsigned eax, edx;
 
@@ -57,8 +58,12 @@
 	rdtscll(ret);
 
 	return ret;
+#else
+	return 0;
+#endif
 }
 
+#ifdef CONFIG_X86_TSC
 extern void tsc_init(void);
 extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
@@ -70,5 +75,15 @@
  */
 extern void check_tsc_sync_source(int cpu);
 extern void check_tsc_sync_target(void);
+#else /* CONFIG_X86_TSC */
+/* effectively disable all calls to TSC functions.
+ * GCC should optimize these inline functions down to nothing. */
+static inline void tsc_init(void) { }
+static inline void mark_tsc_unstable(char *reason) { }
+static inline int unsynchronized_tsc(void) { return 1; }
+static inline void init_tsc_clocksource(void) { }
+static inline void check_tsc_sync_source(int cpu) { }
+static inline void check_tsc_sync_target(void) { }
+#endif /* CONFIG_X86_TSC */
 
 #endif


--------------020504050109050407060300--

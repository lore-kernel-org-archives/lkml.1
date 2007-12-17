Return-Path: <linux-kernel-owner+w=401wt.eu-S934698AbXLQB6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934698AbXLQB6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 20:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbXLQB6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 20:58:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:6859 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758668AbXLQB6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 20:58:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=afpqGAV6IBZBB8xrG/iwfx3IbFS6zWZsFh6B6NFI6J8O9qPggWUxNXvajPZWII9dq5jboWdsRzHimyXIFRPT7n3bR1ivS5q9C2ifEC/kxNoW983UBUMNLQTzP+cbb+NmdCEATagjtHWacYwj9RCfXesNNoUbcKpb0YMGNjDwAgk=
Message-ID: <4765D745.7040306@gmail.com>
Date: Mon, 17 Dec 2007 02:56:21 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Paul Rolland <rol@as2917.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <469578CD.3080609@reed.com>	<1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <4765B0CF.2040000@reed.com>
In-Reply-To: <4765B0CF.2040000@reed.com>
Content-Type: multipart/mixed;
 boundary="------------050102070105000203070602"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050102070105000203070602
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 17-12-07 00:12, David P. Reed wrote:

> Rene Herman wrote:
>> David: I've plugged in your DMI values in this. Could you perhaps test 
>> this to confirm that it works for you?
>>
> Will test it by tomorrow morning.

Might as well test the new version then. Ingo Molnar requested a few changes 
and this fixes a couple of problems as well.

Rene.



--------------050102070105000203070602
Content-Type: text/plain;
 name="dmi-io_delay2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmi-io_delay2.diff"

commit 5001121e449040aa9cc021f69bfb191662c13004
Author: Rene Herman <rene.herman@gmail.com>
Date:   Sun Dec 16 13:36:39 2007 +0100

    x86: provide a DMI based port 0x80 I/O delay override.
    
    Certain (HP) laptops experience trouble from our port 0x80 I/O delay
    writes. This patch provides for a DMI based switch to the "alternate
    diagnostic port" 0xed (as used by some BIOSes as well) for these.
    
    David P. Reed confirmed that port 0xed works for him and provides a
    proper delay. The symptoms of _not_ working are a hanging machine,
    with "hwclock" use being a direct trigger.
    
    Earlier versions of this attempted to simply use udelay(2), with the
    2 being a value tested to be a nicely conservative upper-bound with
    help from many on the linux-kernel mailinglist but that approach has
    two problems.
    
    First, pre-loops_per_jiffy calibration (which is post PIT init while
    some implementations of the PIT are actually one of the historically
    problematic devices that need the delay) udelay() isn't particularly
    well-defined. We could initialise loops_per_jiffy conservatively (and
    based on CPU family so as to not unduly delay old machines) which
    would sort of work, but...
    
    Second, delaying isn't the only effect that a write to port 0x80 has.
    It's also a PCI posting barrier which some devices may be explicitly
    or implicitly relying on. Alan Cox did a survey and found evidence
    that additionally some drivers may be racy on SMP without the bus
    locking outb.
    
    Switching to an inb() makes the timing too unpredictable and as such,
    this DMI based switch should be the safest approach for now. Any more
    invasive changes should get more rigid testing first. It's moreover
    only very few machines with the problem and a DMI based hack seems
    to fit that situation.
    
    This also introduces a command-line parameter "io_delay" to override
    the DMI based choice again:
    
    	io_delay=<standard|alternate>
    
    where "standard" means using the standard port 0x80 and "alternate"
    port 0xed.
    
    At the request of Ingo Molnar this retains the udelay method as a
    config (CONFIG_UDELAY_IO_DELAY) and command-line ("io_delay=udelay")
    choice for testing purposes as well.
    
    This does not change the io_delay() in the boot code which is using
    the same port 0x80 I/O delay but those do not appear to be a problem
    as David P. Reed reported the problem was already gone after using the
    udelay version. He moreover reported that booting with "acpi=off" also
    fixed things and seeing as how ACPI isn't touched until after this DMI
    based I/O port switch I believe it's safe to leave the ones in the boot
    code be.
    
    The DMI strings from David's HP Pavilion dv9000z are in there already
    and we need to get/verify the DMI info from other machines with the
    problem, notably the HP Pavilion dv6000z.
    
    This patch is partly based on earlier patches from Pavel Machek and
    David P. Reed.
    
    Signed-off-by: Rene Herman <rene.herman@gmail.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 33121d6..9dce154 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -785,6 +785,14 @@ and is between 256 and 4096 characters. It is defined in the file
 			for translation below 32 bit and if not available
 			then look in the higher range.
 
+	io_delay=	[X86-32,X86-64] I/O delay method
+		standard
+			Standard port 0x80 delay
+		alternate
+			Alternate port 0xed delay
+		udelay
+			Simple two microsecond delay
+
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
 			arch/alpha/kernel/core_marvel.c.
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 761ca7b..40aba67 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -112,4 +112,13 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
+config UDELAY_IO_DELAY
+	bool "Delay I/O through udelay instead of outb"
+	depends on DEBUG_KERNEL
+	help
+	  Make inb_p/outb_p use udelay() based delays by default. Please note
+	  that udelay() does not have the same bus-level side-effects that
+	  the normal outb based delay does meaning this could cause drivers
+	  to change behaviour and/or bugs to surface.
+
 endmenu
diff --git a/arch/x86/boot/compressed/misc_32.c b/arch/x86/boot/compressed/misc_32.c
index b74d60d..288e162 100644
--- a/arch/x86/boot/compressed/misc_32.c
+++ b/arch/x86/boot/compressed/misc_32.c
@@ -276,10 +276,10 @@ static void putstr(const char *s)
 	RM_SCREEN_INFO.orig_y = y;
 
 	pos = (x + cols * y) * 2;	/* Update cursor position */
-	outb_p(14, vidport);
-	outb_p(0xff & (pos >> 9), vidport+1);
-	outb_p(15, vidport);
-	outb_p(0xff & (pos >> 1), vidport+1);
+	outb(14, vidport);
+	outb(0xff & (pos >> 9), vidport+1);
+	outb(15, vidport);
+	outb(0xff & (pos >> 1), vidport+1);
 }
 
 static void* memset(void* s, int c, unsigned n)
diff --git a/arch/x86/boot/compressed/misc_64.c b/arch/x86/boot/compressed/misc_64.c
index 6ea015a..43e5fcc 100644
--- a/arch/x86/boot/compressed/misc_64.c
+++ b/arch/x86/boot/compressed/misc_64.c
@@ -269,10 +269,10 @@ static void putstr(const char *s)
 	RM_SCREEN_INFO.orig_y = y;
 
 	pos = (x + cols * y) * 2;	/* Update cursor position */
-	outb_p(14, vidport);
-	outb_p(0xff & (pos >> 9), vidport+1);
-	outb_p(15, vidport);
-	outb_p(0xff & (pos >> 1), vidport+1);
+	outb(14, vidport);
+	outb(0xff & (pos >> 9), vidport+1);
+	outb(15, vidport);
+	outb(0xff & (pos >> 1), vidport+1);
 }
 
 static void* memset(void* s, int c, unsigned n)
diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index a7bc93c..0cc1981 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -8,7 +8,7 @@ CPPFLAGS_vmlinux.lds += -Ui386
 obj-y	:= process_32.o signal_32.o entry_32.o traps_32.o irq_32.o \
 		ptrace_32.o time_32.o ioport_32.o ldt_32.o setup_32.o i8259_32.o sys_i386_32.o \
 		pci-dma_32.o i386_ksyms_32.o i387_32.o bootflag.o e820_32.o\
-		quirks.o i8237.o topology.o alternative.o i8253.o tsc_32.o
+		quirks.o i8237.o topology.o alternative.o i8253.o tsc_32.o io_delay.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index 5a88890..08a68f0 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -11,7 +11,7 @@ obj-y	:= process_64.o signal_64.o entry_64.o traps_64.o irq_64.o \
 		x8664_ksyms_64.o i387_64.o syscall_64.o vsyscall_64.o \
 		setup64.o bootflag.o e820_64.o reboot_64.o quirks.o i8237.o \
 		pci-dma_64.o pci-nommu_64.o alternative.o hpet.o tsc_64.o bugs_64.o \
-		i8253.o
+		i8253.o io_delay.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
diff --git a/arch/x86/kernel/io_delay.c b/arch/x86/kernel/io_delay.c
new file mode 100644
index 0000000..4d955e7
--- /dev/null
+++ b/arch/x86/kernel/io_delay.c
@@ -0,0 +1,106 @@
+/*
+ * I/O delay strategies for inb_p/outb_p
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/dmi.h>
+#include <asm/io.h>
+
+/*
+ * Allow for a DMI based override of port 0x80 needed for certain HP laptops
+ */
+#define IO_DELAY_PORT_STD 0x80
+#define IO_DELAY_PORT_ALT 0xed
+
+static void standard_io_delay(void)
+{
+	asm volatile ("outb %%al, %0" : : "N" (IO_DELAY_PORT_STD));
+}
+
+static void alternate_io_delay(void)
+{
+	asm volatile ("outb %%al, %0" : : "N" (IO_DELAY_PORT_ALT));
+}
+
+/*
+ * 2 usecs is an upper-bound for the outb delay but note that udelay doesn't
+ * have the bus-level side-effects that outb does
+ */
+#define IO_DELAY_USECS 2
+
+/*
+ * High on a hill was a lonely goatherd
+ */
+static void udelay_io_delay(void)
+{
+	udelay(IO_DELAY_USECS);
+}
+
+#ifndef CONFIG_UDELAY_IO_DELAY
+static void (*io_delay)(void) = standard_io_delay;
+#else
+static void (*io_delay)(void) = udelay_io_delay;
+#endif
+
+/*
+ * Paravirt wants native_io_delay to be a constant.
+ */
+void native_io_delay(void)
+{
+	io_delay();
+}
+EXPORT_SYMBOL(native_io_delay);
+
+#ifndef CONFIG_UDELAY_IO_DELAY
+static int __init dmi_alternate_io_delay_port(const struct dmi_system_id *id)
+{
+	printk(KERN_NOTICE "%s: using alternate I/O delay port\n", id->ident);
+	io_delay = alternate_io_delay;
+	return 0;
+}
+
+static struct dmi_system_id __initdata alternate_io_delay_port_dmi_table[] = {
+	{
+		.callback	= dmi_alternate_io_delay_port,
+		.ident		= "HP Pavilion dv9000z",
+		.matches	= {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
+			DMI_MATCH(DMI_BOARD_NAME, "30B9")
+		}
+	},
+	{
+	}
+};
+
+static int __initdata io_delay_override;
+
+void __init io_delay_init(void)
+{
+	if (!io_delay_override)
+		dmi_check_system(alternate_io_delay_port_dmi_table);
+}
+#endif
+
+static int __init io_delay_param(char *s)
+{
+	if (!s)
+		return -EINVAL;
+
+	if (!strcmp(s, "standard"))
+		io_delay = standard_io_delay;
+	else if (!strcmp(s, "alternate"))
+		io_delay = alternate_io_delay;
+	else if (!strcmp(s, "udelay"))
+		io_delay = udelay_io_delay;
+	else
+		return -EINVAL;
+
+#ifndef CONFIG_UDELAY_IO_DELAY
+	io_delay_override = 1;
+#endif
+	return 0;
+}
+
+early_param("io_delay", io_delay_param);
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index e1e18c3..6c3a3b4 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -648,6 +648,8 @@ void __init setup_arch(char **cmdline_p)
 
 	dmi_scan_machine();
 
+	io_delay_init();;
+
 #ifdef CONFIG_X86_GENERICARCH
 	generic_apic_probe();
 #endif	
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 30d94d1..ec976ed 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -311,6 +311,8 @@ void __init setup_arch(char **cmdline_p)
 
 	dmi_scan_machine();
 
+	io_delay_init();
+
 #ifdef CONFIG_SMP
 	/* setup to use the static apicid table during kernel startup */
 	x86_cpu_to_apicid_ptr = (void *)&x86_cpu_to_apicid_init;
diff --git a/include/asm-x86/io_32.h b/include/asm-x86/io_32.h
index fe881cd..a8d25c3 100644
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -250,10 +250,14 @@ static inline void flush_write_buffers(void)
 
 #endif /* __KERNEL__ */
 
-static inline void native_io_delay(void)
+#ifndef CONFIG_UDELAY_IO_DELAY
+extern void io_delay_init(void);
+#else
+static inline void io_delay_init(void)
 {
-	asm volatile("outb %%al,$0x80" : : : "memory");
 }
+#endif
+extern void native_io_delay(void);
 
 #if defined(CONFIG_PARAVIRT)
 #include <asm/paravirt.h>
diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
index a037b07..5bebaf9 100644
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -35,13 +35,24 @@
   *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
   */
 
-#define __SLOW_DOWN_IO "\noutb %%al,$0x80"
+#ifndef CONFIG_UDELAY_IO_DELAY
+extern void io_delay_init(void);
+#else
+static inline void io_delay_init(void)
+{
+}
+#endif
+extern void native_io_delay(void);
 
+static inline void slow_down_io(void)
+{
+	native_io_delay();
 #ifdef REALLY_SLOW_IO
-#define __FULL_SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO
-#else
-#define __FULL_SLOW_DOWN_IO __SLOW_DOWN_IO
+	native_io_delay();
+	native_io_delay();
+	native_io_delay();
 #endif
+}
 
 /*
  * Talk about misusing macros..
@@ -50,21 +61,21 @@
 static inline void out##s(unsigned x value, unsigned short port) {
 
 #define __OUT2(s,s1,s2) \
-__asm__ __volatile__ ("out" #s " %" s1 "0,%" s2 "1"
+__asm__ __volatile__ ("out" #s " %" s1 "0,%" s2 "1" : : "a" (value), "Nd" (port))
 
 #define __OUT(s,s1,x) \
-__OUT1(s,x) __OUT2(s,s1,"w") : : "a" (value), "Nd" (port)); } \
-__OUT1(s##_p,x) __OUT2(s,s1,"w") __FULL_SLOW_DOWN_IO : : "a" (value), "Nd" (port));} \
+__OUT1(s,x) __OUT2(s,s1,"w"); } \
+__OUT1(s##_p,x) __OUT2(s,s1,"w"); slow_down_io(); }
 
 #define __IN1(s) \
 static inline RETURN_TYPE in##s(unsigned short port) { RETURN_TYPE _v;
 
 #define __IN2(s,s1,s2) \
-__asm__ __volatile__ ("in" #s " %" s2 "1,%" s1 "0"
+__asm__ __volatile__ ("in" #s " %" s2 "1,%" s1 "0" : "=a" (_v) : "Nd" (port))
 
-#define __IN(s,s1,i...) \
-__IN1(s) __IN2(s,s1,"w") : "=a" (_v) : "Nd" (port) ,##i ); return _v; } \
-__IN1(s##_p) __IN2(s,s1,"w") __FULL_SLOW_DOWN_IO : "=a" (_v) : "Nd" (port) ,##i ); return _v; } \
+#define __IN(s,s1) \
+__IN1(s) __IN2(s,s1,"w"); return _v; } \
+__IN1(s##_p) __IN2(s,s1,"w"); slow_down_io(); return _v; }
 
 #define __INS(s) \
 static inline void ins##s(unsigned short port, void * addr, unsigned long count) \

--------------050102070105000203070602--

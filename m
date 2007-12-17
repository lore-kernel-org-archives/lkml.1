Return-Path: <linux-kernel-owner+w=401wt.eu-S935167AbXLQVrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935167AbXLQVrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762027AbXLQVrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:47:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52370 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759174AbXLQVrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:47:09 -0500
Date: Mon, 17 Dec 2007 22:46:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20071217214600.GD22828@elte.hu>
References: <4766684D.40202@gmail.com> <20071217130933.GB27992@elte.hu> <47667812.8050708@gmail.com> <47667A85.3080100@reed.com> <20071217143900.GA16604@elte.hu> <20071217161243.05c32df4@the-village.bc.nu> <4766E086.9090500@gmail.com> <4766E2B5.8080001@zytor.com> <4766EB45.6010402@keyaccess.nl> <4766ECE2.1060604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4766ECE2.1060604@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Rene Herman wrote:
>>
>> Well, yes, I guess that does make sense. It's back again. Named the 
>> choices "standard" and "alternate" again as I feel "0x80" and "0xed" 
>> suggest they're free values a bit too much but if anyone feels 
>> strongly about it, so be it.
>
> They ARE -- or really, should be, free values (0xeb and 0xf0 are other 
> reasonable values, for example.)

yeah. We've got the variant below for now, tested by David. We can still 
change things later on if the need arises.

	Ingo

-------------->
Subject: x86: provide a DMI based port 0x80 I/O delay override.
From: Rene Herman <rene.herman@gmail.com>

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

	io_delay=<0x80|0xed|udelay|none>

where 0x80 means using the standard port 0x80 and 0xed means the
alternate port 0xed.

All these methods can also be selected via the kernel .config,
and can be runtime tuned via /proc/sys/kernel/io_delay_type (for
debugging purposes).

The DMI strings from David's HP Pavilion dv9000z are in there already
and we need to get/verify the DMI info from other machines with the
problem, notably the HP Pavilion dv6000z.

This patch is partly based on earlier patches from Pavel Machek and
David P. Reed.

[ mingo@elte.hu:
  - add the io_delay=none method
  - make each method selectable from the kernel config
  - eliminate the indirect function calls
  - add the /proc/sys/kernel/io_delay_type sysctl
  - change 'standard' and 'alternate' to 0x80 and 0xed
  - make the io delay config not depend on CONFIG_DEBUG_KERNEL ]

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: "David P. Reed" <dpreed@reed.com>
---
 Documentation/kernel-parameters.txt |   10 +++
 arch/x86/Kconfig.debug              |   74 +++++++++++++++++++++++++++
 arch/x86/boot/compressed/misc_32.c  |    8 +-
 arch/x86/boot/compressed/misc_64.c  |    8 +-
 arch/x86/kernel/Makefile_32         |    2 
 arch/x86/kernel/Makefile_64         |    2 
 arch/x86/kernel/io_delay.c          |   98 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup_32.c          |    2 
 arch/x86/kernel/setup_64.c          |    2 
 include/asm-x86/io_32.h             |    8 +-
 include/asm-x86/io_64.h             |   29 ++++++----
 kernel/sysctl.c                     |    9 +++
 12 files changed, 227 insertions(+), 25 deletions(-)

Index: linux-x86.q/Documentation/kernel-parameters.txt
===================================================================
--- linux-x86.q.orig/Documentation/kernel-parameters.txt
+++ linux-x86.q/Documentation/kernel-parameters.txt
@@ -785,6 +785,16 @@ and is between 256 and 4096 characters. 
 			for translation below 32 bit and if not available
 			then look in the higher range.
 
+	io_delay=	[X86-32,X86-64] I/O delay method
+		0x80
+			Standard port 0x80 based delay
+		0xed
+			Alternate port 0xed based delay (needed on some systems)
+		udelay
+			Simple two microseconds delay
+		none
+			No delay
+
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
 			arch/alpha/kernel/core_marvel.c.
Index: linux-x86.q/arch/x86/Kconfig.debug
===================================================================
--- linux-x86.q.orig/arch/x86/Kconfig.debug
+++ linux-x86.q/arch/x86/Kconfig.debug
@@ -112,4 +112,78 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
+#
+# IO delay types:
+#
+
+config IO_DELAY_TYPE_0X80
+	int
+	default "0"
+
+config IO_DELAY_TYPE_0XED
+	int
+	default "1"
+
+config IO_DELAY_TYPE_UDELAY
+	int
+	default "2"
+
+config IO_DELAY_TYPE_NONE
+	int
+	default "3"
+
+choice
+	prompt "IO delay type"
+	default IO_DELAY_0X80
+
+config IO_DELAY_0X80
+	bool "port 0x80 based port-IO delay [recommended]"
+	help
+	  This is the traditional Linux IO delay used for in/out_p.
+	  It is the most tested hence safest selection here.
+
+config IO_DELAY_0XED
+	bool "port 0xed based port-IO delay"
+	help
+	  Use port 0xed as the IO delay. This frees up port 0x80 which is
+	  often used as a hardware-debug port.
+
+config IO_DELAY_UDELAY
+	bool "udelay based port-IO delay"
+	help
+	  Use udelay(2) as the IO delay method. This provides the delay
+	  while not having any side-effect on the IO port space.
+
+config IO_DELAY_NONE
+	bool "no port-IO delay"
+	help
+	  No port-IO delay. Will break on old boxes that require port-IO
+	  delay for certain operations. Should work on most new machines.
+
+endchoice
+
+if IO_DELAY_0X80
+config DEFAULT_IO_DELAY_TYPE
+	int
+	default IO_DELAY_TYPE_0X80
+endif
+
+if IO_DELAY_0XED
+config DEFAULT_IO_DELAY_TYPE
+	int
+	default IO_DELAY_TYPE_0XED
+endif
+
+if IO_DELAY_UDELAY
+config DEFAULT_IO_DELAY_TYPE
+	int
+	default IO_DELAY_TYPE_UDELAY
+endif
+
+if IO_DELAY_NONE
+config DEFAULT_IO_DELAY_TYPE
+	int
+	default IO_DELAY_TYPE_NONE
+endif
+
 endmenu
Index: linux-x86.q/arch/x86/boot/compressed/misc_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/boot/compressed/misc_32.c
+++ linux-x86.q/arch/x86/boot/compressed/misc_32.c
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
Index: linux-x86.q/arch/x86/boot/compressed/misc_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/boot/compressed/misc_64.c
+++ linux-x86.q/arch/x86/boot/compressed/misc_64.c
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
Index: linux-x86.q/arch/x86/kernel/Makefile_32
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/Makefile_32
+++ linux-x86.q/arch/x86/kernel/Makefile_32
@@ -8,7 +8,7 @@ CPPFLAGS_vmlinux.lds += -Ui386
 obj-y	:= process_32.o signal_32.o entry_32.o traps_32.o irq_32.o \
 		ptrace_32.o time_32.o ioport_32.o ldt_32.o setup_32.o i8259_32.o sys_i386_32.o \
 		pci-dma_32.o i386_ksyms_32.o i387_32.o bootflag.o e820_32.o\
-		quirks.o i8237.o topology.o alternative.o i8253.o tsc_32.o
+		quirks.o i8237.o topology.o alternative.o i8253.o tsc_32.o io_delay.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
Index: linux-x86.q/arch/x86/kernel/Makefile_64
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/Makefile_64
+++ linux-x86.q/arch/x86/kernel/Makefile_64
@@ -11,7 +11,7 @@ obj-y	:= process_64.o signal_64.o entry_
 		x8664_ksyms_64.o i387_64.o syscall_64.o vsyscall_64.o \
 		setup64.o bootflag.o e820_64.o reboot_64.o quirks.o i8237.o \
 		pci-dma_64.o pci-nommu_64.o alternative.o hpet.o tsc_64.o bugs_64.o \
-		i8253.o
+		i8253.o io_delay.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
Index: linux-x86.q/arch/x86/kernel/io_delay.c
===================================================================
--- /dev/null
+++ linux-x86.q/arch/x86/kernel/io_delay.c
@@ -0,0 +1,98 @@
+/*
+ * I/O delay strategies for inb_p/outb_p
+ *
+ * Allow for a DMI based override of port 0x80, needed for certain HP laptops
+ * and possibly other systems. Also allow for the gradual elimination of
+ * outb_p/inb_p API uses.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/dmi.h>
+#include <asm/io.h>
+
+int io_delay_type __read_mostly = CONFIG_DEFAULT_IO_DELAY_TYPE;
+EXPORT_SYMBOL_GPL(io_delay_type);
+
+static int __initdata io_delay_override;
+
+/*
+ * Paravirt wants native_io_delay to be a constant.
+ */
+void native_io_delay(void)
+{
+	switch (io_delay_type) {
+	default:
+	case CONFIG_IO_DELAY_TYPE_0X80:
+		asm volatile ("outb %al, $0x80");
+		break;
+	case CONFIG_IO_DELAY_TYPE_0XED:
+		asm volatile ("outb %al, $0xed");
+		break;
+	case CONFIG_IO_DELAY_TYPE_UDELAY:
+		/*
+		 * 2 usecs is an upper-bound for the outb delay but
+		 * note that udelay doesn't have the bus-level
+		 * side-effects that outb does, nor does udelay() have
+		 * precise timings during very early bootup (the delays
+		 * are shorter until calibrated):
+		 */
+		udelay(2);
+	case CONFIG_IO_DELAY_TYPE_NONE:
+		break;
+	}
+}
+EXPORT_SYMBOL(native_io_delay);
+
+static int __init dmi_io_delay_0xed_port(const struct dmi_system_id *id)
+{
+	if (io_delay_type == CONFIG_IO_DELAY_TYPE_0X80) {
+		printk(KERN_NOTICE "%s: using 0xed I/O delay port\n",
+			id->ident);
+		io_delay_type = CONFIG_IO_DELAY_TYPE_0XED;
+	}
+
+	return 0;
+}
+
+/*
+ * Quirk table for systems that misbehave (lock up, etc.) if port
+ * 0x80 is used:
+ */
+static struct dmi_system_id __initdata io_delay_0xed_port_dmi_table[] = {
+	{
+		.callback	= dmi_io_delay_0xed_port,
+		.ident		= "HP Pavilion dv9000z",
+		.matches	= {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
+			DMI_MATCH(DMI_BOARD_NAME, "30B9")
+		}
+	},
+	{ }
+};
+
+void __init io_delay_init(void)
+{
+	if (!io_delay_override)
+		dmi_check_system(io_delay_0xed_port_dmi_table);
+}
+
+static int __init io_delay_param(char *s)
+{
+	if (!strcmp(s, "0x80"))
+		io_delay_type = CONFIG_IO_DELAY_TYPE_0X80;
+	else if (!strcmp(s, "0xed"))
+		io_delay_type = CONFIG_IO_DELAY_TYPE_0XED;
+	else if (!strcmp(s, "udelay"))
+		io_delay_type = CONFIG_IO_DELAY_TYPE_UDELAY;
+	else if (!strcmp(s, "none"))
+		io_delay_type = CONFIG_IO_DELAY_TYPE_NONE;
+	else
+		return -EINVAL;
+
+	io_delay_override = 1;
+	return 0;
+}
+
+early_param("io_delay", io_delay_param);
Index: linux-x86.q/arch/x86/kernel/setup_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/setup_32.c
+++ linux-x86.q/arch/x86/kernel/setup_32.c
@@ -648,6 +648,8 @@ void __init setup_arch(char **cmdline_p)
 
 	dmi_scan_machine();
 
+	io_delay_init();;
+
 #ifdef CONFIG_X86_GENERICARCH
 	generic_apic_probe();
 #endif	
Index: linux-x86.q/arch/x86/kernel/setup_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/setup_64.c
+++ linux-x86.q/arch/x86/kernel/setup_64.c
@@ -311,6 +311,8 @@ void __init setup_arch(char **cmdline_p)
 
 	dmi_scan_machine();
 
+	io_delay_init();
+
 #ifdef CONFIG_SMP
 	/* setup to use the static apicid table during kernel startup */
 	x86_cpu_to_apicid_ptr = (void *)&x86_cpu_to_apicid_init;
Index: linux-x86.q/include/asm-x86/io_32.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/io_32.h
+++ linux-x86.q/include/asm-x86/io_32.h
@@ -250,10 +250,10 @@ static inline void flush_write_buffers(v
 
 #endif /* __KERNEL__ */
 
-static inline void native_io_delay(void)
-{
-	asm volatile("outb %%al,$0x80" : : : "memory");
-}
+extern void native_io_delay(void);
+
+extern int io_delay_type;
+extern void io_delay_init(void);
 
 #if defined(CONFIG_PARAVIRT)
 #include <asm/paravirt.h>
Index: linux-x86.q/include/asm-x86/io_64.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/io_64.h
+++ linux-x86.q/include/asm-x86/io_64.h
@@ -35,13 +35,20 @@
   *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
   */
 
-#define __SLOW_DOWN_IO "\noutb %%al,$0x80"
+extern void native_io_delay(void);
 
+extern int io_delay_type;
+extern void io_delay_init(void);
+
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
@@ -50,21 +57,21 @@
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
Index: linux-x86.q/kernel/sysctl.c
===================================================================
--- linux-x86.q.orig/kernel/sysctl.c
+++ linux-x86.q/kernel/sysctl.c
@@ -53,6 +53,7 @@
 #ifdef CONFIG_X86
 #include <asm/nmi.h>
 #include <asm/stacktrace.h>
+#include <asm/io.h>
 #endif
 
 static int deprecated_sysctl_warning(struct __sysctl_args *args);
@@ -683,6 +684,14 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "io_delay_type",
+		.data		= &io_delay_type,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #endif
 #if defined(CONFIG_MMU)
 	{

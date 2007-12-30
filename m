Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbXL3DiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbXL3DiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 22:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbXL3DiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 22:38:05 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:57563 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbXL3DiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 22:38:03 -0500
Message-ID: <477711DC.5030800@keyaccess.nl>
Date: Sun, 30 Dec 2007 04:34:52 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: dpreed@reed.com, Islam Amer <pharon@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Content-Type: multipart/mixed;
 boundary="------------060401090409000200040709"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060401090409000200040709
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Linus.

[ resend, forgot the CC to linux-kernel. sorry ]

This fixes "hwclock" triggered boottime hangs for a few HP/Compaq laptops
and might as such be applicable to 2.6.24 still.

The kernel's use of an outb to port 0x80 as an I/O delay disagrees with
these machines (after ACPI is live, that is) and this provides for a DMI
based switch to alternate port 0xed for them.

Complete changelog inside the patch.

An evolved version of this patch that also supplies udelay(2) and <nothing>
as I/O delay lives in the x86.git tree as well but Alan Cox suggested those
choices shouldn't yet be provided as he's finding races in drivers on SMP
without the bus-locking outb.

As a minimal version I thought you might perhaps want to take this as a
specific fix for the afflicted laptops for 2.6.24. H. Peter Anvin earlier
agreed it would be minimal enough for that.

It was tested on both of the afflicted machines the DMI strings cover and
doesn't change anything on others by default. It also introduces a bootparam
io_delay=<standard|alternate> to make (or override) the choice manually.

   Documentation/kernel-parameters.txt |    6 ++
   arch/x86/boot/compressed/misc_32.c  |    8 +--
   arch/x86/boot/compressed/misc_64.c  |    8 +--
   arch/x86/kernel/Makefile_32         |    2
   arch/x86/kernel/Makefile_64         |    2
   arch/x86/kernel/io_delay.c          |   77
++++++++++++++++++++++++++++++++++++
   arch/x86/kernel/setup_32.c          |    2
   arch/x86/kernel/setup_64.c          |    2
   include/asm-x86/io_32.h             |    6 --
   include/asm-x86/io_64.h             |   27 +++++++-----
   10 files changed, 115 insertions(+), 25 deletions(-)

Rene.


--------------060401090409000200040709
Content-Type: text/plain;
 name="dmi-port80-minimal-bootparam.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmi-port80-minimal-bootparam.diff"

commit b2a10c0b8e6c1c73b940e60fae4cbe9db9ca9e3b
Author: Rene Herman <rene.herman@gmail.com>
Date:   Mon Dec 17 21:23:55 2007 +0100

    x86: provide a DMI based port 0x80 I/O delay override.
    
    Certain (HP/Compaq) laptops experience trouble from our port 0x80
    I/O delay writes. This patch provides for a DMI based switch to the
    "alternate diagnostic port" 0xed (as used by some BIOSes as well)
    for these.
    
    David P. Reed confirmed that using port 0xed works and provides a
    proper delay on his HP Pavilion dv9000z, Islam Amer comfirmed that
    it does so on a Compaq Presario V6000. Both are Quanta boards, type
    30B9 and 30B7 respectively and are the (only) machines for which
    the DMI based switch triggers. HP Pavilion dv6000z is expected to
    also need this but its DMI info hasn't been verified yet.
    
    The symptoms of _not_ working are a hanging machine, with "hwclock"
    use being a direct trigger and therefore the bootup often hanging
    already on these machines.
    
    Earlier versions of this attempted to simply use udelay(2), with the
    2 being a value tested to be a nicely conservative upper-bound with
    help from many on the linux-kernel mailinglist, but that approach has
    two problems.
    
    First, pre-loops_per_jiffy calibration (which is post PIT init while
    some implementations of the PIT are actually one of the historically
    problematic devices that need the delay) udelay() isn't particularly
    well-defined. We could initialise loops_per_jiffy conservatively (and
    based on CPU family so as to not unduly delay old machines) which
    would sort of work, but still leaves:
    
    Second, delaying isn't the only effect that a write to port 0x80 has.
    It's also a PCI posting barrier which some devices may be explicitly
    or implicitly relying on. Alan Cox did a survey and found evidence
    that additionally various drivers are racy on SMP without the bus
    locking outb.
    
    Switching to an inb() makes the timing too unpredictable and as such,
    this DMI based switch should be the safest approach for now. Any more
    invasive changes should get more rigid testing first. It's moreover
    only very few machines with the problem and a DMI based hack seems
    to fit that situation.
    
    An early boot parameter to make the choice manually (and override any
    possible DMI based decision) is also provided:
    
    	io_delay=standard|alternate
    
    This does not change the io_delay() in the boot code which is using
    the same port 0x80 I/O delay but those do not appear to be a problem
    as tested by David P. Reed. He moreover reported that booting with
    "acpi=off" also fixed things and seeing as how ACPI isn't touched
    until after this DMI based I/O port switch leaving the ones in the
    boot code be is safe.
    
    This patch is partly based on earlier patches from Pavel Machek and
    David P. Reed.
    
    Signed-off-by: Rene Herman <rene.herman@gmail.com>
    Tested-by: David P. Reed <dpreed@reed.com>
    Tested-by: Islam Amer <pharon@gmail.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 33121d6..6948e25 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -785,6 +785,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			for translation below 32 bit and if not available
 			then look in the higher range.
 
+	io_delay=	[X86-32,X86-64] I/O delay port
+		standard
+			Use the 0x80 standard I/O delay port (default)
+		alternate
+			Use the 0xed alternate I/O delay port
+
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
 			arch/alpha/kernel/core_marvel.c.
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
index 0000000..77a8bcd
--- /dev/null
+++ b/arch/x86/kernel/io_delay.c
@@ -0,0 +1,77 @@
+/*
+ * I/O delay strategies for inb_p/outb_p
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/dmi.h>
+#include <asm/io.h>
+
+/*
+ * Allow for a DMI based override of port 0x80
+ */
+#define IO_DELAY_PORT_STD 0x80
+#define IO_DELAY_PORT_ALT 0xed
+
+static unsigned short io_delay_port __read_mostly = IO_DELAY_PORT_STD;
+
+void native_io_delay(void)
+{
+	asm volatile ("outb %%al, %w0" : : "d" (io_delay_port));
+}
+EXPORT_SYMBOL(native_io_delay);
+
+static int __init dmi_io_delay_port_alt(const struct dmi_system_id *id)
+{
+	printk(KERN_NOTICE "%s: using alternate I/O delay port\n", id->ident);
+	io_delay_port = IO_DELAY_PORT_ALT;
+	return 0;
+}
+
+static struct dmi_system_id __initdata dmi_io_delay_port_alt_table[] = {
+	{
+		.callback	= dmi_io_delay_port_alt,
+		.ident		= "Compaq Presario V6000",
+		.matches	= {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
+			DMI_MATCH(DMI_BOARD_NAME, "30B7")
+		}
+	},
+	{
+		.callback	= dmi_io_delay_port_alt,
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
+static int __init io_delay_param(char *s)
+{
+	if (!s)
+		return -EINVAL;
+
+	if (!strcmp(s, "standard"))
+		io_delay_port = IO_DELAY_PORT_STD;
+	else if (!strcmp(s, "alternate"))
+		io_delay_port = IO_DELAY_PORT_ALT;
+	else
+		return -EINVAL;
+
+	io_delay_override = 1;
+	return 0;
+}
+
+early_param("io_delay", io_delay_param);
+
+void __init io_delay_init(void)
+{
+	if (!io_delay_override)
+		dmi_check_system(dmi_io_delay_port_alt_table);
+}
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
index fe881cd..690b8f4 100644
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -250,10 +250,8 @@ static inline void flush_write_buffers(void)
 
 #endif /* __KERNEL__ */
 
-static inline void native_io_delay(void)
-{
-	asm volatile("outb %%al,$0x80" : : : "memory");
-}
+extern void io_delay_init(void);
+extern void native_io_delay(void);
 
 #if defined(CONFIG_PARAVIRT)
 #include <asm/paravirt.h>
diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
index a037b07..b2d4994 100644
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -35,13 +35,18 @@
   *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
   */
 
-#define __SLOW_DOWN_IO "\noutb %%al,$0x80"
+extern void io_delay_init(void);
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
@@ -50,21 +55,21 @@
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


--------------060401090409000200040709--

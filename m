Return-Path: <linux-kernel-owner+w=401wt.eu-S964966AbXLQUuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964966AbXLQUuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbXLQUt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:49:57 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:27533 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbXLQUt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:49:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=xHucahiuJ3Zbp0y1WY1yAIhUUt1K/Tf5++jrCr4UhdbNvNA/YBTcn+HuEpRm6/uidiXYafskxr/jy/AiD0SOzQWasQkp6AjbW805kch87muW61I9gZWfllnI+WXJEKFriKuKI0FxOrMMOsxYAQy5BKiWKx36gkcEUI8C5JKUBmY=
Message-ID: <4766E086.9090500@gmail.com>
Date: Mon, 17 Dec 2007 21:48:06 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, "David P. Reed" <dpreed@reed.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <476462BE.3030701@gmail.com>	<4764687D.6080609@zytor.com>	<476524DB.7020806@gmail.com>	<20071216152250.GA21245@elte.hu>	<4765D43E.1010800@gmail.com>	<20071217105744.GA14315@elte.hu>	<4766684D.40202@gmail.com>	<20071217130933.GB27992@elte.hu>	<47667812.8050708@gmail.com>	<47667A85.3080100@reed.com>	<20071217143900.GA16604@elte.hu> <20071217161243.05c32df4@the-village.bc.nu>
In-Reply-To: <20071217161243.05c32df4@the-village.bc.nu>
Content-Type: multipart/mixed;
 boundary="------------020504040502070508050806"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020504040502070508050806
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 17-12-07 17:12, Alan Cox wrote:

> I don't think we should be offering udelay based delays at this point.
> There are a lot of drivers to fix first. This is just one trivial example

I agree. This thread's too full of people calling this outb method a dumb 
hack. It's a well-known legacy PC thing and while in practice the udelay 
might be a functional replacement for a majority of cases (save the races 
you are finding) a delay proportional to the bus speed makes great sense 
certainly when talking to hardware that itself runs proportinal to the bus 
speed for example.

So, really, how about just sticking in this minimal version for now? Only 
switches the port to 0xed based on DMI and is all that is needed to fix the 
actual problem. This should be minimal and no-risk enough that it could also 
go to .24 if people want it to. It'll fix a few HP laptops (I'll try and 
get/verify the dv6000z DMI strings as well).

Ingo?

Signed-off-by: Rene Herman <rene.herman@gmail.com>

--------------020504040502070508050806
Content-Type: text/plain;
 name="dmi-port80-minimal.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmi-port80-minimal.diff"

commit e5f4d11c2470550500e8d8b798d902f2fe07b5c4
Author: Rene Herman <rene.herman@gmail.com>
Date:   Mon Dec 17 21:23:55 2007 +0100

    x86: provide a DMI based port 0x80 I/O delay override.
    
    Certain (HP) laptops experience trouble from our port 0x80 I/O delay
    writes. This patch provides for a DMI based switch to the "alternate
    diagnostic port" 0xed (as used by some BIOSes as well) for these.
    
    David P. Reed confirmed that port 0xed works for him and provides a
    proper delay. The symptoms of _not_ working are a hanging machine,
    with "hwclock" use being a direct trigger.
    
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
    
    This does not change the io_delay() in the boot code which is using
    the same port 0x80 I/O delay but those do not appear to be a problem
    as tested by David P. Reed. He moreover reported that booting with
    "acpi=off" also fixed things and seeing as how ACPI isn't touched
    until after this DMI based I/O port switch leaving the ones in the
    boot code be is safe.
    
    The DMI strings from David's HP Pavilion dv9000z are in there already
    and we need to get/verify the DMI info from other machines with the
    problem, notably the HP Pavilion dv6000z.
    
    This patch is partly based on earlier patches from Pavel Machek and
    David P. Reed.
    
    Signed-off-by: Rene Herman <rene.herman@gmail.com>

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
index 0000000..e736bab
--- /dev/null
+++ b/arch/x86/kernel/io_delay.c
@@ -0,0 +1,48 @@
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
+void __init io_delay_init(void)
+{
+	dmi_check_system(dmi_io_delay_port_alt_table);
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

--------------020504040502070508050806--

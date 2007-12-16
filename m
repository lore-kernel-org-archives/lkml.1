Return-Path: <linux-kernel-owner+w=401wt.eu-S933644AbXLPNRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644AbXLPNRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 08:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbXLPNQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 08:16:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:57262 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbXLPNQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 08:16:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=ORt7SkkM+OhQ+QbfkNfT8m+CWuRR7tW9b6+9idVSLcFYOb5hecKEI17DE5eL1uL8HC23nh35TvVpRZJ9n9Fy+xKq/QVXhIPxGLToM9LIWY9tZjSFLxYU46rf7fX9rdsHfePKDCSuCrH4wAAbKxJRD16TmITQkljRiW60u7Lw/hk=
Message-ID: <476524DB.7020806@gmail.com>
Date: Sun, 16 Dec 2007 14:15:07 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <469578CD.3080609@reed.com>	<1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com>
In-Reply-To: <4764687D.6080609@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------060200070006090106070609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060200070006090106070609
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 16-12-07 00:51, H. Peter Anvin wrote:

> Rene Herman wrote:
>>
>> I hope this is considered half-way correct/sane (note by the way that 
>> it's not a good idea to switch a "native_io_delay_port" value since 
>> plugging in a variable port would clobber register dx for every 
>> outb_p, which would then have to be reloaded for the next outb again). 
>> Comments appreciated.
> 
> That actually wouldn't be that big of a deal.  Switching values in and 
> out of registers is dirt cheap (and MUCH cheaper than an indirect 
> function call)

Well, I suppose. With stuff inline, constantly reloading dx also bloats 
things up a bit but yes, out of line who cares. Do you think this version is 
better?

> Note, however, that your code doesn't deal with io_delay()'s in the boot 
> code (arch/x86/boot) at all, nor (obviously) io_delay()'s in boot 
> loaders.  In the boot code, access to DMI data is NOT available (we 
> can't even use the INT 15h mover if we want to continue to support 
> Loadlin.)
> 
> In the boot code, io_delay() is used to slow down accesses to the KBC, 
> interrupt controller, INT13h logic, and the NMI gate, and to provide a 
> fixed delay during A20 stabilization.

Thanks for the heads up (also saw the SMBIOS update to this) but those don't 
seem to be a problem in fact. David Reed has been running with the simple 
udelay(2) version of this and reported no more hangs. He moreover reported 
no trouble after booting with "acpi=off" meaning that things seem to be fine 
pre-acpi which the boot code (and this io_delay_init) is. So I believe we 
get to ignore those.

David: I've plugged in your DMI values in this. Could you perhaps test this 
to confirm that it works for you?

Any ACKs, NAKs or further comments from others in this thread also welcome.

Changelog in the patch.

  arch/x86/boot/compressed/misc_32.c |    8 ++---
  arch/x86/boot/compressed/misc_64.c |    8 ++---
  arch/x86/kernel/Makefile_32        |    2 -
  arch/x86/kernel/Makefile_64        |    2 -
  arch/x86/kernel/io_delay.c         |   54 
+++++++++++++++++++++++++++++++++++++
  arch/x86/kernel/setup_32.c         |    2 +
  arch/x86/kernel/setup_64.c         |    2 +
  include/asm-x86/io_32.h            |   17 ++---------
  include/asm-x86/io_64.h            |   23 ++++++---------
  9 files changed, 80 insertions(+), 38 deletions(-)

Rene.

--------------060200070006090106070609
Content-Type: text/plain;
 name="dmi-io_delay.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmi-io_delay.diff"

commit a17ccb1964b53fd4ab00d501b7f229a9a6cf91d1
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
    help from many on the linux-kernel mailinglist, but that approach has
    two problems.
    
    First, pre-loops_per_jiffy calibration (which is post PIT init while
    some implementations of the PIT are actually one of the historically
    problematic devices that need the delay) udelay() isn't particularly
    well-defined. We could initialise loops_per_jiffy conservatively (and
    based on CPU family so as to not unduly delay old machines) which
    would sort of work, but still leaves problem 2.
    
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
    
    This does not change the io_delay() in the boot code which is using
    the same port 0x80 I/O delay but those do not appear to be a problem
    as David P. Reed reported the problem was already gone after using the
    udelay(2) version of this. He moreover reported that booting with
    "acpi=off" also fixed things and seeing as how ACPI isn't touched
    until after this DMI based I/O port switch I believe it's safe to
    leave the ones in the boot code be.
    
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
index 0000000..d889c43
--- /dev/null
+++ b/arch/x86/kernel/io_delay.c
@@ -0,0 +1,54 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/dmi.h>
+#include <asm/io.h>
+
+/*
+ * Some machines get upset at port 0x80 writes which we use as
+ * an I/O delay. Allow for a DMI based override to alternate
+ * port 0xed.
+ */
+#define STANDARD_IO_DELAY_PORT	0x80
+#define ALTERNATE_IO_DELAY_PORT	0xed
+
+static unsigned short io_delay_port = STANDARD_IO_DELAY_PORT;
+
+void native_io_delay(void)
+{
+	asm volatile ("outb %%al, %w0" : : "d" (io_delay_port));
+}
+
+void slow_down_io(void) {
+	native_io_delay();
+#ifdef REALLY_SLOW_IO
+	native_io_delay();
+	native_io_delay();
+	native_io_delay();
+#endif
+}
+EXPORT_SYMBOL(slow_down_io);
+
+static int __init dmi_alternate_io_delay_port(const struct dmi_system_id *id)
+{
+	printk(KERN_NOTICE "%s: using alternate I/O delay port\n", id->ident);
+	io_delay_port = ALTERNATE_IO_DELAY_PORT;
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
+void __init io_delay_init(void)
+{
+	dmi_check_system(alternate_io_delay_port_dmi_table);
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
index fe881cd..5d4e5e5 100644
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -250,24 +250,13 @@ static inline void flush_write_buffers(void)
 
 #endif /* __KERNEL__ */
 
-static inline void native_io_delay(void)
-{
-	asm volatile("outb %%al,$0x80" : : : "memory");
-}
+extern void io_delay_init(void);
+extern void native_io_delay(void);
 
 #if defined(CONFIG_PARAVIRT)
 #include <asm/paravirt.h>
 #else
-
-static inline void slow_down_io(void) {
-	native_io_delay();
-#ifdef REALLY_SLOW_IO
-	native_io_delay();
-	native_io_delay();
-	native_io_delay();
-#endif
-}
-
+extern void slow_down_io(void);
 #endif
 
 #ifdef CONFIG_X86_NUMAQ
diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
index a037b07..486a110 100644
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -35,13 +35,8 @@
   *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
   */
 
-#define __SLOW_DOWN_IO "\noutb %%al,$0x80"
-
-#ifdef REALLY_SLOW_IO
-#define __FULL_SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO __SLOW_DOWN_IO
-#else
-#define __FULL_SLOW_DOWN_IO __SLOW_DOWN_IO
-#endif
+extern void io_delay_init(void);
+extern void slow_down_io(void);
 
 /*
  * Talk about misusing macros..
@@ -50,21 +45,21 @@
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

--------------060200070006090106070609--

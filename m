Return-Path: <linux-kernel-owner+w=401wt.eu-S1760908AbXLOX3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908AbXLOX3F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 18:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbXLOX2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 18:28:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:32069 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbXLOX2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 18:28:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=acSmh5sKtx4yeRFY0mfxXIqzFN9scDjMw+6rtku7VkYcGBr/IP9ye/dRbbyfTQPjziEz+2spUi1358C1ziblnowroNSJ4C+TErI12lxTgrnWi/NrX2vt5tOubk5BPG5M2Y/WbeXyb6NZubrl4pC9yUd4oPLIHIUWbdM6mZ0DIxA=
Message-ID: <476462BE.3030701@gmail.com>
Date: Sun, 16 Dec 2007 00:26:54 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Paul Rolland <rol@as2917.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>, rol@witbe.net
Subject: [PATCH] x86: fix problems due to use of "outb" to port 80 on some
 AMD64x2 laptops, etc.
References: <469578CD.3080609@reed.com>	<1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com>
In-Reply-To: <476438B4.2020600@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------080204070202060802060608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080204070202060802060608
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 15-12-07 21:27, H. Peter Anvin wrote:

> Rene Herman wrote:
>>
>> Yes, just posted a Patch-For-Comments that switches on the 
>> availability of a TSC (tsc_init sets tsc_disable also for 
>> !cpu_has_tsc) which would mean that only really old stuff would be 
>> using the outb still. A TSC is really all we need to have a sensible 
>> udelay().
> 
> Uhm, no.  You have no clue what the speed of the TSC is until you have 
> been able to calibrate it against a fixed timesource - like the PIT.

Yes. Hnng. Okay, this is going nowhere in a hurry, so back to the very first 
suggestion in this thread. How about this? This allows to switch from port 
0x80 to port 0xed based on DMI.

David: I plugged in my own DMI values for testing, but obviously yours are 
needed. The values that are needed are retrieved by the "dmidecode" program 
which you will probably have installed (it might be in an sbin directory) or 
will be able to install through whatever package manager you use.

dmidecode -s baseboard-manufacturer
dmidecode -s baseboard-product-name

are the values you should plug into the .matches field in the dmi_system_id 
struct in this. It would be great if you could do that, test, and post back 
with those values. .ident should be a nice human name.

It's been tested on x86-32 and seems to work fine. It's not been tested on 
x86-64 but seems to stand a fair chance of working similarly.

It ofcourse remains possible to switch to a udelay() based method later on 
anyways but with all the pre-calibratin trouble, this might be the lowest 
risk method in the short run.

This is partly based on previous patches by Pavel Machek and David P. Reed.

I hope this is considered half-way correct/sane (note by the way that it's 
not a good idea to switch a "native_io_delay_port" value since plugging in a 
variable port would clobber register dx for every outb_p, which would then 
have to be reloaded for the next outb again). Comments appreciated.

Signed-off-by: Rene Herman <rene.herman@gmail.com>

  arch/x86/boot/compressed/misc_32.c |    8 ++---
  arch/x86/boot/compressed/misc_64.c |    8 ++---
  arch/x86/kernel/Makefile_32        |    2 -
  arch/x86/kernel/Makefile_64        |    2 -
  arch/x86/kernel/io_delay.c         |   53 
+++++++++++++++++++++++++++++++++++++
  arch/x86/kernel/setup_32.c         |    2 +
  arch/x86/kernel/setup_64.c         |    2 +
  include/asm-x86/io_32.h            |   17 ++---------
  include/asm-x86/io_64.h            |   23 ++++++----------


--------------080204070202060802060608
Content-Type: text/plain;
 name="dmi-io_delay.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmi-io_delay.diff"

commit 4a7e75776c648102488a89dbfad516448830ab1a
Author: Rene Herman <rene.herman@gmail.com>
Date:   Sun Dec 16 00:24:32 2007 +0100

    foo

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
index 0000000..1a2a856
--- /dev/null
+++ b/arch/x86/kernel/io_delay.c
@@ -0,0 +1,53 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/dmi.h>
+#include <asm/io.h>
+
+#define IO_DELAY(port) asm volatile ("outb %%al, %0" : : "N" ((port)))
+
+static void standard_io_delay(void)
+{
+	IO_DELAY(0x80);
+}
+
+static void alternate_io_delay(void)
+{
+	IO_DELAY(0xed);
+}
+
+void (*native_io_delay)(void) = standard_io_delay;
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
+static int __init dmi_alternate_io_delay(const struct dmi_system_id *id)
+{
+	printk(KERN_NOTICE "%s: using alternate I/O delay.\n", id->ident);
+	native_io_delay = alternate_io_delay;
+	return 0;
+}
+
+static struct dmi_system_id __initdata alternate_io_delay_dmi_table[] = {
+	{
+		.callback	= dmi_alternate_io_delay,
+		.ident		= "Gigabyte GA-7IXE4",
+		.matches	= {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co., Ltd."),
+			DMI_MATCH(DMI_BOARD_NAME, "7IXE4")
+		}
+	},
+	{
+	}
+};
+
+void __init io_delay_init(void)
+{
+	dmi_check_system(alternate_io_delay_dmi_table);
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
index fe881cd..bf352e3 100644
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -250,24 +250,13 @@ static inline void flush_write_buffers(void)
 
 #endif /* __KERNEL__ */
 
-static inline void native_io_delay(void)
-{
-	asm volatile("outb %%al,$0x80" : : : "memory");
-}
+extern void io_delay_init(void);
+extern void (*native_io_delay)(void);
 
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

--------------080204070202060802060608--

Return-Path: <linux-kernel-owner+w=401wt.eu-S935720AbXLQK6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935720AbXLQK6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 05:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934854AbXLQK6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 05:58:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47736 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934848AbXLQK6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 05:58:19 -0500
Date: Mon, 17 Dec 2007 11:57:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Paul Rolland <rol@as2917.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20071217105744.GA14315@elte.hu>
References: <4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4765D43E.1010800@gmail.com>
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


* Rene Herman <rene.herman@gmail.com> wrote:

> On 16-12-07 16:22, Ingo Molnar wrote:
>
>> looks good to me. Could you please also provide three more controls that i 
>> suggested earlier:
>>
>>  - a boot option enabling/disabling the udelay based code
>>  - a .config method of enabling/disabling the udelay based code
>>  - a sysctl to toggle it
>>
>> if we want to clean this all up we'll need as many controls as possible.
>
> This version does the boot and the .config option but not the sysctl. 
> It makes for clumsy code and I don't believe it provides for much 
> added value as soon as you have the boot option. I am moreover not 
> completely confident about things such as paravirt liking the 
> possibility of the native_io_delay being changed out from under them 
> at unpredictable times.
>
> So how is this? Also fixes a few problems with the previous version.

thanks Rene! I've added your patch to x86.git. I changed a few things 
ontop of it, see the additional changelog and delta patch below.

	Ingo

------------>

- add the io_delay=none method
- make each method selectable from the kernel config
- simplify the delay code a bit by getting rid of an indirect function call
- add the /proc/sys/kernel/io_delay_type sysctl
- change 'standard' and 'alternate' to 0x80 and 0xed
- make the io delay config not depend on CONFIG_DEBUG_KERNEL

---
 Documentation/kernel-parameters.txt |   12 ++--
 arch/x86/Kconfig.debug              |   79 +++++++++++++++++++++++++--
 arch/x86/kernel/io_delay.c          |  103 ++++++++++++++++--------------------
 include/asm-x86/io_32.h             |    2 
 include/asm-x86/io_64.h             |    2 
 kernel/sysctl.c                     |    9 +++
 6 files changed, 138 insertions(+), 69 deletions(-)

Index: linux-x86.q/Documentation/kernel-parameters.txt
===================================================================
--- linux-x86.q.orig/Documentation/kernel-parameters.txt
+++ linux-x86.q/Documentation/kernel-parameters.txt
@@ -786,12 +786,14 @@ and is between 256 and 4096 characters. 
 			then look in the higher range.
 
 	io_delay=	[X86-32,X86-64] I/O delay method
-		standard
-			Standard port 0x80 delay
-		alternate
-			Alternate port 0xed delay
+		0x80
+			Standard port 0x80 based delay
+		0xed
+			Alternate port 0xed based delay (needed on some systems)
 		udelay
-			Simple two microsecond delay
+			Simple two microseconds delay
+		none
+			No delay
 
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
Index: linux-x86.q/arch/x86/Kconfig.debug
===================================================================
--- linux-x86.q.orig/arch/x86/Kconfig.debug
+++ linux-x86.q/arch/x86/Kconfig.debug
@@ -112,13 +112,78 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
-config UDELAY_IO_DELAY
-	bool "Delay I/O through udelay instead of outb"
-	depends on DEBUG_KERNEL
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
 	help
-	  Make inb_p/outb_p use udelay() based delays by default. Please note
-	  that udelay() does not have the same bus-level side-effects that
-	  the normal outb based delay does meaning this could cause drivers
-	  to change behaviour and/or bugs to surface.
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
 
 endmenu
Index: linux-x86.q/arch/x86/kernel/io_delay.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/io_delay.c
+++ linux-x86.q/arch/x86/kernel/io_delay.c
@@ -1,5 +1,9 @@
 /*
  * I/O delay strategies for inb_p/outb_p
+ *
+ * Allow for a DMI based override of port 0x80, needed for certain HP laptops
+ * and possibly other systems. Also allow for the gradual elimination of
+ * outb_p/inb_p API uses.
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -8,98 +12,83 @@
 #include <linux/dmi.h>
 #include <asm/io.h>
 
-/*
- * Allow for a DMI based override of port 0x80 needed for certain HP laptops
- */
-#define IO_DELAY_PORT_STD 0x80
-#define IO_DELAY_PORT_ALT 0xed
-
-static void standard_io_delay(void)
-{
-	asm volatile ("outb %%al, %0" : : "N" (IO_DELAY_PORT_STD));
-}
-
-static void alternate_io_delay(void)
-{
-	asm volatile ("outb %%al, %0" : : "N" (IO_DELAY_PORT_ALT));
-}
-
-/*
- * 2 usecs is an upper-bound for the outb delay but note that udelay doesn't
- * have the bus-level side-effects that outb does
- */
-#define IO_DELAY_USECS 2
+int io_delay_type __read_mostly = CONFIG_DEFAULT_IO_DELAY_TYPE;
+EXPORT_SYMBOL_GPL(io_delay_type);
 
-/*
- * High on a hill was a lonely goatherd
- */
-static void udelay_io_delay(void)
-{
-	udelay(IO_DELAY_USECS);
-}
-
-#ifndef CONFIG_UDELAY_IO_DELAY
-static void (*io_delay)(void) = standard_io_delay;
-#else
-static void (*io_delay)(void) = udelay_io_delay;
-#endif
+static int __initdata io_delay_override;
 
 /*
  * Paravirt wants native_io_delay to be a constant.
  */
 void native_io_delay(void)
 {
-	io_delay();
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
 }
 EXPORT_SYMBOL(native_io_delay);
 
-#ifndef CONFIG_UDELAY_IO_DELAY
-static int __init dmi_alternate_io_delay_port(const struct dmi_system_id *id)
+static int __init dmi_io_delay_0xed_port(const struct dmi_system_id *id)
 {
-	printk(KERN_NOTICE "%s: using alternate I/O delay port\n", id->ident);
-	io_delay = alternate_io_delay;
+	printk(KERN_NOTICE "%s: using 0xed I/O delay port\n", id->ident);
+	io_delay_type = CONFIG_IO_DELAY_TYPE_0XED;
+
 	return 0;
 }
 
-static struct dmi_system_id __initdata alternate_io_delay_port_dmi_table[] = {
+/*
+ * Quirk table for systems that misbehave (lock up, etc.) if port
+ * 0x80 is used:
+ */
+static struct dmi_system_id __initdata io_delay_0xed_port_dmi_table[] = {
 	{
-		.callback	= dmi_alternate_io_delay_port,
+		.callback	= dmi_io_delay_0xed_port,
 		.ident		= "HP Pavilion dv9000z",
 		.matches	= {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
 			DMI_MATCH(DMI_BOARD_NAME, "30B9")
 		}
 	},
-	{
-	}
+	{ }
 };
 
-static int __initdata io_delay_override;
-
 void __init io_delay_init(void)
 {
 	if (!io_delay_override)
-		dmi_check_system(alternate_io_delay_port_dmi_table);
+		dmi_check_system(io_delay_0xed_port_dmi_table);
 }
-#endif
 
 static int __init io_delay_param(char *s)
 {
-	if (!s)
-		return -EINVAL;
-
-	if (!strcmp(s, "standard"))
-		io_delay = standard_io_delay;
-	else if (!strcmp(s, "alternate"))
-		io_delay = alternate_io_delay;
+	if (!strcmp(s, "0x80"))
+		io_delay_type = CONFIG_IO_DELAY_TYPE_0X80;
+	else if (!strcmp(s, "0xed"))
+		io_delay_type = CONFIG_IO_DELAY_TYPE_0XED;
 	else if (!strcmp(s, "udelay"))
-		io_delay = udelay_io_delay;
+		io_delay_type = CONFIG_IO_DELAY_TYPE_UDELAY;
+	else if (!strcmp(s, "none"))
+		io_delay_type = CONFIG_IO_DELAY_TYPE_NONE;
 	else
 		return -EINVAL;
 
-#ifndef CONFIG_UDELAY_IO_DELAY
 	io_delay_override = 1;
-#endif
 	return 0;
 }
 
Index: linux-x86.q/include/asm-x86/io_32.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/io_32.h
+++ linux-x86.q/include/asm-x86/io_32.h
@@ -259,6 +259,8 @@ static inline void io_delay_init(void)
 #endif
 extern void native_io_delay(void);
 
+extern int io_delay_type;
+
 #if defined(CONFIG_PARAVIRT)
 #include <asm/paravirt.h>
 #else
Index: linux-x86.q/include/asm-x86/io_64.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/io_64.h
+++ linux-x86.q/include/asm-x86/io_64.h
@@ -44,6 +44,8 @@ static inline void io_delay_init(void)
 #endif
 extern void native_io_delay(void);
 
+extern int io_delay_type;
+
 static inline void slow_down_io(void)
 {
 	native_io_delay();
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

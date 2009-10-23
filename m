Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZJWXht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZJWXht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZJWXhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:37:47 -0400
Received: from relay1.sgi.com ([192.48.179.29]:49141 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752682AbZJWXho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:37:44 -0400
Message-Id: <20091023233746.128967000@alcatraz.americas.sgi.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 23 Oct 2009 18:37:44 -0500
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Robin Getz <rgetz@analog.com>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH 1/8] SGI x86_64 UV: Add limit console output function
Content-Disposition: inline; filename=limit_console_output
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a large number of processors in a system there is an excessive amount
of messages sent to the system console.  It's estimated that with 4096
processors in a system, and the console baudrate set to 56K, the startup
messages will take about 84 minutes to clear the serial port.

This patch adds (for SGI UV only) a kernel start option "limit_console_
output" (or 'lco' for short), which when set provides the ability to
temporarily reduce the console loglevel during system startup.  This allows
informative messages to still be seen on the console without producing
excessive amounts of repetious messages.

Note that all the messages are still available in the kernel log buffer.

Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Robin Getz <rgetz@analog.com>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Signed-off-by: Mike Travis <travis@sgi.com>
---
 Documentation/kernel-parameters.txt |    6 ++++
 include/linux/kernel.h              |   23 +++++++++++++++++
 kernel/printk.c                     |   47 ++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)

--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -103,6 +103,7 @@
 	UMS	USB Mass Storage support is enabled.
 	USB	USB support is enabled.
 	USBHID	USB Human Interface Device support is enabled.
+	UV	SGI Ultraviolet
 	V4L	Video For Linux support is enabled.
 	VGA	The VGA console has been enabled.
 	VT	Virtual terminal support is enabled.
@@ -1218,6 +1219,11 @@
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
+	limit_console_output [UV]
+	lco		[UV]
+			Limits repetitous messages when the number of cpus in
+			a system is large.
+
 	lmb=debug	[KNL] Enable lmb debug messages.
 
 	load_ramdisk=	[RAM] List of ramdisks to load from floppy
--- linux.orig/include/linux/kernel.h
+++ linux/include/linux/kernel.h
@@ -372,6 +372,29 @@
 }
 #endif
 
+#ifdef CONFIG_X86_UV
+bool _limit_console_output(bool suspend);
+#define limit_console_output(suspend)			\
+({							\
+	bool limit = _limit_console_output(suspend);	\
+	if (limit)					\
+		printk_once(KERN_NOTICE			\
+			"printk: further related messages suppressed\n");\
+	limit;						\
+})
+
+void end_limit_console_output(void);
+#else
+static inline bool limit_console_output(bool suspend)
+{
+	return false;
+}
+
+static inline void end_limit_console_output(void)
+{
+}
+#endif
+
 extern int printk_needs_cpu(int cpu);
 extern void printk_tick(void);
 
--- linux.orig/kernel/printk.c
+++ linux/kernel/printk.c
@@ -1417,3 +1417,50 @@
 }
 EXPORT_SYMBOL(printk_timed_ratelimit);
 #endif
+
+#ifdef CONFIG_X86_UV
+/*
+ * Support to suppress the zillions of extra messages being sent to
+ * the console when a server has a large number of cpus.
+ */
+static bool __read_mostly console_output_limited;
+static int __init limit_console_output_setup(char *str)
+{
+	console_output_limited = true;
+	printk(KERN_NOTICE "printk: console messages will be limited.\n");
+	return 0;
+}
+early_param("limit_console_output", limit_console_output_setup);
+
+static int __init lco(char *str)
+{
+	return limit_console_output_setup(str);
+}
+early_param("lco", lco);
+
+#define	SUSPENDED_CONSOLE_LOGLEVEL	(DEFAULT_CONSOLE_LOGLEVEL-1)
+
+/* check if "limiting" console output and suspend further msgs if requested. */
+bool _limit_console_output(bool suspend)
+{
+	if (console_output_limited) {
+		if (suspend && saved_console_loglevel == -1) {
+			saved_console_loglevel = console_loglevel;
+			console_loglevel = SUSPENDED_CONSOLE_LOGLEVEL;
+		}
+		return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL(_limit_console_output);
+
+/* remove suspension of console msgs. */
+void end_limit_console_output(void)
+{
+	if (console_output_limited && saved_console_loglevel != -1) {
+		console_loglevel = saved_console_loglevel;
+		saved_console_loglevel = -1;
+	}
+}
+EXPORT_SYMBOL(end_limit_console_output);
+#endif

-- 

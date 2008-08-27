Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbYH0RFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbYH0RFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYH0RFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:05:33 -0400
Received: from flusers.ccur.com ([12.192.68.2]:45216 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751270AbYH0RFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:05:31 -0400
Date: Wed, 27 Aug 2008 13:04:25 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Mark Brown <broonie@sirena.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Simon Farnsworth <simon.farnsworth@onelan.com>
Subject: [PATCH] printk timestamp post-boot suppression, v2
Message-ID: <20080827170424.GA17217@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20080827151613.GA10325@tsunami.ccur.com> <20080827161621.GF10834@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827161621.GF10834@sirena.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 12:16:30PM -0400, Mark Brown wrote:
> It'd be nicer if this were optional - syslog typically only logs at
> second resolution and not all systems are going to have logfiles.


Optionally suppress printk timestamping after system boot.

A new config option is introduced, which if selected
suppresses printk timestamping after the boot sequence
is completed.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.27-rc4-git4/kernel/printk.c
===================================================================
--- 2.6.27-rc4-git4.orig/kernel/printk.c	2008-08-27 09:37:52.000000000 -0400
+++ 2.6.27-rc4-git4/kernel/printk.c	2008-08-27 12:35:14.000000000 -0400
@@ -560,6 +560,12 @@
 #endif
 module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
+#if defined(CONFIG_PRINTK_TIME_BOOTONLY)
+#define printk_time_bootonly (system_state == SYSTEM_BOOTING)
+#else
+#define printk_time_bootonly (1)
+#endif
+
 /* Check if we have any console registered that can be called early in boot. */
 static int have_callable_console(void)
 {
@@ -730,7 +736,7 @@
 			printed_len += 3;
 			new_text_line = 0;
 
-			if (printk_time) {
+			if (printk_time && printk_time_bootonly) {
 				/* Follow the token with the time */
 				char tbuf[50], *tp;
 				unsigned tlen;
Index: 2.6.27-rc4-git4/lib/Kconfig.debug
===================================================================
--- 2.6.27-rc4-git4.orig/lib/Kconfig.debug	2008-08-26 16:28:41.000000000 -0400
+++ 2.6.27-rc4-git4/lib/Kconfig.debug	2008-08-27 12:29:34.000000000 -0400
@@ -9,6 +9,17 @@
 	  operations.  This is useful for identifying long delays
 	  in kernel startup.
 
+config PRINTK_TIME_BOOTONLY
+	bool "Only show printk timing during kernel startup"
+	depends on PRINTK_TIME
+	help
+	  If Y is selected, then timing information will
+	  be prefixed to printk output lines only as long
+	  as the kernel startup phase is in operation.
+
+	  If N is selected, then every printk line will
+	  be prefixed with timing information.
+
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
 	default y

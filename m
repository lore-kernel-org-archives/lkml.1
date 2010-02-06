Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0BFNlI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 08:41:08 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:58551 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab0BFNlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 08:41:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Vlw660/zmusbfB3LffSvLYWro/cuSyg3jekCQuRXTT+K7b0eZ4ujU/4qGD9zmwdicR
         40RWI88qXj3Qumta9p1XJUHMZw/51ZmMzEuH/94EqO8jWXu52ET20/7kgNnboYkEr/xx
         5DU4kxZH1942Gl4bXP39igspzPGn4dJ62FMp8=
Date: Sat, 6 Feb 2010 21:40:56 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2] allow printk delay after multi lines
Message-ID: <20100206134056.GB2562@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk delay help us to capture printk messages on some unconvenient senarios,
but it is still not easy to read.

Add another sysctl variable printk_delay_per_lines to make it more readable.
We can set the lines according to screen height, then take pictures by camera.

kmesg will delay printk_delay_per_lines * printk_delay_msecs milliseconds
after every printk_delay_per_lines lines when printk_delay is enabled.

Setting the lines by proc/sysctl interface:
/proc/sys/kernel/printk_delay_per_lines

Andrew, sorry, I have not find time to cleanup the kernel.h sysctl variables.
If I'm free I will try to do it.

The value range from 1 - 100, default value is 1

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---

 Documentation/sysctl/kernel.txt |    9 +++++++++
 include/linux/kernel.h          |    1 +
 kernel/printk.c                 |   12 +++++++++++-
 kernel/sysctl.c                 |    9 +++++++++
 4 files changed, 30 insertions(+), 1 deletions(-)

--- linux-2.6.orig/Documentation/sysctl/kernel.txt	2010-02-02 13:38:09.517495705 +0800
+++ linux-2.6/Documentation/sysctl/kernel.txt	2010-02-02 13:40:47.657480122 +0800
@@ -374,6 +374,15 @@ Value from 0 - 10000 is allowed.
 
 ==============================================================
 
+printk_delay_per_lines:
+
+Delay printk message every printk_delay_per_lines lines
+in printk_delay * printk_delay_per_lines milliseconds
+
+Value from 1 - 100 is allowed.
+
+==============================================================
+
 randomize-va-space:
 
 This option can be used to select the type of process address
--- linux-2.6.orig/include/linux/kernel.h	2010-02-02 13:38:09.537495564 +0800
+++ linux-2.6/include/linux/kernel.h	2010-02-02 13:40:47.657480122 +0800
@@ -246,6 +246,7 @@ extern bool printk_timed_ratelimit(unsig
 				   unsigned int interval_msec);
 
 extern int printk_delay_msec;
+extern int printk_delay_per_lines;
 
 /*
  * Print a one-time message (analogous to WARN_ONCE() et al):
--- linux-2.6.orig/kernel/printk.c	2010-02-02 13:39:19.446657319 +0800
+++ linux-2.6/kernel/printk.c	2010-02-02 13:40:47.660813615 +0800
@@ -656,16 +656,26 @@ static int new_text_line = 1;
 static char printk_buf[1024];
 
 int printk_delay_msec __read_mostly;
+int printk_delay_per_lines __read_mostly;
 
 static inline void printk_delay(void)
 {
 	if (unlikely(printk_delay_msec)) {
-		int m = printk_delay_msec;
+		static int m, l;
 
+		if (!l)
+			l = printk_delay_per_lines;
+
+		if (--l) {
+			m += printk_delay_msec;
+			return;
+		}
+		m += printk_delay_msec;
 		while (m--) {
 			mdelay(1);
 			touch_nmi_watchdog();
 		}
+		m = 0;
 	}
 }
 
--- linux-2.6.orig/kernel/sysctl.c	2010-02-02 13:38:09.507495705 +0800
+++ linux-2.6/kernel/sysctl.c	2010-02-02 13:40:47.660813615 +0800
@@ -684,6 +684,15 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &ten_thousand,
 	},
+	{
+		.procname	= "printk_delay_per_lines",
+		.data		= &printk_delay_per_lines,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+		.extra2		= &one_hundred,
+	},
 #endif
 	{
 		.procname	= "ngroups_max",

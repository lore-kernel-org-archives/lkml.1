Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbXEYAJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbXEYAJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 20:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXEYAJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 20:09:43 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20892 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbXEYAJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 20:09:42 -0400
Date: Thu, 24 May 2007 17:15:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, rene.herman@gmail.com, mjt@tls.msk.ru,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH] use printk.time option, drop time/notime
Message-Id: <20070524171535.329ea2c0.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.61.0705241832500.31549@yvahk01.tjqt.qr>
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com>
	<Pine.LNX.4.61.0705241812450.31549@yvahk01.tjqt.qr>
	<4655BC2D.2070701@oracle.com>
	<Pine.LNX.4.61.0705241832500.31549@yvahk01.tjqt.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Andrew, please drop add-notime-boot-option.patch
and use this patch instead...

Allow printk_time to be enabled or disabled at boot time.
Previously it could be enabled only, but not disabled.

Change printk_time from an int to a bool since that's what it is.
Make its logical (exposed) name just be "time" (was "printk_time").

Note:  Changes kernel boot option syntax from "time" to "printk.time=value".

Since printk_time is declared as a module_param, it can also be
changed at run-time by modifying
  /sys/module/printk/parameters/time
to a value of 1/Y/y to enabled it or 0/N/n to disable it.

Since printk_time is declared as a module_param, its value can also
be set at boot-time by using
  linux printk.time=<bool>

Drop the "time" boot option and its __setup() functions.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |    5 +++--
 kernel/printk.c                     |   12 +-----------
 2 files changed, 4 insertions(+), 13 deletions(-)

--- linux-2622-rc2g5.orig/Documentation/kernel-parameters.txt
+++ linux-2622-rc2g5/Documentation/kernel-parameters.txt
@@ -1406,6 +1406,9 @@ and is between 256 and 4096 characters. 
 			autoconfiguration.
 			Ranges are in pairs (memory base and size).
 
+	printk.time=	Show timing data prefixed to each printk message line
+			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
+
 	profile=	[KNL] Enable kernel profiling via /proc/profile
 			Format: [schedule,]<number>
 			Param: "schedule" - profile schedule points.
@@ -1805,8 +1808,6 @@ and is between 256 and 4096 characters. 
 	thash_entries=	[KNL,NET]
 			Set number of hash buckets for TCP connection
 
-	time		Show timing data prefixed to each printk message line
-
 	clocksource=	[GENERIC_TIME] Override the default clocksource
 			Override the default clocksource and use the clocksource
 			with the name specified.
--- linux-2622-rc2g5.orig/kernel/printk.c
+++ linux-2622-rc2g5/kernel/printk.c
@@ -449,17 +449,7 @@ static int printk_time = 1;
 #else
 static int printk_time = 0;
 #endif
-module_param(printk_time, int, S_IRUGO | S_IWUSR);
-
-static int __init printk_time_setup(char *str)
-{
-	if (*str)
-		return 0;
-	printk_time = 1;
-	return 1;
-}
-
-__setup("time", printk_time_setup);
+module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
 __attribute__((weak)) unsigned long long printk_clock(void)
 {

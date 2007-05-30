Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbXE3SjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbXE3SjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 14:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbXE3SjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 14:39:11 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:31146 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbXE3SjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 14:39:10 -0400
Date: Wed, 30 May 2007 11:37:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, rene.herman@gmail.com, mjt@tls.msk.ru,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH v3] add printk.time option, deprecate 'time'
Message-Id: <20070530113700.73da8cd0.randy.dunlap@oracle.com>
In-Reply-To: <20070529130705.fdf43e4b.akpm@linux-foundation.org>
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com>
	<Pine.LNX.4.61.0705241812450.31549@yvahk01.tjqt.qr>
	<4655BC2D.2070701@oracle.com>
	<Pine.LNX.4.61.0705241832500.31549@yvahk01.tjqt.qr>
	<20070524171535.329ea2c0.randy.dunlap@oracle.com>
	<20070529130705.fdf43e4b.akpm@linux-foundation.org>
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

On Tue, 29 May 2007 13:07:05 -0700 Andrew Morton wrote:

> That's going to break a *lot* of people's setups - timestamping appears
> to be very popular.  We will get sad emails from people.
> 
> If we're going to do this then I'm afraid we should retain the `time='
> thing for a while and add a this-is-going-away printk to it.

[$ checkpatch-v2.pl ~/patch/printk-time-onoff.patch 
Your patch has no obvious style problems and is ready for submission.]


From: Randy Dunlap <randy.dunlap@oracle.com>

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

If the "time" boot option is used, print a message that it is deprecated
and will be removed.
Note its planned removal in feature-removal-schedule.txt.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/feature-removal-schedule.txt |    7 +++++++
 Documentation/kernel-parameters.txt        |    4 ++++
 kernel/printk.c                            |    5 ++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

--- linux-2622-rc3.orig/Documentation/kernel-parameters.txt
+++ linux-2622-rc3/Documentation/kernel-parameters.txt
@@ -1426,6 +1426,9 @@ and is between 256 and 4096 characters. 
 			autoconfiguration.
 			Ranges are in pairs (memory base and size).
 
+	printk.time=	Show timing data prefixed to each printk message line
+			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
+
 	profile=	[KNL] Enable kernel profiling via /proc/profile
 			Format: [schedule,]<number>
 			Param: "schedule" - profile schedule points.
@@ -1826,6 +1829,7 @@ and is between 256 and 4096 characters. 
 			Set number of hash buckets for TCP connection
 
 	time		Show timing data prefixed to each printk message line
+			[deprecated, see 'printk.time']
 
 	tipar.timeout=	[HW,PPT]
 			Set communications timeout in tenths of a second
--- linux-2622-rc3.orig/kernel/printk.c
+++ linux-2622-rc3/kernel/printk.c
@@ -449,13 +449,16 @@ static int printk_time = 1;
 #else
 static int printk_time = 0;
 #endif
-module_param(printk_time, int, S_IRUGO | S_IWUSR);
+module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
 static int __init printk_time_setup(char *str)
 {
 	if (*str)
 		return 0;
 	printk_time = 1;
+	printk(KERN_NOTICE "The 'time' option is deprecated and "
+		"is scheduled for removal in early 2008\n");
+	printk(KERN_NOTICE "Use 'printk.time=<value>' instead\n");
 	return 1;
 }
 
--- linux-2622-rc3.orig/Documentation/feature-removal-schedule.txt
+++ linux-2622-rc3/Documentation/feature-removal-schedule.txt
@@ -346,3 +346,10 @@ Who:  Tejun Heo <htejun@gmail.com>
 
 ---------------------------
 
+What:	'time' kernel boot parameter
+When:	January 2008
+Why:	replaced by 'printk.time=<value>' so that printk timestamps can be
+	enabled or disabled as needed
+Who:	Randy Dunlap <randy.dunlap@oracle.com>
+
+---------------------------

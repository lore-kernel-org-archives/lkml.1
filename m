Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbXEVT5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbXEVT5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbXEVT50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:57:26 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37775 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556AbXEVT50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:57:26 -0400
Date: Tue, 22 May 2007 13:00:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Jones <davej@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] add "notime" boot option
Message-Id: <20070522130050.26a846cc.randy.dunlap@oracle.com>
In-Reply-To: <20070522194030.GF12157@redhat.com>
References: <20070522120938.db67f1e9.randy.dunlap@oracle.com>
	<20070522194030.GF12157@redhat.com>
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

On Tue, 22 May 2007 15:40:30 -0400 Dave Jones wrote:

> Not disagreeing with the patch, but I wonder if it'd be a net win
> if we had a helper that would replace the zillion instances
> of "set this variable to a 0/1 depending if its prefixed with 'no'"
> with 1-2 lines.

I don't know about that, but I had another version of this patch
that removed the use of __setup() and just used the module_param()
that is already there (but with the param renamed to "time" and
changed to a bool), so that the usage on the command line is:
  linux printk.time=<bool>

I like this alternate version pretty well, but it causes more
change and a usage that is not well-known.  Patch is below.
The __setup() declaration and its function helper are not removed
yet, but they could be, and just leave the value-setting job
to the module_param() code.  All tested.

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Allow printk_time to be enabled or disabled at boot time.
Previously it could be enabled only, but not disabled.

Change printk_time from an int to a bool since that's what it is.
Make its logical (exposed) name just be "time".

Note:  Changes kernel boot option syntax from "time" to "time=value".

Since printk_time is declared as a module_param, it can also be
changed at run-time by modifying
  /sys/module/printk/parameters/time
to a value of 1/Y/y to enabled it or 0/N/n to disable it.

Since printk_time is declared as a module_param, its value can also
be set at boot-time by using
  linux printk.time=<bool>

If we are willing to drop the shorter "time=value" syntax, we could
also drop the entire printk_time_setup() function and the __setup()
for it.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |    5 ++++-
 kernel/printk.c                     |   12 +++++++-----
 2 files changed, 11 insertions(+), 6 deletions(-)

--- linux-2622-rc2.orig/Documentation/kernel-parameters.txt
+++ linux-2622-rc2/Documentation/kernel-parameters.txt
@@ -1824,7 +1824,10 @@ and is between 256 and 4096 characters. 
 	thash_entries=	[KNL,NET]
 			Set number of hash buckets for TCP connection
 
-	time		Show timing data prefixed to each printk message line
+	time=		Show timing data prefixed to each printk message line
+			Format: <bool>  (1=enable, 0=disable)
+or	printk.time=	Show timing data prefixed to each printk message line
+			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 
 	tipar.timeout=	[HW,PPT]
 			Set communications timeout in tenths of a second
--- linux-2622-rc2.orig/kernel/printk.c
+++ linux-2622-rc2/kernel/printk.c
@@ -449,17 +449,19 @@ static int printk_time = 1;
 #else
 static int printk_time = 0;
 #endif
-module_param(printk_time, int, S_IRUGO | S_IWUSR);
+module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
 
 static int __init printk_time_setup(char *str)
 {
-	if (*str)
+	if (!*str)
 		return 0;
-	printk_time = 1;
+	if (*str == '1')
+		printk_time = 1;
+	else if (*str == '0')
+		printk_time = 0;
 	return 1;
 }
-
-__setup("time", printk_time_setup);
+__setup("time=", printk_time_setup);
 
 __attribute__((weak)) unsigned long long printk_clock(void)
 {

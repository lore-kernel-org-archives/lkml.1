Return-Path: <linux-kernel-owner+w=401wt.eu-S1757929AbZDWHiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbZDWHiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755998AbZDWH3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:29:24 -0400
Received: from sous-sol.org ([216.99.217.87]:48457 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752777AbZDWH3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:29:22 -0400
Message-Id: <20090423072409.299330729@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:50 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Matthew Wilcox <matthew@wil.cx>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [patch 030/100] sysctl: fix suid_dumpable and lease-break-time sysctls
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=sysctl-fix-suid_dumpable-and-lease-break-time-sysctls.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Matthew Wilcox <matthew@wil.cx>

upstream commit: 8e654fba4a376f436bdfe361fc5cdbc87ac09b35

Arne de Bruijn points out that commit
76fdbb25f963de5dc1e308325f0578a2f92b1c2d ("coredump masking: bound
suid_dumpable sysctl") mistakenly limits lease-break-time instead of
suid_dumpable.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
Reported-by: Arne de Bruijn <kernelbt@arbruijn.dds.nl>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 kernel/sysctl.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -95,12 +95,9 @@ static int sixty = 60;
 static int neg_one = -1;
 #endif
 
-#if defined(CONFIG_MMU) && defined(CONFIG_FILE_LOCKING)
-static int two = 2;
-#endif
-
 static int zero;
 static int one = 1;
+static int two = 2;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
 
@@ -1373,10 +1370,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &lease_break_time,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &zero,
-		.extra2		= &two,
+		.proc_handler	= &proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_AIO
@@ -1417,7 +1411,10 @@ static struct ctl_table fs_table[] = {
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &two,
 	},
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 	{


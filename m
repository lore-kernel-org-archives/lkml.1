Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZC0NcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZC0NcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 09:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbZC0Nb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 09:31:59 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50098 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbZC0Nb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 09:31:58 -0400
Date: Fri, 27 Mar 2009 07:31:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH] Fix suid_dumpable and lease-break-time sysctls
Message-ID: <20090327133138.GJ8014@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arne de Bruijn points out in Bugzilla 12953 that commit
76fdbb25f963de5dc1e308325f0578a2f92b1c2d mistakenly limits
lease-break-time instead of suid_dumpable.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c5ef44f..7755ae7 100644
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

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

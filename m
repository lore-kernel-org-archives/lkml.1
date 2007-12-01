Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbXLATzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbXLATzy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 14:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXLATzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 14:55:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35388 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbXLATzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 14:55:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-mtd@lists.infradead.org
Subject: [PATCH] Freezer: Fix JFFS2 garbage collector freezing issue (was: Re: JFFS2 garbage collection threads not freezing?)
Date: Sat, 1 Dec 2007 21:14:10 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Pete MacKay" <armlinux@architechnical.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <36289.69.30.123.186.1196443476.squirrel@architechnical.net>
In-Reply-To: <36289.69.30.123.186.1196443476.squirrel@architechnical.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712012114.10881.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 30 of November 2007, Pete MacKay wrote:
> We've ported from 2.6.18 to 2.6.24-rc3 on a pxa270-based machine and can
> no longer enter 'standby' or 'mem' states.  I've stripped down the kernel
> and talked with the freezer maintainer and we believe the jffs2 garbage
> collection threads may not be calling try_to_freeze() or marking
> themselves properly.  (We have two mounted jffs2 file systems - mtd2 and
> mtd3).  The following is some cleaned-up output:
> 
> Freezing remaining freezable tasks ...
> Freezing of tasks failed after 20.00 seconds (2 tasks refusing to freeze):
>   task                PC stack   pid father
> init          D c0244b90     0     1      0
> kthreadd      S c0244b90     0     2      0
> ksoftirqd/0   S c0244b90     0     3      2
> events/0      S c0244b90     0     4      2
> khelper       S c0244b90     0     5      2
> kblockd/0     S c0244b90     0    51      2
> ksuspend_usbd D c0244b90     0    59      2
> khubd         D c0244b90     0    64      2
> kseriod       D c0244b90     0    67      2
> pdflush       D c0244b90     0    90      2
> pdflush       D c0244b90     0    91      2
> kswapd0       D c0244b90     0    92      2
> aio/0         S c0244b90     0    93      2
> mtdblockd     S c0244b90     0   192      2
> udevd         D c0244b90     0   619      1
> jffs2_gcd_mtd R running      0  1533      2
> jffs2_gcd_mtd R running      0  1598      2
> syslogd       D c0244b90     0  2248      1
> klogd         D c0244b90     0  2250      1
> hcid          D c0244b90     0  2273      1
> sdpd          D c0244b90     0  2277      1
> hidd          D c0244b90     0  2281      1
> sh            D c0244b90     0  2292      1
> getty         D c0244b90     0  2293      1
> echo          R running      0  2303   2292
>  jffs2_gcd_mtd2
>  jffs2_gcd_mtd3
> 
> Restarting tasks ... done.

I think that the appended patch is necessary to fix this problem.

Greetings,
Rafael

---
Subject: Freezer: Fix JFFS2 garbage collector freezing issue
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix breakage caused by commit d5d8c5976d6adeddb8208c240460411e2198b393
"freezer: do not send signals to kernel threads" in
jffs2_garbage_collect_thread() that assumed it would be sent signals
by the freezer.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pete MacKay <armlinux@architechnical.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/jffs2/background.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/jffs2/background.c
===================================================================
--- linux-2.6.orig/fs/jffs2/background.c
+++ linux-2.6/fs/jffs2/background.c
@@ -103,15 +103,17 @@ static int jffs2_garbage_collect_thread(
 		   get there first. */
 		yield();
 
+		/* If system suspend is in progress, go to the refrigerator and
+		   start again when the suspend is done */
+		if (try_to_freeze())
+			goto again;
+
 		/* Put_super will send a SIGKILL and then wait on the sem.
 		 */
 		while (signal_pending(current)) {
 			siginfo_t info;
 			unsigned long signr;
 
-			if (try_to_freeze())
-				goto again;
-
 			signr = dequeue_signal_lock(current, &current->blocked, &info);
 
 			switch(signr) {

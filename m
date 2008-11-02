Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbYKBSO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbYKBSO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbYKBSKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:10:12 -0500
Received: from main.gmane.org ([80.91.229.2]:52690 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375AbYKBSKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:10:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@queued.net>
Subject: [PATCH] jffs2: force the jffs2 GC daemon to behave a bit better
Date: Sun, 2 Nov 2008 13:04:49 -0500
Message-ID: <20081102130449.0aa74adb@fred>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-mtd@lists.infradead.org
X-Gmane-NNTP-Posting-Host: wireless.queued.net
X-Newsreader: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've noticed some pretty poor behavior on OLPC machines after bootup, when
gdm/X are starting.  The GCD monopolizes the scheduler (which in turns means
it gets to do more nand i/o), which results in processes taking much much
longer than they should to start.

As an example, on an OLPC machine going from OFW to a usable X (via auto-login
gdm) takes 2m 30s.  The majority of this time is consumed by the switch into
graphical mode.  With this patch, we cut a full 60s off of bootup time.  After
bootup, things are much snappier as well.

Note that we have seen a CRC node error with this patch that causes the machine
to fail to boot, but we've also seen that problem without this patch.  

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 fs/jffs2/background.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/jffs2/background.c b/fs/jffs2/background.c
index 8adebd3..f38d557 100644
--- a/fs/jffs2/background.c
+++ b/fs/jffs2/background.c
@@ -95,13 +95,17 @@ static int jffs2_garbage_collect_thread(void *_c)
 			schedule();
 		}
 
-		/* This thread is purely an optimisation. But if it runs when
-		   other things could be running, it actually makes things a
-		   lot worse. Use yield() and put it at the back of the runqueue
-		   every time. Especially during boot, pulling an inode in
-		   with read_inode() is much preferable to having the GC thread
-		   get there first. */
-		yield();
+		/* Problem - immediately after bootup, the GCD spends a lot
+		 * of time in places like jffs2_kill_fragtree(); so much so
+		 * that userspace processes (like gdm and X) are starved
+		 * despite plenty of cond_resched()s and renicing.  Yield()
+		 * doesn't help, either (presumably because userspace and GCD
+		 * are generally competing for a higher latency resource -
+		 * disk).
+		 * This forces the GCD to slow the hell down.   Pulling an
+		 * inode in with read_inode() is much preferable to having
+		 * the GC thread get there first. */
+		schedule_timeout_interruptible(msecs_to_jiffies(50));
 
 		/* Put_super will send a SIGKILL and then wait on the sem.
 		 */
-- 
1.5.6.5


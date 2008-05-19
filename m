Return-Path: <linux-kernel-owner+w=401wt.eu-S1763309AbYESSGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763309AbYESSGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 14:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761625AbYESSEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 14:04:54 -0400
Received: from 66-189-124-104.dhcp.oxfr.ma.charter.com ([66.189.124.104]:48410
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761014AbYESSEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 14:04:50 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 8/8] remove the extra call to try_to_take_lock
To: mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, bill.huey@gmail.com, dsingleton@mvista.com,
       dwalker@mvista.com, npiggin@suse.de, pavel@ucw.cz, acme@redhat.com,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com,
       ghaskins@novell.com
Date: Mon, 19 May 2008 13:07:54 -0400
Message-ID: <20080519170754.6820.31938.stgit@novell1.haskins.net>
In-Reply-To: <20080519170356.6820.5274.stgit@novell1.haskins.net>
References: <20080519170356.6820.5274.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter W. Morreale <pmorreale@novell.com>

Remove the redundant attempt to get the lock.  While it is true that the
exit path with this patch adds an un-necessary xchg (in the event the
lock is granted without further traversal in the loop) experimentation
shows that we almost never encounter this situation.

Signed-off-by: Peter W. Morreale <pmorreale@novell.com>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/rtmutex.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index bf81966..1e694a8 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -733,12 +733,6 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 	spin_lock_irqsave(&lock->wait_lock, flags);
 	init_lists(lock);
 
-	/* Try to acquire the lock again: */
-	if (do_try_to_take_rt_mutex(lock, STEAL_LATERAL)) {
-		spin_unlock_irqrestore(&lock->wait_lock, flags);
-		return;
-	}
-
 	BUG_ON(rt_mutex_owner(lock) == current);
 
 	/*


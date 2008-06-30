Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbYF3Peu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbYF3Peu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763295AbYF3PcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:32:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55809 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763291AbYF3PcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:32:20 -0400
Date: Mon, 30 Jun 2008 17:32:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] core kernel fixes
Message-ID: <20080630153200.GA22360@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core kernel fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

Thanks,

	Ingo

------------------>
Vegard Nossum (1):
      debugobjects: fix lockdep warning

 lib/debugobjects.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index a76a5e1..85b18d7 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -68,6 +68,7 @@ static int fill_pool(void)
 {
 	gfp_t gfp = GFP_ATOMIC | __GFP_NORETRY | __GFP_NOWARN;
 	struct debug_obj *new;
+	unsigned long flags;
 
 	if (likely(obj_pool_free >= ODEBUG_POOL_MIN_LEVEL))
 		return obj_pool_free;
@@ -81,10 +82,10 @@ static int fill_pool(void)
 		if (!new)
 			return obj_pool_free;
 
-		spin_lock(&pool_lock);
+		spin_lock_irqsave(&pool_lock, flags);
 		hlist_add_head(&new->node, &obj_pool);
 		obj_pool_free++;
-		spin_unlock(&pool_lock);
+		spin_unlock_irqrestore(&pool_lock, flags);
 	}
 	return obj_pool_free;
 }
@@ -110,16 +111,13 @@ static struct debug_obj *lookup_object(void *addr, struct debug_bucket *b)
 }
 
 /*
- * Allocate a new object. If the pool is empty and no refill possible,
- * switch off the debugger.
+ * Allocate a new object. If the pool is empty, switch off the debugger.
  */
 static struct debug_obj *
 alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
 {
 	struct debug_obj *obj = NULL;
-	int retry = 0;
 
-repeat:
 	spin_lock(&pool_lock);
 	if (obj_pool.first) {
 		obj	    = hlist_entry(obj_pool.first, typeof(*obj), node);
@@ -141,9 +139,6 @@ repeat:
 	}
 	spin_unlock(&pool_lock);
 
-	if (fill_pool() && !obj && !retry++)
-		goto repeat;
-
 	return obj;
 }
 
@@ -261,6 +256,8 @@ __debug_object_init(void *addr, struct debug_obj_descr *descr, int onstack)
 	struct debug_obj *obj;
 	unsigned long flags;
 
+	fill_pool();
+
 	db = get_bucket((unsigned long) addr);
 
 	spin_lock_irqsave(&db->lock, flags);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYH1Pc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYH1Pc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 11:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYH1PcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 11:32:17 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:58543 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbYH1PcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 11:32:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=wLolLWmjx8USwk4F9gB1mvIOShhpXIm9t7iOjMIQH3WgVegyC1iuMzrJHj0Gdw5Dpf
         QGZyuH7aEPccH9BJeZUG3CkUVRCog9ch7nBtnxasLkB9JcClECUBd2IT44JTs9khyHgH
         Jxvxa/6LgFBjY/pmm9W11EKmVbpjOtS2RB82A=
Date: Thu, 28 Aug 2008 17:32:14 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: [PATCH] debugobjects: fix lockdep warning #2
Message-ID: <20080828153214.GA27653@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 3:56 PM, Ingo Molnar <mingo@elte.hu> wrote:
> could you resend the final patch please? It's a candidate for .27, if it
> works out fine.

Here is the combined patch. I've tested it only briefly, and I am
unsure of whether it still produces lockdep warnings for Daniel or
not. I wish it would not be applied anywhere unless it was
officially Reviewed-by: someone. In particular, I'm not quite
steady with the irq-safe locking (Thomas might want to have a look).

Thanks :)


Vegard


>From 977cf583b79be7308d5e310711fe6038c8af96a4 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 28 Aug 2008 17:09:57 +0200
Subject: [PATCH] debugobjects: fix lockdep warning #2

Daniel J. Blueman reported:
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.27-rc4-224c #1
> -------------------------------------------------------
> hald/4680 is trying to acquire lock:
>  (&n->list_lock){++..}, at: [<ffffffff802bfa26>] add_partial+0x26/0x80
>
> but task is already holding lock:
>  (&obj_hash[i].lock){++..}, at: [<ffffffff8041cfdc>]
> debug_object_free+0x5c/0x120

We fix it by moving the actual freeing to outside the lock (the lock
now only protects the list).

The lock is also promoted to irq-safe (suggested by Dan).

Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 lib/debugobjects.c |   38 +++++++++++++++++++++++++++++---------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 19acf8c..acf9ed8 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -115,9 +115,10 @@ static struct debug_obj *lookup_object(void *addr, struct debug_bucket *b)
 static struct debug_obj *
 alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
 {
+	unsigned long flags;
 	struct debug_obj *obj = NULL;
 
-	spin_lock(&pool_lock);
+	spin_lock_irqsave(&pool_lock, flags);
 	if (obj_pool.first) {
 		obj	    = hlist_entry(obj_pool.first, typeof(*obj), node);
 
@@ -136,7 +137,7 @@ alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
 		if (obj_pool_free < obj_pool_min_free)
 			obj_pool_min_free = obj_pool_free;
 	}
-	spin_unlock(&pool_lock);
+	spin_unlock_irqrestore(&pool_lock, flags);
 
 	return obj;
 }
@@ -146,18 +147,19 @@ alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
  */
 static void free_object(struct debug_obj *obj)
 {
+	unsigned long flags;
 	unsigned long idx = (unsigned long)(obj - obj_static_pool);
 
 	if (obj_pool_free < ODEBUG_POOL_SIZE || idx < ODEBUG_POOL_SIZE) {
-		spin_lock(&pool_lock);
+		spin_lock_irqsave(&pool_lock, flags);
 		hlist_add_head(&obj->node, &obj_pool);
 		obj_pool_free++;
 		obj_pool_used--;
-		spin_unlock(&pool_lock);
+		spin_unlock_irqrestore(&pool_lock, flags);
 	} else {
-		spin_lock(&pool_lock);
+		spin_lock_irqsave(&pool_lock, flags);
 		obj_pool_used--;
-		spin_unlock(&pool_lock);
+		spin_unlock_irqrestore(&pool_lock, flags);
 		kmem_cache_free(obj_cache, obj);
 	}
 }
@@ -170,19 +172,28 @@ static void debug_objects_oom(void)
 {
 	struct debug_bucket *db = obj_hash;
 	struct hlist_node *node, *tmp;
+	HLIST_HEAD(freelist);
 	struct debug_obj *obj;
 	unsigned long flags;
 	int i;
 
 	printk(KERN_WARNING "ODEBUG: Out of memory. ODEBUG disabled\n");
 
+	/* XXX: Could probably be optimized by transplantation of more than
+	 * one entry at a time. */
 	for (i = 0; i < ODEBUG_HASH_SIZE; i++, db++) {
 		spin_lock_irqsave(&db->lock, flags);
 		hlist_for_each_entry_safe(obj, node, tmp, &db->list, node) {
 			hlist_del(&obj->node);
-			free_object(obj);
+			hlist_add_head(&obj->node, &freelist);
 		}
 		spin_unlock_irqrestore(&db->lock, flags);
+
+		/* Now free them */
+		hlist_for_each_entry_safe(obj, node, tmp, &freelist, node) {
+			hlist_del(&obj->node);
+			free_object(obj);
+		}
 	}
 }
 
@@ -500,8 +511,9 @@ void debug_object_free(void *addr, struct debug_obj_descr *descr)
 		return;
 	default:
 		hlist_del(&obj->node);
+		spin_unlock_irqrestore(&db->lock, flags);
 		free_object(obj);
-		break;
+		return;
 	}
 out_unlock:
 	spin_unlock_irqrestore(&db->lock, flags);
@@ -512,6 +524,7 @@ static void __debug_check_no_obj_freed(const void *address, unsigned long size)
 {
 	unsigned long flags, oaddr, saddr, eaddr, paddr, chunks;
 	struct hlist_node *node, *tmp;
+	HLIST_HEAD(freelist);
 	struct debug_obj_descr *descr;
 	enum debug_obj_state state;
 	struct debug_bucket *db;
@@ -547,11 +560,18 @@ repeat:
 				goto repeat;
 			default:
 				hlist_del(&obj->node);
-				free_object(obj);
+				hlist_add_head(&obj->node, &freelist);
 				break;
 			}
 		}
 		spin_unlock_irqrestore(&db->lock, flags);
+
+		/* Now free them */
+		hlist_for_each_entry_safe(obj, node, tmp, &freelist, node) {
+			hlist_del(&obj->node);
+			free_object(obj);
+		}
+
 		if (cnt > debug_objects_maxchain)
 			debug_objects_maxchain = cnt;
 	}
-- 
1.5.5.1


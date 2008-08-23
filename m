Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbYHWFe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbYHWFe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 01:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYHWFer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 01:34:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:6294 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbYHWFeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 01:34:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=EM4lQ3Tye2yWzqGQ011kUIlI3UL9tc6pIMo23UmavY0Tvy/KYtslgo/w8oulyzb1hp
         qb33m4d7s1E4LZd13Q9mUH23KlhHEl/ykufRso1J8d6GBfAG6Gqh7eZAY7i6ZzS+bOzR
         e6oFrqm9HQ6M6ECW8BUVDiZ+qCQAMWOh3BkoA=
Date: Sat, 23 Aug 2008 07:34:43 +0200
To: Daniel J Blueman <daniel.blueman@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.27-rc4] SLUB list_lock vs obj_hash.lock...
Message-ID: <20080823053443.GA9209@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2220808221448l24e98c61t83a2680f9df314f2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 11:48 PM, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> When booting 2.6.27-rc4 with SLUB and debug_objects=1, we see (after
> some activity) lock ordering issues with obj_hash.lock and SLUB's
> list_lock [1].

That's quite funny :-)

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

It seems to be a similar problem as before, except that this is the free path, and not alloc.

You might try the appended patch -- but it's completely untested on my end!

What it does is to move the actual freeing until after we've released the hash-entry lock. In the cases of multiple objects freed, we enqueue all the objects on a local list.

Also added Thomas to Cc.


Vegard

PS: Why are you the only one seeing these things? Does debug_objects=1 need to be passed to activate this code, or can a CONFIG also be used?


diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 45a6bde..9d8161f 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -171,19 +171,28 @@ static void debug_objects_oom(void)
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
 
@@ -498,8 +507,9 @@ void debug_object_free(void *addr, struct debug_obj_descr *descr)
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
@@ -510,6 +520,7 @@ static void __debug_check_no_obj_freed(const void *address, unsigned long size)
 {
 	unsigned long flags, oaddr, saddr, eaddr, paddr, chunks;
 	struct hlist_node *node, *tmp;
+	HLIST_HEAD(freelist);
 	struct debug_obj_descr *descr;
 	enum debug_obj_state state;
 	struct debug_bucket *db;
@@ -545,11 +556,18 @@ repeat:
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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbYFLTjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbYFLTjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbYFLTjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:39:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57817 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbYFLTjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:39:08 -0400
Subject: Re: [patch] radix-tree: fix small lockless radix-tree bug
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       paulmck@us.ibm.com
In-Reply-To: <20080612123102.d8783b98.akpm@linux-foundation.org>
References: <200806130503.45369.nickpiggin@yahoo.com.au>
	 <20080612123102.d8783b98.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Thu, 12 Jun 2008 21:38:33 +0200
Message-Id: <1213299513.31518.174.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-12 at 12:31 -0700, Andrew Morton wrote:
> On Fri, 13 Jun 2008 05:03:45 +1000
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > Hi guys,
> > 
> > Although this doesn't seem like cause for alarm (as per the analysis),
> > it may still be a good 2.6.26 candidate as we should have a few more
> > weeks of testing left.
> > 
> > It should definitely go in -mm with the lockless pagecache patch.
> > 
> > When shrinking a radix-tree, we do it in a lockless manner by atomically
> > switching the root pointer away from the redundant node (one that only
> > has a single entry in the left most slot), and switching it over to its
> > lone child.
> > 
> > Because a lockless lookup may have got a reference to the parent and be
> > in the middle of deciding what to do with it while it is being swapped
> > away for its child. For this reason, we also have to keep it around and
> > in a valid state for the lookup to proceed and give a valid result, for
> > at least an RCU grace period. So we need to keep the child in the left
> > most slot there in case that is requested by the lookup.
> > 
> > This is all pretty standard RCU stuff. It is worth repeating because
> > in my eagerness to obey the radix tree node constructor scheme, I had
> > broken this by zeroing the radix tree node before the grace period.
> > 
> > Fix it by clearing those fields in the RCU callback. I would normally
> > want to rip out the constructor entirely, but radix tree nodes are one
> > of those places where they make sense (only few cachelines will be
> > touched soon after allocation).
> > 
> > 
> > This was never actually observed in any lockless pagecache testing or
> > using the test harness, but as a rare problem testing my scalable vmap
> > rewrite.
> > 
> > Fortunately, it is not a problem anywhere lockless pagecache is used in
> > mainline kernels (pagecache probe is not a guarantee, and brd does not
> > have concurrent lookups and deletes).
> > 
> > However, it would eventually pop up for someone using lockless pagecache :P
> > 
> 
> OK, I give up.  A cannot spot what you actually changed amongst all the
> code motion?

The two relevant hunks:

﻿@@ -124,6 +175,17 @@ static void radix_tree_node_rcu_free(str
 {
        struct radix_tree_node *node =
                        container_of(head, struct radix_tree_node, rcu_head);
+
+       /*
+        * must only free zeroed nodes into the slab. radix_tree_shrink
+        * can leave us with a non-NULL entry in the first slot, so clear
+        * that here to make sure.
+        */
+       tag_clear(node, 0, 0);
+       tag_clear(node, 1, 0);
+       node->slots[0] = NULL;
+       node->count = 0;
+
        kmem_cache_free(radix_tree_node_cachep, node);
 }
 
@@ -930,11 +939,6 @@ static inline void radix_tree_shrink(str
                        newptr = radix_tree_ptr_to_indirect(newptr);
                root->rnode = newptr;
                root->height--;
-               /* must only free zeroed nodes into the slab */
-               tag_clear(to_free, 0, 0);
-               tag_clear(to_free, 1, 0);
-               to_free->slots[0] = NULL;
-               to_free->count = 0;
                radix_tree_node_free(to_free);
        }
 }

So instead of clearing the first slot on free, we delay it one grace
period and clear it later. So that anybody already having a pointer to
the node can correctly resolve the item.


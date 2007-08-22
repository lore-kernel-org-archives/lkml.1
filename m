Return-Path: <linux-kernel-owner+w=401wt.eu-S932730AbXHVUi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730AbXHVUi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbXHVUiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:38:21 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45938 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763032AbXHVUiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:38:20 -0400
Date: Wed, 22 Aug 2007 13:38:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070822202955.GA26612@Krystal>
Message-ID: <Pine.LNX.4.64.0708221336030.16087@schroedinger.engr.sgi.com>
References: <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com>
 <20070822000323.GG29691@Krystal> <p73fy2cz7bs.fsf@bingen.suse.de>
 <20070822003834.GB1400@Krystal> <Pine.LNX.4.64.0708211757360.3118@schroedinger.engr.sgi.com>
 <20070822134532.GA3769@Krystal> <Pine.LNX.4.64.0708221224550.14795@schroedinger.engr.sgi.com>
 <20070822200910.GA25687@Krystal> <Pine.LNX.4.64.0708221316240.15775@schroedinger.engr.sgi.com>
 <20070822202955.GA26612@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok so we need this.


Fix up preempt checks.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-08-22 13:33:40.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-08-22 13:35:31.000000000 -0700
@@ -1469,6 +1469,7 @@ load_freelist:
 out:
 	slab_unlock(c->page);
 	local_irq_restore(flags);
+	preempt_check_resched();
 	if (unlikely((gfpflags & __GFP_ZERO)))
 		memset(object, 0, c->objsize);
 	return object;
@@ -1512,6 +1513,7 @@ new_slab:
 		goto load_freelist;
 	}
 	local_irq_restore(flags);
+	preempt_check_resched();
 	return NULL;
 debug:
 	object = c->page->freelist;
@@ -1592,8 +1594,8 @@ static void __slab_free(struct kmem_cach
 	void **object = (void *)x;
 	unsigned long flags;
 
+	put_cpu();
 	local_irq_save(flags);
-	put_cpu_no_resched();
 	slab_lock(page);
 
 	if (unlikely(SlabDebug(page)))


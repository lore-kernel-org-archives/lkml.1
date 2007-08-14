Return-Path: <linux-kernel-owner+w=401wt.eu-S935561AbXHNWVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935561AbXHNWVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936779AbXHNWLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:11:13 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37636 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936772AbXHNWLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:11:10 -0400
Date: Tue, 14 Aug 2007 15:11:09 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Luck, Tony" <tony.luck@intel.com>
cc: Chris Snook <csnook@redhat.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: RE: [PATCH 10/23] make atomic_read() and atomic_set() behavior
 consistent on ia64
In-Reply-To: <617E1C2C70743745A92448908E030B2A022A009A@scsmsx411.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0708141509300.32420@schroedinger.engr.sgi.com>
References: <46C03885.7000109@redhat.com> <20070813112334.GJ24018@shell.boston.redhat.com>
 <617E1C2C70743745A92448908E030B2A0229FD89@scsmsx411.amr.corp.intel.com>
 <46C1F917.1070008@redhat.com> <617E1C2C70743745A92448908E030B2A022A009A@scsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Luck, Tony wrote:

> I re-tried the macros ... the three warnings from mm/slub.c all result in
> broken code ... and quite rightly too, they all come from code that does:
> 
> 	atomic_read(&n->nr_slabs)
> 
> But the nr_slabs field is an atomic_long_t, so we shouldn't be using
> atomic_read().  I didn't spot these last time around because I was using
> slab, not slub for the previous build.

Hmmmm...  Strange that this did not cause failures before on any other 
platforms?


Fix atomic_read's in slub

Signed-off-by: Christoph Lameter <clameter@sgi.com>

diff --git a/mm/slub.c b/mm/slub.c
index 69d02e3..0c106d7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3112,7 +3112,7 @@ static int list_locations(struct kmem_cache *s, char *buf,
 		unsigned long flags;
 		struct page *page;
 
-		if (!atomic_read(&n->nr_slabs))
+		if (!atomic_long_read(&n->nr_slabs))
 			continue;
 
 		spin_lock_irqsave(&n->list_lock, flags);
@@ -3247,7 +3247,7 @@ static unsigned long slab_objects(struct kmem_cache *s,
 		}
 
 		if (flags & SO_FULL) {
-			int full_slabs = atomic_read(&n->nr_slabs)
+			int full_slabs = atomic_long_read(&n->nr_slabs)
 					- per_cpu[node]
 					- n->nr_partial;
 
@@ -3283,7 +3283,7 @@ static int any_slab_objects(struct kmem_cache *s)
 	for_each_node(node) {
 		struct kmem_cache_node *n = get_node(s, node);
 
-		if (n->nr_partial || atomic_read(&n->nr_slabs))
+		if (n->nr_partial || atomic_long_read(&n->nr_slabs))
 			return 1;
 	}
 	return 0;

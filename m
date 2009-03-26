Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbZCZJns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbZCZJns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZCZJng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:43:36 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49630 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbZCZJne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:43:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=NK6bB/JuXkZK3RQhf6Wp+dJS2pYhHY4wxvRc3U5+ac52JG0/6jlNXdgcrj48mtD/B
	5IaoGnpUmvKXCAnYRyivA==
Date: Thu, 26 Mar 2009 02:42:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 3/3] slub: sort parital list when thrashing
In-Reply-To: <alpine.DEB.2.00.0903260241150.1454@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0903260241330.1454@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903260240390.1454@chino.kir.corp.google.com> <alpine.DEB.2.00.0903260241150.1454@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caches that are cpu slab thrashing will scan their entire partial list
until a slab is found that will satisfy at least the requisite number of
allocations so that it will not be considered thrashing (as defined by
/sys/kernel/slab/cache/slab_thrash_ratio).

The partial list can be extremely long and its scanning requires that
list_lock is held for that particular node.  This can be inefficient if
slabs at the head of the list are not appropriate cpu slab replacements.

When an object is freed, the number of free objects for its slab is
calculated if the cpu cache is currently thrashing.  If it can satisfy
the requisite number of allocations so that the slab thrash ratio is
exceeded, it is moved to the head of the partial list.  This minimizes
the time spent holding list_lock and can help cacheline optimizations
for recently freed objects.

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1264,6 +1264,13 @@ static void remove_partial(struct kmem_cache *s, struct page *page)
 	spin_unlock(&n->list_lock);
 }
 
+static void move_partial_to_head(struct kmem_cache_node *n, struct page *page)
+{
+	spin_lock(&n->list_lock);
+	list_move(&page->lru, &n->partial);
+	spin_unlock(&n->list_lock);
+}
+
 /*
  * Remove from the partial list.
  *
@@ -1726,6 +1733,15 @@ checks_ok:
 	if (unlikely(!prior)) {
 		add_partial(get_node(s, page_to_nid(page)), page, 1);
 		stat(c, FREE_ADD_PARTIAL);
+	} else if (c->slowpath_allocs >= SLAB_THRASHING_THRESHOLD) {
+		/*
+		 * If the cache is actively slab thrashing, it's necessary to
+		 * move partial slabs to the head of the list so there isn't
+		 * excessive partial list scanning while holding list_lock.
+		 */
+		if (!skip_partial(s, page))
+			move_partial_to_head(get_node(s, page_to_nid(page)),
+					     page);
 	}
 
 out_unlock:

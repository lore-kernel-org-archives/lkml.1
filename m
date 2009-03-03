Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZCCNrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZCCNrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbZCCNqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:46:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59148 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754817AbZCCNqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:46:12 -0500
Message-ID: <49AD3442.5040306@cn.fujitsu.com>
Date: Tue, 03 Mar 2009 21:44:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 4/6] slqb: record slab's start address in slqb_page
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


slqb's slab is coloring, it's will be useful that record the
color value or start address in struct slqb_page.

This fix adds a field in struct slqb_page to record slab's
start address, It will be used by kfree_rcu().


struct slqb_page has a field:
	struct kmem_cache_list *list;

the corresponding field in struct page is:

	union {
	    struct {
		unsigned long private;
		struct address_space *mapping;
	    };
	    struct kmem_cache *slab;
	    struct page *first_page;
	};

It's large than 'struct kmem_cache_list *list;'
*So we are safe to add a field in struct page.*


(This field will not become a burden in future:)
struct page is very small, this fix uses the last room of
struct page. But if we have to add a more important
field in struct slqb_page in future, We can record slab's
color value in slqb_page instead of start address.
like this:
	struct {
		unsigned long	flags;
		atomic_t	_count;
		u16		inuse;		/* use u16 instead */
		u16		color;  	/* of unsigned int */
		void 		*a_more_important_field;
		struct kmem_cache_list *list;
		void		 **freelist;
		union {
			struct list_head lru;
			struct rcu_head rcu_head;
		};
	};

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/mm/slqb.c b/mm/slqb.c
index 48bdf3b..c258ddc 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -41,6 +41,7 @@ struct slqb_page {
 			unsigned long	flags;		/* mandatory */
 			atomic_t	_count;		/* mandatory */
 			unsigned int	inuse;		/* Nr of objects */
+			void 		*s_mem;		/* start address */
 			struct kmem_cache_list *list;	/* Pointer to list */
 			void		 **freelist;	/* LIFO freelist */
 			union {
@@ -1010,6 +1011,7 @@ static struct slqb_page *new_slab_page(struct kmem_cache *s,
 	}
 	set_freepointer(s, last, NULL);
 
+	page->s_mem = start;
 	page->freelist = start;
 	page->inuse = 0;
 out:









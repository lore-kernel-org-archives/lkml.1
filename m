Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbYLCT7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbYLCT7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbYLCTuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:39 -0500
Received: from kroah.org ([198.145.64.141]:59634 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751667AbYLCTu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:29 -0500
Date: Wed, 3 Dec 2008 11:49:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Manfred Spraul <manfred@colorfullife.com>,
       Clement Calmels <cboulte@gmail.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>
Subject: [patch 021/104] lib/idr.c: fix rcu related race with idr_find
Message-ID: <20081203194906.GV8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="lib-idr.c-fix-rcu-related-race-with-idr_find.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Manfred Spraul <manfred@colorfullife.com>

commit 6ff2d39b91aec3dcae951afa982059e3dd9b49dc upstream.

2nd part of the fixes needed for
http://bugzilla.kernel.org/show_bug.cgi?id=11796.

When the idr tree is either grown or shrunk, then the update to the number
of layers and the top pointer were not atomic.  This race caused crashes.

The attached patch fixes that by replicating the layers counter in each
layer, thus idr_find doesn't need idp->layers anymore.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Clement Calmels <cboulte@gmail.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/idr.h |    3 ++-
 lib/idr.c           |   14 ++++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)

--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -52,13 +52,14 @@ struct idr_layer {
 	unsigned long		 bitmap; /* A zero bit means "space here" */
 	struct idr_layer	*ary[1<<IDR_BITS];
 	int			 count;	 /* When zero, we can release it */
+	int			 layer;	 /* distance from leaf */
 	struct rcu_head		 rcu_head;
 };
 
 struct idr {
 	struct idr_layer *top;
 	struct idr_layer *id_free;
-	int		  layers;
+	int		  layers; /* only valid without concurrent changes */
 	int		  id_free_cnt;
 	spinlock_t	  lock;
 };
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -185,6 +185,7 @@ static int sub_alloc(struct idr *idp, in
 			new = get_from_free_list(idp);
 			if (!new)
 				return -1;
+			new->layer = l-1;
 			rcu_assign_pointer(p->ary[m], new);
 			p->count++;
 		}
@@ -210,6 +211,7 @@ build_up:
 	if (unlikely(!p)) {
 		if (!(p = get_from_free_list(idp)))
 			return -1;
+		p->layer = 0;
 		layers = 1;
 	}
 	/*
@@ -237,6 +239,7 @@ build_up:
 		}
 		new->ary[0] = p;
 		new->count = 1;
+		new->layer = layers-1;
 		if (p->bitmap == IDR_FULL)
 			__set_bit(0, &new->bitmap);
 		p = new;
@@ -493,17 +496,21 @@ void *idr_find(struct idr *idp, int id)
 	int n;
 	struct idr_layer *p;
 
-	n = idp->layers * IDR_BITS;
 	p = rcu_dereference(idp->top);
+	if (!p)
+		return NULL;
+	n = (p->layer+1) * IDR_BITS;
 
 	/* Mask off upper bits we don't use for the search. */
 	id &= MAX_ID_MASK;
 
 	if (id >= (1 << n))
 		return NULL;
+	BUG_ON(n == 0);
 
 	while (n > 0 && p) {
 		n -= IDR_BITS;
+		BUG_ON(n != p->layer*IDR_BITS);
 		p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
 	}
 	return((void *)p);
@@ -582,8 +589,11 @@ void *idr_replace(struct idr *idp, void 
 	int n;
 	struct idr_layer *p, *old_p;
 
-	n = idp->layers * IDR_BITS;
 	p = idp->top;
+	if (!p)
+		return ERR_PTR(-EINVAL);
+
+	n = (p->layer+1) * IDR_BITS;
 
 	id &= MAX_ID_MASK;
 


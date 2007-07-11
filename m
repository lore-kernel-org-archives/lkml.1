Return-Path: <linux-kernel-owner+w=401wt.eu-S935575AbXGKXmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935575AbXGKXmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935103AbXGKXeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:34:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:33778 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935095AbXGKXeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:34:18 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/61] idr: separate out idr_mark_full()
Date: Wed, 11 Jul 2007 16:31:39 -0700
Message-Id: <11841968352439-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841968303508-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Separate out idr_mark_full() from sub_alloc() and make marking the
allocated slot full the responsibility of idr_get_new_above_int().

Allocation part of idr_get_new_above_int() is renamed to
idr_get_empty_slot().  New idr_get_new_above_int() allocates a slot
using the function, install the user pointer and marks it full using
idr_mark_full().

This change doesn't introduce any behavior change.  This will be
used by ida.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/idr.c |   71 +++++++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 46 insertions(+), 25 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 7b5a59c..30b33e2 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -70,6 +70,26 @@ static void free_layer(struct idr *idp, struct idr_layer *p)
 	spin_unlock_irqrestore(&idp->lock, flags);
 }
 
+static void idr_mark_full(struct idr_layer **pa, int id)
+{
+	struct idr_layer *p = pa[0];
+	int l = 0;
+
+	__set_bit(id & IDR_MASK, &p->bitmap);
+	/*
+	 * If this layer is full mark the bit in the layer above to
+	 * show that this part of the radix tree is full.  This may
+	 * complete the layer above and require walking up the radix
+	 * tree.
+	 */
+	while (p->bitmap == IDR_FULL) {
+		if (!(p = pa[++l]))
+			break;
+		id = id >> IDR_BITS;
+		__set_bit((id & IDR_MASK), &p->bitmap);
+	}
+}
+
 /**
  * idr_pre_get - reserver resources for idr allocation
  * @idp:	idr handle
@@ -95,11 +115,10 @@ int idr_pre_get(struct idr *idp, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(idr_pre_get);
 
-static int sub_alloc(struct idr *idp, void *ptr, int *starting_id)
+static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 {
 	int n, m, sh;
 	struct idr_layer *p, *new;
-	struct idr_layer *pa[MAX_LEVEL];
 	int l, id, oid;
 	long bm;
 
@@ -156,30 +175,13 @@ static int sub_alloc(struct idr *idp, void *ptr, int *starting_id)
 		pa[l--] = p;
 		p = p->ary[m];
 	}
-	/*
-	 * We have reached the leaf node, plant the
-	 * users pointer and return the raw id.
-	 */
-	p->ary[m] = (struct idr_layer *)ptr;
-	__set_bit(m, &p->bitmap);
-	p->count++;
-	/*
-	 * If this layer is full mark the bit in the layer above
-	 * to show that this part of the radix tree is full.
-	 * This may complete the layer above and require walking
-	 * up the radix tree.
-	 */
-	n = id;
-	while (p->bitmap == IDR_FULL) {
-		if (!(p = pa[++l]))
-			break;
-		n = n >> IDR_BITS;
-		__set_bit((n & IDR_MASK), &p->bitmap);
-	}
-	return(id);
+
+	pa[l] = p;
+	return id;
 }
 
-static int idr_get_new_above_int(struct idr *idp, void *ptr, int starting_id)
+static int idr_get_empty_slot(struct idr *idp, int starting_id,
+			      struct idr_layer **pa)
 {
 	struct idr_layer *p, *new;
 	int layers, v, id;
@@ -225,12 +227,31 @@ build_up:
 	}
 	idp->top = p;
 	idp->layers = layers;
-	v = sub_alloc(idp, ptr, &id);
+	v = sub_alloc(idp, &id, pa);
 	if (v == -2)
 		goto build_up;
 	return(v);
 }
 
+static int idr_get_new_above_int(struct idr *idp, void *ptr, int starting_id)
+{
+	struct idr_layer *pa[MAX_LEVEL];
+	int id;
+
+	id = idr_get_empty_slot(idp, starting_id, pa);
+	if (id >= 0) {
+		/*
+		 * Successfully found an empty slot.  Install the user
+		 * pointer and mark the slot full.
+		 */
+		pa[0]->ary[id & IDR_MASK] = (struct idr_layer *)ptr;
+		pa[0]->count++;
+		idr_mark_full(pa, id);
+	}
+
+	return id;
+}
+
 /**
  * idr_get_new_above - allocate new idr entry above or equal to a start id
  * @idp: idr handle
-- 
1.5.2.2


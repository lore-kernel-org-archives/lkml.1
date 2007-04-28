Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbXD1Nk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbXD1Nk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031151AbXD1Nk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:40:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:45359 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212AbXD1Njr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=N4tpByrNmyeyuk9lDxLNuBbrupkGKh7TFByua71Jn4C/LszD0Vew9pdxvCTbXI4C0x+TUmsNp9ycTnBlyx9GW2hFl3paetRmimcRGfaDy0952l0DF/VyhoaCcVS48Y3nzeeot0Dyo6Zi3q1nKXJxxAkwioBXFBcuHrCd6fqCgSg=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 02/21] idr: separate out idr_mark_full()
In-Reply-To: <11777675753460-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 28 Apr 2007 22:39:39 +0900
Message-Id: <11777675791348-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out idr_mark_full() from sub_alloc() and make marking the
allocated slot full the responsibility of idr_get_new_above_int().

Allocation part of idr_get_new_above_int() is renamed to
idr_get_empty_slot().  New idr_get_new_above_int() allocates a slot
using the function, install the user pointer and marks it full using
idr_mark_full().

This change doesn't introduce any behavior change.  This will be
used by ida.

Signed-off-by: Tejun Heo <htejun@gmail.com>
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
1.5.0.3



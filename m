Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYEGLjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYEGLjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539AbYEGLiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:38:12 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56375 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbYEGLhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:37:45 -0400
Message-Id: <20080507113736.350271000@bull.net>
References: <20080507113553.395937000@bull.net>
User-Agent: quilt/0.45-1
Date: Wed, 07 May 2008 13:35:57 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 4/9] Error checking factorization
Content-Disposition: inline; filename=idr_rc_to_errno.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 04/09]

This is a trivial patch that does some codes factorization in the return code
analysis.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/idr.h |    6 ++++++
 lib/idr.c           |   30 +++++++++---------------------
 2 files changed, 15 insertions(+), 21 deletions(-)

Index: linux-2.6.25-mm1/include/linux/idr.h
===================================================================
--- linux-2.6.25-mm1.orig/include/linux/idr.h	2008-05-06 17:35:42.000000000 +0200
+++ linux-2.6.25-mm1/include/linux/idr.h	2008-05-06 17:38:42.000000000 +0200
@@ -73,6 +73,12 @@ struct idr {
 }
 #define DEFINE_IDR(name)	struct idr name = IDR_INIT(name)
 
+/* Actions to be taken after a call to _idr_sub_alloc */
+#define IDR_NEED_TO_GROW -2
+#define IDR_NOMORE_SPACE -3
+
+#define _idr_rc_to_errno(rc) ((rc) == -1 ? -EAGAIN : -ENOSPC)
+
 /*
  * This is what we export.
  */
Index: linux-2.6.25-mm1/lib/idr.c
===================================================================
--- linux-2.6.25-mm1.orig/lib/idr.c	2008-05-06 17:37:40.000000000 +0200
+++ linux-2.6.25-mm1/lib/idr.c	2008-05-06 17:38:42.000000000 +0200
@@ -143,7 +143,7 @@ static int sub_alloc(struct idr *idp, in
 			/* if already at the top layer, we need to grow */
 			if (!(p = pa[l])) {
 				*starting_id = id;
-				return -2;
+				return IDR_NEED_TO_GROW;
 			}
 
 			/* If we need to go up one layer, continue the
@@ -160,7 +160,7 @@ static int sub_alloc(struct idr *idp, in
 			id = ((id >> sh) ^ n ^ m) << sh;
 		}
 		if ((id >= MAX_ID_BIT) || (id < 0))
-			return -3;
+			return IDR_NOMORE_SPACE;
 		if (l == 0)
 			break;
 		/*
@@ -229,7 +229,7 @@ build_up:
 	idp->top = p;
 	idp->layers = layers;
 	v = sub_alloc(idp, &id, pa);
-	if (v == -2)
+	if (v == IDR_NEED_TO_GROW)
 		goto build_up;
 	return(v);
 }
@@ -278,12 +278,8 @@ int idr_get_new_above(struct idr *idp, v
 	 * This is a cheap hack until the IDR code can be fixed to
 	 * return proper error values.
 	 */
-	if (rv < 0) {
-		if (rv == -1)
-			return -EAGAIN;
-		else /* Will be -3 */
-			return -ENOSPC;
-	}
+	if (rv < 0)
+		return _idr_rc_to_errno(rv);
 	*id = rv;
 	return 0;
 }
@@ -313,12 +309,8 @@ int idr_get_new(struct idr *idp, void *p
 	 * This is a cheap hack until the IDR code can be fixed to
 	 * return proper error values.
 	 */
-	if (rv < 0) {
-		if (rv == -1)
-			return -EAGAIN;
-		else /* Will be -3 */
-			return -ENOSPC;
-	}
+	if (rv < 0)
+		return _idr_rc_to_errno(rv);
 	*id = rv;
 	return 0;
 }
@@ -696,12 +688,8 @@ int ida_get_new_above(struct ida *ida, i
  restart:
 	/* get vacant slot */
 	t = idr_get_empty_slot(&ida->idr, idr_id, pa);
-	if (t < 0) {
-		if (t == -1)
-			return -EAGAIN;
-		else /* will be -3 */
-			return -ENOSPC;
-	}
+	if (t < 0)
+		return _idr_rc_to_errno(t);
 
 	if (t * IDA_BITMAP_BITS >= MAX_ID_BIT)
 		return -ENOSPC;

--

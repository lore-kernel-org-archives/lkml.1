Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbXKZJER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbXKZJER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 04:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbXKZJCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 04:02:54 -0500
Received: from nz-out-0506.google.com ([64.233.162.236]:15045 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbXKZJCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 04:02:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=WmL2TRWOEgj6yIU3GRIMaqbTXmTu6khm3XroEJTGVluoKF6ZM9Pz+ihCckfFaq4ZawEU61sKNNfgsIZR7RVIENn2JSq8R047BvMvtHtXGpzrdfr9jY/NlRggKOYq8R6n5ZLFW0hK9i4ryorCoQWamg84ms0algUfGJRgCmICfqM=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] fib_hash: kmalloc + memset conversion to kzalloc
Date: Mon, 26 Nov 2007 18:02:40 +0900
Message-ID: <007e01c8300b$1a1f46d0$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: AcgwCxjH1kDh1DcdQK6VJKoxMayoEw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fib_hash: kmalloc + memset conversion to kzalloc

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>

Thanks.
Joonwoo

---
diff --git a/net/ipv4/fib_hash.c b/net/ipv4/fib_hash.c
index 527a6e0..2874fe7 100644
--- a/net/ipv4/fib_hash.c
+++ b/net/ipv4/fib_hash.c
@@ -102,10 +102,14 @@ static struct hlist_head *fz_hash_alloc(int divisor)
 	unsigned long size = divisor * sizeof(struct hlist_head);
 
 	if (size <= PAGE_SIZE) {
-		return kmalloc(size, GFP_KERNEL);
+		return kzalloc(size, GFP_KERNEL);
 	} else {
-		return (struct hlist_head *)
+		struct hlist_head *hash;
+		hash = (struct hlist_head *)
 			__get_free_pages(GFP_KERNEL, get_order(size));
+		if (hash)
+			memset(hash, 0, size);
+		return hash;
 	}
 }
 
@@ -174,8 +178,6 @@ static void fn_rehash_zone(struct fn_zone *fz)
 	ht = fz_hash_alloc(new_divisor);
 
 	if (ht)	{
-		memset(ht, 0, new_divisor * sizeof(struct hlist_head));
-
 		write_lock_bh(&fib_hash_lock);
 		old_ht = fz->fz_hash;
 		fz->fz_hash = ht;
@@ -219,7 +221,6 @@ fn_new_zone(struct fn_hash *table, int z)
 		kfree(fz);
 		return NULL;
 	}
-	memset(fz->fz_hash, 0, fz->fz_divisor * sizeof(struct hlist_head *));
 	fz->fz_order = z;
 	fz->fz_mask = inet_make_mask(z);
 
---


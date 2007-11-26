Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbXKZKYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbXKZKYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 05:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbXKZKYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 05:24:18 -0500
Received: from ro-out-1112.google.com ([72.14.202.180]:56764 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbXKZKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 05:24:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:x-mimeole;
        b=GX+Hpr3QRoj7JtNzIzpKOS2pSy56sDW0pwd0Cyd8GjDo3wA3BhbuZy0j1taV8g5eColVpn7r+Xu5OMbnjkDAl2Kh9ms3Je5Ck6bEShDlxIePZBeV+egWqwJ5SsNeOsosgTV802+acuI0BBom5vv4mh9AcFoFBfPuZ0A3RtZqcc4=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] fib_hash: kmalloc + memset conversion to kzalloc
Date: Mon, 26 Nov 2007 19:24:03 +0900
Message-ID: <000401c83016$78a9d930$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcgwFnMo/rUpO5A3Sfaf7uBiVHxKbQ==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fib_hash: kmalloc + memset conversion to kzalloc
fix to avoid memset entirely.

Thanks.
Joonwoo

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>

---
diff --git a/net/ipv4/fib_hash.c b/net/ipv4/fib_hash.c
index 527a6e0..9d0cee2 100644
--- a/net/ipv4/fib_hash.c
+++ b/net/ipv4/fib_hash.c
@@ -102,10 +102,10 @@ static struct hlist_head *fz_hash_alloc(int divisor)
 	unsigned long size = divisor * sizeof(struct hlist_head);
 
 	if (size <= PAGE_SIZE) {
-		return kmalloc(size, GFP_KERNEL);
+		return kzalloc(size, GFP_KERNEL);
 	} else {
 		return (struct hlist_head *)
-			__get_free_pages(GFP_KERNEL, get_order(size));
+			__get_free_pages(GFP_KERNEL | __GFP_ZERO, get_order(size));
 	}
 }
 
@@ -174,8 +174,6 @@ static void fn_rehash_zone(struct fn_zone *fz)
 	ht = fz_hash_alloc(new_divisor);
 
 	if (ht)	{
-		memset(ht, 0, new_divisor * sizeof(struct hlist_head));
-
 		write_lock_bh(&fib_hash_lock);
 		old_ht = fz->fz_hash;
 		fz->fz_hash = ht;
@@ -219,7 +217,6 @@ fn_new_zone(struct fn_hash *table, int z)
 		kfree(fz);
 		return NULL;
 	}
-	memset(fz->fz_hash, 0, fz->fz_divisor * sizeof(struct hlist_head *));
 	fz->fz_order = z;
 	fz->fz_mask = inet_make_mask(z);
 
---


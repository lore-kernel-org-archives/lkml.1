Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbXKZJDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbXKZJDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 04:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbXKZJCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 04:02:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:60035 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbXKZJCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 04:02:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=BfKOgMSVPmuD7dRXiZAe6UukLK9MR4pDJd2ici8uYewe+1ij/JkPvdst5LhserobYnczc6ktbjH3i7qtMXdSHV7jW7dpr7seE94kqRW7oFOPuVnuHYwU5qQerXeQT4gvnkkP77MzTEi63O5eHdfw3VcoZDbRv61wllROdMYObsE=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] fib_semantics: kmalloc + memset conversion to kzalloc
Date: Mon, 26 Nov 2007 18:02:39 +0900
Message-ID: <007d01c8300b$18be5740$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: AcgwCxeNH4+uce1PTreoH+Nv+PT/4w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fib_semantics: kmalloc + memset conversion to kzalloc

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>

Thanks.
Joonwoo

---
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 1351a26..87a1e72 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -605,10 +605,15 @@ static inline unsigned int fib_laddr_hashfn(__be32 val)
 static struct hlist_head *fib_hash_alloc(int bytes)
 {
 	if (bytes <= PAGE_SIZE)
-		return kmalloc(bytes, GFP_KERNEL);
-	else
-		return (struct hlist_head *)
+		return kzalloc(bytes, GFP_KERNEL);
+	else {
+		struct hlist_head *hash;
+		hash = (struct hlist_head *)
 			__get_free_pages(GFP_KERNEL, get_order(bytes));
+		if (hash)
+			memset(hash, 0, bytes);
+		return hash;
+	}
 }
 
 static void fib_hash_free(struct hlist_head *hash, int bytes)
@@ -712,12 +717,8 @@ struct fib_info *fib_create_info(struct fib_config *cfg)
 		if (!new_info_hash || !new_laddrhash) {
 			fib_hash_free(new_info_hash, bytes);
 			fib_hash_free(new_laddrhash, bytes);
-		} else {
-			memset(new_info_hash, 0, bytes);
-			memset(new_laddrhash, 0, bytes);
-
+		} else
 			fib_hash_move(new_info_hash, new_laddrhash, new_size);
-		}
 
 		if (!fib_hash_size)
 			goto failure;
---


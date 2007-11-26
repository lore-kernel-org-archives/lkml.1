Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbXKZKZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbXKZKZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 05:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbXKZKYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 05:24:22 -0500
Received: from ro-out-1112.google.com ([72.14.202.183]:54593 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbXKZKYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 05:24:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:x-mimeole;
        b=Uq1ULdLkW21wmuRFHa5DVyH2S6i9TgBD1ZgNeIyvfLTZJR58Ggvjrc6XBj587sdJZU1nY9jV22h746vsBAaQJyVl1q9JA+ZgUBpuGISzOtQELVnJKXt7dQOlYNfZJ5TfWYTUnT7hb/ucNZM8QWztpkYRepS+rboUtWUXUbMRqps=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] fib_semantics: kmalloc + memset conversion to kzalloc
Date: Mon, 26 Nov 2007 19:24:03 +0900
Message-ID: <000501c83016$7a3cd540$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcgwFnHTADbD5CZ0SOq9Sg5vXXdhHA==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fib_semantics: kmalloc + memset conversion to kzalloc
fix to avoid memset entirely.

Thanks.
Joonwoo

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>

---
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 1351a26..352f8c4 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -605,10 +605,10 @@ static inline unsigned int fib_laddr_hashfn(__be32 val)
 static struct hlist_head *fib_hash_alloc(int bytes)
 {
 	if (bytes <= PAGE_SIZE)
-		return kmalloc(bytes, GFP_KERNEL);
+		return kzalloc(bytes, GFP_KERNEL);
 	else
 		return (struct hlist_head *)
-			__get_free_pages(GFP_KERNEL, get_order(bytes));
+			__get_free_pages(GFP_KERNEL | __GFP_ZERO, get_order(bytes));
 }
 
 static void fib_hash_free(struct hlist_head *hash, int bytes)
@@ -712,12 +712,8 @@ struct fib_info *fib_create_info(struct fib_config *cfg)
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


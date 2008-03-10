Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbYCJPIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbYCJPIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYCJPIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:08:15 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:1730 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYCJPIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=qdeiAcyjID9RwyKE/sapytWrnkAZlwMtocAqv7Xleds/wulmGcNIKDPSlqVCBUwLaFvKmraoAhXZiM6rzPGsDwaUEgqPQkogmVAWcTucA/UJh8LRu5AYYbF2CW0RsKA8EVxKz11FVxdCXyl3riJnAOj5ZfcUt7P+4dS4O5dupio=
Date: Tue, 11 Mar 2008 00:00:27 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 2/5] idr: use call_once()
Message-ID: <20080310150026.GA6407@APFDCB5C>
References: <20080310145704.GA6396@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20080310145704.GA6396@APFDCB5C>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_layer_cache is created when idr_init() is called first time by someone.

This patch makes the idr_layer_cache initialization to use call_once().

This conversion prevents an unlikely race condition when two idr_init()
callers attempt to create idr_layer_cache simultaneously.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 lib/idr.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: 2.6-rc/lib/idr.c
===================================================================
--- 2.6-rc.orig/lib/idr.c
+++ 2.6-rc/lib/idr.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/once.h>
 #endif
 #include <linux/err.h>
 #include <linux/string.h>
@@ -585,12 +586,12 @@ static void idr_cache_ctor(struct kmem_c
 	memset(idr_layer, 0, sizeof(struct idr_layer));
 }
 
-static  int init_id_cache(void)
+static int init_id_cache(void)
 {
-	if (!idr_layer_cache)
-		idr_layer_cache = kmem_cache_create("idr_layer_cache",
+	idr_layer_cache = kmem_cache_create("idr_layer_cache",
 			sizeof(struct idr_layer), 0, 0, idr_cache_ctor);
-	return 0;
+
+	return !idr_layer_cache ? -ENOMEM : 0;
 }
 
 /**
@@ -602,7 +603,9 @@ static  int init_id_cache(void)
  */
 void idr_init(struct idr *idp)
 {
-	init_id_cache();
+	static DEFINE_ONCE(once);
+
+	call_once(&once, init_id_cache);
 	memset(idp, 0, sizeof(struct idr));
 	spin_lock_init(&idp->lock);
 }

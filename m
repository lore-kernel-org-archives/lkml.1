Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYKTJwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYKTJwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYKTJwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:52:04 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:39225 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788AbYKTJwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:52:01 -0500
Subject: Re: Possible memory leak via slub kmem_cache_create
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <Pine.LNX.4.64.0811191319360.23084@quilx.com>
References: <1227111954.27162.28.camel@pc1117.cambridge.arm.com>
	 <Pine.LNX.4.64.0811191319360.23084@quilx.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 20 Nov 2008 09:51:50 +0000
Message-Id: <1227174711.5784.9.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2008 09:51:51.0920 (UTC) FILETIME=[9D0EB700:01C94AF5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-19 at 13:22 -0600, Christoph Lameter wrote:
> proto_register could add another field somewhere and store the pointer to
> the name there? Then free the string on proto_unregister.

The patch below fixes this issue for proto_register. There is another
similar case in net/dccp/ccid.c. I cc'ed the person who added the
original proto_register code and he also seems to be the DCCP
maintainer.

My point is that the API is slightly different when slub is used since
kmem_cache_name is no longer guaranteed to return the same pointer
passed to kmem_cache_create. Maybe a documentation update:

diff --git a/mm/slab.c b/mm/slab.c
index ea76bcb..9723a72 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2124,6 +2124,8 @@ static int __init_refok setup_cpu_cache(struct kmem_cache 
  *
  * @name must be valid until the cache is destroyed. This implies that
  * the module calling this has to destroy the cache before getting unloaded.
+ * Note that kmem_cache_name() is not guaranteed to return the same pointer,
+ * therefore applications must manage it themselves.
  *
  * The flags are
  *

And the proto_register fix below (if it looks alright, I'll submit it
separately):


Fix memory leak in the proto_register function

From: Catalin Marinas <catalin.marinas@arm.com>

If the slub allocator is used, kmem_cache_create() may merge two or more
kmem_cache's into one but the cache name pointer is not updated and
kmem_cache_name() is no longer guaranteed to return the pointer passed
to the former function. This patch stores the kmalloc'ed pointers in the
corresponding request_sock_ops and timewait_sock_ops structures.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 include/net/request_sock.h  |    1 +
 include/net/timewait_sock.h |    1 +
 net/core/sock.c             |   31 ++++++++++++-------------------
 3 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index cac811e..c719084 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -31,6 +31,7 @@ struct request_sock_ops {
 	int		family;
 	int		obj_size;
 	struct kmem_cache	*slab;
+	char		*slab_name;
 	int		(*rtx_syn_ack)(struct sock *sk,
 				       struct request_sock *req);
 	void		(*send_ack)(struct sock *sk, struct sk_buff *skb,
diff --git a/include/net/timewait_sock.h b/include/net/timewait_sock.h
index 1e1ee32..97c3b14 100644
--- a/include/net/timewait_sock.h
+++ b/include/net/timewait_sock.h
@@ -16,6 +16,7 @@
 
 struct timewait_sock_ops {
 	struct kmem_cache	*twsk_slab;
+	char		*twsk_slab_name;
 	unsigned int	twsk_obj_size;
 	int		(*twsk_unique)(struct sock *sk,
 				       struct sock *sktw, void *twp);
diff --git a/net/core/sock.c b/net/core/sock.c
index 5e2a313..b7300af 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2037,9 +2037,6 @@ static inline void release_proto_idx(struct proto *prot)
 
 int proto_register(struct proto *prot, int alloc_slab)
 {
-	char *request_sock_slab_name = NULL;
-	char *timewait_sock_slab_name;
-
 	if (alloc_slab) {
 		prot->slab = kmem_cache_create(prot->name, prot->obj_size, 0,
 					       SLAB_HWCACHE_ALIGN, NULL);
@@ -2053,12 +2050,12 @@ int proto_register(struct proto *prot, int alloc_slab)
 		if (prot->rsk_prot != NULL) {
 			static const char mask[] = "request_sock_%s";
 
-			request_sock_slab_name = kmalloc(strlen(prot->name) + sizeof(mask) - 1, GFP_KERNEL);
-			if (request_sock_slab_name == NULL)
+			prot->rsk_prot->slab_name = kmalloc(strlen(prot->name) + sizeof(mask) - 1, GFP_KERNEL);
+			if (prot->rsk_prot->slab_name == NULL)
 				goto out_free_sock_slab;
 
-			sprintf(request_sock_slab_name, mask, prot->name);
-			prot->rsk_prot->slab = kmem_cache_create(request_sock_slab_name,
+			sprintf(prot->rsk_prot->slab_name, mask, prot->name);
+			prot->rsk_prot->slab = kmem_cache_create(prot->rsk_prot->slab_name,
 								 prot->rsk_prot->obj_size, 0,
 								 SLAB_HWCACHE_ALIGN, NULL);
 
@@ -2072,14 +2069,14 @@ int proto_register(struct proto *prot, int alloc_slab)
 		if (prot->twsk_prot != NULL) {
 			static const char mask[] = "tw_sock_%s";
 
-			timewait_sock_slab_name = kmalloc(strlen(prot->name) + sizeof(mask) - 1, GFP_KERNEL);
+			prot->twsk_prot->twsk_slab_name = kmalloc(strlen(prot->name) + sizeof(mask) - 1, GFP_KERNEL);
 
-			if (timewait_sock_slab_name == NULL)
+			if (prot->twsk_prot->twsk_slab_name == NULL)
 				goto out_free_request_sock_slab;
 
-			sprintf(timewait_sock_slab_name, mask, prot->name);
+			sprintf(prot->twsk_prot->twsk_slab_name, mask, prot->name);
 			prot->twsk_prot->twsk_slab =
-				kmem_cache_create(timewait_sock_slab_name,
+				kmem_cache_create(prot->twsk_prot->twsk_slab_name,
 						  prot->twsk_prot->twsk_obj_size,
 						  0, SLAB_HWCACHE_ALIGN,
 						  NULL);
@@ -2095,14 +2092,14 @@ int proto_register(struct proto *prot, int alloc_slab)
 	return 0;
 
 out_free_timewait_sock_slab_name:
-	kfree(timewait_sock_slab_name);
+	kfree(prot->twsk_prot->twsk_slab_name);
 out_free_request_sock_slab:
 	if (prot->rsk_prot && prot->rsk_prot->slab) {
 		kmem_cache_destroy(prot->rsk_prot->slab);
 		prot->rsk_prot->slab = NULL;
 	}
 out_free_request_sock_slab_name:
-	kfree(request_sock_slab_name);
+	kfree(prot->rsk_prot->slab_name);
 out_free_sock_slab:
 	kmem_cache_destroy(prot->slab);
 	prot->slab = NULL;
@@ -2125,18 +2122,14 @@ void proto_unregister(struct proto *prot)
 	}
 
 	if (prot->rsk_prot != NULL && prot->rsk_prot->slab != NULL) {
-		const char *name = kmem_cache_name(prot->rsk_prot->slab);
-
 		kmem_cache_destroy(prot->rsk_prot->slab);
-		kfree(name);
+		kfree(prot->rsk_prot->slab_name);
 		prot->rsk_prot->slab = NULL;
 	}
 
 	if (prot->twsk_prot != NULL && prot->twsk_prot->twsk_slab != NULL) {
-		const char *name = kmem_cache_name(prot->twsk_prot->twsk_slab);
-
 		kmem_cache_destroy(prot->twsk_prot->twsk_slab);
-		kfree(name);
+		kfree(prot->twsk_prot->twsk_slab_name);
 		prot->twsk_prot->twsk_slab = NULL;
 	}
 }


-- 
Catalin


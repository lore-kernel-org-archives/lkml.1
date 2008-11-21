Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbYKUM4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbYKUM4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 07:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbYKUM4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 07:56:43 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:55003 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348AbYKUM4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 07:56:42 -0500
Subject: [PATCH] Fix memory leak in the proto_register function
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Fri, 21 Nov 2008 12:56:28 +0000
Message-ID: <20081121125628.11468.72009.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.286.g8983
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Nov 2008 12:56:28.0784 (UTC) FILETIME=[91CBC700:01C94BD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the slub allocator is used, kmem_cache_create() may merge two or more
kmem_cache's into one but the cache name pointer is not updated and
kmem_cache_name() is no longer guaranteed to return the pointer passed
to the former function. This patch stores the kmalloc'ed pointers in the
corresponding request_sock_ops and timewait_sock_ops structures.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
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
index 341e394..edf7220 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2035,9 +2035,6 @@ static inline void release_proto_idx(struct proto *prot)
 
 int proto_register(struct proto *prot, int alloc_slab)
 {
-	char *request_sock_slab_name = NULL;
-	char *timewait_sock_slab_name;
-
 	if (alloc_slab) {
 		prot->slab = kmem_cache_create(prot->name, prot->obj_size, 0,
 					       SLAB_HWCACHE_ALIGN, NULL);
@@ -2051,12 +2048,12 @@ int proto_register(struct proto *prot, int alloc_slab)
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
 
@@ -2070,14 +2067,14 @@ int proto_register(struct proto *prot, int alloc_slab)
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
@@ -2093,14 +2090,14 @@ int proto_register(struct proto *prot, int alloc_slab)
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
@@ -2123,18 +2120,14 @@ void proto_unregister(struct proto *prot)
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


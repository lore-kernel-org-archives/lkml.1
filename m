Return-Path: <linux-kernel-owner+w=401wt.eu-S1758471AbXKTBUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbXKTBUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756590AbXKTBN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:57 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36876 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754687AbXKTBNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:37 -0500
Message-Id: <20071120011336.922518291@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:54 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 22/45] cpu alloc: convert scatches
Content-Disposition: inline; filename=0030-cpu-alloc-convert-scatches.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 net/ipv4/ipcomp.c  |   26 +++++++++++++-------------
 net/ipv6/ipcomp6.c |   26 +++++++++++++-------------
 2 files changed, 26 insertions(+), 26 deletions(-)

Index: linux-2.6/net/ipv4/ipcomp.c
===================================================================
--- linux-2.6.orig/net/ipv4/ipcomp.c	2007-11-15 21:17:24.199404507 -0800
+++ linux-2.6/net/ipv4/ipcomp.c	2007-11-15 21:25:34.771154012 -0800
@@ -48,8 +48,8 @@ static int ipcomp_decompress(struct xfrm
 	int dlen = IPCOMP_SCRATCH_SIZE;
 	const u8 *start = skb->data;
 	const int cpu = get_cpu();
-	u8 *scratch = *per_cpu_ptr(ipcomp_scratches, cpu);
-	struct crypto_comp *tfm = *per_cpu_ptr(ipcd->tfms, cpu);
+	u8 *scratch = *CPU_PTR(ipcomp_scratches, cpu);
+	struct crypto_comp *tfm = *CPU_PTR(ipcd->tfms, cpu);
 	int err = crypto_comp_decompress(tfm, start, plen, scratch, &dlen);
 
 	if (err)
@@ -103,8 +103,8 @@ static int ipcomp_compress(struct xfrm_s
 	int dlen = IPCOMP_SCRATCH_SIZE;
 	u8 *start = skb->data;
 	const int cpu = get_cpu();
-	u8 *scratch = *per_cpu_ptr(ipcomp_scratches, cpu);
-	struct crypto_comp *tfm = *per_cpu_ptr(ipcd->tfms, cpu);
+	u8 *scratch = *CPU_PTR(ipcomp_scratches, cpu);
+	struct crypto_comp *tfm = *CPU_PTR(ipcd->tfms, cpu);
 	int err = crypto_comp_compress(tfm, start, plen, scratch, &dlen);
 
 	if (err)
@@ -252,9 +252,9 @@ static void ipcomp_free_scratches(void)
 		return;
 
 	for_each_possible_cpu(i)
-		vfree(*per_cpu_ptr(scratches, i));
+		vfree(*CPU_PTR(scratches, i));
 
-	free_percpu(scratches);
+	CPU_FREE(scratches);
 }
 
 static void **ipcomp_alloc_scratches(void)
@@ -265,7 +265,7 @@ static void **ipcomp_alloc_scratches(voi
 	if (ipcomp_scratch_users++)
 		return ipcomp_scratches;
 
-	scratches = alloc_percpu(void *);
+	scratches = CPU_ALLOC(void *, GFP_KERNEL);
 	if (!scratches)
 		return NULL;
 
@@ -275,7 +275,7 @@ static void **ipcomp_alloc_scratches(voi
 		void *scratch = vmalloc(IPCOMP_SCRATCH_SIZE);
 		if (!scratch)
 			return NULL;
-		*per_cpu_ptr(scratches, i) = scratch;
+		*CPU_PTR(scratches, i) = scratch;
 	}
 
 	return scratches;
@@ -303,10 +303,10 @@ static void ipcomp_free_tfms(struct cryp
 		return;
 
 	for_each_possible_cpu(cpu) {
-		struct crypto_comp *tfm = *per_cpu_ptr(tfms, cpu);
+		struct crypto_comp *tfm = *CPU_PTR(tfms, cpu);
 		crypto_free_comp(tfm);
 	}
-	free_percpu(tfms);
+	CPU_FREE(tfms);
 }
 
 static struct crypto_comp **ipcomp_alloc_tfms(const char *alg_name)
@@ -322,7 +322,7 @@ static struct crypto_comp **ipcomp_alloc
 		struct crypto_comp *tfm;
 
 		tfms = pos->tfms;
-		tfm = *per_cpu_ptr(tfms, cpu);
+		tfm = *CPU_PTR(tfms, cpu);
 
 		if (!strcmp(crypto_comp_name(tfm), alg_name)) {
 			pos->users++;
@@ -338,7 +338,7 @@ static struct crypto_comp **ipcomp_alloc
 	INIT_LIST_HEAD(&pos->list);
 	list_add(&pos->list, &ipcomp_tfms_list);
 
-	pos->tfms = tfms = alloc_percpu(struct crypto_comp *);
+	pos->tfms = tfms = CPU_ALLOC(struct crypto_comp *, GFP_KERNEL);
 	if (!tfms)
 		goto error;
 
@@ -347,7 +347,7 @@ static struct crypto_comp **ipcomp_alloc
 							    CRYPTO_ALG_ASYNC);
 		if (IS_ERR(tfm))
 			goto error;
-		*per_cpu_ptr(tfms, cpu) = tfm;
+		*CPU_PTR(tfms, cpu) = tfm;
 	}
 
 	return tfms;
Index: linux-2.6/net/ipv6/ipcomp6.c
===================================================================
--- linux-2.6.orig/net/ipv6/ipcomp6.c	2007-11-15 21:17:24.207404544 -0800
+++ linux-2.6/net/ipv6/ipcomp6.c	2007-11-15 21:25:34.774656957 -0800
@@ -88,8 +88,8 @@ static int ipcomp6_input(struct xfrm_sta
 	start = skb->data;
 
 	cpu = get_cpu();
-	scratch = *per_cpu_ptr(ipcomp6_scratches, cpu);
-	tfm = *per_cpu_ptr(ipcd->tfms, cpu);
+	scratch = *CPU_PTR(ipcomp6_scratches, cpu);
+	tfm = *CPU_PTR(ipcd->tfms, cpu);
 
 	err = crypto_comp_decompress(tfm, start, plen, scratch, &dlen);
 	if (err)
@@ -140,8 +140,8 @@ static int ipcomp6_output(struct xfrm_st
 	start = skb->data;
 
 	cpu = get_cpu();
-	scratch = *per_cpu_ptr(ipcomp6_scratches, cpu);
-	tfm = *per_cpu_ptr(ipcd->tfms, cpu);
+	scratch = *CPU_PTR(ipcomp6_scratches, cpu);
+	tfm = *CPU_PTR(ipcd->tfms, cpu);
 
 	err = crypto_comp_compress(tfm, start, plen, scratch, &dlen);
 	if (err || (dlen + sizeof(*ipch)) >= plen) {
@@ -263,12 +263,12 @@ static void ipcomp6_free_scratches(void)
 		return;
 
 	for_each_possible_cpu(i) {
-		void *scratch = *per_cpu_ptr(scratches, i);
+		void *scratch = *CPU_PTR(scratches, i);
 
 		vfree(scratch);
 	}
 
-	free_percpu(scratches);
+	CPU_FREE(scratches);
 }
 
 static void **ipcomp6_alloc_scratches(void)
@@ -279,7 +279,7 @@ static void **ipcomp6_alloc_scratches(vo
 	if (ipcomp6_scratch_users++)
 		return ipcomp6_scratches;
 
-	scratches = alloc_percpu(void *);
+	scratches = CPU_ALLOC(void *, GFP_KERNEL);
 	if (!scratches)
 		return NULL;
 
@@ -289,7 +289,7 @@ static void **ipcomp6_alloc_scratches(vo
 		void *scratch = vmalloc(IPCOMP_SCRATCH_SIZE);
 		if (!scratch)
 			return NULL;
-		*per_cpu_ptr(scratches, i) = scratch;
+		*CPU_PTR(scratches, i) = scratch;
 	}
 
 	return scratches;
@@ -317,10 +317,10 @@ static void ipcomp6_free_tfms(struct cry
 		return;
 
 	for_each_possible_cpu(cpu) {
-		struct crypto_comp *tfm = *per_cpu_ptr(tfms, cpu);
+		struct crypto_comp *tfm = *CPU_PTR(tfms, cpu);
 		crypto_free_comp(tfm);
 	}
-	free_percpu(tfms);
+	CPU_FREE(tfms);
 }
 
 static struct crypto_comp **ipcomp6_alloc_tfms(const char *alg_name)
@@ -336,7 +336,7 @@ static struct crypto_comp **ipcomp6_allo
 		struct crypto_comp *tfm;
 
 		tfms = pos->tfms;
-		tfm = *per_cpu_ptr(tfms, cpu);
+		tfm = *CPU_PTR(tfms, cpu);
 
 		if (!strcmp(crypto_comp_name(tfm), alg_name)) {
 			pos->users++;
@@ -352,7 +352,7 @@ static struct crypto_comp **ipcomp6_allo
 	INIT_LIST_HEAD(&pos->list);
 	list_add(&pos->list, &ipcomp6_tfms_list);
 
-	pos->tfms = tfms = alloc_percpu(struct crypto_comp *);
+	pos->tfms = tfms = CPU_ALLOC(struct crypto_comp *, GFP_KERNEL);
 	if (!tfms)
 		goto error;
 
@@ -361,7 +361,7 @@ static struct crypto_comp **ipcomp6_allo
 							    CRYPTO_ALG_ASYNC);
 		if (IS_ERR(tfm))
 			goto error;
-		*per_cpu_ptr(tfms, cpu) = tfm;
+		*CPU_PTR(tfms, cpu) = tfm;
 	}
 
 	return tfms;

-- 

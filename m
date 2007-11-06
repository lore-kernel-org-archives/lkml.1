Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbXKFT4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbXKFT4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757295AbXKFTwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:24 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52146 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754121AbXKFTwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:03 -0500
Message-Id: <20071106195201.999428198@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:52:03 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 19/28] cpu alloc: convert scatches
Content-Disposition: inline; filename=cpu_alloc_ipv4_icomp
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 net/ipv4/ipcomp.c  |   26 +++++++++++++-------------
 net/ipv6/ipcomp6.c |   26 +++++++++++++-------------
 2 files changed, 26 insertions(+), 26 deletions(-)

Index: linux-2.6/net/ipv4/ipcomp.c
===================================================================
--- linux-2.6.orig/net/ipv4/ipcomp.c	2007-11-05 09:41:23.000000000 -0800
+++ linux-2.6/net/ipv4/ipcomp.c	2007-11-05 09:41:37.000000000 -0800
@@ -47,8 +47,8 @@ static int ipcomp_decompress(struct xfrm
 	int dlen = IPCOMP_SCRATCH_SIZE;
 	const u8 *start = skb->data;
 	const int cpu = get_cpu();
-	u8 *scratch = *per_cpu_ptr(ipcomp_scratches, cpu);
-	struct crypto_comp *tfm = *per_cpu_ptr(ipcd->tfms, cpu);
+	u8 *scratch = *CPU_PTR(ipcomp_scratches, cpu);
+	struct crypto_comp *tfm = *CPU_PTR(ipcd->tfms, cpu);
 	int err = crypto_comp_decompress(tfm, start, plen, scratch, &dlen);
 
 	if (err)
@@ -102,8 +102,8 @@ static int ipcomp_compress(struct xfrm_s
 	int dlen = IPCOMP_SCRATCH_SIZE;
 	u8 *start = skb->data;
 	const int cpu = get_cpu();
-	u8 *scratch = *per_cpu_ptr(ipcomp_scratches, cpu);
-	struct crypto_comp *tfm = *per_cpu_ptr(ipcd->tfms, cpu);
+	u8 *scratch = *CPU_PTR(ipcomp_scratches, cpu);
+	struct crypto_comp *tfm = *CPU_PTR(ipcd->tfms, cpu);
 	int err = crypto_comp_compress(tfm, start, plen, scratch, &dlen);
 
 	if (err)
@@ -251,9 +251,9 @@ static void ipcomp_free_scratches(void)
 		return;
 
 	for_each_possible_cpu(i)
-		vfree(*per_cpu_ptr(scratches, i));
+		vfree(*CPU_PTR(scratches, i));
 
-	free_percpu(scratches);
+	CPU_FREE(scratches);
 }
 
 static void **ipcomp_alloc_scratches(void)
@@ -264,7 +264,7 @@ static void **ipcomp_alloc_scratches(voi
 	if (ipcomp_scratch_users++)
 		return ipcomp_scratches;
 
-	scratches = alloc_percpu(void *);
+	scratches = CPU_ALLOC(void *, GFP_KERNEL);
 	if (!scratches)
 		return NULL;
 
@@ -274,7 +274,7 @@ static void **ipcomp_alloc_scratches(voi
 		void *scratch = vmalloc(IPCOMP_SCRATCH_SIZE);
 		if (!scratch)
 			return NULL;
-		*per_cpu_ptr(scratches, i) = scratch;
+		*CPU_PTR(scratches, i) = scratch;
 	}
 
 	return scratches;
@@ -302,10 +302,10 @@ static void ipcomp_free_tfms(struct cryp
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
@@ -321,7 +321,7 @@ static struct crypto_comp **ipcomp_alloc
 		struct crypto_comp *tfm;
 
 		tfms = pos->tfms;
-		tfm = *per_cpu_ptr(tfms, cpu);
+		tfm = *CPU_PTR(tfms, cpu);
 
 		if (!strcmp(crypto_comp_name(tfm), alg_name)) {
 			pos->users++;
@@ -337,7 +337,7 @@ static struct crypto_comp **ipcomp_alloc
 	INIT_LIST_HEAD(&pos->list);
 	list_add(&pos->list, &ipcomp_tfms_list);
 
-	pos->tfms = tfms = alloc_percpu(struct crypto_comp *);
+	pos->tfms = tfms = CPU_ALLOC(struct crypto_comp *, GFP_KERNEL);
 	if (!tfms)
 		goto error;
 
@@ -346,7 +346,7 @@ static struct crypto_comp **ipcomp_alloc
 							    CRYPTO_ALG_ASYNC);
 		if (!tfm)
 			goto error;
-		*per_cpu_ptr(tfms, cpu) = tfm;
+		*CPU_PTR(tfms, cpu) = tfm;
 	}
 
 	return tfms;
Index: linux-2.6/net/ipv6/ipcomp6.c
===================================================================
--- linux-2.6.orig/net/ipv6/ipcomp6.c	2007-11-05 09:41:23.000000000 -0800
+++ linux-2.6/net/ipv6/ipcomp6.c	2007-11-05 09:43:13.000000000 -0800
@@ -87,8 +87,8 @@ static int ipcomp6_input(struct xfrm_sta
 	start = skb->data;
 
 	cpu = get_cpu();
-	scratch = *per_cpu_ptr(ipcomp6_scratches, cpu);
-	tfm = *per_cpu_ptr(ipcd->tfms, cpu);
+	scratch = *CPU_PTR(ipcomp6_scratches, cpu);
+	tfm = *CPU_PTR(ipcd->tfms, cpu);
 
 	err = crypto_comp_decompress(tfm, start, plen, scratch, &dlen);
 	if (err)
@@ -139,8 +139,8 @@ static int ipcomp6_output(struct xfrm_st
 	start = skb->data;
 
 	cpu = get_cpu();
-	scratch = *per_cpu_ptr(ipcomp6_scratches, cpu);
-	tfm = *per_cpu_ptr(ipcd->tfms, cpu);
+	scratch = *CPU_PTR(ipcomp6_scratches, cpu);
+	tfm = *CPU_PTR(ipcd->tfms, cpu);
 
 	err = crypto_comp_compress(tfm, start, plen, scratch, &dlen);
 	if (err || (dlen + sizeof(*ipch)) >= plen) {
@@ -262,12 +262,12 @@ static void ipcomp6_free_scratches(void)
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
@@ -278,7 +278,7 @@ static void **ipcomp6_alloc_scratches(vo
 	if (ipcomp6_scratch_users++)
 		return ipcomp6_scratches;
 
-	scratches = alloc_percpu(void *);
+	scratches = CPU_ALLOC(void *, GFP_KERNEL);
 	if (!scratches)
 		return NULL;
 
@@ -288,7 +288,7 @@ static void **ipcomp6_alloc_scratches(vo
 		void *scratch = vmalloc(IPCOMP_SCRATCH_SIZE);
 		if (!scratch)
 			return NULL;
-		*per_cpu_ptr(scratches, i) = scratch;
+		*CPU_PTR(scratches, i) = scratch;
 	}
 
 	return scratches;
@@ -316,10 +316,10 @@ static void ipcomp6_free_tfms(struct cry
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
@@ -335,7 +335,7 @@ static struct crypto_comp **ipcomp6_allo
 		struct crypto_comp *tfm;
 
 		tfms = pos->tfms;
-		tfm = *per_cpu_ptr(tfms, cpu);
+		tfm = *CPU_PTR(tfms, cpu);
 
 		if (!strcmp(crypto_comp_name(tfm), alg_name)) {
 			pos->users++;
@@ -351,7 +351,7 @@ static struct crypto_comp **ipcomp6_allo
 	INIT_LIST_HEAD(&pos->list);
 	list_add(&pos->list, &ipcomp6_tfms_list);
 
-	pos->tfms = tfms = alloc_percpu(struct crypto_comp *);
+	pos->tfms = tfms = CPU_ALLOC(struct crypto_comp *, GFP_KERNEL);
 	if (!tfms)
 		goto error;
 
@@ -360,7 +360,7 @@ static struct crypto_comp **ipcomp6_allo
 							    CRYPTO_ALG_ASYNC);
 		if (!tfm)
 			goto error;
-		*per_cpu_ptr(tfms, cpu) = tfm;
+		*CPU_PTR(tfms, cpu) = tfm;
 	}
 
 	return tfms;

-- 

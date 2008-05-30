Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbYE3ENU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbYE3ENU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756480AbYE3EB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:27 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56615 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752751AbYE3EAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:21 -0400
Message-Id: <20080530040017.035773206@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:37 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 17/41] cpu alloc: Convert scratches to cpu alloc
Content-Disposition: inline; filename=cpu_alloc_scratches_convert
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert scratch handling in the network stack to cpu alloc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 net/ipv4/ipcomp.c  |   26 +++++++++++++-------------
 net/ipv6/ipcomp6.c |   26 +++++++++++++-------------
 2 files changed, 26 insertions(+), 26 deletions(-)

Index: linux-2.6/net/ipv4/ipcomp.c
===================================================================
--- linux-2.6.orig/net/ipv4/ipcomp.c	2008-04-29 14:55:55.000000000 -0700
+++ linux-2.6/net/ipv4/ipcomp.c	2008-05-21 21:48:14.000000000 -0700
@@ -47,8 +47,8 @@
 	int dlen = IPCOMP_SCRATCH_SIZE;
 	const u8 *start = skb->data;
 	const int cpu = get_cpu();
-	u8 *scratch = *per_cpu_ptr(ipcomp_scratches, cpu);
-	struct crypto_comp *tfm = *per_cpu_ptr(ipcd->tfms, cpu);
+	u8 *scratch = *CPU_PTR(ipcomp_scratches, cpu);
+	struct crypto_comp *tfm = *CPU_PTR(ipcd->tfms, cpu);
 	int err = crypto_comp_decompress(tfm, start, plen, scratch, &dlen);
 
 	if (err)
@@ -105,8 +105,8 @@
 	int dlen = IPCOMP_SCRATCH_SIZE;
 	u8 *start = skb->data;
 	const int cpu = get_cpu();
-	u8 *scratch = *per_cpu_ptr(ipcomp_scratches, cpu);
-	struct crypto_comp *tfm = *per_cpu_ptr(ipcd->tfms, cpu);
+	u8 *scratch = *CPU_PTR(ipcomp_scratches, cpu);
+	struct crypto_comp *tfm = *CPU_PTR(ipcd->tfms, cpu);
 	int err;
 
 	local_bh_disable();
@@ -254,9 +254,9 @@
 		return;
 
 	for_each_possible_cpu(i)
-		vfree(*per_cpu_ptr(scratches, i));
+		vfree(*CPU_PTR(scratches, i));
 
-	free_percpu(scratches);
+	CPU_FREE(scratches);
 }
 
 static void **ipcomp_alloc_scratches(void)
@@ -267,7 +267,7 @@
 	if (ipcomp_scratch_users++)
 		return ipcomp_scratches;
 
-	scratches = alloc_percpu(void *);
+	scratches = CPU_ALLOC(void *, GFP_KERNEL);
 	if (!scratches)
 		return NULL;
 
@@ -277,7 +277,7 @@
 		void *scratch = vmalloc(IPCOMP_SCRATCH_SIZE);
 		if (!scratch)
 			return NULL;
-		*per_cpu_ptr(scratches, i) = scratch;
+		*CPU_PTR(scratches, i) = scratch;
 	}
 
 	return scratches;
@@ -305,10 +305,10 @@
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
@@ -324,7 +324,7 @@
 		struct crypto_comp *tfm;
 
 		tfms = pos->tfms;
-		tfm = *per_cpu_ptr(tfms, cpu);
+		tfm = *CPU_PTR(tfms, cpu);
 
 		if (!strcmp(crypto_comp_name(tfm), alg_name)) {
 			pos->users++;
@@ -340,7 +340,7 @@
 	INIT_LIST_HEAD(&pos->list);
 	list_add(&pos->list, &ipcomp_tfms_list);
 
-	pos->tfms = tfms = alloc_percpu(struct crypto_comp *);
+	pos->tfms = tfms = CPU_ALLOC(struct crypto_comp *, GFP_KERNEL);
 	if (!tfms)
 		goto error;
 
@@ -349,7 +349,7 @@
 							    CRYPTO_ALG_ASYNC);
 		if (IS_ERR(tfm))
 			goto error;
-		*per_cpu_ptr(tfms, cpu) = tfm;
+		*CPU_PTR(tfms, cpu) = tfm;
 	}
 
 	return tfms;
Index: linux-2.6/net/ipv6/ipcomp6.c
===================================================================
--- linux-2.6.orig/net/ipv6/ipcomp6.c	2008-04-29 14:55:55.000000000 -0700
+++ linux-2.6/net/ipv6/ipcomp6.c	2008-05-21 21:47:09.000000000 -0700
@@ -90,8 +90,8 @@
 	start = skb->data;
 
 	cpu = get_cpu();
-	scratch = *per_cpu_ptr(ipcomp6_scratches, cpu);
-	tfm = *per_cpu_ptr(ipcd->tfms, cpu);
+	scratch = *CPU_PTR(ipcomp6_scratches, cpu);
+	tfm = *CPU_PTR(ipcd->tfms, cpu);
 
 	err = crypto_comp_decompress(tfm, start, plen, scratch, &dlen);
 	if (err)
@@ -142,8 +142,8 @@
 	start = skb->data;
 
 	cpu = get_cpu();
-	scratch = *per_cpu_ptr(ipcomp6_scratches, cpu);
-	tfm = *per_cpu_ptr(ipcd->tfms, cpu);
+	scratch = *CPU_PTR(ipcomp6_scratches, cpu);
+	tfm = *CPU_PTR(ipcd->tfms, cpu);
 
 	local_bh_disable();
 	err = crypto_comp_compress(tfm, start, plen, scratch, &dlen);
@@ -264,12 +264,12 @@
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
@@ -280,7 +280,7 @@
 	if (ipcomp6_scratch_users++)
 		return ipcomp6_scratches;
 
-	scratches = alloc_percpu(void *);
+	scratches = CPU_ALLOC(void *, GFP_KERNEL);
 	if (!scratches)
 		return NULL;
 
@@ -290,7 +290,7 @@
 		void *scratch = vmalloc(IPCOMP_SCRATCH_SIZE);
 		if (!scratch)
 			return NULL;
-		*per_cpu_ptr(scratches, i) = scratch;
+		*CPU_PTR(scratches, i) = scratch;
 	}
 
 	return scratches;
@@ -318,10 +318,10 @@
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
@@ -337,7 +337,7 @@
 		struct crypto_comp *tfm;
 
 		tfms = pos->tfms;
-		tfm = *per_cpu_ptr(tfms, cpu);
+		tfm = *CPU_PTR(tfms, cpu);
 
 		if (!strcmp(crypto_comp_name(tfm), alg_name)) {
 			pos->users++;
@@ -353,7 +353,7 @@
 	INIT_LIST_HEAD(&pos->list);
 	list_add(&pos->list, &ipcomp6_tfms_list);
 
-	pos->tfms = tfms = alloc_percpu(struct crypto_comp *);
+	pos->tfms = tfms = CPU_ALLOC(struct crypto_comp *, GFP_KERNEL);
 	if (!tfms)
 		goto error;
 
@@ -362,7 +362,7 @@
 							    CRYPTO_ALG_ASYNC);
 		if (IS_ERR(tfm))
 			goto error;
-		*per_cpu_ptr(tfms, cpu) = tfm;
+		*CPU_PTR(tfms, cpu) = tfm;
 	}
 
 	return tfms;

-- 

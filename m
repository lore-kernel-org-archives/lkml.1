Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbXFWFP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbXFWFP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 01:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXFWFPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 01:15:51 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:40119 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbXFWFPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 01:15:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:date:message-id;
        b=upw9viRNIIgKZdG5sRLKuyoueuwo4J6exS3Eogat8t2MsKTDYWCWEEqwB7yVFZSDbWvQD4SRgzq5QVJkive3IougVcwk/iB3E5VahOBek0OzkCUr70G4Q3IG1g+r8O0vmKzUgk5+lbjSO8sRaZmD36Zg5u8VvaGeTARFKItq4P4=
Subject: [PATCH] trivial: the memset operation on a automatic array
	variable should be optimized out by data initialization
From: Denis Cheng <crquan@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Fri, 22 Jun 2007 22:15:49 -0700 (PDT)
Message-ID: <467cac85.081b600a.5b88.457f@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>

the explicit memset call could be optimized out by data initialization,
thus all the fill working can be done by the compiler implicitly.

and C standard guaranteed all the unspecified data field initialized to zero.

Signed-off-by: Denis Cheng <crquan@gmail.com>

---
After comments in the former threads:
http://lkml.org/lkml/2007/6/18/119
http://lkml.org/lkml/2007/6/18/48

On 6/18/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> The cost is the same. "= {0}" is transformed into a bunch of movs,
> or a rep mov, (At least for x86), so is equivalent to memset (which
> will get transformed to __builtin_memset anyway). So I wonder
> what this really buys.
> 
> And, you do not even need the zero. Just write
>         ...[MAX_NR_ZONES] = {};

>         Jan
I also think this style of zero initialization would be better.
so the patch is little different:

--- arch/x86_64/mm/init.c.orig	2007-06-07 10:08:04.000000000 +0800
+++ arch/x86_64/mm/init.c	2007-06-23 13:12:26.000000000 +0800
@@ -406,8 +406,8 @@ void __cpuinit zap_low_mappings(int cpu)
 #ifndef CONFIG_NUMA
 void __init paging_init(void)
 {
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+	unsigned long max_zone_pfns[MAX_NR_ZONES] = {};
+
 	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 	max_zone_pfns[ZONE_NORMAL] = end_pfn;

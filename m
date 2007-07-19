Return-Path: <linux-kernel-owner+w=401wt.eu-S1761037AbXGSWy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761037AbXGSWy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 18:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbXGSWys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 18:54:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbXGSWys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 18:54:48 -0400
Subject: [PATCH] Use wbinvd() macro instead of raw inline assembly in .c
	files
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: ak@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat
Date: Thu, 19 Jul 2007 19:55:40 -0300
Message-Id: <1184885740.16311.19.camel@t60>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the already-existant wbinvd() macro to replace
raw assembly to perform this very same task in some .c files
    
Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

diff --git a/arch/x86_64/kernel/tce.c b/arch/x86_64/kernel/tce.c
index f61fb8e..afbb951 100644
--- a/arch/x86_64/kernel/tce.c
+++ b/arch/x86_64/kernel/tce.c
@@ -42,7 +42,7 @@ static inline void flush_tce(void* tceaddr)
 	if (cpu_has_clflush)
 		asm volatile("clflush (%0)" :: "r" (tceaddr));
 	else
-		asm volatile("wbinvd":::"memory");
+		wbinvd();
 }
 
 void tce_build(struct iommu_table *tbl, unsigned long index,
diff --git a/arch/x86_64/mm/pageattr.c b/arch/x86_64/mm/pageattr.c
index 9148f4a..0a75790 100644
--- a/arch/x86_64/mm/pageattr.c
+++ b/arch/x86_64/mm/pageattr.c
@@ -77,7 +77,7 @@ static void flush_kernel_map(void *arg)
 	   much cheaper than WBINVD. Disable clflush for now because
 	   the high level code is not ready yet */
 	if (1 || !cpu_has_clflush)
-		asm volatile("wbinvd" ::: "memory");
+		wbinvd();
 	else list_for_each_entry(pg, l, lru) {
 		void *adr = page_address(pg);
 		if (cpu_has_clflush)



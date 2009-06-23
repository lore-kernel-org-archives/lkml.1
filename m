Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbZFWIwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbZFWIwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbZFWIwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:52:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:43078 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbZFWIwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:52:13 -0400
Date: Tue, 23 Jun 2009 08:51:34 GMT
From: tip-bot for Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <Pine.LNX.4.64.0906221731210.19474@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906221731210.19474@melkki.cs.Helsinki.FI>
Subject: [tip:x86/urgent] x86: Move init_gbpages() to setup_arch()
Message-ID: <tip-854c879f5abf309ebd378bea1ee41acf4ddf7194@git.kernel.org>
Git-Commit-ID: 854c879f5abf309ebd378bea1ee41acf4ddf7194
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 23 Jun 2009 08:51:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  854c879f5abf309ebd378bea1ee41acf4ddf7194
Gitweb:     http://git.kernel.org/tip/854c879f5abf309ebd378bea1ee41acf4ddf7194
Author:     Pekka J Enberg <penberg@cs.helsinki.fi>
AuthorDate: Mon, 22 Jun 2009 17:39:41 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 23 Jun 2009 10:33:32 +0200

x86: Move init_gbpages() to setup_arch()

The init_gbpages() function is conditionally called from
init_memory_mapping() function. There are two call-sites where
this 'after_bootmem' condition can be true: setup_arch() and
mem_init() via pci_iommu_alloc().

Therefore, it's safe to move the call to init_gbpages() to
setup_arch() as it's always called before mem_init().

This removes an after_bootmem use - paving the way to remove
all uses of that state variable.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <Pine.LNX.4.64.0906221731210.19474@melkki.cs.Helsinki.FI>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/setup.c |   16 ++++++++++++++++
 arch/x86/mm/init.c      |   17 -----------------
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index be5ae80..de2cab1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -289,6 +289,20 @@ void * __init extend_brk(size_t size, size_t align)
 	return ret;
 }
 
+#ifdef CONFIG_X86_64
+static void __init init_gbpages(void)
+{
+	if (direct_gbpages && cpu_has_gbpages)
+		printk(KERN_INFO "Using GB pages for direct mapping\n");
+	else
+		direct_gbpages = 0;
+}
+#else
+static inline void init_gbpages(void)
+{
+}
+#endif
+
 static void __init reserve_brk(void)
 {
 	if (_brk_end > _brk_start)
@@ -871,6 +885,8 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_brk();
 
+	init_gbpages();
+
 	/* max_pfn_mapped is updated here */
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index f53b57e..47ce9a2 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -177,20 +177,6 @@ static int __meminit save_mr(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
-#ifdef CONFIG_X86_64
-static void __init init_gbpages(void)
-{
-	if (direct_gbpages && cpu_has_gbpages)
-		printk(KERN_INFO "Using GB pages for direct mapping\n");
-	else
-		direct_gbpages = 0;
-}
-#else
-static inline void init_gbpages(void)
-{
-}
-#endif
-
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
@@ -210,9 +196,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
 
-	if (!after_bootmem)
-		init_gbpages();
-
 #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
 	/*
 	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.

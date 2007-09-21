Return-Path: <linux-kernel-owner+w=401wt.eu-S1765673AbXIUWgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765673AbXIUWgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763581AbXIUWcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:20 -0400
Received: from ns2.suse.de ([195.135.220.15]:40468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762413AbXIUWcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:13 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [14/50] x86: Minor code-style cleanups to change_page_attr
Message-Id: <20070921223212.CA97313DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove a one liner function and expand into parent.
No functional changes.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/mm/pageattr.c   |    7 +------
 arch/x86_64/mm/pageattr.c |    7 +------
 2 files changed, 2 insertions(+), 12 deletions(-)

Index: linux/arch/x86_64/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86_64/mm/pageattr.c
+++ linux/arch/x86_64/mm/pageattr.c
@@ -93,11 +93,6 @@ static void flush_kernel_map(void *arg)
 	__flush_tlb_all();
 }
 
-static inline void flush_map(struct list_head *l)
-{	
-	on_each_cpu(flush_kernel_map, l, 1, 1);
-}
-
 /* both protected by init_mm.mmap_sem */
 static int full_flush;
 static LIST_HEAD(deferred_pages);
@@ -271,7 +266,7 @@ void global_flush_tlb(void)
 	list_replace_init(&deferred_pages, &arg.l);
 	up_read(&init_mm.mmap_sem);
 
-	flush_map(&arg);
+	on_each_cpu(flush_kernel_map, &arg, 1, 1);
 
 	list_for_each_entry_safe(pg, next, &arg.l, lru) {
 		list_del(&pg->lru);
Index: linux/arch/i386/mm/pageattr.c
===================================================================
--- linux.orig/arch/i386/mm/pageattr.c
+++ linux/arch/i386/mm/pageattr.c
@@ -238,11 +238,6 @@ __change_page_attr(struct page *page, pg
 	return 0;
 } 
 
-static inline void flush_map(struct list_head *l)
-{
-	on_each_cpu(flush_kernel_map, l, 1, 1);
-}
-
 /*
  * Change the page attributes of an page in the linear mapping.
  *
@@ -284,7 +279,7 @@ void global_flush_tlb(void)
 	full_flush = 0;
 	list_replace_init(&df_list, &arg.l);
 	spin_unlock_irq(&cpa_lock);
-	flush_map(&arg);
+	on_each_cpu(flush_kernel_map, &arg, 1, 1);
 	list_for_each_entry_safe(pg, next, &arg.l, lru) {
 		list_del(&pg->lru);
 		clear_bit(PG_arch_1, &pg->flags);

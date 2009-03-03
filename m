Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZCCLZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZCCLZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbZCCLZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:25:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:41851 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbZCCLZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:25:31 -0500
Date: Tue, 3 Mar 2009 11:24:30 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236078902.2675.16.camel@penberg-laptop>
References: <1236078902.2675.16.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: add sanity checks to init_32.c
Message-ID: <tip-05f209e7b936a48e341d36831079116a06658ccc@git.kernel.org>
Git-Commit-ID: 05f209e7b936a48e341d36831079116a06658ccc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 03 Mar 2009 11:24:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05f209e7b936a48e341d36831079116a06658ccc
Gitweb:     http://git.kernel.org/tip/05f209e7b936a48e341d36831079116a06658ccc
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Tue, 3 Mar 2009 13:15:02 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 3 Mar 2009 12:21:17 +0100

x86: add sanity checks to init_32.c

Impact: unification

This patch adds sanity checks that are already in init_64.c to init_32.c.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1236078902.2675.16.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 1dd6b63..1570a82 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1214,18 +1214,21 @@ void mark_rodata_ro(void)
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
-#ifdef CONFIG_DEBUG_PAGEALLOC
+	unsigned long addr = begin;
+
+	if (addr >= end)
+		return;
+
 	/*
 	 * If debugging page accesses then do not free this memory but
 	 * mark them not present - any buggy init-section access will
 	 * create a kernel page fault:
 	 */
+#ifdef CONFIG_DEBUG_PAGEALLOC
 	printk(KERN_INFO "debug: unmapping init memory %08lx..%08lx\n",
 		begin, PAGE_ALIGN(end));
 	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
 #else
-	unsigned long addr;
-
 	/*
 	 * We just marked the kernel text read only above, now that
 	 * we are going to free part of that, we need to make that
@@ -1233,14 +1236,16 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 	 */
 	set_memory_rw(begin, (end - begin) >> PAGE_SHIFT);
 
-	for (addr = begin; addr < end; addr += PAGE_SIZE) {
+	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
+
+	for (; addr < end; addr += PAGE_SIZE) {
 		ClearPageReserved(virt_to_page(addr));
 		init_page_count(virt_to_page(addr));
-		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
+		memset((void *)(addr & ~(PAGE_SIZE-1)),
+			POISON_FREE_INITMEM, PAGE_SIZE);
 		free_page(addr);
 		totalram_pages++;
 	}
-	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 #endif
 }
 

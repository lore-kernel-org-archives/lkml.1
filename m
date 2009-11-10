Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbZKJNY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbZKJNY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 08:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbZKJNYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 08:24:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:34180 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbZKJNYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 08:24:21 -0500
Date: Tue, 10 Nov 2009 13:23:52 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, penberg@cs.helsinki.fi,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, torvalds@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257849980-22640-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1257849980-22640-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] bootmem: Add free_bootmem_late()
Message-ID: <tip-9f993ac3f708b661207ed7de521f245586217a68@git.kernel.org>
Git-Commit-ID: 9f993ac3f708b661207ed7de521f245586217a68
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f993ac3f708b661207ed7de521f245586217a68
Gitweb:     http://git.kernel.org/tip/9f993ac3f708b661207ed7de521f245586217a68
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Tue, 10 Nov 2009 19:46:17 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Nov 2009 12:31:43 +0100

bootmem: Add free_bootmem_late()

Add a new function for freeing bootmem after the bootmem
allocator has been released and the unreserved pages given to
the page allocator.

This allows us to reserve bootmem and then release it if we
later discover it was not needed.

( This new API will be used by the swiotlb code to recover
  a significant amount of RAM (64MB). )

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: chrisw@sous-sol.org
Cc: dwmw2@infradead.org
Cc: joerg.roedel@amd.com
Cc: muli@il.ibm.com
Cc: hannes@cmpxchg.org
Cc: tj@kernel.org
Cc: akpm@linux-foundation.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1257849980-22640-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/bootmem.h |    1 +
 mm/bootmem.c            |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index dd97fb8..b10ec49 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -53,6 +53,7 @@ extern void free_bootmem_node(pg_data_t *pgdat,
 			      unsigned long addr,
 			      unsigned long size);
 extern void free_bootmem(unsigned long addr, unsigned long size);
+extern void free_bootmem_late(unsigned long addr, unsigned long size);
 
 /*
  * Flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 555d5d2..d1dc23c 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -143,6 +143,30 @@ unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
 	return init_bootmem_core(NODE_DATA(0)->bdata, start, 0, pages);
 }
 
+/*
+ * free_bootmem_late - free bootmem pages directly to page allocator
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ *
+ * This is only useful when the bootmem allocator has already been torn
+ * down, but we are still initializing the system.  Pages are given directly
+ * to the page allocator, no bootmem metadata is updated because it is gone.
+ */
+void __init free_bootmem_late(unsigned long addr, unsigned long size)
+{
+	unsigned long cursor, end;
+
+	kmemleak_free_part(__va(addr), size);
+
+	cursor = PFN_UP(addr);
+	end = PFN_DOWN(addr + size);
+
+	for (; cursor < end; cursor++) {
+		__free_pages_bootmem(pfn_to_page(cursor), 0);
+		totalram_pages++;
+	}
+}
+
 static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 {
 	int aligned;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760561AbZDBOmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561AbZDBOmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbZDBOmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:42:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:39983 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbZDBOmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:42:05 -0400
Date: Thu, 2 Apr 2009 14:39:35 GMT
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <20090402070126.GA3951@localhost.localdomain>
References: <20090402070126.GA3951@localhost.localdomain>
Subject: [tip:x86/urgent] x86, mm: fix misuse of debug_kmap_atomic
Message-ID: <tip-a7f8c50d90a4e983c456ae75e534b5cd6c03674b@git.kernel.org>
Git-Commit-ID: a7f8c50d90a4e983c456ae75e534b5cd6c03674b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 14:39:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7f8c50d90a4e983c456ae75e534b5cd6c03674b
Gitweb:     http://git.kernel.org/tip/a7f8c50d90a4e983c456ae75e534b5cd6c03674b
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Thu, 2 Apr 2009 16:01:26 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 2 Apr 2009 16:37:04 +0200

x86, mm: fix misuse of debug_kmap_atomic

Impact: fix CONFIG_DEBUG_HIGHMEM=y breakage

Commit 7ca43e756 ("mm: use debug_kmap_atomic") introduced some
debug_kmap_atomic() calls in the wrong places.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20090402070126.GA3951@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/highmem_32.c |    1 -
 arch/x86/mm/iomap_32.c   |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 5bc5d16..8126e8d 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -40,7 +40,6 @@ void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
 
 	debug_kmap_atomic(type);
 
-	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index bff0c90..e331f77 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -39,6 +39,7 @@ void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 
 	pagefault_disable();
 
+	debug_kmap_atomic(type);
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
@@ -72,7 +73,6 @@ iounmap_atomic(void *kvaddr, enum km_type type)
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
 
-	debug_kmap_atomic(type);
 	/*
 	 * Force other mappings to Oops if they'll try to access this pte
 	 * without first remap it.  Keeping stale mappings around is a bad idea

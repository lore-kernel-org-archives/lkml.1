Return-Path: <linux-kernel-owner+w=401wt.eu-S1762265AbZCTK0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762265AbZCTK0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760980AbZCTKZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:25:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:35160 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760838AbZCTKZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:25:15 -0400
Date: Fri, 20 Mar 2009 10:24:42 GMT
From: "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090319215358.901545000@intel.com>
References: <20090319215358.901545000@intel.com>
Subject: [tip:x86/mm] x86, CPA: Add set_pages_arrayuc and set_pages_array_wb
Message-ID: <tip-0f3507555f6fa4acbc85a646d6e8766230db38fc@git.kernel.org>
Git-Commit-ID: 0f3507555f6fa4acbc85a646d6e8766230db38fc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:24:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f3507555f6fa4acbc85a646d6e8766230db38fc
Gitweb:     http://git.kernel.org/tip/0f3507555f6fa4acbc85a646d6e8766230db38fc
Author:     venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
AuthorDate: Thu, 19 Mar 2009 14:51:15 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 10:34:49 +0100

x86, CPA: Add set_pages_arrayuc and set_pages_array_wb

Add new interfaces:

  set_pages_array_uc()
  set_pages_array_wb()

that can be used change the page attribute for a bunch of pages with
flush etc done once at the end of all the changes. These interfaces
are similar to existing set_memory_array_uc() and set_memory_array_wc().

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: arjan@infradead.org
Cc: eric@anholt.net
Cc: airlied@redhat.com
LKML-Reference: <20090319215358.901545000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/cacheflush.h |    3 ++
 arch/x86/mm/pageattr.c            |   63 +++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 5b301b7..b3894bf 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -90,6 +90,9 @@ int set_memory_4k(unsigned long addr, int numpages);
 int set_memory_array_uc(unsigned long *addr, int addrinarray);
 int set_memory_array_wb(unsigned long *addr, int addrinarray);
 
+int set_pages_array_uc(struct page **pages, int addrinarray);
+int set_pages_array_wb(struct page **pages, int addrinarray);
+
 /*
  * For legacy compatibility with the old APIs, a few functions
  * are provided that work on a "struct page".
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e5c257f..d71e1b6 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -920,6 +920,20 @@ static inline int change_page_attr_clear(unsigned long *addr, int numpages,
 		(array ? CPA_ARRAY : 0), NULL);
 }
 
+static inline int cpa_set_pages_array(struct page **pages, int numpages,
+				       pgprot_t mask)
+{
+	return change_page_attr_set_clr(NULL, numpages, mask, __pgprot(0), 0,
+		CPA_PAGES_ARRAY, pages);
+}
+
+static inline int cpa_clear_pages_array(struct page **pages, int numpages,
+					 pgprot_t mask)
+{
+	return change_page_attr_set_clr(NULL, numpages, __pgprot(0), mask, 0,
+		CPA_PAGES_ARRAY, pages);
+}
+
 int _set_memory_uc(unsigned long addr, int numpages)
 {
 	/*
@@ -1076,6 +1090,35 @@ int set_pages_uc(struct page *page, int numpages)
 }
 EXPORT_SYMBOL(set_pages_uc);
 
+int set_pages_array_uc(struct page **pages, int addrinarray)
+{
+	unsigned long start;
+	unsigned long end;
+	int i;
+	int free_idx;
+
+	for (i = 0; i < addrinarray; i++) {
+		start = (unsigned long)page_address(pages[i]);
+		end = start + PAGE_SIZE;
+		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
+			goto err_out;
+	}
+
+	if (cpa_set_pages_array(pages, addrinarray,
+			__pgprot(_PAGE_CACHE_UC_MINUS)) == 0) {
+		return 0; /* Success */
+	}
+err_out:
+	free_idx = i;
+	for (i = 0; i < free_idx; i++) {
+		start = (unsigned long)page_address(pages[i]);
+		end = start + PAGE_SIZE;
+		free_memtype(start, end);
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(set_pages_array_uc);
+
 int set_pages_wb(struct page *page, int numpages)
 {
 	unsigned long addr = (unsigned long)page_address(page);
@@ -1084,6 +1127,26 @@ int set_pages_wb(struct page *page, int numpages)
 }
 EXPORT_SYMBOL(set_pages_wb);
 
+int set_pages_array_wb(struct page **pages, int addrinarray)
+{
+	int retval;
+	unsigned long start;
+	unsigned long end;
+	int i;
+
+	retval = cpa_clear_pages_array(pages, addrinarray,
+			__pgprot(_PAGE_CACHE_MASK));
+
+	for (i = 0; i < addrinarray; i++) {
+		start = (unsigned long)page_address(pages[i]);
+		end = start + PAGE_SIZE;
+		free_memtype(start, end);
+	}
+
+	return retval;
+}
+EXPORT_SYMBOL(set_pages_array_wb);
+
 int set_pages_x(struct page *page, int numpages)
 {
 	unsigned long addr = (unsigned long)page_address(page);

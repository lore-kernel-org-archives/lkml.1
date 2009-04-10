Return-Path: <linux-kernel-owner+w=401wt.eu-S937567AbZDJMfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937567AbZDJMfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937387AbZDJMfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:35:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:45683 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937279AbZDJMfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:35:09 -0400
Date: Fri, 10 Apr 2009 12:34:21 GMT
From: "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090409212708.653222000@intel.com>
References: <20090409212708.653222000@intel.com>
Subject: [tip:x86/pat] x86, PAT: Handle faults cleanly in set_memory_ APIs
Message-ID: <tip-9fa3ab390abfc8b49fc0dd7c845b0ad224ec429f@git.kernel.org>
Git-Commit-ID: 9fa3ab390abfc8b49fc0dd7c845b0ad224ec429f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 12:34:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9fa3ab390abfc8b49fc0dd7c845b0ad224ec429f
Gitweb:     http://git.kernel.org/tip/9fa3ab390abfc8b49fc0dd7c845b0ad224ec429f
Author:     venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
AuthorDate: Thu, 9 Apr 2009 14:26:49 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 13:55:47 +0200

x86, PAT: Handle faults cleanly in set_memory_ APIs

Handle faults and do proper cleanups in set_memory_*() functions. In
some cases, these functions were not doing proper free on failure paths.

With the changes to tracking memtype of RAM pages in struct page instead
of pat list, we do not need the changes in commits c5e147. This patch
reverts that change.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20090409212708.653222000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/pageattr.c |  113 +++++++++++++++++++++++++++--------------------
 1 files changed, 65 insertions(+), 48 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index d487eaa..985eef8 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -945,52 +945,56 @@ int _set_memory_uc(unsigned long addr, int numpages)
 
 int set_memory_uc(unsigned long addr, int numpages)
 {
+	int ret;
+
 	/*
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
-	if (reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
-			    _PAGE_CACHE_UC_MINUS, NULL))
-		return -EINVAL;
+	ret = reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
+			    _PAGE_CACHE_UC_MINUS, NULL);
+	if (ret)
+		goto out_err;
+
+	ret = _set_memory_uc(addr, numpages);
+	if (ret)
+		goto out_free;
+
+	return 0;
 
-	return _set_memory_uc(addr, numpages);
+out_free:
+	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
+out_err:
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_uc);
 
 int set_memory_array_uc(unsigned long *addr, int addrinarray)
 {
-	unsigned long start;
-	unsigned long end;
-	int i;
+	int i, j;
+	int ret;
+
 	/*
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
 	for (i = 0; i < addrinarray; i++) {
-		start = __pa(addr[i]);
-		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
-			if (end != __pa(addr[i + 1]))
-				break;
-			i++;
-		}
-		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
-			goto out;
+		ret = reserve_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE,
+					_PAGE_CACHE_UC_MINUS, NULL);
+		if (ret)
+			goto out_free;
 	}
 
-	return change_page_attr_set(addr, addrinarray,
+	ret = change_page_attr_set(addr, addrinarray,
 				    __pgprot(_PAGE_CACHE_UC_MINUS), 1);
-out:
-	for (i = 0; i < addrinarray; i++) {
-		unsigned long tmp = __pa(addr[i]);
-
-		if (tmp == start)
-			break;
-		for (end = tmp + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
-			if (end != __pa(addr[i + 1]))
-				break;
-			i++;
-		}
-		free_memtype(tmp, end);
-	}
-	return -EINVAL;
+	if (ret)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	for (j = 0; j < i; j++)
+		free_memtype(__pa(addr[j]), __pa(addr[j]) + PAGE_SIZE);
+
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_array_uc);
 
@@ -1002,14 +1006,26 @@ int _set_memory_wc(unsigned long addr, int numpages)
 
 int set_memory_wc(unsigned long addr, int numpages)
 {
+	int ret;
+
 	if (!pat_enabled)
 		return set_memory_uc(addr, numpages);
 
-	if (reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
-		_PAGE_CACHE_WC, NULL))
-		return -EINVAL;
+	ret = reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
+		_PAGE_CACHE_WC, NULL);
+	if (ret)
+		goto out_err;
 
-	return _set_memory_wc(addr, numpages);
+	ret = _set_memory_wc(addr, numpages);
+	if (ret)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
+out_err:
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_wc);
 
@@ -1021,9 +1037,14 @@ int _set_memory_wb(unsigned long addr, int numpages)
 
 int set_memory_wb(unsigned long addr, int numpages)
 {
-	int ret = _set_memory_wb(addr, numpages);
+	int ret;
+
+	ret = _set_memory_wb(addr, numpages);
+	if (ret)
+		return ret;
+
 	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(set_memory_wb);
 
@@ -1034,19 +1055,13 @@ int set_memory_array_wb(unsigned long *addr, int addrinarray)
 
 	ret = change_page_attr_clear(addr, addrinarray,
 				      __pgprot(_PAGE_CACHE_MASK), 1);
+	if (ret)
+		return ret;
 
-	for (i = 0; i < addrinarray; i++) {
-		unsigned long start = __pa(addr[i]);
-		unsigned long end;
+	for (i = 0; i < addrinarray; i++)
+		free_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE);
 
-		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
-			if (end != __pa(addr[i + 1]))
-				break;
-			i++;
-		}
-		free_memtype(start, end);
-	}
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(set_memory_array_wb);
 
@@ -1139,6 +1154,8 @@ int set_pages_array_wb(struct page **pages, int addrinarray)
 
 	retval = cpa_clear_pages_array(pages, addrinarray,
 			__pgprot(_PAGE_CACHE_MASK));
+	if (retval)
+		return retval;
 
 	for (i = 0; i < addrinarray; i++) {
 		start = (unsigned long)page_address(pages[i]);
@@ -1146,7 +1163,7 @@ int set_pages_array_wb(struct page **pages, int addrinarray)
 		free_memtype(start, end);
 	}
 
-	return retval;
+	return 0;
 }
 EXPORT_SYMBOL(set_pages_array_wb);
 

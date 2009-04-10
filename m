Return-Path: <linux-kernel-owner+w=401wt.eu-S937298AbZDJMfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937298AbZDJMfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759338AbZDJMer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:34:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:41647 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937059AbZDJMep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:34:45 -0400
Date: Fri, 10 Apr 2009 12:34:09 GMT
From: "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090409212708.512280000@intel.com>
References: <20090409212708.512280000@intel.com>
Subject: [tip:x86/pat] x86, PAT: Change order of cpa and free in set_memory_wb
Message-ID: <tip-a5593e0b329a14dea41ea173380dbf1533de2bd2@git.kernel.org>
Git-Commit-ID: a5593e0b329a14dea41ea173380dbf1533de2bd2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 12:34:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5593e0b329a14dea41ea173380dbf1533de2bd2
Gitweb:     http://git.kernel.org/tip/a5593e0b329a14dea41ea173380dbf1533de2bd2
Author:     venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
AuthorDate: Thu, 9 Apr 2009 14:26:48 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 13:55:46 +0200

x86, PAT: Change order of cpa and free in set_memory_wb

To be free of aliasing due to races, set_memory_* interfaces should
follow ordering of reserving, changing memtype to UC/WC, changing
memtype back to WB followed by free.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20090409212708.512280000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/pageattr.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index d71e1b6..d487eaa 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1021,15 +1021,19 @@ int _set_memory_wb(unsigned long addr, int numpages)
 
 int set_memory_wb(unsigned long addr, int numpages)
 {
+	int ret = _set_memory_wb(addr, numpages);
 	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
-
-	return _set_memory_wb(addr, numpages);
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_wb);
 
 int set_memory_array_wb(unsigned long *addr, int addrinarray)
 {
 	int i;
+	int ret;
+
+	ret = change_page_attr_clear(addr, addrinarray,
+				      __pgprot(_PAGE_CACHE_MASK), 1);
 
 	for (i = 0; i < addrinarray; i++) {
 		unsigned long start = __pa(addr[i]);
@@ -1042,8 +1046,7 @@ int set_memory_array_wb(unsigned long *addr, int addrinarray)
 		}
 		free_memtype(start, end);
 	}
-	return change_page_attr_clear(addr, addrinarray,
-				      __pgprot(_PAGE_CACHE_MASK), 1);
+	return ret;
 }
 EXPORT_SYMBOL(set_memory_array_wb);
 

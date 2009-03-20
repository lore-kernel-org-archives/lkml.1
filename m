Return-Path: <linux-kernel-owner+w=401wt.eu-S1759558AbZCTKZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558AbZCTKZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZCTKZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:25:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:35133 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbZCTKZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:25:02 -0400
Date: Fri, 20 Mar 2009 10:24:25 GMT
From: "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090319215358.611346000@intel.com>
References: <20090319215358.611346000@intel.com>
Subject: [tip:x86/mm] x86, CPA: Add a flag parameter to cpa set_clr()
Message-ID: <tip-728c9518873de0bbb92b66daa1943b12e5b9f80f@git.kernel.org>
Git-Commit-ID: 728c9518873de0bbb92b66daa1943b12e5b9f80f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:24:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  728c9518873de0bbb92b66daa1943b12e5b9f80f
Gitweb:     http://git.kernel.org/tip/728c9518873de0bbb92b66daa1943b12e5b9f80f
Author:     venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
AuthorDate: Thu, 19 Mar 2009 14:51:13 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 10:34:47 +0100

x86, CPA: Add a flag parameter to cpa set_clr()

Change change_page_attr_set_clr() array parameter to a flag. This helps
following patches which adds an interface to change attr to uc/wb over a
set of pages referred by struct page.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: arjan@infradead.org
Cc: eric@anholt.net
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: airlied@redhat.com
LKML-Reference: <20090319215358.611346000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/pageattr.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 1280565..69009af 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -787,7 +787,7 @@ static inline int cache_attr(pgprot_t attr)
 
 static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 				    pgprot_t mask_set, pgprot_t mask_clr,
-				    int force_split, int array)
+				    int force_split, int in_flag)
 {
 	struct cpa_data cpa;
 	int ret, cache, checkalias;
@@ -802,7 +802,7 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 		return 0;
 
 	/* Ensure we are PAGE_SIZE aligned */
-	if (!array) {
+	if (!(in_flag & CPA_ARRAY)) {
 		if (*addr & ~PAGE_MASK) {
 			*addr &= PAGE_MASK;
 			/*
@@ -840,7 +840,7 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	cpa.curpage = 0;
 	cpa.force_split = force_split;
 
-	if (array)
+	if (in_flag & CPA_ARRAY)
 		cpa.flags |= CPA_ARRAY;
 
 	/* No alias checking for _NX bit modifications */
@@ -889,14 +889,14 @@ static inline int change_page_attr_set(unsigned long *addr, int numpages,
 				       pgprot_t mask, int array)
 {
 	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0), 0,
-		array);
+		(array ? CPA_ARRAY : 0));
 }
 
 static inline int change_page_attr_clear(unsigned long *addr, int numpages,
 					 pgprot_t mask, int array)
 {
 	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask, 0,
-		array);
+		(array ? CPA_ARRAY : 0));
 }
 
 int _set_memory_uc(unsigned long addr, int numpages)

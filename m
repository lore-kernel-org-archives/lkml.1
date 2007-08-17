Return-Path: <linux-kernel-owner+w=401wt.eu-S1762338AbXHQJjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762338AbXHQJjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 05:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXHQJji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 05:39:38 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:45841 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750925AbXHQJjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 05:39:37 -0400
Message-ID: <387343573.05776@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 17 Aug 2007 17:39:33 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] maps: show swapped out pages in smaps
Message-ID: <20070817093933.GA6056@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Show the amount of swapped out pages in /proc/<pid>/smaps.
Currently there's no way to know who is using the swap file.

A possible better way to support it is to add a new counter to struct_mm.
Or maybe not that important at all?

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/proc/task_mmu.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc2-mm2.orig/fs/proc/task_mmu.c
+++ linux-2.6.23-rc2-mm2/fs/proc/task_mmu.c
@@ -324,6 +324,7 @@ struct mem_size_stats
 	unsigned long private_clean;
 	unsigned long private_dirty;
 	unsigned long referenced;
+	unsigned long swapped;
 
 	/*
 	 * Proportional Set Size(PSS): my share of RSS.
@@ -367,8 +368,11 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		ptent = *pte;
-		if (!pte_present(ptent))
+		if (!pte_present(ptent)) {
+			if (!pte_none(ptent) && !pte_file(ptent))
+				mms->swapped += PAGE_SIZE;
 			continue;
+		}
 
 		mss->resident += PAGE_SIZE;
 
@@ -425,7 +429,8 @@ static int show_smap(struct seq_file *m,
 		   "Shared_Dirty:   %8lu kB\n"
 		   "Private_Clean:  %8lu kB\n"
 		   "Private_Dirty:  %8lu kB\n"
-		   "Referenced:     %8lu kB\n",
+		   "Referenced:     %8lu kB\n"
+		   "Swapped:        %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
 		   sarg.mss.resident >> 10,
 		   (unsigned long)(sarg.mss.pss >> (10 + PSS_ERROR_BITS)),
@@ -433,7 +438,8 @@ static int show_smap(struct seq_file *m,
 		   sarg.mss.shared_dirty  >> 10,
 		   sarg.mss.private_clean >> 10,
 		   sarg.mss.private_dirty >> 10,
-		   sarg.mss.referenced >> 10);
+		   sarg.mss.referenced    >> 10,
+		   sarg.mss.swapped       >> 10);
 
 	return ret;
 }


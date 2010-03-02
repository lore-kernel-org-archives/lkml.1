Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0CBSaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:30:12 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:16126 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab0CBS3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:29:52 -0500
X-Spam-Processed: digidescorp.com, Tue, 02 Mar 2010 12:29:51 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1677b2d779=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Steven J. Magnani" <steve@digidescorp.com>
Subject: [PATCH] nommu: get_user_pages(): pin last page on non-page-aligned start
Date: Tue,  2 Mar 2010 12:29:44 -0600
Message-Id: <1267554584-24349-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The noMMU version of get_user_pages() fails to pin the last page
when the start address isn't page-aligned. The patch fixes this in a way
that makes find_extend_vma() congruent to its MMU cousin.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/mm/nommu.c b/mm/nommu.c
--- a/mm/nommu.c	2010-03-01 16:37:31.000000000 -0600
+++ b/mm/nommu.c	2010-03-01 21:34:49.000000000 -0600
@@ -146,7 +146,7 @@ int __get_user_pages(struct task_struct 
 			(VM_MAYREAD | VM_MAYWRITE) : (VM_READ | VM_WRITE);
 
 	for (i = 0; i < nr_pages; i++) {
-		vma = find_vma(mm, start);
+		vma = find_extend_vma(mm, start);
 		if (!vma)
 			goto finish_or_fault;
 
@@ -764,7 +764,7 @@ EXPORT_SYMBOL(find_vma);
  */
 struct vm_area_struct *find_extend_vma(struct mm_struct *mm, unsigned long addr)
 {
-	return find_vma(mm, addr);
+	return find_vma(mm, addr & PAGE_MASK);
 }
 
 /*


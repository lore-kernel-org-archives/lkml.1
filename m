Return-Path: <linux-kernel-owner+w=401wt.eu-S1751239AbZGXEFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239AbZGXEFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 00:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbZGXEFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 00:05:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:18647 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZGXEFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 00:05:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=iP+iFrB4f/1q+sTuS9XNnnjzPF4gRLAf/tUssKtH83cBmR5CdrT2ozVyOeePna7+ot
         IET8maVh8lSjF+tWtPdSuZaOzzwY/MEqVHb1VYOxpoDgEEr5SU/PdPS2bJbxZHu8cyjU
         HGxDtbrgng0SIHADFXJ5BAw2IYaWAlFIt/+bI=
Message-ID: <4A693122.6060503@gmail.com>
Date: Thu, 23 Jul 2009 20:57:22 -0700
From: "Moussa A. Ba" <moussa.a.ba@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, adobriyan@gmail.com, mpm@selenic.com,
       mel@csn.ul.ie, yinghan@google.com, npiggin@suse.de, jaredeh@gmail.com,
       moussa.a.ba@gmail.com
Subject: [PATCH 1/1] pagemap clear_refs: modify to specify anon or mapped
 vma clearing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jared E. Hulbert <jaredeh@gmail.com>
Signed-off-by: Moussa Ba <moussa.a.ba@gmail.com>
--- a/fs/proc/task_mmu.c	2009-07-21 14:30:01.000000000 -0700
+++ b/fs/proc/task_mmu.c	2009-07-21 14:32:56.000000000 -0700
@@ -461,6 +461,33 @@
  	cond_resched();
  	return 0;
  }
+static void walk_vma_area(struct mm_walk *this_walk, struct 
vm_area_struct *vma,
+						int type)
+{
+	switch (type) {
+		/* Clear Anon VMAs only */
+	case 1:
+		if (!is_vm_hugetlb_page(vma) && !vma->vm_file)
+			walk_page_range(vma->vm_start,
+					vma->vm_end,
+					this_walk);
+		break;
+		/* Clear Mapped VMAs only */
+	case 2:
+		if (!is_vm_hugetlb_page(vma) && vma->vm_file)
+			walk_page_range(vma->vm_start,
+					vma->vm_end,
+					this_walk);
+		break;
+		/* Clear All VMAs */
+	default:
+		if (!is_vm_hugetlb_page(vma))
+			walk_page_range(vma->vm_start,
+					vma->vm_end,
+					this_walk);
+		break;
+	}
+}

  static ssize_t clear_refs_write(struct file *file, const char __user * 
buf,
  				size_t count, loff_t * ppos)
@@ -469,13 +496,15 @@
  	char buffer[PROC_NUMBUF], *end;
  	struct mm_struct *mm;
  	struct vm_area_struct *vma;
+	int type;

  	memset(buffer, 0, sizeof(buffer));
  	if (count > sizeof(buffer) - 1)
  		count = sizeof(buffer) - 1;
  	if (copy_from_user(buffer, buf, count))
  		return -EFAULT;
-	if (!simple_strtol(buffer, &end, 0))
+	type = simple_strtol(buffer, &end, 0);
+	if (!type)
  		return -EINVAL;
  	if (*end == '\n')
  		end++;
@@ -491,9 +520,7 @@
  		down_read(&mm->mmap_sem);
  		for (vma = mm->mmap; vma; vma = vma->vm_next) {
  			clear_refs_walk.private = vma;
-			if (!is_vm_hugetlb_page(vma))
-				walk_page_range(vma->vm_start, vma->vm_end,
-						&clear_refs_walk);
+			walk_vma_area(&clear_refs_walk, vma, type);
  		}
  		flush_tlb_mm(mm);
  		up_read(&mm->mmap_sem);

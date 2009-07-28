Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbZG1WwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbZG1WwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbZG1WwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:52:10 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:48682 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbZG1WwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:52:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hSDiARyfNH9Mt4iR6nhf3Bigbx1az50d10cUXB6iNNWwO2l13fT9q8K4MiROkzwqaF
         KsS5VPxzSccKlMJYFy62ZTL8pP+2ENDlKT+Ji8xt+KsF1/2NM92zEq39zt+HGJT8KO49
         pXMJ7EmRjdxwFmxxYgKUODZ+SvJTj9akk+bLI=
Message-ID: <4A6F8115.7000500@gmail.com>
Date: Tue, 28 Jul 2009 15:52:05 -0700
From: "Moussa A. Ba" <moussa.a.ba@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: David Rientjes <rientjes@google.com>, xiyou.wangcong@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Matt Mackall <mpm@selenic.com>,
       Mel Gorman <mel@csn.ul.ie>, Ying Han <yinghan@google.com>,
       Nick Piggin <npiggin@suse.de>, jaredeh@gmail.com
Subject: [PATCH 1/1] pagemap clear_refs: modify to specify anon or mapped
 vma clearing
References: <4A693122.6060503@gmail.com> <20090724083926.GA6372@cr0.nay.redhat.com> <4A6E0BD6.50102@gmail.com> <alpine.DEB.2.00.0907271339070.17425@chino.kir.corp.google.com> <7928e7bd0907271514y699d1de4j54f9c562b94ef0cc@mail.gmail.com> <alpine.DEB.2.00.0907271543420.23587@chino.kir.corp.google.com> <7928e7bd0907271638x5ddbfd2ckba2802338a33765a@mail.gmail.com> <alpine.DEB.2.00.0907271657160.27881@chino.kir.corp.google.com> <4A6F2AF4.6050505@gmail.com> <alpine.DEB.2.00.0907281401150.7140@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0907281401150.7140@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds anonymous and file backed filters to the clear_refs interface.
echo 1 > /proc/PID/clear_refs resets the bits on all pages
echo 2 > /proc/PID/clear_refs resets the bits on anonymous pages only
echo 3 > /proc/PID/clear_refs resets the bits on file backed pages only
Any other value is ignored
---

Signed-off-by: Moussa A. Ba <moussa.a.ba@gmail.com>
Signed-off-by: Jared E. Hulbert <jaredeh@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>

--- a/Documentation/filesystems/proc.txt	2009-07-20 17:29:11.000000000 -0700
+++ b/Documentation/filesystems/proc.txt	2009-07-27 16:58:05.000000000 -0700
@@ -375,6 +375,18 @@ of memory currently marked as referenced
  This file is only present if the CONFIG_MMU kernel configuration option is
  enabled.

+The /proc/PID/clear_refs is used to reset the PG_Referenced and ACCESSED/YOUNG
+bits on both physical and virtual pages associated with a process.
+To clear the bits for all the pages associated with the process
+    > echo 1 > /proc/PID/clear_refs
+
+To clear the bits for the anonymous pages associated with the process
+    > echo 2 > /proc/PID/clear_refs
+
+To clear the bits for the file mapped pages associated with the process
+    > echo 3 > /proc/PID/clear_refs
+Any other value written to /proc/PID/clear_refs will have no effect.
+
  1.2 Kernel data
  ---------------

--- a/fs/proc/task_mmu.c	2009-07-21 14:30:01.000000000 -0700
+++ b/fs/proc/task_mmu.c	2009-07-27 17:05:25.000000000 -0700
@@ -462,6 +462,10 @@ static int clear_refs_pte_range(pmd_t *
  	return 0;
  }

+#define CLEAR_REFS_ALL 1
+#define CLEAR_REFS_ANON 2
+#define CLEAR_REFS_MAPPED 3
+
  static ssize_t clear_refs_write(struct file *file, const char __user * buf,
  				size_t count, loff_t * ppos)
  {
@@ -469,13 +473,15 @@ static ssize_t clear_refs_write(struct f
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
+	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
  		return -EINVAL;
  	if (*end == '\n')
  		end++;
@@ -491,9 +497,23 @@ static ssize_t clear_refs_write(struct f
  		down_read(&mm->mmap_sem);
  		for (vma = mm->mmap; vma; vma = vma->vm_next) {
  			clear_refs_walk.private = vma;
-			if (!is_vm_hugetlb_page(vma))
-				walk_page_range(vma->vm_start, vma->vm_end,
-						&clear_refs_walk);
+			if (is_vm_hugetlb_page(vma))
+				continue;
+			/*
+			 * Writing 1 to /proc/pid/clear_refs affects all pages.
+			 *
+			 * Writing 2 to /proc/pid/clear_refs only affects
+			 * Anonymous pages.
+			 *
+			 * Writing 3 to /proc/pid/clear_refs only affects file
+			 * mapped pages.
+			 */
+			if (type == CLEAR_REFS_ANON && vma->vm_file)
+				continue;
+			if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
+				continue;
+			walk_page_range(vma->vm_start, vma->vm_end,
+					&clear_refs_walk);
  		}
  		flush_tlb_mm(mm);
  		up_read(&mm->mmap_sem);

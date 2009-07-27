Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZG0UTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZG0UTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZG0UTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:19:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:11257 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZG0UTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:19:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IgX7UqUJuVXh2SuQpPC1jtnzpffYURAchTnG57kUUBzCAGM39u0aTTJFoBEf4i6cd9
         0nLcA6UWiZfFH/H131bIoD3/Kh0ScHcihhzWziNjmBu6e6LHLZEa97tXSHou73coqsWH
         hIA37iWYv6tfkiUSNjtoFoTYYT3Cm+iDi9L0U=
Message-ID: <4A6E0BD6.50102@gmail.com>
Date: Mon, 27 Jul 2009 13:19:34 -0700
From: "Moussa A. Ba" <moussa.a.ba@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Amerigo Wang <xiyou.wangcong@gmail.com>, akpm@linux-foundation.org,
       adobriyan@gmail.com, mpm@selenic.com, mel@csn.ul.ie, yinghan@google.com,
       npiggin@suse.de, jaredeh@gmail.com
Subject: [PATCH 1/1] pagemap clear_refs: modify to specify anon or mapped
 vma clearing
References: <4A693122.6060503@gmail.com> <20090724083926.GA6372@cr0.nay.redhat.com>
In-Reply-To: <20090724083926.GA6372@cr0.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the clear_refs proc interface a bit more versatile.
It adds support  for clearing anonymous pages, file mapped pages or both.

The clear_refs entry is used to reset the Referenced bits on virtual and
physical pages associated with a process.
echo 1 > /proc/PID/clear_refs clears all pages associated with the process
echo 2 > /proc/PID/clear_refs clears anonymous pages only
echo 3 > /proc/PID/clear_refs clears file mapped pages only
Any other value written to the proc entry will clear all pages.

Selective clearing the pages has a measurable impact on performance as it
limits the number of page walks.  We have been using this interface and  this
adds flexibility to the user user space application implementing the reference
clearing.

Signed-off-by: Jared Hulbert (jaredeh@gmail.com)
Signed-off-by: Moussa A. Ba (moussa.a.ba@gmail.com)
-------
Documentation/filesystems/proc.txt |    7 +++++++
fs/proc/task_mmu.c                 |   29 +++++++++++++++++++++++++----
2 files changed, 32 insertions(+), 4 deletions(-)

--- a/fs/proc/task_mmu.c	2009-07-21 14:30:01.000000000 -0700
+++ b/fs/proc/task_mmu.c	2009-07-27 11:46:05.000000000 -0700
@@ -462,6 +462,27 @@
  	return 0;
  }

+static void walk_vma_area(struct mm_walk *this_walk,
+			  struct vm_area_struct *vma, int type)
+{
+
+	/* Writing 2 to /proc/pid/clear_refs will clear all Anonymous
+	 * pages.
+	 *
+	 * Writing 3 to /proc/pid/clear_refs will clear all file mapped
+	 * pages.
+	 *
+	 * Writing any other value including 1 will clear all pages
+	 */
+	if (is_vm_hugetlb_page(vma))
+		return;
+	if (type == 2 && vma->vm_file)
+		return;
+	if (type == 3 && !vma->vm_file)
+		return;
+	walk_page_range(vma->vm_start, vma->vm_end, this_walk);
+}
+
  static ssize_t clear_refs_write(struct file *file, const char __user * buf,
  				size_t count, loff_t * ppos)
  {
@@ -469,13 +490,15 @@
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
+	type = strict_strtol(buffer, &end, 0);
+	if (!type)
  		return -EINVAL;
  	if (*end == '\n')
  		end++;
@@ -491,9 +514,7 @@
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
--- a/Documentation/filesystems/proc.txt	2009-07-20 17:29:11.000000000 -0700
+++ b/Documentation/filesystems/proc.txt	2009-07-27 12:08:34.000000000 -0700
@@ -375,6 +375,13 @@
  This file is only present if the CONFIG_MMU kernel configuration option is
  enabled.

+The clear_refs entry is used to reset the Referenced bits on virtual and physical
+pages associated with a process.
+echo 1 > /proc/PID/clear_refs clears all pages associated with the process
+echo 2 > /proc/PID/clear_refs clears anonymous pages only
+echo 3 > /proc/PID/clear_refs clears file mapped pages only
+Any other value written to the proc entry will clear all pages.
+
  1.2 Kernel data
  ---------------


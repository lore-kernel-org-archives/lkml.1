Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYCHXdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYCHXdB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 18:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752236AbYCHXcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 18:32:54 -0500
Received: from kanga.kvack.org ([66.96.29.28]:42140 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbYCHXcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 18:32:53 -0500
Date: Sat, 8 Mar 2008 20:35:55 -0300
From: Marcelo Tosatti <marcelo@kvack.org>
To: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pagemap: proper read error handling
Message-ID: <20080308233555.GA21461@dmt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix pagemap_read() error handling by releasing acquired resources and
checking for get_user_pages() partial failure.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>


diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 6dc0334..4206454 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -640,17 +640,17 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 
 	ret = -EACCES;
 	if (!ptrace_may_attach(task))
-		goto out;
+		goto out_task;
 
 	ret = -EINVAL;
 	/* file position must be aligned */
 	if (*ppos % PM_ENTRY_BYTES)
-		goto out;
+		goto out_task;
 
 	ret = 0;
 	mm = get_task_mm(task);
 	if (!mm)
-		goto out;
+		goto out_task;
 
 	ret = -ENOMEM;
 	uaddr = (unsigned long)buf & PAGE_MASK;
@@ -658,7 +658,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	pagecount = (PAGE_ALIGN(uend) - uaddr) / PAGE_SIZE;
 	pages = kmalloc(pagecount * sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
-		goto out_task;
+		goto out_mm;
 
 	down_read(&current->mm->mmap_sem);
 	ret = get_user_pages(current, current->mm, uaddr, pagecount,
@@ -668,6 +668,12 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	if (ret < 0)
 		goto out_free;
 
+	if (ret != pagecount) {
+		pagecount = ret;
+		ret = -EFAULT;
+		goto out_pages;
+	}
+
 	pm.out = buf;
 	pm.end = buf + count;
 
@@ -699,15 +705,17 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 			ret = pm.out - buf;
 	}
 
+out_pages:
 	for (; pagecount; pagecount--) {
 		page = pages[pagecount-1];
 		if (!PageReserved(page))
 			SetPageDirty(page);
 		page_cache_release(page);
 	}
-	mmput(mm);
 out_free:
 	kfree(pages);
+out_mm:
+	mmput(mm);
 out_task:
 	put_task_struct(task);
 out:

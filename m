Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZCLKgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZCLKgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbZCLKgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:36:23 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:39301 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZCLKgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:36:22 -0400
Date: Thu, 12 Mar 2009 11:33:08 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Matt Mackall <mpm@selenic.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>, akpm@linux-foundation.org
Subject: [PATCH] acquire mmap semaphore in pagemap_read.
Message-ID: <20090312113308.6fe18a93@skybase>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The walk_page_range function may only be called while holding the mmap
semaphore. Otherwise a concurrent munmap could free a page table that
is read by the generic page table walker.

Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 fs/proc/task_mmu.c |    2 ++
 1 file changed, 2 insertions(+)

diff -urpN linux-2.6/fs/proc/task_mmu.c linux-2.6-patched/fs/proc/task_mmu.c
--- linux-2.6/fs/proc/task_mmu.c	2009-03-12 11:32:51.000000000 +0100
+++ linux-2.6-patched/fs/proc/task_mmu.c	2009-03-12 11:33:16.000000000 +0100
@@ -716,7 +716,9 @@ static ssize_t pagemap_read(struct file 
 	 * user buffer is tracked in "pm", and the walk
 	 * will stop when we hit the end of the buffer.
 	 */
+	down_read(&mm->mmap_sem);
 	ret = walk_page_range(start_vaddr, end_vaddr, &pagemap_walk);
+	up_read(&mm->mmap_sem);
 	if (ret == PM_END_OF_BUFFER)
 		ret = 0;
 	/* don't need mmap_sem for these, but this looks cleaner */

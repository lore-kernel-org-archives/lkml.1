Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbXLTNGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbXLTNGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbXLTNFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:05:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49931 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbXLTNFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:05:53 -0500
Subject: [rfc][patch] mm: madvise(WILLNEED) for anonymous memory
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: hugh <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       riel <riel@redhat.com>, Lennart Poettering <mztabzr@0pointer.de>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 14:05:38 +0100
Message-Id: <1198155938.6821.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Lennart asked for madvise(WILLNEED) to work on anonymous pages, he plans
to use this to pre-fault pages. He currently uses: mlock/munlock for
this purpose.

[ compile tested only ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/mm/madvise.c b/mm/madvise.c
index 93ee375..eff60ce 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -100,6 +100,24 @@ out:
 	return error;
 }
 
+static long madvice_willneed_anon(struct vm_area_struct *vma,
+				  struct vm_area_struct **prev,
+				  unsigned long start, unsigned long end)
+{
+	int ret, len;
+
+	*prev = vma;
+	if (end > vma->vm_end)
+		end = vma->vm_end;
+
+	len = end - start;
+	ret = get_user_pages(current, current->mm, start, len,
+			0, 0, NULL, NULL);
+	if (ret < 0)
+		return ret;
+	return ret == len ? 0 : -1;
+}
+
 /*
  * Schedule all required I/O operations.  Do not wait for completion.
  */
@@ -110,7 +128,7 @@ static long madvise_willneed(struct vm_area_struct * vma,
 	struct file *file = vma->vm_file;
 
 	if (!file)
-		return -EBADF;
+		return madvice_willneed_anon(vma, prev, start, end);
 
 	if (file->f_mapping->a_ops->get_xip_page) {
 		/* no bad return value, but ignore advice */



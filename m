Return-Path: <linux-kernel-owner+w=401wt.eu-S1751713AbXC1Ngn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbXC1Ngn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 09:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXC1Ngm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 09:36:42 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51813 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbXC1Ngl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 09:36:41 -0400
Date: Wed, 28 Mar 2007 16:36:40 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org
Subject: [PATCH] revoke: break cow fixes
Message-ID: <Pine.LNX.4.64.0703281636010.10857@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

As pointed out by Nick Piggin, __revoke_break_cow() only needs to do
down_read() and we must use vma_pages() for get_user_pages().

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/revoke.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: uml-2.6/fs/revoke.c
===================================================================
--- uml-2.6.orig/fs/revoke.c	2007-03-28 12:25:29.000000000 +0300
+++ uml-2.6/fs/revoke.c	2007-03-28 12:54:49.000000000 +0300
@@ -184,7 +184,7 @@ static int __revoke_break_cow(struct tas
 	struct vm_area_struct *vma;
 	int err = 0;
 
-	down_write(&mm->mmap_sem);
+	down_read(&mm->mmap_sem);
 	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
 		int ret;
 
@@ -195,14 +195,13 @@ 	int err = 0;
 			continue;
 
 		ret = get_user_pages(tsk, tsk->mm, vma->vm_start,
-				     vma->vm_end-vma->vm_start, 1, 1, NULL,
-				     NULL);
+				     vma_pages(vma), 1, 1, NULL, NULL);
 		if (ret < 0) {
 			err = ret;
 			break;
 		}
 	}
-	up_write(&mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 	return err;
 }
 

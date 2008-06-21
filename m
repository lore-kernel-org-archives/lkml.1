Return-Path: <linux-kernel-owner+w=401wt.eu-S1752017AbYFUNjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbYFUNjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 09:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbYFUNjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 09:39:04 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51393 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbYFUNjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 09:39:03 -0400
Date: Sat, 21 Jun 2008 17:41:25 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] get_user_pages: minor code tweaks
Message-ID: <20080621134125.GA10854@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

1. Change the code from

	if (len <= 0)
		return;
	do {
	} while (len);

   to
	for (; len > 0; ) {
	}

   (I wonder what is the right behavior when len < 0. Currently we hide the
    caller's error and return 0. Perhaps it is better to test "len != 0" or
    turn this argument into "unsigned int").

2. Move "foll_flags |= FOLL_WRITE;" from the inner loop up.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/mm/memory.c~2_GUP_CLEANUP	2008-06-21 15:56:58.000000000 +0400
+++ 26-rc2/mm/memory.c	2008-06-21 17:26:06.000000000 +0400
@@ -1035,17 +1035,14 @@ int get_user_pages(struct task_struct *t
 	int i;
 	unsigned int vm_flags;
 
-	if (len <= 0)
-		return 0;
-	/* 
+	/*
 	 * Require read or write permissions.
 	 * If 'force' is set, we only require the "MAY" flags.
 	 */
 	vm_flags  = write ? (VM_WRITE | VM_MAYWRITE) : (VM_READ | VM_MAYREAD);
 	vm_flags &= force ? (VM_MAYREAD | VM_MAYWRITE) : (VM_READ | VM_WRITE);
-	i = 0;
 
-	do {
+	for (i = 0; len > 0; ) {
 		struct vm_area_struct *vma;
 		unsigned int foll_flags;
 
@@ -1102,8 +1099,10 @@ int get_user_pages(struct task_struct *t
 		foll_flags = FOLL_TOUCH;
 		if (pages)
 			foll_flags |= FOLL_GET;
-		if (!write && !(vma->vm_flags & VM_LOCKED) &&
-		    (!vma->vm_ops || !vma->vm_ops->fault))
+		if (write)
+			foll_flags |= FOLL_WRITE;
+		else if (!(vma->vm_flags & VM_LOCKED) &&
+				(!vma->vm_ops || !vma->vm_ops->fault))
 			foll_flags |= FOLL_ANON;
 
 		do {
@@ -1117,9 +1116,6 @@ int get_user_pages(struct task_struct *t
 			if (unlikely(test_tsk_thread_flag(tsk, TIF_MEMDIE)))
 				return i ? i : -ENOMEM;
 
-			if (write)
-				foll_flags |= FOLL_WRITE;
-
 			cond_resched();
 			while (!(page = follow_page(vma, start, foll_flags))) {
 				int ret;
@@ -1163,7 +1159,7 @@ int get_user_pages(struct task_struct *t
 			start += PAGE_SIZE;
 			len--;
 		} while (len && start < vma->vm_end);
-	} while (len);
+	}
 	return i;
 }
 EXPORT_SYMBOL(get_user_pages);


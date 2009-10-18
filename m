Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbZJRLke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbZJRLke (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 07:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZJRLkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 07:40:33 -0400
Received: from ozlabs.org ([203.10.76.45]:37719 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbZJRLkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 07:40:33 -0400
Date: Sun, 18 Oct 2009 22:39:08 +1100
From: Anton Blanchard <anton@samba.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] exec: setup_arg_pages fails to return errors
Message-ID: <20091018113908.GR4808@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In setup_arg_pages we work hard to assign a value to ret, but on exit
we always return 0.

Also remove a now duplicated exit path and branch to out_unlock instead.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/fs/exec.c
===================================================================
--- linux.trees.git.orig/fs/exec.c	2009-09-28 12:17:10.000000000 +1000
+++ linux.trees.git/fs/exec.c	2009-09-28 12:17:58.000000000 +1000
@@ -624,10 +624,8 @@ int setup_arg_pages(struct linux_binprm 
 	/* Move stack pages down in memory. */
 	if (stack_shift) {
 		ret = shift_arg_pages(vma, stack_shift);
-		if (ret) {
-			up_write(&mm->mmap_sem);
-			return ret;
-		}
+		if (ret)
+			goto out_unlock;
 	}
 
 #ifdef CONFIG_STACK_GROWSUP
@@ -641,7 +639,7 @@ int setup_arg_pages(struct linux_binprm 
 
 out_unlock:
 	up_write(&mm->mmap_sem);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(setup_arg_pages);
 

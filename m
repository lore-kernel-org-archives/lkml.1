Return-Path: <linux-kernel-owner+w=401wt.eu-S1031164AbXDZKpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031164AbXDZKpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031168AbXDZKpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:45:33 -0400
Received: from ozlabs.org ([203.10.76.45]:52568 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031164AbXDZKpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:45:31 -0400
Subject: [PATCH] Fix lguest oops when guest dies while receiving I/O
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 20:45:10 +1000
Message-Id: <1177584310.30071.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lguest needs to hold a reference to its task in case it exits while
another Guest is sending it I/O.  Otherwise we can oops in
access_process_vm->get_task_mm->task_lock().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/lguest_user.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

===================================================================
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -107,7 +107,8 @@ static int initialize(struct file *file,
 	setup_regs(lg->regs, args[2]);
 	setup_guest_gdt(lg);
 	lg->tsk = current;
-	lg->mm = get_task_mm(current);
+	get_task_struct(lg->tsk);
+	lg->mm = get_task_mm(lg->tsk);
 	lg->last_pages = NULL;
 	mutex_unlock(&lguest_lock);
 
@@ -160,6 +161,7 @@ static int close(struct inode *inode, st
 	mutex_lock(&lguest_lock);
 	release_all_dma(lg);
 	free_guest_pagetable(lg);
+	put_task_struct(lg->tsk);
 	mmput(lg->mm);
 	if (!IS_ERR(lg->dead))
 		kfree(lg->dead);



Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbZAXEoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbZAXEoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 23:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbZAXEoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 23:44:05 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:34100 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbZAXEoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 23:44:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PNbAlf3W7JV+igaLQrFQPjh2wCrjwpNc8lp1yNfwI9SvEjA3KJ58oE6bZ5QnWNuGSt
         wzqqIv1PWWNt+fXrkP4CFvpYKNzH6hSNoR3tnNXBzn6EJr6T3ZoICjezyGZW4vwDgF02
         BSlzvD0HpVJ6aibSsqL3GdSso9qv0GQT9thHA=
From: Cheng Renquan <crquan@gmail.com>
To: Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, cr_quan@163.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] do_pipe cleanup: drop its last user in arch/alpha/
Date: Sat, 24 Jan 2009 12:43:50 +0800
Message-Id: <1232772231-6523-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last user of do_pipe is in arch/alpha/, after replacing it with
do_pipe_flags, the do_pipe can be eventually dropped.

Signed-off-by: Cheng Renquan <crquan@gmail.com>
Acked-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/kernel/entry.S   |    3 ++-
 arch/alpha/kernel/osf_sys.c |    2 +-
 fs/pipe.c                   |    5 -----
 include/linux/fs.h          |    1 -
 4 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
index aa2e50c..9031eb5 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -903,8 +903,9 @@ sys_alpha_pipe:
 	stq	$26, 0($sp)
 	.prologue 0
 
+	mov	$31, $17
 	lda	$16, 8($sp)
-	jsr	$26, do_pipe
+	jsr	$26, do_pipe_flags
 
 	ldq	$26, 0($sp)
 	bne	$0, 1f
diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 18a3ea1..5c1678e 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -46,7 +46,7 @@
 #include <asm/hwrpb.h>
 #include <asm/processor.h>
 
-extern int do_pipe(int *);
+extern int do_pipe_flags(int *, int);
 
 /*
  * Brk needs to return an error.  Still support Linux's brk(0) query idiom,
diff --git a/fs/pipe.c b/fs/pipe.c
index 3a48ba5..365120c 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1034,11 +1034,6 @@ int do_pipe_flags(int *fd, int flags)
 	return error;
 }
 
-int do_pipe(int *fd)
-{
-	return do_pipe_flags(fd, 0);
-}
-
 /*
  * sys_pipe() is the normal C calling standard for creating
  * a pipe. It's not the way Unix traditionally does this, though.
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6022f44..9c0494c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1875,7 +1875,6 @@ static inline void allow_write_access(struct file *file)
 	if (file)
 		atomic_inc(&file->f_path.dentry->d_inode->i_writecount);
 }
-extern int do_pipe(int *);
 extern int do_pipe_flags(int *, int);
 extern struct file *create_read_pipe(struct file *f, int flags);
 extern struct file *create_write_pipe(int flags);
-- 
1.6.0.6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1751629AbZIWXC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbZIWXC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 19:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZIWXC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 19:02:56 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:39129 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986AbZIWXCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:02:55 -0400
Date: Thu, 24 Sep 2009 01:02:55 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Revert "kmod: fix race in usermodehelper code"
Message-ID: <20090923230255.GA18878@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit c02e3f361:
|Author: Neil Horman <nhorman@tuxdriver.com>
|Date:   Tue Sep 22 16:43:36 2009 -0700
|
|    kmod: fix race in usermodehelper code
|
|    The user mode helper code has a race in it.  call_usermodehelper_exec()
|    takes an allocated subprocess_info structure, which it passes to a
|    workqueue, and then passes it to a kernel thread which it creates, after
|    which it calls complete to signal to the caller of
|    call_usermodehelper_exec() that it can free the subprocess_info struct.
|
|    But since we use that structure in the created thread, we can't call
|    complete from __call_usermodehelper(), which is where we create the kernel
|    thread.  We need to call complete() from within the kernel thread and then
|    not use subprocess_info afterward in the case of UMH_WAIT_EXEC.  Tested
|    successfully by me.
|
|    Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
|    Cc: Rusty Russell <rusty@rustcorp.com.au>
|    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
|    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

The pach is wrong IMHO. UMH_WAIT_EXEC is called with VFORK what ensures
that the child finishes prior returing back to the parent. No race. The patch
makes it even worse because it does the thing it claims not do:
- It calls ->complete() on UMH_WAIT_EXEC
- the complete() callback may de-allocated subinfo
As seen in the following call chain:
|[<c009f904>] (__link_path_walk+0x20/0xeb4) from [<c00a094c>] (path_walk+0x48/0x94)
|[<c00a094c>] (path_walk+0x48/0x94) from [<c00a0a34>] (do_path_lookup+0x24/0x4c)
|[<c00a0a34>] (do_path_lookup+0x24/0x4c) from [<c00a158c>] (do_filp_open+0xa4/0x83c)
|[<c00a158c>] (do_filp_open+0xa4/0x83c) from [<c009ba90>] (open_exec+0x24/0xe0)
|[<c009ba90>] (open_exec+0x24/0xe0) from [<c009bfa8>] (do_execve+0x7c/0x2e4)
|[<c009bfa8>] (do_execve+0x7c/0x2e4) from [<c0026a80>] (kernel_execve+0x34/0x80)
|[<c0026a80>] (kernel_execve+0x34/0x80) from [<c004b514>] (____call_usermodehelper+0x130/0x148)
|[<c004b514>] (____call_usermodehelper+0x130/0x148) from [<c0024858>] (kernel_thread_exit+0x0/0x8)

And the path pointer was NULL. Good that ARM's kernel_execve() doesn't
check the pointer for NULL or else I wouldn't notice it.

The only race there might be is with UMH_NO_WAIT but it is too late for
me to investigate it now. UMH_WAIT_PROC could probably also use VFORK
and we could save one exec. So the only race I see is with UMH_NO_WAIT
and recent scheduler changes where the child does not always run first
might have trigger here something but as I said, it is late....

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 kernel/kmod.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 689d20f..9fcb53a 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -143,7 +143,6 @@ struct subprocess_info {
 static int ____call_usermodehelper(void *data)
 {
 	struct subprocess_info *sub_info = data;
-	enum umh_wait wait = sub_info->wait;
 	int retval;
 
 	BUG_ON(atomic_read(&sub_info->cred->usage) != 1);
@@ -185,14 +184,10 @@ static int ____call_usermodehelper(void *data)
 	 */
 	set_user_nice(current, 0);
 
-	if (wait == UMH_WAIT_EXEC)
-		complete(sub_info->complete);
-
 	retval = kernel_execve(sub_info->path, sub_info->argv, sub_info->envp);
 
 	/* Exec failed? */
-	if (wait != UMH_WAIT_EXEC)
-		sub_info->retval = retval;
+	sub_info->retval = retval;
 	do_exit(0);
 }
 
@@ -271,14 +266,16 @@ static void __call_usermodehelper(struct work_struct *work)
 
 	switch (wait) {
 	case UMH_NO_WAIT:
-	case UMH_WAIT_EXEC:
 		break;
 
 	case UMH_WAIT_PROC:
 		if (pid > 0)
 			break;
 		sub_info->retval = pid;
-		break;
+		/* FALLTHROUGH */
+
+	case UMH_WAIT_EXEC:
+		complete(sub_info->complete);
 	}
 }
 
-- 
1.6.4.GIT


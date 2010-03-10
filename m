Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab0CJRSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:18:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab0CJRSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:18:39 -0500
Date: Wed, 10 Mar 2010 18:16:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH] wait_for_helper: SIGCHLD from user-space can lead to
	use-after-free
Message-ID: <20100310171634.GA1039@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(this patch is orthogonal to other umh changes in -mm)

1. wait_for_helper() does allow_signal(SIGCHLD) to ensure the child can't
   autoreap itself.

   However, this means that a spurious SIGCHILD from user-space can
   set TIF_SIGPENDING and:

   	- kernel_thread() or sys_wait4() can fail due to signal_pending()

   	- worse, wait4() can fail before ____call_usermodehelper() execs
   	  or exits. In this case the caller may kfree(subprocess_info)
   	  while the child still uses this memory.

   Change the code to use SIG_DFL instead of magic "(void __user *)2"
   set by allow_signal(). This means that SIGCHLD won't be delivered,
   yet the child won't autoreap itsefl.

   The problem is minor, only root can send a signal to this kthread.

2. If sys_wait4(&ret) fails it doesn't populate "ret", in this case
   wait_for_helper() reports a random value from uninitialized var.

   With this patch sys_wait4() should never fail, but still it makes
   sense to initialize ret = -ECHILD so that the caller can notice
   the problem.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/kmod.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- mm/kernel/kmod.c~4_SIGCHLD_RACE	2010-03-09 22:23:37.000000000 +0100
+++ mm/kernel/kmod.c	2010-03-10 17:36:37.000000000 +0100
@@ -194,15 +194,16 @@ static int wait_for_helper(void *data)
 	struct subprocess_info *sub_info = data;
 	pid_t pid;
 
-	/* Install a handler: if SIGCLD isn't handled sys_wait4 won't
-	 * populate the status, but will return -ECHILD. */
-	allow_signal(SIGCHLD);
+	/* If SIGCLD is ignored sys_wait4 won't populate the status. */
+	spin_lock_irq(&current->sighand->siglock);
+	current->sighand->action[SIGCHLD-1].sa.sa_handler = SIG_DFL;
+	spin_unlock_irq(&current->sighand->siglock);
 
 	pid = kernel_thread(____call_usermodehelper, sub_info, SIGCHLD);
 	if (pid < 0) {
 		sub_info->retval = pid;
 	} else {
-		int ret;
+		int ret = -ECHILD;
 
 		/*
 		 * Normally it is bogus to call wait4() from in-kernel because


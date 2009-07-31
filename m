Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbZGaWka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbZGaWka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 18:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbZGaWk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 18:40:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46005 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZGaWk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 18:40:29 -0400
Date: Sat, 1 Aug 2009 00:29:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, drepper@redhat.com,
       jens@mcbone.net, mingo@elte.hu, peterz@infradead.org,
       sonnyrao@us.ibm.com, stable@kernel.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: + execve-must-clear-current-clear_child_tid.patch added to -mm
	tree
Message-ID: <20090731222959.GA8195@redhat.com>
References: <200907312142.n6VLgKfx021454@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907312142.n6VLgKfx021454@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Eric Dumazet <eric.dumazet@gmail.com>
>
> diff -puN fs/compat.c~execve-must-clear-current-clear_child_tid fs/compat.c
> --- a/fs/compat.c~execve-must-clear-current-clear_child_tid
> +++ a/fs/compat.c
> @@ -1550,6 +1550,7 @@ int compat_do_execve(char * filename,
>  	mutex_unlock(&current->cred_guard_mutex);
>  	acct_update_integrals(current);
>  	free_bprm(bprm);
> +	current->clear_child_tid = NULL;
>  	if (displaced)
>  		put_files_struct(displaced);
>  	return retval;
> diff -puN fs/exec.c~execve-must-clear-current-clear_child_tid fs/exec.c
> --- a/fs/exec.c~execve-must-clear-current-clear_child_tid
> +++ a/fs/exec.c
> @@ -1343,6 +1343,7 @@ int do_execve(char * filename,
>  	mutex_unlock(&current->cred_guard_mutex);
>  	acct_update_integrals(current);
>  	free_bprm(bprm);
> +	current->clear_child_tid = NULL;
>  	if (displaced)
>  		put_files_struct(displaced);
>  	return retval;

Perhaps it is better to change mm_release() ? It has to play with
->clear_child_tid anyway.

Oleg.

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -568,18 +568,18 @@ void mm_release(struct task_struct *tsk,
 	 * the value intact in a core dump, and to save the unnecessary
 	 * trouble otherwise.  Userland only wants this done for a sys_exit.
 	 */
-	if (tsk->clear_child_tid
-	    && !(tsk->flags & PF_SIGNALED)
-	    && atomic_read(&mm->mm_users) > 1) {
-		u32 __user * tidptr = tsk->clear_child_tid;
+	if (tsk->clear_child_tid) {
+		if (!(tsk->flags & PF_SIGNALED) &&
+		    atomic_read(&mm->mm_users) > 1) {
+			/*
+			 * We don't check the error code - if userspace has
+			 * not set up a proper pointer then tough luck.
+			 */
+			put_user(0, tsk->clear_child_tid);
+			sys_futex(tsk->clear_child_tid, FUTEX_WAKE,
+					1, NULL, NULL, 0);
+		}
 		tsk->clear_child_tid = NULL;
-
-		/*
-		 * We don't check the error code - if userspace has
-		 * not set up a proper pointer then tough luck.
-		 */
-		put_user(0, tidptr);
-		sys_futex(tidptr, FUTEX_WAKE, 1, NULL, NULL, 0);
 	}
 }
 


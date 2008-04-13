Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbYDMI74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbYDMI74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 04:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYDMI7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 04:59:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbYDMI7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 04:59:44 -0400
Date: Sun, 13 Apr 2008 01:59:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [PATCH 1/2] fix sys_unshare()+SEM_UNDO: add support for
 CLONE_SYSVSEM
Message-Id: <20080413015936.580bf7fe.akpm@linux-foundation.org>
In-Reply-To: <200804130848.m3D8mU7D007104@mail.q-ag.de>
References: <200804130848.m3D8mU7D007104@mail.q-ag.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 10:04:17 +0200 Manfred Spraul <manfred@colorfullife.com> wrote:

> sys_unshare(CLONE_NEWIPC) doesn't handle the undo lists properly, this can
> cause a kernel memory corruption. CLONE_NEWIPC must detach from the existing
> undo lists.
> Fix, part 1: add support for sys_unshare(CLONE_SYSVSEM)
> 

Is this a non-back-compatible change?

> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> ---
>  ipc/sem.c     |    1 +
>  kernel/fork.c |   18 ++++++++++++++----
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 0b45a4d..35841bd 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -1298,6 +1298,7 @@ void exit_sem(struct task_struct *tsk)
>  	undo_list = tsk->sysvsem.undo_list;
>  	if (!undo_list)
>  		return;
> +	tsk->sysvsem.undo_list = NULL;
>  
>  	if (!atomic_dec_and_test(&undo_list->refcnt))
>  		return;
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 9c042f9..7f242b0 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1675,13 +1675,17 @@ static int unshare_fd(unsigned long unshare_flags, struct files_struct **new_fdp
>  }
>  
>  /*
> - * Unsharing of semundo for tasks created with CLONE_SYSVSEM is not
> - * supported yet
> + * Unsharing of semundo for tasks created with CLONE_SYSVSEM doesn't require
> + * any allocations: it means that the task leaves the existing undo lists,
> + * just like sys_exit(). The new undo lists are allocated on demand in the
> + * ipc syscalls.
> + * new_ulistp is set to a non-NULL value, the caller expects that on success.
>   */
>  static int unshare_semundo(unsigned long unshare_flags, struct sem_undo_list **new_ulistp)
>  {
> -	if (unshare_flags & CLONE_SYSVSEM)
> -		return -EINVAL;
> +	if (unshare_flags & CLONE_SYSVSEM) {
> +		*new_ulistp = (void*)1;
> +	}

And can we do anything nicer than this?

>  	return 0;
>  }
> @@ -1731,6 +1735,12 @@ asmlinkage long sys_unshare(unsigned long unshare_flags)
>  		goto bad_unshare_cleanup_semundo;
>  
>  	if (new_fs ||  new_mm || new_fd || new_ulist || new_nsproxy) {
> +		if (unshare_flags & CLONE_SYSVSEM) {
> +			/*
> +			 * CLONE_SYSVSEM is equivalent to sys_exit().
> +			 */
> +			exit_sem(current);
> +		}
>  
>  		if (new_nsproxy) {
>  			switch_task_namespaces(current, new_nsproxy);
> -- 
> 1.5.4.1

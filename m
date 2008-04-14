Return-Path: <linux-kernel-owner+w=401wt.eu-S1760624AbYDNO6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624AbYDNO6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYDNO6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:58:45 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34629 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbYDNO6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:58:44 -0400
Date: Mon, 14 Apr 2008 09:58:40 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Pierre PEIFFER <pierre.peiffer@bull.net>
Subject: Re: [PATCH 1/2] fix sys_unshare()+SEM_UNDO: add support for
	CLONE_SYSVSEM
Message-ID: <20080414145840.GA15667@sergelap.austin.ibm.com>
References: <200804130848.m3D8mU7D007104@mail.q-ag.de> <20080413015936.580bf7fe.akpm@linux-foundation.org> <4801F038.8020003@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4801F038.8020003@colorfullife.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Manfred Spraul (manfred@colorfullife.com):
> Andrew Morton wrote:
>> On Sun, 13 Apr 2008 10:04:17 +0200 Manfred Spraul 
>> <manfred@colorfullife.com> wrote:
>>
>>   
>>> sys_unshare(CLONE_NEWIPC) doesn't handle the undo lists properly, this 
>>> can
>>> cause a kernel memory corruption. CLONE_NEWIPC must detach from the 
>>> existing
>>> undo lists.
>>> Fix, part 1: add support for sys_unshare(CLONE_SYSVSEM)
>>>
>>>     
>>
>> Is this a non-back-compatible change?
>>
>>   
> It adds a new feature - previously sys_unshare(CLONE_SYSVSEM) returned 
> -EINVAL.
>
>>> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
>>> ---
>>>  ipc/sem.c     |    1 +
>>>  kernel/fork.c |   18 ++++++++++++++----
>>>  2 files changed, 15 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/ipc/sem.c b/ipc/sem.c
>>> index 0b45a4d..35841bd 100644
>>> --- a/ipc/sem.c
>>> +++ b/ipc/sem.c
>>> @@ -1298,6 +1298,7 @@ void exit_sem(struct task_struct *tsk)
>>>  	undo_list = tsk->sysvsem.undo_list;
>>>  	if (!undo_list)
>>>  		return;
>>> +	tsk->sysvsem.undo_list = NULL;
>>>   	if (!atomic_dec_and_test(&undo_list->refcnt))
>>>  		return;
>>> diff --git a/kernel/fork.c b/kernel/fork.c
>>> index 9c042f9..7f242b0 100644
>>> --- a/kernel/fork.c
>>> +++ b/kernel/fork.c
>>> @@ -1675,13 +1675,17 @@ static int unshare_fd(unsigned long 
>>> unshare_flags, struct files_struct **new_fdp
>>>  }
>>>   /*
>>> - * Unsharing of semundo for tasks created with CLONE_SYSVSEM is not
>>> - * supported yet
>>> + * Unsharing of semundo for tasks created with CLONE_SYSVSEM doesn't 
>>> require
>>> + * any allocations: it means that the task leaves the existing undo 
>>> lists,
>>> + * just like sys_exit(). The new undo lists are allocated on demand in 
>>> the
>>> + * ipc syscalls.
>>> + * new_ulistp is set to a non-NULL value, the caller expects that on 
>>> success.
>>>   */
>>>  static int unshare_semundo(unsigned long unshare_flags, struct 
>>> sem_undo_list **new_ulistp)
>>>  {
>>> -	if (unshare_flags & CLONE_SYSVSEM)
>>> -		return -EINVAL;
>>> +	if (unshare_flags & CLONE_SYSVSEM) {
>>> +		*new_ulistp = (void*)1;
>>> +	}
>>>     
>>
>> And can we do anything nicer than this?
>>
>>   
> Attached is an alternative. If you prefer it, I'll send another patch set.

FWIW I definately far far prefer this version  :)

As for 'maintainers', in the end wrt this code I'd defer to any two of
Pavel, Nadia, and Pierre, each of who I've seen do a great deal of
digging around this code.

(I think I saw some set of these go into -mm so I guess I'll just grab
mmotm and test with that a bit later today)

thanks,
-serge

> --
>    Manfred

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
> index 9c042f9..535aa92 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1675,18 +1675,6 @@ static int unshare_fd(unsigned long unshare_flags, struct files_struct **new_fdp
>  }
> 
>  /*
> - * Unsharing of semundo for tasks created with CLONE_SYSVSEM is not
> - * supported yet
> - */
> -static int unshare_semundo(unsigned long unshare_flags, struct sem_undo_list **new_ulistp)
> -{
> -	if (unshare_flags & CLONE_SYSVSEM)
> -		return -EINVAL;
> -
> -	return 0;
> -}
> -
> -/*
>   * unshare allows a process to 'unshare' part of the process
>   * context which was originally shared using clone.  copy_*
>   * functions used by do_fork() cannot be used here directly
> @@ -1701,7 +1689,6 @@ asmlinkage long sys_unshare(unsigned long unshare_flags)
>  	struct sighand_struct *new_sigh = NULL;
>  	struct mm_struct *mm, *new_mm = NULL, *active_mm = NULL;
>  	struct files_struct *fd, *new_fd = NULL;
> -	struct sem_undo_list *new_ulist = NULL;
>  	struct nsproxy *new_nsproxy = NULL;
> 
>  	check_unshare_flags(&unshare_flags);
> @@ -1724,13 +1711,17 @@ asmlinkage long sys_unshare(unsigned long unshare_flags)
>  		goto bad_unshare_cleanup_sigh;
>  	if ((err = unshare_fd(unshare_flags, &new_fd)))
>  		goto bad_unshare_cleanup_vm;
> -	if ((err = unshare_semundo(unshare_flags, &new_ulist)))
> -		goto bad_unshare_cleanup_fd;
>  	if ((err = unshare_nsproxy_namespaces(unshare_flags, &new_nsproxy,
>  			new_fs)))
> -		goto bad_unshare_cleanup_semundo;
> +		goto bad_unshare_cleanup_fd;
> 
> -	if (new_fs ||  new_mm || new_fd || new_ulist || new_nsproxy) {
> +	if (new_fs ||  new_mm || new_fd || (unshare_flags & CLONE_SYSVSEM) || new_nsproxy) {
> +		if (unshare_flags & CLONE_SYSVSEM) {
> +			/*
> +			 * CLONE_SYSVSEM is equivalent to sys_exit().
> +			 */
> +			exit_sem(current);
> +		}
> 
>  		if (new_nsproxy) {
>  			switch_task_namespaces(current, new_nsproxy);
> @@ -1766,7 +1757,6 @@ asmlinkage long sys_unshare(unsigned long unshare_flags)
>  	if (new_nsproxy)
>  		put_nsproxy(new_nsproxy);
> 
> -bad_unshare_cleanup_semundo:
>  bad_unshare_cleanup_fd:
>  	if (new_fd)
>  		put_files_struct(new_fd);


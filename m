Return-Path: <linux-kernel-owner+w=401wt.eu-S1752019AbZHAGUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbZHAGUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 02:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZHAGUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 02:20:52 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:52368 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbZHAGUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 02:20:51 -0400
Message-ID: <4A73DCBE.7080309@gmail.com>
Date: Sat, 01 Aug 2009 08:12:14 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, drepper@redhat.com, jens@mcbone.net,
       mingo@elte.hu, peterz@infradead.org, sonnyrao@us.ibm.com,
       stable@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH v2] execve: must clear current->clear_child_tid
References: <200907312142.n6VLgKfx021454@imap1.linux-foundation.org> <20090731222959.GA8195@redhat.com> <alpine.LFD.2.01.0907311732250.3304@localhost.localdomain> <20090731175101.1699d653.akpm@linux-foundation.org> <20090801015434.GA755@redhat.com>
In-Reply-To: <20090801015434.GA755@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 01 Aug 2009 08:12:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov a écrit :
> On 07/31, Andrew Morton wrote:
>> On Fri, 31 Jul 2009 17:38:14 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>>>
>>> On Sat, 1 Aug 2009, Oleg Nesterov wrote:
>>>> Perhaps it is better to change mm_release() ? It has to play with
>>>> ->clear_child_tid anyway.
>>> Ahh. I take back my previous Ack. Your patch is better. I'll ack that
>>> instead.
>>>
>> 'k, thanks.  I shall compulsively watch my inbox awaiting the signed-off
>> and tested version ;)
> 
> I did some testing, but didn't try to check if this patches fixes the
> origianal problem. It obviously should... Still I removed Tested-by tag.
> But added Linus's ack, the patch is the same.
> 
> ------------------------------------------------------------------------------
> [PATCH v2] execve: must clear current->clear_child_tid
> 
> From: Eric Dumazet <eric.dumazet@gmail.com>
> 
> While looking at Jens Rosenboom bug report
> (http://lkml.org/lkml/2009/7/27/35) about strange sys_futex call done from
> a dying "ps" program, we found following problem.
> 
> clone() syscall has special support for TID of created threads.  This
> support includes two features.
> 
> One (CLONE_CHILD_SETTID) is to set an integer into user memory with the
> TID value.
> 
> One (CLONE_CHILD_CLEARTID) is to clear this same integer once the created
> thread dies.
> 
> The integer location is a user provided pointer, provided at clone()
> time.
> 
> kernel keeps this pointer value into current->clear_child_tid.
> 
> At execve() time, we should make sure kernel doesnt keep this user
> provided pointer, as full user memory is replaced by a new one.
> 
> As glibc fork() actually uses clone() syscall with CLONE_CHILD_SETTID and
> CLONE_CHILD_CLEARTID set, chances are high that we might corrupt user
> memory in forked processes.
> 
> Following sequence could happen:
> 
> 1) bash (or any program) starts a new process, by a fork() call that
>    glibc maps to a clone( ...  CLONE_CHILD_SETTID | CLONE_CHILD_CLEARTID
>    ...) syscall
> 
> 2) When new process starts, its current->clear_child_tid is set to a
>    location that has a meaning only in bash (or initial program) context
>    (&THREAD_SELF->tid)
> 
> 3) This new process does the execve() syscall to start a new program. 
>    current->clear_child_tid is left unchanged (a non NULL value)
> 
> 4) If this new program creates some threads, and initial thread exits,
>    kernel will attempt to clear the integer pointed by
>    current->clear_child_tid from mm_release() :
> 
>         if (tsk->clear_child_tid
>             && !(tsk->flags & PF_SIGNALED)
>             && atomic_read(&mm->mm_users) > 1) {
>                 u32 __user * tidptr = tsk->clear_child_tid;
>                 tsk->clear_child_tid = NULL;
> 
>                 /*
>                  * We don't check the error code - if userspace has
>                  * not set up a proper pointer then tough luck.
>                  */
> << here >>      put_user(0, tidptr);
>                 sys_futex(tidptr, FUTEX_WAKE, 1, NULL, NULL, 0);
>         }
> 
> 5) OR : if new program is not multi-threaded, but spied by /proc/pid
>    users (ps command for example), mm_users > 1, and the exiting program
>    could corrupt 4 bytes in a persistent memory area (shm or memory mapped
>    file)
> 
> If current->clear_child_tid points to a writeable portion of memory of the
> new program, kernel happily and silently corrupts 4 bytes of memory, with
> unexpected effects.
> 
> Fix is straightforward and should not break any sane program.
> 
> Reported-by: Jens Rosenboom <jens@mcbone.net>
> Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  kernel/fork.c |   22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> --- WAIT/kernel/fork.c~CLEARTID	2009-07-02 19:27:36.000000000 +0200
> +++ WAIT/kernel/fork.c	2009-08-01 03:36:59.000000000 +0200
> @@ -568,18 +568,18 @@ void mm_release(struct task_struct *tsk,
>  	 * the value intact in a core dump, and to save the unnecessary
>  	 * trouble otherwise.  Userland only wants this done for a sys_exit.
>  	 */
> -	if (tsk->clear_child_tid
> -	    && !(tsk->flags & PF_SIGNALED)
> -	    && atomic_read(&mm->mm_users) > 1) {
> -		u32 __user * tidptr = tsk->clear_child_tid;
> +	if (tsk->clear_child_tid) {
> +		if (!(tsk->flags & PF_SIGNALED) &&
> +		    atomic_read(&mm->mm_users) > 1) {
> +			/*
> +			 * We don't check the error code - if userspace has
> +			 * not set up a proper pointer then tough luck.
> +			 */
> +			put_user(0, tsk->clear_child_tid);
> +			sys_futex(tsk->clear_child_tid, FUTEX_WAKE,
> +					1, NULL, NULL, 0);
> +		}
>  		tsk->clear_child_tid = NULL;
> -
> -		/*
> -		 * We don't check the error code - if userspace has
> -		 * not set up a proper pointer then tough luck.
> -		 */
> -		put_user(0, tidptr);
> -		sys_futex(tidptr, FUTEX_WAKE, 1, NULL, NULL, 0);
>  	}
>  }
>  
> 

Thanks Oleg, you are right this seems cleaner.

I only wonder about core dumping, since mm_release() is also used by exiting tasks.

Isnt clear_child_tid used by gdb or other debugger ?
(The tid value is carefuly untouched in case of a core dump, but maybe
gdb needs the current->clear_child_tid for whatever reason, for example
to get TID address in user memory ?


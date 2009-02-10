Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbZBJUTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbZBJUTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZBJUS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:18:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753869AbZBJUS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:18:56 -0500
Date: Tue, 10 Feb 2009 12:08:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: mingo@elte.hu, markus.t.metzger@intel.com, roland@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, for 2.6.29] ptrace: fix the usage of ptrace_fork()
Message-Id: <20090210120808.60fa0d7b.akpm@linux-foundation.org>
In-Reply-To: <20090209010233.GA26444@redhat.com>
References: <20090209010233.GA26444@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 02:02:33 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> I noticed by pure accident we have ptrace_fork() and friends. This was
> added by "x86, bts: add fork and exit handling", commit
> bf53de907dfdaac178c92d774aae7370d7b97d20
> 
> I can't test this, ds_request_bts() returns -EOPNOTSUPP, but I strongly
> believe this needs the fix. I think something like this program
> 
> 	int main(void)
> 	{
> 		int pid = fork();
> 
> 		if (!pid) {
> 			ptrace(PTRACE_TRACEME, 0, NULL, NULL);
> 			kill(getpid(), SIGSTOP);
> 			fork();
> 		} else {
> 			struct ptrace_bts_config bts = {
> 				.flags = PTRACE_BTS_O_ALLOC,
> 				.size  = 4 * 4096,
> 			};
> 
> 			wait(NULL);
> 
> 			ptrace(PTRACE_SETOPTIONS, pid, NULL, PTRACE_O_TRACEFORK);
> 			ptrace(PTRACE_BTS_CONFIG, pid, &bts, sizeof(bts));
> 			ptrace(PTRACE_CONT, pid, NULL, NULL);
> 
> 			sleep(1);
> 		}
> 
> 		return 0;
> 	}
> 
> should crash the kernel.
> 
> If the task is traced by its natural parent ptrace_reparented() returns 0
> but we should clear ->btsxxx anyway.
> 
> This is a minimal fix for 2.6.29, we need further cleanups imho.
> 

This changelog is all a bit tentative-sounding.

> 
> --- 6.29-rc3/kernel/fork.c~BTS_FIX	2009-01-29 01:13:55.000000000 +0100
> +++ 6.29-rc3/kernel/fork.c	2009-02-09 01:03:48.000000000 +0100
> @@ -1093,7 +1093,7 @@ static struct task_struct *copy_process(
>  #ifdef CONFIG_DEBUG_MUTEXES
>  	p->blocked_on = NULL; /* not blocked yet */
>  #endif
> -	if (unlikely(ptrace_reparented(current)))
> +	if (unlikely(current->ptrace))
>  		ptrace_fork(p, clone_flags);
>  
>  	/* Perform scheduler related setup. Assign this task to a CPU. */

Can we please confirm that this patch is indeed correct and needed?

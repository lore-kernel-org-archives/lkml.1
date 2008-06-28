Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYF1NeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYF1NeF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 09:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYF1Ndz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 09:33:55 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:53436 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbYF1Ndy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 09:33:54 -0400
Date: Sat, 28 Jun 2008 17:36:28 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: elf_core_dump: skip kernel threads
Message-ID: <20080628133628.GA4434@tv-sign.ru>
References: <20080616162603.GA21028@tv-sign.ru> <20080627204953.C2A49154224@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627204953.C2A49154224@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19, Roland McGrath wrote:
>
> Perhaps a little prettier like this:
> 
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -1469,6 +1469,12 @@ static int fill_thread_core_info(struct 
>  	return 1;
>  }
>  
> +static bool is_dump_thread(struct task_struct *dump_task,
> +			   struct task_struct *thread)
> +{
> +	return !(thread->flags & PF_KTHREAD) && thread->mm == dump_task->mm;
> +}
> +
>  static int fill_note_info(struct elfhdr *elf, int phdrs,
>  			  struct elf_note_info *info,
>  			  long signr, struct pt_regs *regs)
> @@ -1518,7 +1524,7 @@ static int fill_note_info(struct elfhdr 
>  	 */
>  	rcu_read_lock();
>  	do_each_thread(g, p)
> -		if (p->mm == dump_task->mm) {
> +		if (is_dump_thread(dump_task, p)) {
>  			t = kzalloc(offsetof(struct elf_thread_core_info,
>  					     notes[info->thread_notes]),
>  				    GFP_ATOMIC);

Agreed.

> > It is sad we have to iterate over all threads in system and use GFP_ATOMIC.
> > Hopefully we can kill theses ugly do_each_thread()s, but this needs some
> > nontrivial changes in mm_struct and do_coredump.
> 
> Agreed, and twice at that (coredump_wait).  But this is something more to
> consider for the future, and I wouldn't worry about it right now.

In most cases coredump_wait() doesn't need to do for_each_process().

And I think there are other reasons to kill these do_each_thread()s.
We can simplify the code and make the coredumping process visible to
oom_kill. I sent the preparatory patches.

Oleg.


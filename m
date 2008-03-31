Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbYCaKMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbYCaKMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 06:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbYCaKMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 06:12:38 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:39600 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbYCaKMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 06:12:37 -0400
Date: Mon, 31 Mar 2008 13:12:15 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ptrace children revamp
Message-ID: <20080331091215.GB400@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain> <alpine.LFD.1.00.0803290906050.14670@woody.linux-foundation.org> <20080331035701.3926726F8E9@magilla.localdomain> <20080331035912.894A826F8E9@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331035912.894A826F8E9@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Roland McGrath wrote:
>
> +static void ptrace_exit(struct task_struct *parent, struct list_head *dead)
>  {
> -	if (p->pdeath_signal)
> -		/* We already hold the tasklist_lock here.  */
> -		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
> +	struct task_struct *p, *n;
>  
> -	/* Move the child from its dying parent to the new one.  */
> -	if (unlikely(traced)) {
> -		/* Preserve ptrace links if someone else is tracing this child.  */
> -		list_del_init(&p->ptrace_list);
> -		if (p->parent != p->real_parent)
> -			list_add(&p->ptrace_list, &p->real_parent->ptrace_children);
> -	} else {
> -		/* If this child is being traced, then we're the one tracing it
> -		 * anyway, so let go of it.
> -		 */
> -		p->ptrace = 0;
> -		remove_parent(p);
> -		p->parent = p->real_parent;
> -		add_parent(p);
> +	list_for_each_entry_safe(p, n, &parent->ptrace_attach, ptrace_list) {
> +		__ptrace_unlink(p);
>  
> -		if (task_is_traced(p)) {
> -			/*
> -			 * If it was at a trace stop, turn it into
> -			 * a normal stop since it's no longer being
> -			 * traced.
> -			 */
> -			ptrace_untrace(p);
> +		/*
> +		 * If it's a zombie, our attachedness prevented normal
> +		 * parent notification or self-reaping.  Do notification
> +		 * now if it would have happened earlier.  If it should
> +		 * reap itself, add it to the @dead list.  We can't call
> +		 * release_task() here because we already hold tasklist_lock.
> +		 */
> +		if (p->exit_state == EXIT_ZOMBIE) {
> +			if (p->exit_signal != -1 && !thread_group_empty(p))
                                                    ^^^^^^^^^^^^^^^^^^^^^^^
I still think this is wrong. Please also look at my previous reply,
http://marc.info/?l=linux-kernel&m=120680153931177

> @@ -1481,6 +1478,15 @@ static int wait_consider_task(struct task_struct *parent,
>  	 */
>  	*retval = 0;
>
> +	if (unlikely(p->parent != parent)) {
> +		/*
> +		 * This child is hidden by someone else who did PTRACE_ATTACH.
> +		 * We aren't allowed to see it now, but eventually we will.
> +		 */
> +		*retval = 0;
> +		return 0;
> +	}

Looks wrong... Above this "p->parent != parent" check we have

	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
		return wait_task_zombie(p, options, infop, stat_addr, ru);

Suppose that p is not a group leader, it is traced by some unrelated task,
and now it is EXIT_ZOMBIE. We shouldn't release it (and return the "bogus"
pid to user-space).

Oleg.


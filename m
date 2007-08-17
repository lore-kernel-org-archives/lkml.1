Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbXHQOpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbXHQOpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 10:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbXHQOpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 10:45:33 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:45025 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbXHQOpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 10:45:32 -0400
Date: Fri, 17 Aug 2007 18:48:13 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, devel@openvz.org
Subject: Re: [PATCH] Isolate some explicit usage of task->tgid
Message-ID: <20070817144813.GA347@tv-sign.ru>
References: <46C5AD92.70909@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C5AD92.70909@openvz.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17, Pavel Emelyanov wrote:
>
> Actually the p->tgid == pid has to be changed to has_group_leader_pid(), 
> but Oleg pointed out that this is the same and thread_group_leader() 
> is more preferable. 

No, no, sorry for confusion! I was not clear. I meant that thread_group_leader()
is imho better for posix timers, but

> @@ -865,8 +865,8 @@ static int de_thread(struct task_struct 
> 
> 		write_lock_irq(&tasklist_lock);
> 
> -		BUG_ON(leader->tgid != tsk->tgid);
> -		BUG_ON(tsk->pid == tsk->tgid);
> +		BUG_ON(!same_thread_group(leader, tsk));
> +		BUG_ON(thread_group_leader(tsk));

This should be has_group_leader_pid(), BUG_ON() really checks that
we didn't confuse ->tgid's.

> 		/*
> 		 * An exec() starts a new thread group with the
> 		 * TGID of the previous thread group. Rehash the
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index e3009ab..31e7dfe 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2288,7 +2288,7 @@ retry:
> 		 * found doesn't happen to be a thread group leader.
> 		 * As we don't care in the case of readdir.
> 		 */
> -		if (!task || !has_group_leader_pid(task))
> +		if (!task || !thread_group_leader(task))

And this _must_ be has_group_leader_pid(), this was actually the reason
to introduce the "has_group_leader_pid()" helper.

Otherwise I think the patch is fine, and the new helper is really useful.

Oleg.


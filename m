Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbYIDUht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbYIDUht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758167AbYIDUgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:36:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33372 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760626AbYIDUgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:36:35 -0400
Date: Thu, 4 Sep 2008 16:36:32 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, npiggin@suse.de,
       gregory.haskins@gmail.com
Subject: Re: [TIP/SCHED/DEVEL PATCH v3 4/6] sched: add sched_class->needs_post_schedule()
 member
In-Reply-To: <20080904125520.23633.64862.stgit@dev.haskins.net>
Message-ID: <alpine.DEB.1.10.0809041634580.3849@gandalf.stny.rr.com>
References: <20080904125029.23633.88210.stgit@dev.haskins.net> <20080904125520.23633.64862.stgit@dev.haskins.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Sep 2008, Gregory Haskins wrote:
> diff --git a/kernel/sched.c b/kernel/sched.c
> index af4c6fa..ddc3877 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2525,6 +2525,14 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>  {
>  	struct mm_struct *mm = rq->prev_mm;
>  	long prev_state;
> +#ifdef CONFIG_SMP
> +	int post_schedule = 0;
> +
> +	if (current->sched_class->needs_post_schedule) {
> +		BUG_ON(!current->sched_class->post_schedule);

The only one to ever hit this BUG_ON is a kernel developer creating a new
sched class. Since they should be smart enough to figure out why they get 
a segv later on, we really don't need it. Because this BUG_ON is also in 
a hot path, I strongly suggest nuking it.

-- Steve


> +		post_schedule = current->sched_class->needs_post_schedule(rq);
> +	}
> +#endif

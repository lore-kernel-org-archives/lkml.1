Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYFXKOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYFXKOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757833AbYFXKNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:13:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41814 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722AbYFXKNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:13:43 -0400
Subject: Re: [PATCH 3/3] sched: terminate newidle balancing once at least
	one task has moved over
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       dbahi@novell.com
In-Reply-To: <20080623230450.31515.75112.stgit@lsg.lsg.lab.novell.com>
References: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com>
	 <20080623230450.31515.75112.stgit@lsg.lsg.lab.novell.com>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 12:13:26 +0200
Message-Id: <1214302406.4351.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 17:04 -0600, Gregory Haskins wrote:
> Inspired by Peter Zijlstra.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  kernel/sched.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 3efbbc5..c8e8520 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2775,6 +2775,10 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
>  				max_load_move - total_load_moved,
>  				sd, idle, all_pinned, &this_best_prio);
>  		class = class->next;
> +
> +		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
> +			break;
> +
>  	} while (class && max_load_move > total_load_moved);
>  
>  	return total_load_moved > 0;


right,.. uhm, except that you forgot all the other fixes and
generalizations I had,..

The LB_START/LB_COMPLETE stuff is needed to fix CFS load balancing. It
now always iterates the first sysctl_sched_nr_migrate tasks, and if it
doesn't find any there, just gives up - which isn't too big of a problem
with it set to 32, but if you drop it to 2/4 stuff starts valing apart.

And the break I had here, only checks classes above and equal to the
current class.

This again is needed when you have more classes.


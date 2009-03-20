Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZCTOIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZCTOIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 10:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbZCTOIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 10:08:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54740 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZCTOIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 10:08:06 -0400
Date: Fri, 20 Mar 2009 15:04:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: roland@redhat.com, peterz@infradead.org, efault@gmx.de, rjw@sisk.pl,
       jdike@addtoit.com, mingo@elte.hu,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] fix uml slowness caused by ptrace preemption bug on
	host
Message-ID: <20090320140409.GB20965@redhat.com>
References: <E1LkQeU-00020Z-Be@pomaz-ex.szeredi.hu> <20090319233311.8B26BFC381@magilla.sf.frob.com> <E1LkZjf-0002vu-84@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LkZjf-0002vu-84@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20, Miklos Szeredi wrote:
>
> I'm no scheduler expert either.

neither me ;)

> --- linux.git.orig/kernel/sched.c	2009-03-18 12:53:47.000000000 +0100
> +++ linux.git/kernel/sched.c	2009-03-20 08:58:13.000000000 +0100
> @@ -4629,7 +4629,8 @@ asmlinkage void __sched preempt_schedule
>  	 * If there is a non-zero preempt_count or interrupts are disabled,
>  	 * we do not want to preempt the current task. Just return..
>  	 */
> -	if (likely(ti->preempt_count || irqs_disabled()))
> +	if (likely(ti->preempt_count || irqs_disabled() ||
> +		   current->state != TASK_RUNNING))

But this was specially designed to allow to preempt !TASK_RUNNING tasks,
note the "if (prev->state && !(preempt_count() & PREEMPT_ACTIVE))" in
schedule().

Perhaps "|| current->state == TASK_TRACED" makes more sense, TASK_TRACED
is special because we know we are going to schedule really soon. But I think
your previous patch is better, imho we should change preempt_schedule() to
fix the very specific problem with ptrace_notify().

Oleg.


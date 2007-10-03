Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbXJCK6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbXJCK6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbXJCK63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:58:29 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:28426 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbXJCK62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LbOZQHoc2MTXW7iZzCvpnlkn+sZX/yv1Y1KNY2tYFyiQ1Pa4huFvBHjaejGmBhfKTPg9zkIZ1IOL5bNkNamV5agTT6YfdN7aVkfZY9ZsAhaebI7/lJacl6J78aj8XUlXfsHnRmDW9z27xNfVwqwu9aERgaMLJNzxPhXakJDF9ZY=
Message-ID: <b647ffbd0710030358m3b107176n5f52e7b7846ef1d8@mail.gmail.com>
Date: Wed, 3 Oct 2007 12:58:26 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Jarek Poplawski" <jarkao2@o2.pl>
Subject: Re: Network slowdown due to CFS
Cc: "Ingo Molnar" <mingo@elte.hu>, "David Schwartz" <davids@webmaster.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <b647ffbd0710030355p116f9b36vae3f24e652921de6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071002060607.GA18588@elte.hu>
	 <20071003080224.GB1726@ff.dom.local> <20071003081613.GA29904@elte.hu>
	 <20071003085636.GC1726@ff.dom.local> <20071003091058.GB7802@elte.hu>
	 <20071003095057.GD1726@ff.dom.local>
	 <b647ffbd0710030355p116f9b36vae3f24e652921de6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2007, Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> On 03/10/2007, Jarek Poplawski <jarkao2@o2.pl> wrote:
> > I can't see anything about clearing. I think, this was about charging,
> > which should change the key enough, to move a task to, maybe, a better
> > place in a que (tree) than with current ways.
>
> just a quick patch, not tested and I've not evaluated all possible
> implications yet.
> But someone might give it a try with his/(her -- are even more
> welcomed :-) favourite sched_yield() load.
>
> (and white space damaged)
>
> --- sched_fair-old.c    2007-10-03 12:45:17.010306000 +0200
> +++ sched_fair.c        2007-10-03 12:44:46.899851000 +0200
> @@ -803,7 +803,35 @@ static void yield_task_fair(struct rq *r
>                 update_curr(cfs_rq);
>
>                 return;
> +       } else if (sysctl_sched_compat_yield == 2) {
> +               unsigned long ideal_runtime, delta_exec,
> +                             delta_exec_weighted;
> +
> +               __update_rq_clock(rq);
> +               /*
> +                * Update run-time statistics of the 'current'.
> +                */
> +               update_curr(cfs_rq);
> +
> +               /*
> +                * Emulate (speed up) the effect of us being preempted
> +                * by scheduler_tick().
> +                */
> +               ideal_runtime = sched_slice(cfs_rq, curr);
> +               delta_exec = curr->sum_exec_runtime -
> curr->prev_sum_exec_runtime;
> +
> +               if (ideal_runtime > delta_exec) {
> +                       delta_exec_weighted = ideal_runtime - delta_exec;
> +
> +                       if (unlikely(curr->load.weight != NICE_0_LOAD)) {
> +                               delta_exec_weighted =
> calc_delta_fair(delta_exec_weighted,
> +
>  &se->load);
> +                       }


s/curr/se


-- 
Best regards,
Dmitry Adamushko

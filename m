Return-Path: <linux-kernel-owner+w=401wt.eu-S1762511AbXFFLTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762511AbXFFLTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759635AbXFFLTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:19:07 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:8580 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645AbXFFLTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:19:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WZpCfRMcTL89/7Xsh9J21S327RA0vyk+ygvN6Okm8vx7qoHsDsibLG+2trJJuPO+jnp828Qfz3Z7TV8A3rj0qNvKzwMyjD5ws5g9nYCTfTxUv1DcXSBzPSeVD5p76GBL8oxGLlco3eLFQyrhFfL82GccZUmCCP2Ob99L79pdZD0=
Message-ID: <b647ffbd0706060419v1ed81e15w312f44aad8975d5b@mail.gmail.com>
Date: Wed, 6 Jun 2007 13:19:01 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: vatsa@in.ibm.com
Subject: Re: [patch] CFS scheduler, -v15
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070606105950.GA32729@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070531150908.GA23538@elte.hu>
	 <20070606064228.GA22443@in.ibm.com> <20070606070143.GA7375@elte.hu>
	 <20070606074317.GB3274@in.ibm.com>
	 <b647ffbd0706060208i5666f57eoe96215b636617622@mail.gmail.com>
	 <46668E4D.8060206@linux.vnet.ibm.com>
	 <20070606105950.GA32729@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> [ ... ]
> > > This way, on RT -> NORMAL transition.. some 'delta_exec' ( between
> > > deactivate_task() ---> activate_task() ) will be accounted later as if
> > > the task was 'sched_fair_class' during this time.. which I think makes
> > > some sense. What do you think?
> > >
> >
> > Why not do it explicitly in __setscheduler() if the new policy is SCHED_NORMAL
> > or SCHED_BATCH.
>
> Yes this is the approach I prefer, because we burden the fast/normal
> path less that way (RT->NORMAL transition is not common).

I don't think that rt_sched_class :: dequeue_task_rt() is in any of
such "fast pathes" that we should really care about an additional
math. operation.

If this approach is ok, logically-wise (no side effects from a short
'delta_exec', esp. on RT -> NORMAL).. I think it's better as it keeps
the 'sched_class' interface simpler.

> That's why I
> was considering a set_curr_task() method in fair_sched_class which will
> be invoked in __setscheduler() if the new policy of currently running
> task happens to be SCHED_NORMAL/BATCH. Alternately if the new policy of
> currently running task happens to be SCHED_FIFO (and its old policy was
> SCHED_NORMAL) we need to invoke put_prev_task() method (so that
> fair_clock etc is updated based on outgoing task's execution time in
> SCHED_NORMAL class).

rt_sched_class :: put_prev_task() from __setscheduler() ? But it's not
supposed to be called from here, logically-wise. You just rely on its
current behavior (which is only about updating 'exec_start' and
'exec_sum') -- that's just bad. Maybe I misunderatood your intention
though..


> --
> Regards,
> vatsa
>

-- 
Best regards,
Dmitry Adamushko

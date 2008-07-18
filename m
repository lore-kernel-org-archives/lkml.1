Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYGROjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYGROjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYGROi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:38:57 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:63806 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbYGROi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=j2uCvsOyGxjesiOzR8tB5JeWTRbQOSwhN3L0XRGkBaE5f8bnXjXE3vr5awaO3FSSKc
         +UOEoNvk6ZEFuWPndJ1ONXnJuY6dzyog0JZjNNBXO89SmyFCiqTo8ZAuAN6QpXXnrQ04
         WNPcG9T2og7lZldKM9ZkpeEU5VoYHdwnCpC1w=
Message-ID: <f17812d70807180738r75696e0ak120a884328b68ed3@mail.gmail.com>
Date: Fri, 18 Jul 2008 22:38:55 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH] sched: do not stop ticks when cpu is not idle
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Jack Ren" <jack.ren@marvell.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
In-Reply-To: <alpine.LFD.1.10.0807181548290.4316@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70807172341u92270fdvc80e72cc5599c56f@mail.gmail.com>
	 <20080718102446.GV6875@elte.hu>
	 <alpine.LFD.1.10.0807181548290.4316@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 9:52 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 18 Jul 2008, Ingo Molnar wrote:
>>
>> * eric miao <eric.y.miao@gmail.com> wrote:
>>
>> > Issue: the sched tick would be stopped in some race conditions.
>>
>> > --- a/kernel/sched.c
>> > +++ b/kernel/sched.c
>> > @@ -4027,7 +4027,8 @@ need_resched_nonpreemptible:
>> >             rq->nr_switches++;
>> >             rq->curr = next;
>> >             ++*switch_count;
>> > -
>> > +           if (rq->curr != rq->idle)
>> > +                   tick_nohz_restart_sched_tick();
>> >             context_switch(rq, prev, next); /* unlocks the rq */
>>
>> applied to tip/sched/urgent, thanks Eric.
>>
>> Thomas, Peter, Dmitry, do you concur with the analysis? (commit below)
>
> Yes. I did not understand the issue when Jack pointed it out to me,
> but with Erics explanation it's really clear. Thanks for tracking that
> down.

Actually, Jack did most of the analysis and came up with this quick
fix.

>
>> It looks a bit ugly to me in the middle of schedule() - is there no wait
>> to solve this within kernel/time/*.c ?
>
> Hmm, yes. I think the proper fix is to enable the tick stop mechanism
> in the idle loop and disable it before we go to schedule. That takes
> an additional parameter to tick_nohz_stop_sched_tick(), but we then
> gain a very clear section where the nohz mimic can be active.
>
> I'll whip up a patch.

Sounds great, thanks.

>
> Thanks,
>
>        tglx
>



-- 
Cheers
- eric

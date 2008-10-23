Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbYJWBFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbYJWBFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 21:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYJWBFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 21:05:10 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:60199 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYJWBFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 21:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=ptCJWdxf9SV6oox8IDmFkJecH0T2v+DxVvsdo4QaWe+1SMD/seTm7lYUSJptQnFI4+
         npJ7dZQ7REl6BXJi5uZ8sf71qQf5IP3MQINPBfN5GrL0indR4wRwJeE9G44KXm8M4N5c
         avGvkFfZ8gnPfaRsYX+7lVbGg564CzhinHLS4=
Message-ID: <4b6fba110810221805m70fd7e72rd66da9eba8f9f532@mail.gmail.com>
Date: Wed, 22 Oct 2008 21:05:07 -0400
From: "Daniel Rosenthal" <danielrosenthal@acm.org>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: behavior of hrtimers scheduled to expire in the past, SCHED_SPORADIC subtlety
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Dario Faggioli" <raistlin@linux.it>,
       "Peter Zijlstra" <peterz@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: bea2cde0f8c67e58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 4:09 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 20 Oct 2008, Daniel Rosenthal wrote:
>> What is the intended behavior for an hrtimer that is scheduled to
>> expire in the past?  I assumed that it would simply be scheduled to
>> expire at the nearest available time in the future, but I wrote some
>> scheduler code and it looks like hrtimers don't go off at all if they
>> are not scheduled to go off at a time which is after rq->clock.  Is
>> this the intended behavior or is this a bug?
>
> That depends on the callback mode of the hrtimer. The standard ones
> are scheduled to the softirq when they are already expired, but those
> which are not allowed to run their callback in softirq context are
> _not_ enqueued and the caller has to check, whether the timer is
> active/enqueued after starting it.

Ok, thanks for the heads up.  Is this documented somewhere, or do I
need to submit a patch?


Darrio,
Just to warn you, be careful that your SCHED_SPORADIC implementation
deals with the above situation correctly.  There are situations in
which the actual scheduling of a replenishment can unintentionally be
deferred for an excessive period of time (i.e. a SCHED_SPORADIC task
running at its high priority gets preempted for a relatively long
time, or at least a time which is long compared to the task's period).
 In this case, you may accidentally end up scheduling a replenishment
timer with an expiration time in the past (because (activation_time +
period) < rq->clock ).  Be careful to avoid this in your code because
this is subtle and it took me a very long time to debug this (this was
compounded by the fact that I made an incorrect assumption about
hrtimers, discussed above).  It can be solved by executing such past
replenishments immediately, rather than submitting them to
hrtimer_start().

And regarding SCHED_SPORADIC, I am also working on SCHED_SPORADIC in
2.6.25. If I don't finish my RFC patch by the time you finish your
final 2.6.27 patch, please let me know because I believe it would be
beneficial for us to compare code before any final decisions are made
(mine still isn't working well enough to compare yet).

Daniel

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759729AbZAVRvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759729AbZAVRvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758428AbZAVRrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:47:49 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:7944 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759337AbZAVRrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:47:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U7v0dn0kf9NMdVwJr6xNwgVzk3qrrgK4Baj17X8UbffXJr9XIJ+nF+tr+qz9Ib1WMM
         biCboUD8M3ubi5rYMKJ8RZ0IXJLK7HjpKkTT6beY708/rS2Zkx5fU1uCM5098FhaNwgC
         /U+je4epaCa0g9w9JlHksq3EGJSka/pQVe/0w=
MIME-Version: 1.0
In-Reply-To: <20090122172312.GB27250@redhat.com>
References: <497838F0.7020408@cn.fujitsu.com> <20090122093046.GC5891@nowhere>
	 <20090122172312.GB27250@redhat.com>
Date: Thu, 22 Jan 2009 18:47:44 +0100
Message-ID: <c62985530901220947r7cae081bj8660603912769baa@mail.gmail.com>
Subject: Re: [PATCH 2/3] workqueue: not allow recursion run_workqueue
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/22 Oleg Nesterov <oleg@redhat.com>:
> On 01/22, Frederic Weisbecker wrote:
>>
>> On Thu, Jan 22, 2009 at 05:14:24PM +0800, Lai Jiangshan wrote:
>> >  static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
>> >  {
>> > -   int active;
>> > +   int active = 0;
>> > +   struct wq_barrier barr;
>> >
>> > -   if (cwq->thread == current) {
>> > -           /*
>> > -            * Probably keventd trying to flush its own queue. So simply run
>> > -            * it by hand rather than deadlocking.
>> > -            */
>> > -           run_workqueue(cwq);
>> > -           active = 1;
>> > -   } else {
>> > -           struct wq_barrier barr;
>> > +   BUG_ON(cwq->thread == current);
>>
>> Hi Lai,
>>
>> BUG_ON seems perhaps a bit too much for such case. The system
>> will run in an endless loop because of a mistake that will not have
>> necessarily a fatal end.
>
> Confused. Why do you think the system will run in an endless loop?
> cwq-thread will exit.


Because a BUG_ON panics and then spin for ever. Yeah I shoud have said "panic",
sorry... It was just to tell that a BUG_ON is the end...

>
>> WARN_ON should be enough (plus the warn that lockdep will raise
>> too in this case).
>
> and if cwq-thread proceeds after WARN_ON() it will be "lost" anyway
> because it will sleep forever.

You want to say spin forever?
Why would it? cwq->lock is unlocked at this time.
If we keep the usual path:

if (cwq->thread == current) {
		run_workqueue(cwq);
		active = 1;
	}

it shouldn't hurt.

> Not that I think BUG_ON() is much better, except it is more "loud".

I don't think so IMHO, BUG_ON is for critical issues. Here it is not
critical, the workqueue
will flush but lockdep will warn because of recursion.
That's all.

>
> As for the patch itself, I completely agree with Peter.
>
> Oleg.
>
>

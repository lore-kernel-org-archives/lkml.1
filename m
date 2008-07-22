Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYGVFKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYGVFKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYGVFKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:10:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44554 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYGVFJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:09:59 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5343"; a="4939549"
Message-ID: <48856BA9.6050609@qualcomm.com>
Date: Mon, 21 Jul 2008 22:10:01 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       dmitry.adamushko@gmail.com, torvalds@linux-foundation.org, pj@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpu hotplug,	sched:Introduce	cpu_active_map	and	redoscheddomainmanagment
 (take 2)
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com> <487DAD86.BA47.005A.0@novell.com> <487E6BD7.3020006@qualcomm.com> <487E7B6C.BA47.005A.0@novell.com> <487EF1E9.2040101@qualcomm.com> <487EFB71.BA47.005A.0@novell.com> <487F9509.9050802@qualcomm.com> <487F6972.BA47.005A.0@novell.com> <1216382024.28405.26.camel@twins> <488052D5.BA47.005A.0@novell.com>
In-Reply-To: <488052D5.BA47.005A.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Gregory Haskins wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote: 
>> I'm thinking doing it explicitly with the new cpu mask is clearer and
>> easier to understand than 'hiding' the variable in the root domain and
>> having to understand all the domain/root-domain stuff.
>>
>> I think this was Linus' main point. It should be easier to understand
>> this code.
> 
> While I can appreciate this sentiment, note that we conceptually require
> IMO the notion that the root-domain masks present.  E.g. we really dont
> want to migrate to just cpus_active_map, but rather
> rq->rd->span & cpus_active_map (otherwise we could route outside
> of a disjoint cpuset).  And this is precisely what rq->rd->online is (a
> cached version of cpus_active_map & rq->rd->span).
> 
> So while I can understand the motivation to keep things simple, note that
> I tried to design the root-domain stuff to be as simple as possible while
> still meeting the requirements for working within disjoint sets.  I am
> open to other suggestions, but I see nothing particularly complex or
> wrong with whats going on there currently.  Perhaps this very
> conversation is evidence that I needed to comment better ;)
> 
>>
>> So, if there is functional overlap with the root domain stuff, it might
>> be good to remove that bit and use the cpu_active_map stuff for that
>> instead.
> 
> I think we would be doing the code that does use it a disservice, per above.

Sorry for the delay. I finally had a chance to read through this thread again
and to look at the rq->rd->online logic.

One thing that came up during original discussion with Linus and Dmitry is
that cpuset can call partition_sched_domains() at random (user writes into
/dev/cpuset/...) but the scheduler used to rely on a certain sequence of the
domain creation/deletion during cpu hotplug. That's exactly what caused the
problem in the first place. My patch that fixed domain destruction by the
hotplug events changed the sequence the scheduler relied on and things broke.

Greg, correct me if I'm wrong but we seem to have exact same issue with the
rq->rq->online map. Lets take "cpu going down" for example. We're clearing
rq->rd->online bit on DYING event, but nothing AFAICS prevents another cpu
calling rebuild_sched_domains()->partition_sched_domains() in the middle of
the hotplug sequence.
partition_sched_domains() will happily reset rd->rq->online mask and things
will fail. I'm talking about this path

__build_sched_domains() -> cpu_attach_domain() -> rq_attach_root()
	...
	cpu_set(rq->cpu, rd->span);
	if (cpu_isset(rq->cpu, cpu_online_map))
		set_rq_online(rq);
	...

--

btw Why didn't we convert sched*.c to use rq->rd->online when it was
introduced ? ie Instead of using cpu_online_map directly.

Max

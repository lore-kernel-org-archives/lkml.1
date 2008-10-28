Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYJ1Xba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYJ1Xba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYJ1XbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:31:22 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:21238 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbYJ1XbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:31:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4DAM8S9kh5LE2tgWdsb2JhbACTYAEBFiKuDIFr
X-IronPort-AV: E=Sophos;i="4.33,502,1220193000"; 
   d="scan'208";a="220149440"
Date: Wed, 29 Oct 2008 10:31:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: Naveen Gupta <ngupta@google.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, s-uchida@ap.jp.nec.com
Subject: Re: [PATCH] Priorities in Anticipatory I/O scheduler
Message-ID: <20081028233101.GD17077@disturbed>
Mail-Followup-To: Naveen Gupta <ngupta@google.com>,
	linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
	akpm@linux-foundation.org, s-uchida@ap.jp.nec.com
References: <20081027190131.070061000@elf.corp.google.com> <20081027190139.838646000@elf.corp.google.com> <20081028002024.GM4985@disturbed> <2846be6b0810281014q495cef22mae344423ed59c71a@mail.gmail.com> <20081028214443.GX4985@disturbed> <2846be6b0810281548oc81fbe4td2e1a5e2fba18745@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2846be6b0810281548oc81fbe4td2e1a5e2fba18745@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 03:48:44PM -0700, Naveen Gupta wrote:
> 2008/10/28 Dave Chinner <david@fromorbit.com>:
> > On Tue, Oct 28, 2008 at 10:14:20AM -0700, Naveen Gupta wrote:
> >> 2008/10/27 Dave Chinner <david@fromorbit.com>:
> >> > On Mon, Oct 27, 2008 at 12:01:32PM -0700, ngupta@google.com wrote:
> >> >>
> >> >> Modifications to the Anticipatory I/O scheduler to add multiple priority
> >> >> levels. It makes use of anticipation and batching in current
> >> >> anticipatory scheduler to implement priorities.
> > .....
> >> >> In this patch I have added a new class IOPRIO_CLASS_LATENCY to differentiate
> >> >> notion of absolute priority over existing uses of various time-slice based
> >> >> priority classes in cfq. Though internally within anticipatory scheduler all
> >> >> of them map to best-effort levels. Hence, one can also use various best-effort
> >> >> priority levels.
> >> >
> >> > Please don't introduce yet another incompatible behaviour between
> >> > I/O schedulers. It's bad enough from an optimisation point of view
> >> > that BIO_RW_SYNC and BIO_RW_META mean different things to different
> >> > schedulers, let alone that only CFQ currently understands
> >> > priorities. If you are going to introduce priorities into AS, then
> >> > please, please, please make it use the same interface as CFQ.
> >> >
> >> > Why? Both the extN and XFS devs have been considering bumping the
> >> > priority of journal writes using the existing CFQ-based I/O priority
> >> > mechanism - the last thing I want to see is a different scheduler
> >> > requiring a different priority configuration to acheive the same
> >> > optimisation. There is no way we can support this sort of
> >> > optimisation in the filesystem code if the interface changes when
> >> > the I/O scheduler changes. So please use the existing IOPRIO classes
> >> > to map the priorities for the AS scheduler.
> >> >
> >>
> >> The anticipatory scheduler chooses it's next i/o to be of highest
> >> available priority level.
> >
> > That sounds exactly like what the current RT class is supposed to
> > be used for - defining the absolute priority of dispatch. How
> > is this latency class different to the current RT class semantics
> > that are defined for CFQ?
> >
> 
> I/O from RT class in CFQ can still see a bubble with this new latency
> class. An easy way to check this would be to submit ios at multiple
> levels both in CFQ and AS and check max latency of the highest levels.
> I will let Jens or Satoshi comment on exact algorithm for RT class.

You're missing my point entirely.

You're defining a new class that has the exact same meaning as
the current RT class definition, then mapping the BE class over
the top of that, hence changing what that means for everyone.

The fact that the *implementation* of AS and CFQ is different is
irrelevant; if you use the RT class then on CFQ you get the current
RT behaviour, if you use the RT class on AS you should get your new
priority dispatch mechanism. We don't need a new API just because
the implementations are different.

> >> So, in some sense it kind of implements absolute priority and
> >> is best used for jobs which are latency sensitive.  Since the
> >> priorities can be and are mapped internally in anticipatory
> >> scheduler, BEST_EFFORT class is mapped one-one with the LATENCY
> >> class.
> >
> > So you map the BE class to something with the same semantics as
> > the RT class? What mapping do you do when an application uses
> > the RT class?
> >
> 
> Yes I could have used RT class but it was used in CFQ to implement
> it's time-sliced based highest priority class.  If an application
> uses RT class, AS maps all levels of RT class to BE class level 0
> (i.e. to the highest priority available)

Which means you are throwing away all the RT priority levels and
so an application using the RT class would be subtly broken on AS....

> >> A filesystem can use best-effort class using similar interface
> >> as for cfq.
> >
> > The folk using the RT priority classes greatly objected to using
> > the RT class for journal I/O precisely because it would then
> > preempt their application's RT I/O and introduce unpredictable
> > latencies.
> >
> > Journal I/O will typically use the highest priority BE class so
> > that it is promoted above BE I/O but does not preempt RT I/O.
> > With your mapping of BE classes to this new "absolute priority
> > latency" class, this configuration will give journal I/O the
> > highest priority in the scheduler. This will cause preemption of
> > your latency sensitive I/O and so those latencies you are trying
> > to avoid won't go away....
> >
> 
> I see your problem, we could make the LATENCY class different from
> and above BE class (instead of one-one mapping).

Like the RT class is currently defined to be? ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

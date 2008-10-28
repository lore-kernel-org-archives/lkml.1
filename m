Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYJ1Vo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYJ1Vo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbYJ1Vou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:44:50 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:53977 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008AbYJ1Vot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:44:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4DAM8S9kh5LE2tgWdsb2JhbACTYAEBFiKuDIFr
X-IronPort-AV: E=Sophos;i="4.33,501,1220193000"; 
   d="scan'208";a="220067738"
Date: Wed, 29 Oct 2008 08:44:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Naveen Gupta <ngupta@google.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Priorities in Anticipatory I/O scheduler
Message-ID: <20081028214443.GX4985@disturbed>
Mail-Followup-To: Naveen Gupta <ngupta@google.com>,
	linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
	akpm@linux-foundation.org
References: <20081027190131.070061000@elf.corp.google.com> <20081027190139.838646000@elf.corp.google.com> <20081028002024.GM4985@disturbed> <2846be6b0810281014q495cef22mae344423ed59c71a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2846be6b0810281014q495cef22mae344423ed59c71a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 10:14:20AM -0700, Naveen Gupta wrote:
> 2008/10/27 Dave Chinner <david@fromorbit.com>:
> > On Mon, Oct 27, 2008 at 12:01:32PM -0700, ngupta@google.com wrote:
> >>
> >> Modifications to the Anticipatory I/O scheduler to add multiple priority
> >> levels. It makes use of anticipation and batching in current
> >> anticipatory scheduler to implement priorities.
.....
> >> In this patch I have added a new class IOPRIO_CLASS_LATENCY to differentiate
> >> notion of absolute priority over existing uses of various time-slice based
> >> priority classes in cfq. Though internally within anticipatory scheduler all
> >> of them map to best-effort levels. Hence, one can also use various best-effort
> >> priority levels.
> >
> > Please don't introduce yet another incompatible behaviour between
> > I/O schedulers. It's bad enough from an optimisation point of view
> > that BIO_RW_SYNC and BIO_RW_META mean different things to different
> > schedulers, let alone that only CFQ currently understands
> > priorities. If you are going to introduce priorities into AS, then
> > please, please, please make it use the same interface as CFQ.
> >
> > Why? Both the extN and XFS devs have been considering bumping the
> > priority of journal writes using the existing CFQ-based I/O priority
> > mechanism - the last thing I want to see is a different scheduler
> > requiring a different priority configuration to acheive the same
> > optimisation. There is no way we can support this sort of
> > optimisation in the filesystem code if the interface changes when
> > the I/O scheduler changes. So please use the existing IOPRIO classes
> > to map the priorities for the AS scheduler.
> >
> 
> The anticipatory scheduler chooses it's next i/o to be of highest
> available priority level.

That sounds exactly like what the current RT class is supposed to
be used for - defining the absolute priority of dispatch. How
is this latency class different to the current RT class semantics
that are defined for CFQ?

> So, in some sense it kind of implements
> absolute priority and is best used for jobs which are latency
> sensitive.  Since the priorities can be and are mapped internally in
> anticipatory scheduler, BEST_EFFORT class is mapped one-one with the
> LATENCY class.

So you map the BE class to something with the same semantics as the
RT class? What mapping do you do when an application uses the RT
class?

> A filesystem can use best-effort class using similar
> interface as for cfq.

The folk using the RT priority classes greatly objected to using
the RT class for journal I/O precisely because it would then
preempt their application's RT I/O and introduce unpredictable
latencies.

Journal I/O will typically use the highest priority BE class so that
it is promoted above BE I/O but does not preempt RT I/O.  With your
mapping of BE classes to this new "absolute priority latency" class,
this configuration will give journal I/O the highest priority in the
scheduler. This will cause preemption of your latency sensitive I/O
and so those latencies you are trying to avoid won't go away....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbYJ2EG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbYJ2EG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 00:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbYJ2EGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 00:06:17 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:20863 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbYJ2EGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 00:06:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4DAM8S9kh5LE2tgWdsb2JhbACTYAEBFiKuDIFr
X-IronPort-AV: E=Sophos;i="4.33,504,1220193000"; 
   d="scan'208";a="220417857"
Date: Wed, 29 Oct 2008 15:05:38 +1100
From: Dave Chinner <david@fromorbit.com>
To: Naveen Gupta <ngupta@google.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, s-uchida@ap.jp.nec.com
Subject: Re: [PATCH] Priorities in Anticipatory I/O scheduler
Message-ID: <20081029040538.GE17077@disturbed>
Mail-Followup-To: Naveen Gupta <ngupta@google.com>,
	linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
	akpm@linux-foundation.org, s-uchida@ap.jp.nec.com
References: <20081027190131.070061000@elf.corp.google.com> <20081027190139.838646000@elf.corp.google.com> <20081028002024.GM4985@disturbed> <2846be6b0810281014q495cef22mae344423ed59c71a@mail.gmail.com> <20081028214443.GX4985@disturbed> <2846be6b0810281548oc81fbe4td2e1a5e2fba18745@mail.gmail.com> <20081028233101.GD17077@disturbed> <2846be6b0810281704r5092c415n3fea9c849c6086ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2846be6b0810281704r5092c415n3fea9c849c6086ca@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 05:04:53PM -0700, Naveen Gupta wrote:
> 2008/10/28 Dave Chinner <david@fromorbit.com>:
> > On Tue, Oct 28, 2008 at 03:48:44PM -0700, Naveen Gupta wrote:
> >> 2008/10/28 Dave Chinner <david@fromorbit.com>:
> >> > On Tue, Oct 28, 2008 at 10:14:20AM -0700, Naveen Gupta wrote:
> >> >> The anticipatory scheduler chooses it's next i/o to be of highest
> >> >> available priority level.
> >> >
> >> > That sounds exactly like what the current RT class is supposed to
> >> > be used for - defining the absolute priority of dispatch. How
> >> > is this latency class different to the current RT class semantics
> >> > that are defined for CFQ?
> >> >
> >>
> >> I/O from RT class in CFQ can still see a bubble with this new latency
> >> class. An easy way to check this would be to submit ios at multiple
> >> levels both in CFQ and AS and check max latency of the highest levels.
> >> I will let Jens or Satoshi comment on exact algorithm for RT class.
> >
> > You're missing my point entirely.
> >
> > You're defining a new class that has the exact same meaning as
> > the current RT class definition, then mapping the BE class over
> > the top of that, hence changing what that means for everyone.
> >
> > The fact that the *implementation* of AS and CFQ is different is
> > irrelevant; if you use the RT class then on CFQ you get the current
> > RT behaviour, if you use the RT class on AS you should get your new
> > priority dispatch mechanism. We don't need a new API just because
> > the implementations are different.
> >
> 
> There is nothing "real-time" about the current RT class anyways.

That's an implementation problem, not an API definition problem.

> It is
> basically these small *implementation* differences that defines these
> classes in current scheme of things, precise definitions of which
> would be very hard to find if one started looking around.

Please, disconnect what you think about implementation and ask
yourself what makes sense from an API if you were trying to use this
stuff.

I want to be able to use this stuff to optimise filesystem I/O,
but if the priority class I need to use is dependent on the elevator the
*user selects* and can change dynamically, then I simply cannot
make that optimisation.

> Now the initial feedback was since this *implementation* is different
> from anything we have in CFQ which is our current *standard* way of
> thinking and comparing (that is the only thing that exists) why not
> make them into a new class :).

Because it make it impossible to optimise application code as the
class that needs to be used is entirely dependent on the
configuration of the machine that it is running on. Application
writers are not going to probe the I/O scheduler the block device
is using to determine if they should be using RT or LATENCY class
prioritisation. From a user POV they do *exactly the same thing*,
so they should use the same behavioural classes defined by the API.

> >> I see your problem, we could make the LATENCY class different from
> >> and above BE class (instead of one-one mapping).
> >
> > Like the RT class is currently defined to be? ;)
> 
> I agree with you and we could use RT (though you and I know that
> basically it is best effort). LATENCY was invented due to a previous
> suggestion.

As someone who is actually trying to use this stuff, I'm saying that
the LATENCY suggestion was a *bad idea* because of the complexity it
introduces when trying to optimise performance by applying I/O
priorities to different I/O types. I want *one* API that is
implemented by all schedulers, not an API per scheduler.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYJ2Vdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYJ2Vdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbYJ2Vdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:33:35 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:13675 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753681AbYJ2Vde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:33:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABlxCEl5LIT3/2dsb2JhbADNc4NR
X-IronPort-AV: E=Sophos;i="4.33,509,1220193000"; 
   d="scan'208";a="236478777"
Date: Thu, 30 Oct 2008 08:33:24 +1100
From: Dave Chinner <david@fromorbit.com>
To: Naveen Gupta <ngupta@google.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, s-uchida@ap.jp.nec.com
Subject: Re: [PATCH] Priorities in Anticipatory I/O scheduler
Message-ID: <20081029213324.GG17077@disturbed>
Mail-Followup-To: Naveen Gupta <ngupta@google.com>,
	linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
	akpm@linux-foundation.org, s-uchida@ap.jp.nec.com
References: <20081027190131.070061000@elf.corp.google.com> <20081027190139.838646000@elf.corp.google.com> <20081028002024.GM4985@disturbed> <2846be6b0810281014q495cef22mae344423ed59c71a@mail.gmail.com> <20081028214443.GX4985@disturbed> <2846be6b0810281548oc81fbe4td2e1a5e2fba18745@mail.gmail.com> <20081028233101.GD17077@disturbed> <2846be6b0810281704r5092c415n3fea9c849c6086ca@mail.gmail.com> <20081029040538.GE17077@disturbed> <2846be6b0810290149j1330b084sf98cf8913d5640e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2846be6b0810290149j1330b084sf98cf8913d5640e0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 01:49:49AM -0700, Naveen Gupta wrote:
> 2008/10/28 Dave Chinner <david@fromorbit.com>:
> >> Now the initial feedback was since this *implementation* is different
> >> from anything we have in CFQ which is our current *standard* way of
> >> thinking and comparing (that is the only thing that exists) why not
> >> make them into a new class :).
> >
> > Because it make it impossible to optimise application code as the
> > class that needs to be used is entirely dependent on the
> > configuration of the machine that it is running on. Application
> > writers are not going to probe the I/O scheduler the block device
> > is using to determine if they should be using RT or LATENCY class
> > prioritisation. From a user POV they do *exactly the same thing*,
> > so they should use the same behavioural classes defined by the API.
> 
> I agree with you that we need an API which is valid across schedulers.
> But one has to agree that this sort of thing has it's own limitations.
> We are assuming that every scheduler which implements any kind of
> priority has a valid implementation of RT, BE, Idle class, which in
> this we we don't have. What happens tomorrow once we have a scheduler
> which decides that it needs to divide b/w. Which class would one map
> it to?

Throttling does not belong in the elevator. It can be successfully
done generically above the elevator in DM. See the dm-ioband
patches, for example.  The elevator is for optimising scheduling of
issued I/O, not controlling every aspect of the I/O path.

> As I understand what you are asking for is: filesystem i/o can use BE
> 0 across all schedulers for journal updates. And you still have RT
> levels to take care of any higher priority i/o which need not wait for
> journal updates.

No, I wanted to use the very highest priority available for the
journal updates. The folk using the real-time priority class didn't
like that, and suggested that the highest BE priority would be
better so journal I/O didn't preempt their RT data I/O. So what I'm
saying is based on feedback from ppl actually using the RT class for
their RT applications...

This is what I've ben trying to tell you and I have so far been
unsuccessful at getting through to you - there are ppl using
this API because it's exposed to userspace so we can't just change it
whenever someone feels like it.

> Here is what we can do:
> 1. Add 17 levels. top 8 RT, next 8 BE and last 1 idle. Though we know
> they all are similar in implementation. It's just that RT > BE > idle
> in importance.

Yes, just like CPU scheduling. We had a RT class there long before
we could really do RT scheduling. Also, nobody suggested introducing
a new "latency class" to the CPU scheduler to fix problems with the
RT scheduling - they fixed the scheduler instead and the API did not
change. We should be following the exact same model for I/O
scheduling priorities.

> And if the LATENCY camp is still active, add another
> class LATENCY which in context of AS is same as RT. So you get to keep
> RT > BE and they get Latency.

Just drop the whole "latency" idea altogether - it's just
another way of saying "use an rt-like priority mechanism", which
we already have a class for.

> 2. Add 10 levels instead of current 8. top 1 level maps all 8 RT
> levels. next 8 are BE and last 1 maps to idle. This also gives you
> access to BE 0, while all RT levels are higher priority than BE. It
> discourages people from using different RT levels unless we find a new
> meaning for it in context of AS.

That doesn't seem like a very good idea to me - RT is there, ppl are
using it, so not supporting it means that the ppl who really care
about I/O latency will continue to avoid using the AS scheduler...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

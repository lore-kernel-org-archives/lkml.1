Return-Path: <linux-kernel-owner+w=401wt.eu-S1030894AbXDPXLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030894AbXDPXLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 19:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030991AbXDPXLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 19:11:02 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:9747 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030894AbXDPXLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 19:11:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qT4HbGikc0810fbja2SDE23NzXZ11EppSetpqA97XrpTM6mgEljUEobPlxker/e7dZHB5Jm6SMYiLhhlZg0dnXLJ7Xf1iljcBBSGbexdGNvq9GqLz1hm1dpicfubStGZBD33rLzklvPwNFBN5XvcALfi41yEg1w53IfLugeLHbY=
Message-ID: <f2b55d220704161610l71c72bc6k364bd9396cd59300@mail.gmail.com>
Date: Mon, 16 Apr 2007 16:10:59 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Peter Williams" <pwil3058@bigpond.net.au>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Cc: "William Lee Irwin III" <wli@holomorphy.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Matt Mackall" <mpm@selenic.com>,
       "Con Kolivas" <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>, "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <46237239.1070903@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070413202100.GA9957@elte.hu> <20070415150536.GA6623@elte.hu>
	 <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu>
	 <20070415233909.GE2986@holomorphy.com>
	 <4622CC30.6030707@bigpond.net.au>
	 <20070416030405.GI8915@holomorphy.com>
	 <4623050B.8020602@bigpond.net.au>
	 <20070416110439.GH2986@holomorphy.com>
	 <46237239.1070903@bigpond.net.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, Peter Williams <pwil3058@bigpond.net.au> wrote:
> Note that I talk of run queues
> not CPUs as I think a shift to multiple CPUs per run queue may be a good
> idea.

This observation of Peter's is the best thing to come out of this
whole foofaraw.  Looking at what's happening in CPU-land, I think it's
going to be necessary, within a couple of years, to replace the whole
idea of "CPU scheduling" with "run queue scheduling" across a complex,
possibly dynamic mix of CPU-ish resources.  Ergo, there's not much
point in churning the mainline scheduler through a design that isn't
significantly more flexible than any of those now under discussion.

For instance, there are architectures where several "CPUs"
(instruction stream decoders feeding execution pipelines) share parts
of a cache hierarchy ("chip-level multitasking").  On these machines,
you may want to co-schedule a "real" processing task on one pipeline
with a "cache warming" task on the other pipeline -- but only for
tasks whose memory access patterns have been sufficiently analyzed to
write the "cache warming" task code.  Some other tasks may want to
idle the second pipeline so they can use the full cache-to-RAM
bandwidth.  Yet other tasks may be genuinely CPU-intensive (or I/O
bound but so context-heavy that it's not worth yielding the CPU during
quick I/Os), and hence perfectly happy to run concurrently with an
unrelated task on the other pipeline.

There are other architectures where several "hardware threads" fight
over parts of a cache hierarchy (sometimes bizarrely described as
"sharing" the cache, kind of the way most two-year-olds "share" toys).
 On these machines, one instruction pipeline can't help the other
along cache-wise, but it sure can hurt.  A scheduler designed, tested,
and tuned principally on one of these architectures (hint:
"hyperthreading") will probably leave a lot of performance on the
floor on processors in the former category.

In the not-so-distant future, we're likely to see architectures with
dynamically reconfigurable interconnect between instruction issue
units and execution resources.  (This is already quite feasible on,
say, Virtex4 FX devices with multiple PPC cores, or Altera FPGAs with
as many Nios II cores as fit on the chip.)  Restoring task context may
involve not just MMU swaps and FPU instructions (with state-dependent
hidden costs) but processsor reconfiguration.  Achieving "fairness"
according to any standard that a platform integrator cares about (let
alone an end user) will require a fairly detailed model of the hidden
costs associated with different sorts of task switch.

So if you are interested in schedulers for some reason other than a
paycheck, let the distros worry about 5% improvements on x86[_64].
Get hold of some different "hardware" -- say:
  - a Xilinx ML410 if you've got $3K to blow and want to explore
reconfigurable processors;
  - a SunFire T2000 if you've got $11K and want to mess with a CMT
system that's actually shipping;
  - a QEMU-simulated massively SMP x86 if you're poor but clever
enough to implement funky cross-core cache effects yourself; or
  - a cycle-accurate simulator from Gaisler or Virtio if you want a
real research project.
Then go explore some more interesting regions of parameter space and
see what the demands on mainline Linux will look like in a few years.

Cheers,
- Michael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbYGBU5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbYGBU5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 16:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYGBU5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 16:57:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:47433 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbYGBU5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:57:37 -0400
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>
In-Reply-To: <87zlp0sg4l.fsf@basil.nowhere.org>
References: <1214916335.20711.141.camel@pasglop>
	 <486B0298.5030508@linux.intel.com> <1214977447.21182.33.camel@pasglop>
	 <87zlp0sg4l.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 06:57:16 +1000
Message-Id: <1215032236.21182.52.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 13:02 +0200, Andi Kleen wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> 
> >> how much of this would be obsoleted if we had irqthreads ?
> >
> > I'm not sure irqthreads is what I want...
> >
> > First, can they call handle_mm_fault ? (ie, I'm not sure precisely what
> > kind of context those operate into).
> 
> Interrupt threads would be kernel threads and kernel threads
> run with lazy (= random) mm and calling handle_mm_fault on that
> wouldn't be very useful because you would affect a random mm.

That isn't a big issue. handle_mm_fault() takes the mm as an argument
(like when called from get_user_pages()) and if there's anything fishy I
can always attach/detach the mm to the thread. Been done before, works
fine.

> Ok you could force them to run with a specific MM, but that would
> cause first live time issues with the original MM (how could you
> ever free it?) and also increase the interrupt handling latency
> because the interrupt would be a nearly full blown VM context
> switch then.

handle_mm_fault() shouldn't need an mm context switch. I can just
refcount while I have a ref. to the mm in my queue. I can deal with
lifetime, that isn't a big issue.

> I also think interrupts threads are a bad idea in many cases because
> their whole "advantage" over classical interrupts is that they can
> block. Now blocking can be usually take a unbounded potentially long
> time.

Yes, that's what I explain in the rest of my mail. That plus the fact
that I need to context switch the SPU to other contexts while we block.

 .../...

I agree with most of your points, which is why I believe interrupt
threads aren't a good option for me.

Interrupts for "normal" events will be handled in a short/bounded time.

Interrupts coming from SPU page faults will be deferred to a thread from
a pool (which can need more time if none is available, ie work queue ->
allocate more, or just wait on one to free up, the stategy here is to be
defined).

It's not a problem to have them delayed. I can context switch a faulting
SPU to some other task and switch it back later when the fault is
serviced. Anything time critical shouldn't operate on fault-able memory
in the first place :-)

So I need at most one kernel thread per SPU context for handling the
faults. The idea of the thread pools is that most of the time, I don't
take faults, and thus I don't nearly need as many threads in practice.
Thus having a pool that can dynamically grow or shrink based on pressure
would make sense.

Ben.



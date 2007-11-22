Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbXKVH7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbXKVH7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 02:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbXKVH67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 02:58:59 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:34966 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750841AbXKVH66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 02:58:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BukMpyVf/5p3mCYWfFBw19jlJNe7rrazQA6pkzM6OGNzPLyYd6OTKrF5R7UjPKjyShC447Smp5MyG14+zNusrUeQQoNhI00TnxZ9Bk6Il7G5WLkW6OJ4BmCcevyrcRjLpUzChIadVXSXJyCaRt0H8tZYVnyXK4s8Ns9vzVZHmcs=  ;
X-YMail-OSG: LusQ5soVM1kmtRxLEcrwYC89d.61455qNfS4zZRjzija.sfupMgEJfcf.sftkPcQzPQJHuy0eg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Date: Thu, 22 Nov 2007 18:54:15 +1100
User-Agent: KMail/1.9.5
Cc: Mark Lord <lkml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <47425EA5.7000607@rtr.ca> <200711210243.46944.nickpiggin@yahoo.com.au> <20071120110726.4cc2995e@laptopd505.fenrus.org>
In-Reply-To: <20071120110726.4cc2995e@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711221854.15516.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 November 2007 06:07, Arjan van de Ven wrote:
> On Wed, 21 Nov 2007 02:43:46 +1100

> > Of course it is, if you want to effectively use your resources.
> > Imagine if the task balancer only polled once every 10s.
>
> but unlike the task balancer, moving an irq is really expensive.
> (at least for networking and a few other similar systems)
> ANd no it's not just the cache bouncing, it's the entire reassembly of
> multiple packets etc etc that gets really messy.

Actually a blanket statement like that is just wrong. Moving a
network interrupt yes is probably quite expensive, but it is
about the worst case one to move. What's more, moving tasks between
NUMA nodes could easily be many orders of magnitude worse than the
transient slowdown of moving irqs.

Furthermore, what you say doesn't really seem to be an argument
for doing it in userspace or an argument against moving IRQs. It
actually shows that there are complex, hardware and kernel
implementation dependent issues, all of which suggest it is better
to be in kernel.


> > Some constants
> > that make assumptions about the machine it is running on and may or
> > may not agree with what the task scheduler is trying to do.
> >
> > Some
> > classification stuff which makes guesses about how a particular bit of
>
> you misunderstood this; the classification stuff is there to spread
> different irqs of similar class (say networking) over multiple
> cores/packages. Doing this is a system resource balancing proposition
> not just a cpu time one.
>
> You may think this spreading based on classification is a mistake, but
> it's based on the following observation:

No I'm not misunderstanding or think it is a mistake. But it is
something which the kernel and the devices themselves should have
better knowledge of. You have a process which is reading off disk
and sending to a network interface? You may well want to put the
process and the disk interrupt and the network interrupt all on
the same CPU.

[snip]

> We used to rebalance this frequently in the 2.4-early kernels based on
> a patch from Ingo. Turned out to be a really really bad idea;
> performance really tanked.

To reiterate, I do not think that IRQs should be moved more frequently.
I think the kernel is in the position to know far better than userspace
about irq balancing.


> > hardware or device driver wants to be balanced. Hacks to poll
> > hotplugging and topology changes.
>
> "hacks" as in "rescan".. so falls under the topology code and would
> indeed be changed to hook into hotplug inside the kernel; just
> different complexity.

ie. simpler. All the topology stuff would be far simpler.


> > I'm still convinced. Who isn't?
>
> I know you can do SOME sort of balancing in the kernel. But please
> describe the algorithm you would use; I started out with the same
> thought but when it got down to the algorithm to me at least it became
> clear "we really don't want this complexity in kernel mode".

I'd rather not to this far into handwaving. I'm not saying that
I know exactly how it should work right now. I'm questioning the
established viewpoint that irq balancing belongs in userspace.

For that matter, I guess from the results you get, it's not terribly
bad to do in userspace or anything. But I think it can be done in
kernel.

Policy... I think that's a misused argument. The "policy" of any
kernel code I write is to utilise the hardware as efficiently as
possible within restrictions (eg. fairness, permissions). Setting
those restrictions is the realm of userspace, otherwise IMO it is
fine to go in kernel.

Using the same argument, task balancing and even scheduling is
policy, so is page reclaim, page writeback, filesystem block
allocation, etc. Now many of those things can be directed or
restricted somehow from userspace, and in-kernel irq balancing
would be no different.


> > > not needed. (also because on single socket machines, the
> > > irqbalancer basically has a one-shot task because there balancing
> > > is effectively a static setup)
> >
> > I don't think that's a good argument for not having it in kernel.
>
> if you don't care about kernel unpagable memory footprint, fine.
> Others do.

It would be a couple of K, right? I mean it would be probably less than
half the code of irqbalance because of the parsing and topology stuff.

Also, I don't think the one-shot behaviour on single socket machines is
good policy at all, and it can't capture dynamic behaviour at all.


> > > I listed a few;
> > > 1) it's policy
> >
> > I don't think that's such a constructive point. Task balancing is
> > policy in exactly the same way.
>
> not really; CFS has shown that.... the only real policy in task
> balancing is the fairness part,

Ahh, hate to get off topic, but let's not perpetuate this myth.
It wasn't Con, or CFS, or anything that showed fairness is some
great new idea. Actually I was arguing for fairness first,
against both Con and Ingo, way back when the old scheduler was
having so much problems.

Not that I am trying to claim the idea for myself. Fairness is
like the most fundamental and obvious behaviour for any sort of
resource scheduler that I have to laugh when people get "credited"
with this idea.

Back on topic... no, fairness is not the only real policy. Not at
all. Fariness is one of the most important ones, and that is exactly
why it is the default behaviour. After that, deviation from that is
a userspace thing.


> and that seems to be general accepted 
> as the right thing.
>
> > More out of place IMO, is irqbalance has things like checking for
> > NAPI turned on in a driver and in that case it does something specific
> > according to its knowledge of kernel implementation details.
>
> no it doesn't; it uses "packet counts" to deal with NAPI and other
> effects such as irq mitigation to get a more accurate estimate of load
> caused by an irq, but it's not fair to call this inappropriate checking
> for NAPI being turned on.

I don't think it is inappropriate. Obviously it needs to check it
to do something close to the right thing. This to me is yet another
signal that says the kernel is the right place for it.

Anyway, I'm clearly not going to change your mind. But I do have an
idea of the rationale for doing it in userspace now. So if I wanted
to challenge that, I guess I'd have to write code and prove it...


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbXKTHh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbXKTHh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 02:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbXKTHhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 02:37:50 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:42145 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754689AbXKTHht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 02:37:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=HBwyGwQtHARA20yUzoYHleGgc6o6pKSGLpC3f1bzk7Zg/ptxFT8PHXe0oOaETnPnv8KuYJMuCoguGsi4vN+9Y+pRkEOEH+Qn235TIAImkWUWxOmxOl+OeP0l0HKX7NuJzpIvOSin9IGbHL5UUcGc2xPXjxgmWw5DYYXraFMHUp8=  ;
X-YMail-OSG: THpLQXUVM1m9W83JO2EjlGzfbQRBAKqOsGPYaGCqhJHwgE_6xRR2gJZSN.IlNJK1yqQb5Ohfbg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Date: Tue, 20 Nov 2007 18:37:39 +1100
User-Agent: KMail/1.9.5
Cc: Mark Lord <lkml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <47425EA5.7000607@rtr.ca> <200711201517.16171.nickpiggin@yahoo.com.au> <20071119213727.16d5917b@laptopd505.fenrus.org>
In-Reply-To: <20071119213727.16d5917b@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711201837.39664.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007 16:37, Arjan van de Ven wrote:
> On Tue, 20 Nov 2007 15:17:15 +1100

> > For that matter, I'd like to know why it has been decided that the
> > best place for IRQ balancing is in userspace. It should be in kernel
> > IMO, and it would probably allow better power saving, performance,
> > fairness, etc. if it were to be integrated with the task balancer as
> > well.
>
> actually.... no. IRQ balancing is not a "fast" decision; every time you

I didn't say anything of the sort. But IRQ load could still fluctuate
a lot more rapidly than we'd like to wake up the irqbalancer.


> move an interrupt around, you end up causing a really a TON of cache
> line bounces, and generally really bad performance

All the more reason why the kernel should do it. When I say move it to
the kernel, I don't mean because I want to move IRQs 1 000 000 times
per second and can't sustain enough context switches to do it in
userspace. Userspace basically has insufficient information to do it
as well as kernel.

We do task balancing in the kernel too, it's a pretty similar problem
(although granted it is less feasible for userspace because tasks are
created and destroyed very often)


> (esp if you do it 
> for networking ones, since you destroy the packet reassembly stuff in
> the tcp/ip stack).
>
> Instead, what ends up working is if you do high level categories of
> interrupt classes and balance within those (so that no 2 networking
> irqs are on the same core/package unless you have more nics than cores)

Sure, but you say that like it is difficult information for the kernel
to know about. Actually it is much easier. Note that you can still
bind interrupts to specific CPUs.


> etc. Balancing on a 10 second scale seems to work quite well; no need
> to pull that complexity into the kernel....

My perspective is that it isn't a good idea to have such a critical
piece of infrastructure outside the kernel.

I want the kernel to balance interrupts and tasks fairly; maybe move
interrupts closer to the tasks they are interacting with (instead of,
or combined with our current policy of moving tasks near the interrupts,
which can be much more damaging for cache and NUMA); move all interrupts
to a single core when there is enough capacity and we are balancing for
power savings; do exponential interrupt balancing backoff when it isn't
required; etc. Not easy to do all that in userspace.

Any reason you actually think it is a good idea, aside from the fact
that a userspace solution was able to be better than a crappy old
kernel one?

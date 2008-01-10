Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYAJVZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYAJVZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 16:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYAJVZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 16:25:23 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36340 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbYAJVZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 16:25:22 -0500
Subject: Re: [RFC PATCH 13/22 -v2] handle accurate time keeping over long
	delays
From: john stultz <johnstul@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tony Luck <tony.luck@intel.com>, bob.picco@hp.com,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080110204259.GB5836@Krystal>
References: <20080109232914.676624725@goodmis.org>
	 <20080109233044.288563621@goodmis.org>
	 <1199923219.6350.16.camel@localhost.localdomain>
	 <12c511ca0801101154q224c7a43sa016190cf209d304@mail.gmail.com>
	 <1199996959.6108.18.camel@localhost.localdomain>
	 <20080110204259.GB5836@Krystal>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 13:25:14 -0800
Message-Id: <1200000314.30225.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 15:42 -0500, Mathieu Desnoyers wrote:
> I think it's about time I introduce the approach I have taken for LTTng
> timestamping. Basically, one of the main issues with the clock sources
> is the xtime lock : having a read seqlock nested over a write seqlock is
> a really, really bad idea. This can happen with NMIs. Basically, it
> would cause a deadlock.
> 
> What I have done is an RCU algorithm that extends a 32 bits TSC (that's
> the case on MIPS, for instance) to 64 bits. The update of the MSBs is
> done by a periodical timer (fired often enough to make sure we always
> detect the 32 LSBs wrap-around) and the read-side only has to disable
> preemption.
> 
> I use a 2 slots array, each of them keeping, alternatively, the last 64
> bits counter value, to implement the RCU algorithm.
> 
> Since we are discussing time source modification, this is one that I
> would really like to see in the Linux kernel : it would provide the kind
> of time source needed for function entry/exit tracing and for generic
> kernel tracing as well.

Hmm. I know powerpc has had a similar lock-free dual structure method
and for just a raw cycles based method you've shown below (or for some
of the bits Steven is working on), I think it should be fine.

The concern I've had with this method for general timekeeping, is that
I'm not sure it can handle the frequency corrections made by NTP. Since
we have to make sure time does not jump backwards, consider this
exaggerated situation:

time = base + (now - last)*mult;

So we have two structures:
base: 60		base: 180
last: 10		last: 30
mult: 06		mult: 05

Where the second structure has just been updated lock-free, however just
before the atomic pointer switch we were preempted, or somehow delayed,
and some time has past.

Now imagine two cpus now race to get the time. Both read the same now
value, but get different structure pointer values. (Note: You can create
the same race if you reverse the order and grab the pointer first, then
the cycle. However I think this example makes it easier to understand).

now = 50
cpu1:
  60 + (50-10)*6 = 300
cpu2:
  180 + (50-30)*5 = 280


Alternatively:
now=50: 60 + (50-10)*6 = 300
now=51: 180 + (51-30)*5 = 285

Eek. That's not good.

I'm not sure how this can be avoided, but I'd be very interested in
hearing ideas! Bounding the issue is a possibility, but then starts to
run amok with NO_HZ and -rt deferment.

thanks
-john



Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbXKNHr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbXKNHr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 02:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbXKNHru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 02:47:50 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:29552 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750964AbXKNHrt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 02:47:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=c31lCinS1veXNXIYh++A0gRXmBpuHl6Hk3eSCKIgr9Xb6/KSdLw+Y8EcaJsaPO8hK7nDdLQiKGP3UKDOLmgZf4LQmJPoJjcmt/3xMlY3Np6HeghzyWkN4XJJWyFXwZM30x3BynOv9QHHG2eeIPykZUHfkhPtFK9Je6XdEQlp1Eo=  ;
X-YMail-OSG: oCXMCL8VM1n3Ikj2Bu15oX6UJlCeAdkEo4W2W3w5C8jLUlxjaWYWSVd00F.BICHjaG5E93qFSw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Wed, 14 Nov 2007 06:45:26 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <200711091136.20051.david-b@pacbell.net> <20071113124656.3c333bdd.akpm@linux-foundation.org> <200711132252.15872.david-b@pacbell.net>
In-Reply-To: <200711132252.15872.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711140645.26363.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007 17:52, David Brownell wrote:
> On Tuesday 13 November 2007, Andrew Morton wrote:

> > > I'll highlight the
> > > point that such bitops shouldn't be preemption points.
> >
> > Disagree.  *everything* should be a preemption point.
>
> So it's wrong that <asm-generic/bitops/atomic.h> uses the
> same calls to prevent *those* bitops from being prempted?

Upstream, all spinlocks prevent preemption. But these ones
are raw locks rather than normal locks probably because that
they are trivially an innermost and correct lock. It's not
going to be very helpful to bloat it and slow it down when
debugging is turned on (atomic operations are _very_ frequent).

For -rt, who knows. They probably don't even run on parisc
or sparc so don't really care at this point.


> Thus, that code should switch over to normal spinlocks...

For upstream, there is little reason to switch them over, and
some reasons not to.


> I believe that if I submitted patches to do that, there'd
> be a not-so-small riot.  And the arguments would all boil
> down to much the same ones applying to *these* bitops...

I don't think you have valid reasons. Also, core/arch code has
some different considerations to driver code.


> > For internal-implementation
> > details we do need to disable preemtion sometimes
> > (to prevent deadlocks and to protect per-cpu resources).
>
> You're certainly talking about "internal-implementation
> details" in this case.  It's not like the lock is used
> outside of those routines.  Or as if other implementations
> would even *need* such a lock.  (Just like the IRQ table,
> if the entries can't be removed and are all set up very
> early, locking would be pointless.)

Internal implementation details, as in: spin lock code has to
disable preemption otherwise they deadlock; get_cpu_var() has
to disable preemption to give coherent access to the variable
etc.

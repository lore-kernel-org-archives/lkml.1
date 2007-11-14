Return-Path: <linux-kernel-owner+w=401wt.eu-S1763987AbXKNHJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763987AbXKNHJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 02:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761511AbXKNHIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 02:08:52 -0500
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:24520 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760883AbXKNHIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 02:08:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=QbxkDNaJeLMTjIm383V+nnuRFM0Keg3O0Rw6EzH33p9Az5m9MMUoKnAzAKaXZHhLa10Me/Zrj9DglaStJ+YtmycwNZuFNhp/0WLqNO3X776Zjnh75R6//1qYgnCIBNcyheWLLJBi50KSO9WEVEJC0MnfmM9lACBt5Pl2tGAc1Fw=  ;
X-YMail-OSG: VUW_nHgVM1keSnf1Ww2KiobGK2HkK6B5FRi5kIpTO.UEbPz8pVlD7XryW0o3FIH1j0s52QJCEw--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Tue, 13 Nov 2007 22:52:15 -0800
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
References: <200711091136.20051.david-b@pacbell.net> <200711131122.45950.david-b@pacbell.net> <20071113124656.3c333bdd.akpm@linux-foundation.org>
In-Reply-To: <20071113124656.3c333bdd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711132252.15872.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007, Andrew Morton wrote:
> 
> > >      Why do you want to use raw_spinlock_t?
> > 
> > Already answered elsewhere in this thread ...
> 
> Can't say I really understood the answer.  I don't think we
> actually know where all of this extra time is being spent?

Reading that, one could think performance was the only factor.
But it isn't, and wasn't the one which really persuaded me.

And yes we do where that time went.  Although it seems that
repeating that info once again won't help...


> > I'll highlight the
> > point that such bitops shouldn't be preemption points.
> 
> Disagree.  *everything* should be a preemption point.

So it's wrong that <asm-generic/bitops/atomic.h> uses the
same calls to prevent *those* bitops from being prempted?

Thus, that code should switch over to normal spinlocks...

I believe that if I submitted patches to do that, there'd
be a not-so-small riot.  And the arguments would all boil
down to much the same ones applying to *these* bitops...


> For internal-implementation
> details we do need to disable preemtion sometimes 
> (to prevent deadlocks and to protect per-cpu resources).

You're certainly talking about "internal-implementation
details" in this case.  It's not like the lock is used
outside of those routines.  Or as if other implementations
would even *need* such a lock.  (Just like the IRQ table,
if the entries can't be removed and are all set up very
early, locking would be pointless.)


> But those 
> preemption-off periods should be minimised.

Like the three instructions in the "hot paths" for getting
and setting GPIO values, when using raw spinlocks ... check.

- Dave


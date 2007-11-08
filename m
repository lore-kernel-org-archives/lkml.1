Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbXKHICg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbXKHICg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 03:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbXKHIC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 03:02:28 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:39959 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751419AbXKHIC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 03:02:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LUUMQj9fV3At9ZszxWtF4KBRoONB8lYuOl93UeZp/PhwVPno2CBR5yklgO2tNhevvB8SNsgADxImIfI6857HKnTpQEo11GFBV08m9HkzS6i2kIHrGYSJ6zIeTsJ0asxjZAKgaDg4Yy4+61PV2GrWV34FGEvDFmTaWCfR8QlY5PU=  ;
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: VM/networking crash cause #1: page allocation failure (order:1, GFP_ATOMIC)
Date: Thu, 8 Nov 2007 16:55:38 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20071105174214.GA10729@janus> <200711070901.17839.nickpiggin@yahoo.com.au> <20071107134843.GA14000@janus>
In-Reply-To: <20071107134843.GA14000@janus>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711081655.38371.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2007 00:48, Frank van Maarseveen wrote:
> On Wed, Nov 07, 2007 at 09:01:17AM +1100, Nick Piggin wrote:
> > On Tuesday 06 November 2007 04:42, Frank van Maarseveen wrote:
> > > For quite some time I'm seeing occasional lockups spread over 50
> > > different machines I'm maintaining. Symptom: a page allocation failure
> > > with order:1, GFP_ATOMIC, while there is plenty of memory, as it seems
> > > (lots of free pages, almost no swap used) followed by a lockup
> > > (everything dead). I've collected all (12) crash cases which occurred
> > > the last 10 weeks on 50 machines total (i.e. 1 crash every 41 weeks on
> > > average). The kernel messages are summarized to show the interesting
> > > part (IMO) they have in common. Over the years this has become the
> > > crash cause #1 for stable kernels for me (fglrx doesn't count ;).
> > >
> > > One note: I suspect that reporting a GFP_ATOMIC allocation failure in
> > > an network driver via that same driver (netconsole) may not be the
> > > smartest thing to do and this could be responsible for the lockup
> > > itself. However, the initial page allocation failure remains and I'm
> > > not sure how to address that problem.
> >
> > It isn't unexpected. If an atomic allocation doesn't have enough memory,
> > it kicks off kswapd to start freeing memory for it. However, it cannot
> > wait for memory to become free (it's GFP_ATOMIC), so it has to return
> > failure. GFP_ATOMIC allocation paths are designed so that the kernel can
> > recover from this situation, and a subsequent allocation will have free
> > memory.
> >
> > Probably in production kernels we should default to only reporting this
> > when page reclaim is not making any progress.
> >
> > > I still think the issue is memory fragmentation but if so, it looks
> > > a bit extreme to me: One system with 2GB of ram crashed after a day,
> > > merely running a couple of TCP server programs. All systems have either
> > > 1 or 2GB ram and at least 1G of (merely unused) swap.
> >
> > You can reduce the chances of it happening by increasing
> > /proc/sys/vm/min_free_kbytes.
>
> It's 3807 everywhere by default here which means roughly 950 pages if I
> understand correctly. However, the problem occurs with much more free
> pages as it seems. "grep '  free:' messages*" on the netconsole logging
> machine shows:

But it's an order-1 allocation, which may not be available due to
fragmentation. Although you might have large amounts of memory free
at a given point, fragmentation can be triggered earlier when free
memory gets very low (because order-0 allocations may have taken up
all of the free order-1 pages).

Increasing it is known to help. Although you shouldn't crash due to
allocation failures... it would be nice if you could connect a serial
or vga console and see what's happening...

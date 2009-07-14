Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZGNKhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZGNKhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbZGNKhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:37:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:47797 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbZGNKhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:37:46 -0400
Subject: Re: [PATCH] dma-debug: Fix the overlap() function to be correct
 and readable
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joerg Roedel <joerg.roedel@amd.com>
In-Reply-To: <1247566542.2473.18.camel@ht.satnam>
References: <20090710162848.GA26862@elte.hu>
	 <alpine.LFD.2.01.0907101206120.3352@localhost.localdomain>
	 <20090710193110.GA28281@elte.hu>  <20090710195157.GA31361@elte.hu>
	 <1247566542.2473.18.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 16:07:02 +0530
Message-Id: <1247567822.2473.21.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 15:45 +0530, Jaswinder Singh Rajput wrote:
> > >From 35c89da82e969a2fd157478940e7ecde1e19ccc4 Mon Sep 17 00:00:00 2001
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Fri, 10 Jul 2009 21:38:02 +0200
> > Subject: [PATCH] dma-debug: Fix the overlap() function to be correct and readable
> > 
> > Linus noticed how unclean and buggy the overlap() function is:
> > 
> >  - It uses convoluted (and bug-causing) positive checks for
> >    range overlap - instead of using a more natural negative
> >    check.
> > 
> >  - Even the positive checks are buggy: a positive intersection
> >    check has four natural cases while we checked only for three,
> >    missing the (addr < start && addr2 == end) case for example.
> > 
> >  - The variables are mis-named, making it non-obvious how the
> >    check was done.
> > 
> >  - It needlessly uses u64 instead of unsigned long. Since these
> >    are kernel memory pointers and we explicitly exclude highmem
> >    ranges anyway we cannot ever overflow 32 bits, even if we
> >    could. (and on 64-bit it doesnt matter anyway)
> > 
> > All in one, this function needs a total revamp. I used Linus's
> > suggestions minus the paranoid checks (we cannot overflow really
> > because if we get totally bad DMA ranges passed far more things
> > break in the systems than just DMA debugging). I also fixed a
> > few other small details i noticed.
> > 
> > Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Joerg Roedel <joerg.roedel@amd.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  lib/dma-debug.c |   24 ++++++++++++------------
> >  1 files changed, 12 insertions(+), 12 deletions(-)
> > 
> > diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> > index c9187fe..02fed52 100644
> > --- a/lib/dma-debug.c
> > +++ b/lib/dma-debug.c
> > @@ -856,22 +856,21 @@ static void check_for_stack(struct device *dev, void *addr)
> >  				"stack [addr=%p]\n", addr);
> >  }
> >  
> > -static inline bool overlap(void *addr, u64 size, void *start, void *end)
> > +static inline bool overlap(void *addr, unsigned long len, void *start, void *end)
> >  {
> > -	void *addr2 = (char *)addr + size;
> > +	unsigned long a1 = (unsigned long)addr;
> > +	unsigned long b1 = a1 + len;
> > +	unsigned long a2 = (unsigned long)start;
> > +	unsigned long b2 = (unsigned long)end;
> >  
> > -	return ((addr >= start && addr < end) ||
> > -		(addr2 >= start && addr2 < end) ||
> > -		((addr < start) && (addr2 > end)));
> > +	return !(b1 <= a2 || a1 >= b2);
> >  }
> >  
> 
> If b1 = a2 (overlap) then this function will say 0
> If a1 = b2 (overlap) then this function will say 0
> 
> if b1 > (a2 + infinite) which is not overlap this function will say 1
> 
> I think we need to test both edges.
> 
> So it should be :
> 
> 	return ((a2 <= b1 && b2 >= a1) || (a1 <= b2 && a2 <= b1));
> 

We can make it more beautiful like :

	return ((a2 <= b1 && b2 >= a1) || (a1 <= b2 && b1 >= a2));

--
JSR


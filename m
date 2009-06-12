Return-Path: <linux-kernel-owner+w=401wt.eu-S1761125AbZFLNft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761125AbZFLNft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765124AbZFLN2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:28:05 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:7222 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762393AbZFLN2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:28:00 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2009 09:28:00 EDT
X-SpamScore: -28
X-BigFish: VPS-28(zz1432R98dR4015L1805Mzz1202hzzz32i17ch6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KL4ND8-02-BCR-01
Date: Fri, 12 Jun 2009 15:11:45 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86: memtest: fix compile warning
Message-ID: <20090612131145.GH12431@alberich.amd.com>
References: <20090611112746.802a24cb.sfr@canb.auug.org.au> <20090611102927.GE12431@alberich.amd.com> <alpine.LFD.2.00.0906111512400.3372@localhost.localdomain> <20090611152658.GF12431@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090611152658.GF12431@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Jun 2009 13:12:37.0436 (UTC) FILETIME=[750397C0:01C9EB5F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 05:26:58PM +0200, Andreas Herrmann wrote:
> On Thu, Jun 11, 2009 at 04:21:41PM +0200, Thomas Gleixner wrote:
> > On Thu, 11 Jun 2009, Andreas Herrmann wrote:
> > 
> > > Commit c9690998ef48ffefeccb91c70a7739eebdea57f9
> > > (x86: memtest: remove 64-bit division) introduced following compile warning:
> > > 
> > >  arch/x86/mm/memtest.c: In function 'memtest':
> > >  arch/x86/mm/memtest.c:56: warning: comparison of distinct pointer types lacks a cast
> > >  arch/x86/mm/memtest.c:58: warning: comparison of distinct pointer types lacks a cast
> > > 
> > > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > > ---
> > >  arch/x86/mm/memtest.c |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > Sorry.
> > > Please apply.
> > 
> > I applied it already, but zapped it right away, as it is bad style to
> > do the type casting in the loops. The proper fix is below.
> 
> Doesn't your fix re-introduces the 64-bit division problem with old
> gcc?  I removed that division with the mentioned commit just forgot to
> type-cast the pointer.

It doesn't.

> > diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
> > index d1c5cef..18d244f 100644
> > --- a/arch/x86/mm/memtest.c
> > +++ b/arch/x86/mm/memtest.c
> > @@ -40,16 +40,14 @@ static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
> >  
> >  static void __init memtest(u64 pattern, u64 start_phys, u64 size)
> >  {
> > -	u64 *p, *end;
> > -	void *start;
> > +	u64 *p, *start, *end;
> >  	u64 start_bad, last_bad;
> >  	u64 start_phys_aligned;
> > -	size_t incr;
> > +	const size_t incr = sizeof(pattern);

The const qualifier made the difference.


Thanks,

Andreas



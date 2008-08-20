Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYHTTlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYHTTlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757052AbYHTTlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:41:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:53200 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756966AbYHTTl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:41:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,240,1217833200"; 
   d="scan'208";a="430858757"
Date: Wed, 20 Aug 2008 12:41:28 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Airlie <airlied@gmail.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
Message-ID: <20080820194127.GA10887@linux-os.sc.intel.com>
References: <48972EA8.8040001@keyaccess.nl> <20080815142218.GC12954@elte.hu> <48A59FAC.7050605@keyaccess.nl> <48AA9C3B.5030309@keyaccess.nl> <20080819102633.GE6722@elte.hu> <48AAD680.7020508@keyaccess.nl> <20080819190757.GA17470@linux-os.sc.intel.com> <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl> <48AC29CA.1060203@keyaccess.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AC29CA.1060203@keyaccess.nl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 07:27:22AM -0700, Rene Herman wrote:
> On 20-08-08 12:50, Rene Herman wrote:
> 
> > On 20-08-08 12:04, Ingo Molnar wrote:
> >
> >> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> >>
> >>>> I'd really like a reply from the AGP or PAT side right about now.
> >>> Hmm. Looks like there are more than 16000 entries in the PAT list!
> >>
> >> hm, btw., why is that?
> >
> > Because 64M of AGP memory divided by 4K pages is 16K. That is, the
> > underlying problem seems to be AGP drivers using order 0 allocations.
> > I'm looking.
> >
> > Do note also that this means that Venki's change would not constitite a
> > correct/final fix. Sure, caching the last entry speeds up traversing a
> > 16K entry list but the issue is that there shouldn't be a 16K entry
> > list. Through AGP, or maybe even by coalescing entries in the PAT list
> > if that's at all possible (I guess it's not really).
> >
> > Even if such a more fundamental fix isn't (easily) available, the PAT
> > code already comments that the list, which is sorted by ->start value,
> > is expected to be short, and should be turned into an rbtree if it isn't
> > which might be slightly less of a bandaid.
> >
> > Dave Airlie (as the MAINTAINERS entry) can't be arsed to answer email it
> > seems so I've added Dave Jones for a possible comment from the AGP side.
> > If I'm reading this right upto now, still many AGP driver (among which
> > my amd-k7-agp) are affected.
> 
> This was based on a wrong reading; I was looking at the GATT allocation.
> 
> I'm giving up looking until someone can tell me whether or not those 16K
> entries are expected though. I have just one AGP card in a PAT capable
> machine.
> 

OK. I have reproduced this list size issue locally and this order 1
allocation and set_memory_uc on that allocation is actually coming from
agp_allocate_memory() -> agp_generic_alloc_page() -> map_page_into_agp()
agp_allocate_memory breaks higher order page requests into order 1 allocs.

On my system I see multiple agp_allocate_memory requests for nrpages
8841, 1020, 16, 2160, 2160, 8192. Together they end up resulting in
more than 22K entries in PAT pages.

Thanks,
Venki


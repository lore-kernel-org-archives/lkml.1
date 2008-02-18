Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbYBRBPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbYBRBPU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 20:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYBRBPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 20:15:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:51654 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYBRBPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 20:15:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,368,1199692800"; 
   d="scan'208";a="258355420"
Subject: Re: arch/x86/mm/ioremap unification grew by 10x
From: "Huang, Ying" <ying.huang@intel.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Matt Mackall <mpm@selenic.com>, Sam Ravnborg <sam@ravnborg.org>,
       Linux Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1203275382.27987.20.camel@localhost.localdomain>
References: <1203107155.12383.230.camel@cinder.waste.org>
	 <20080215203228.GA4295@uranus.ravnborg.org>
	 <1203110488.12383.231.camel@cinder.waste.org>
	 <1203117425.12383.238.camel@cinder.waste.org>
	 <1203275382.27987.20.camel@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Feb 2008 09:16:10 +0800
Message-Id: <1203297370.27509.4.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 18 Feb 2008 01:15:01.0733 (UTC) FILETIME=[AF88B150:01C871CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-02-17 at 19:09 +0000, Ian Campbell wrote:
> On Fri, 2008-02-15 at 17:17 -0600, Matt Mackall wrote:
> > On Fri, 2008-02-15 at 15:21 -0600, Matt Mackall wrote:
> > > On Fri, 2008-02-15 at 21:32 +0100, Sam Ravnborg wrote:
> > > > On Fri, Feb 15, 2008 at 02:25:54PM -0600, Matt Mackall wrote:
> > > > > In 2.6.24 defconfig, my build stats show ioremap_32.o was 1.8k. In
> > > > > 2.6.25-rc1, the unified ioremap.o is 20.8k.
> > > > 
> > > > Just an observation - 17 commits touches said file after
> > > > the unification (at least in latest -linus).
> > > 
> > > Correction: those numbers should be halved. So we're going from .9k to
> > > 10.4k.
> > 
> > And here's most of the cause:
> > 
> > 000002b8 00000124 T early_ioremap
> > 00001000 00001000 t bm_pte
> > 00002000 00000004 T early_ioremap_debug
> > 
> > static __initdata pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]
> > 				__attribute__((aligned(PAGE_SIZE)));
> > 
> > Double ouch. First, this isn't in BSS. Second, even though it's
> > initdata, the alignment slop won't get recovered.
> 
> 551889a6e2a24a9c06fd453ea03b57b7746ffdc0 (the reason you CC'd me) only
> changed this from unsigned long[1024] to pte_t[PAGE_SIZE/sizeof(pte_t)]
> 
> -static __initdata unsigned long bm_pte[1024]
> +static __initdata pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]
>                                 __attribute__((aligned(PAGE_SIZE)));
> 
> I don't think that would have changed anything in this respect. It seems
> to have been that way since 0947b2f31ca1ea1211d3cde2dbd8fcec579ef395
> when it was added (Huang Ying CC'd).
> 
> > Don't we have a special section for page-aligned crap so it doesn't
> > waste most of two pages?
> 
> We have .bss.page_aligned and it seems appropriate to use it.

But .bss.page_aligned is not an init section, this will waste some
memory after boot. Do you think that it is more appropriate to add
another section like .init.bss and .init.bss.page_aligned.

Best Regards,
Huang Ying


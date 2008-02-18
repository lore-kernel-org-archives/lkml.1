Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbYBRDRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbYBRDRn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 22:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbYBRDRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 22:17:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59925 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbYBRDRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 22:17:35 -0500
Date: Mon, 18 Feb 2008 04:17:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ian Campbell <ijc@hellion.org.uk>, Matt Mackall <mpm@selenic.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/mm/ioremap unification grew by 10x
Message-ID: <20080218031717.GF30201@elte.hu>
References: <1203107155.12383.230.camel@cinder.waste.org> <20080215203228.GA4295@uranus.ravnborg.org> <1203110488.12383.231.camel@cinder.waste.org> <1203117425.12383.238.camel@cinder.waste.org> <1203275382.27987.20.camel@localhost.localdomain> <1203297370.27509.4.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203297370.27509.4.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang, Ying <ying.huang@intel.com> wrote:

> > > And here's most of the cause:
> > > 
> > > 000002b8 00000124 T early_ioremap
> > > 00001000 00001000 t bm_pte
> > > 00002000 00000004 T early_ioremap_debug
> > > 
> > > static __initdata pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]
> > > 				__attribute__((aligned(PAGE_SIZE)));
> > > 
> > > Double ouch. First, this isn't in BSS. Second, even though it's
> > > initdata, the alignment slop won't get recovered.
> > 
> > 551889a6e2a24a9c06fd453ea03b57b7746ffdc0 (the reason you CC'd me) only
> > changed this from unsigned long[1024] to pte_t[PAGE_SIZE/sizeof(pte_t)]
> > 
> > -static __initdata unsigned long bm_pte[1024]
> > +static __initdata pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]
> >                                 __attribute__((aligned(PAGE_SIZE)));
> > 
> > I don't think that would have changed anything in this respect. It seems
> > to have been that way since 0947b2f31ca1ea1211d3cde2dbd8fcec579ef395
> > when it was added (Huang Ying CC'd).
> > 
> > > Don't we have a special section for page-aligned crap so it doesn't
> > > waste most of two pages?
> > 
> > We have .bss.page_aligned and it seems appropriate to use it.
> 
> But .bss.page_aligned is not an init section, this will waste some 
> memory after boot. Do you think that it is more appropriate to add 
> another section like .init.bss and .init.bss.page_aligned.

agreed, and i'd suggest we do so before this information gets forgotten 
and someone has to re-discover the fix the hard way.

	Ingo

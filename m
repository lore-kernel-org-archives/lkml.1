Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbYBQT2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbYBQT2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbYBQT2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:28:34 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:47671 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbYBQT2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:28:33 -0500
Date: Sun, 17 Feb 2008 20:28:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Matt Mackall <mpm@selenic.com>,
       Linux Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>
Subject: Re: arch/x86/mm/ioremap unification grew by 10x
Message-ID: <20080217192840.GH14588@uranus.ravnborg.org>
References: <1203107155.12383.230.camel@cinder.waste.org> <20080215203228.GA4295@uranus.ravnborg.org> <1203110488.12383.231.camel@cinder.waste.org> <1203117425.12383.238.camel@cinder.waste.org> <1203275382.27987.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203275382.27987.20.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 07:09:42PM +0000, Ian Campbell wrote:
> 
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
> 
> Ian.
> 
> --- 
> From ac954372c1ed7830148bdea1e4283856c05c354f Mon Sep 17 00:00:00 2001
> From: Ian Campbell <ijc@hellion.org.uk>
> Date: Sun, 17 Feb 2008 19:08:34 +0000
> Subject: [PATCH] x86: bm_pte can be placed in .bss.page_aligned.
> 
>     text	   data	    bss	    dec	    hex	filename
>     -   3388	   8236	      4	  11628	   2d6c	../build-32/arch/x86/mm/ioremap.o
>     +   3388	     48	   4100	   7536	   1d70	../build-32/arch/x86/mm/ioremap.o
> 
> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Huang Ying <ying.huang@intel.com>
> ---
>  arch/x86/mm/ioremap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index 69f4981..c62ecbd 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -262,8 +262,8 @@ static int __init early_ioremap_debug_setup(char *str)
>  early_param("early_ioremap_debug", early_ioremap_debug_setup);
>  
>  static __initdata int after_paging_init;
> -static __initdata pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]
> -				__attribute__((aligned(PAGE_SIZE)));
> +static pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]

Replace
> +		__attribute__((__section__(".bss.page_aligned")));

with the shorter form:
> +		__section(.bss.page_aligned)));


	Sam

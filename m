Return-Path: <linux-kernel-owner+w=401wt.eu-S935975AbZDBLU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935975AbZDBLU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932597AbZDBLUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:20:12 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:47411 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759064AbZDBLUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:20:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=12sCDMdRMg0RChQZrbm3dXCzsVmndjs5U0r0PIdmEtsERo+ZGwinZt8WvIpaBDrLyrvOkFxPFTGvqDtNxhCaHrrvQ5WvbXjry0lOkfYMVDTAZvGS8ay0W63pY45g5jylAWn47ziR9+5008OwRIid/LHpgXUWKtwnKL4slIq0HcQ=  ;
X-YMail-OSG: 21PRi58VM1mieY6xj9Wt0qt5ksrRu8wmwQ5gDpsBxZ6KvyTjJCLZM4vRhGho1P7ByEFYY07tCdky78MSJOWV7iXDit_trosiaGJ4ofuQOP2G6lm9Odu6ZBpGiVrF_YGKicN4lJ_iCk7fj.knOWBlH1xg_1VBWpaX2okDnfMDTSiUNBBE7oyA1aIWqvyjGAIXH9EMcQEYPvw0SYSQy3EHWLL5UZpL8KekrY_CB1LcB0LPjM33WYDM50tM6FaRoAW0veN54hc_hurEiWnSrF0HEOg8xavywE69p77xWogXZ9PMsNdMokFYoM6PzyDab4p0fOTkmZ8u8FJ9YNlYGnRS
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] x86: gup_fast() batch limit (was: DRM lock ordering fix series)
Date: Thu, 2 Apr 2009 22:19:52 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Brice Goglin <Brice.Goglin@inria.fr>, Eric Anholt <eric@anholt.net>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
References: <1238017510-26784-1-git-send-email-eric@anholt.net> <1238242929.4039.706.camel@laptop> <1238244374.4039.743.camel@laptop>
In-Reply-To: <1238244374.4039.743.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904022219.53949.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 March 2009 23:46:14 Peter Zijlstra wrote:
> On Sat, 2009-03-28 at 13:22 +0100, Peter Zijlstra wrote:
> > I'm not really trusting my brain today, but something like the below
> > should work I think.
> >
> > Nick, any thoughts?
> >
> > Not-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  arch/x86/mm/gup.c |   24 +++++++++++++++++++++---
> >  1 files changed, 21 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
> > index be54176..4ded5c3 100644
> > --- a/arch/x86/mm/gup.c
> > +++ b/arch/x86/mm/gup.c
> > @@ -11,6 +11,8 @@
> >
> >  #include <asm/pgtable.h>
> >
> > +#define GUP_BATCH	32
> > +
> >  static inline pte_t gup_get_pte(pte_t *ptep)
> >  {
> >  #ifndef CONFIG_X86_PAE
> > @@ -91,7 +93,8 @@ static noinline int gup_pte_range(pmd_t pmd, unsigned
> > long addr, get_page(page);
> >  		pages[*nr] = page;
> >  		(*nr)++;
> > -
> > +		if (*nr > GUP_BATCH)
> > +			break;
> >  	} while (ptep++, addr += PAGE_SIZE, addr != end);
> >  	pte_unmap(ptep - 1);
> >
> > @@ -157,6 +160,8 @@ static int gup_pmd_range(pud_t pud, unsigned long
> > addr, unsigned long end, if (!gup_pte_range(pmd, addr, next, write,
> > pages, nr))
> >  				return 0;
> >  		}
> > +		if (*nr > GUP_BATCH)
> > +			break;
> >  	} while (pmdp++, addr = next, addr != end);
> >
> >  	return 1;
> > @@ -214,6 +219,8 @@ static int gup_pud_range(pgd_t pgd, unsigned long
> > addr, unsigned long end, if (!gup_pmd_range(pud, addr, next, write,
> > pages, nr))
> >  				return 0;
> >  		}
> > +		if (*nr > GUP_BATCH)
> > +			break;
> >  	} while (pudp++, addr = next, addr != end);
> >
> >  	return 1;
> > @@ -226,7 +233,7 @@ int get_user_pages_fast(unsigned long start, int
> > nr_pages, int write, unsigned long addr, len, end;
> >  	unsigned long next;
> >  	pgd_t *pgdp;
> > -	int nr = 0;
> > +	int batch = 0, nr = 0;
> >
> >  	start &= PAGE_MASK;
> >  	addr = start;
> > @@ -254,6 +261,7 @@ int get_user_pages_fast(unsigned long start, int
> > nr_pages, int write, * (which we do on x86, with the above PAE
> > exception), we can follow the * address down to the the page and take a
> > ref on it.
> >  	 */
> > +again:
> >  	local_irq_disable();
> >  	pgdp = pgd_offset(mm, addr);
> >  	do {
> > @@ -262,11 +270,21 @@ int get_user_pages_fast(unsigned long start, int
> > nr_pages, int write, next = pgd_addr_end(addr, end);
> >  		if (pgd_none(pgd))
> >  			goto slow;
> > -		if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
> > +		if (!gup_pud_range(pgd, addr, next, write, pages, &batch))
> >  			goto slow;
> > +		if (batch > GUP_BATCH) {
> > +			local_irq_enable();
> > +			addr += batch << PAGE_SHIFT;
> > +			nr += batch;
> > +			batch = 0;
> > +			if (addr != end)
> > +				goto again;
> > +		}
> >  	} while (pgdp++, addr = next, addr != end);
> >  	local_irq_enable();
> >
> > +	nr += batch;
> > +
> >  	VM_BUG_ON(nr != (end - start) >> PAGE_SHIFT);
> >  	return nr;
>
> Would also need the following bit:
>
> @@ -274,6 +292,7 @@ int get_user_pages_fast(unsigned long start, int
> nr_pages, int write, int ret;
>
>  slow:
> +		nr += batch;
>  		local_irq_enable();
>  slow_irqon:
>  		/* Try to get the remaining pages with get_user_pages */


Yeah something like this would be fine (and welcome). And we can
remove the XXX comment in there too. I would suggest 64 being a
reasonable value simply because that's what direct IO does.

Implementation-wise, why not just break "len" into chunks in the
top level function rather than add branches all down the call
chain?


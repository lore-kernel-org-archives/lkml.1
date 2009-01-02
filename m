Return-Path: <linux-kernel-owner+w=401wt.eu-S1757889AbZABJ5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbZABJ5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756612AbZABJ5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:57:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36878 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294AbZABJ5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:57:36 -0500
Date: Fri, 2 Jan 2009 10:57:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Tom Spink <tspink@gmail.com>, Ingo Brueckl <ib@wupperonline.de>,
       linux-kernel@vger.kernel.org
Subject: Re: compile time warnings
Message-ID: <20090102095727.GH1975@elte.hu>
References: <495d3100@wupperonline.de> <alpine.LNX.2.00.0901012312450.11772@swampdragon.chaosbits.net> <7b9198260901011735k42e9298tb1c5dc0e15285eb1@mail.gmail.com> <alpine.LNX.2.00.0901020301230.11772@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0901020301230.11772@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jesper Juhl <jj@chaosbits.net> wrote:

> On Fri, 2 Jan 2009, Tom Spink wrote:
> 
> > 2009/1/1 Jesper Juhl <jj@chaosbits.net>:
> > > On Thu, 1 Jan 2009, Ingo Brueckl wrote:
> > [snip]
> > 
> > Hi,
> > 
> > > pgd_base is very much used...
> > 
> > It's probably something to do with:
> > 
> > # define permanent_kmaps_init(pgd_base)         do { } while (0)
> > 
> > Which is within the #else part of #if CONFIG_HIGHMEM.  So, if
> > CONFIG_HIGHMEM is not set, permanent_kmaps_init gets wiped out, and
> > therefore that warning will be issued.
> > 
> > Perhaps changing that to an empty inline would remove the warning?
> > 
> Yeah, I noticed that as well after sending the mail.
> Another way to silence the warning (which I think is nicer) would be 
> something like this;
> 
> 
> Silence 'unused variable' warning in arch/x86/mm/init_32.c::pagetable_init
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
> 
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 8655b5b..0affa8e 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -511,9 +511,7 @@ static void __init early_ioremap_page_table_range_init(pgd_t *pgd_base)
>  
>  static void __init pagetable_init(void)
>  {
> -	pgd_t *pgd_base = swapper_pg_dir;
> -
> -	permanent_kmaps_init(pgd_base);
> +	permanent_kmaps_init((pgd_t *)swapper_pg_dir);
>  }

no, this only works around the warning by 'silencing' it (it also includes 
an ugly type cast) - instead of fixing the core problem.

The core problem is that permanent_kmaps_init() is a CPP macro in the 
!HIGHMEM case - so the right fix would be to convert that to a proper C 
inline function. (same for set_highmem_pages_init() while at it)

Would you mind to send a patch for that that we could push to Linus?

<soapbox>

The highest quality fixes that are motivated by compiler warnings are the 
ones that do not actually 'fix a warning', but instead improve/reshape 
some code so that as a side-effect the warning goes away.

If you ever see a patch that 'silences a warning', it usually shows that 
the deeper problem has not been fully understood. (Except of course if the 
warning shows a genuine bug in the code - but in that case we fix the bug 
and not the warning - the warning was just the canary to it.)

</soapbox>

	Ingo

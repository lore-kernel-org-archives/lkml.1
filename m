Return-Path: <linux-kernel-owner+w=401wt.eu-S934495AbZARR3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934495AbZARR3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 12:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764991AbZARR31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 12:29:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35814 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764652AbZARR30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 12:29:26 -0500
Date: Sun, 18 Jan 2009 18:29:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip] fix 41 'make headers_check' warnings
Message-ID: <20090118172908.GC22624@elte.hu>
References: <1232273454.23100.9.camel@localhost.localdomain> <20090118110221.GA29602@elte.hu> <20090118125721.GA31655@uranus.ravnborg.org> <20090118130059.GA32422@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118130059.GA32422@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sun, Jan 18, 2009 at 01:57:22PM +0100, Sam Ravnborg wrote:
> > On Sun, Jan 18, 2009 at 12:02:21PM +0100, Ingo Molnar wrote:
> > > 
> > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > 
> > > > diff --git a/include/linux/acct.h b/include/linux/acct.h
> > > > index 882dc72..a20c97c 100644
> > > > --- a/include/linux/acct.h
> > > > +++ b/include/linux/acct.h
> > > > @@ -59,9 +59,13 @@ struct acct
> > > >  	comp_t		ac_majflt;		/* Major Pagefaults */
> > > >  	comp_t		ac_swaps;		/* Number of Swaps */
> > > >  /* m68k had no padding here. */
> > > > -#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
> > > > +#ifdef __KERNEL__
> > > > +#ifndef CONFIG_M68K
> > > >  	__u16		ac_ahz;			/* AHZ */
> > > > -#endif
> > > > +#endif /* CONFIG_M68K */
> > > > +#else /* __KERNEL__ */
> > > > +	__u16		ac_ahz;			/* AHZ */
> > > > +#endif /* __KERNEL__ */
> > > 
> > > that looks rather ugly.
> > > 
> > > Why not just flip it around to:
> > > 
> > > 	#if !defined(__KERNEL__) || !defined(CONFIG_M68K)
> > > 
> > > ? Does headers_check misinterpret that?
> > 
> > The original expression is misinterpreted by headers_check
> > because we want the ac_ahz to stay if either of __KERNEL__
> > or CONFIG_M68K is not defined.
> > And unifdef does not optimize away the !defined(CONFIG_M68K)
> > part - it has no knowledge that this is kernel internal.
> > 
> > So I am happy with Jaswinder's patch.
> Almost happy.
> I digged out my original patch and it looks like this:
> -#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
> +#ifndef __KERNEL__
>         __u16           ac_ahz;                 /* AHZ */
> +#else
> +  #ifndef CONFIG_M68K
> +       __u16           ac_ahz;                 /* AHZ */
> +  #endif
>  #endif
> 
> The indention can be discussed..
> But the logic is simpler.

yes - that's the 3-block versus 2-block issue i mentioned to Jaswinder. 
(the first version duplicated the same thing into 3 places - while the 
logic only splits it in two)

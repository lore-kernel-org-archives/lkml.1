Return-Path: <linux-kernel-owner+w=401wt.eu-S933282AbZARM0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbZARM0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 07:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbZARM0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 07:26:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52062 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbZARM0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 07:26:33 -0500
Date: Sun, 18 Jan 2009 13:26:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip] fix 41 'make headers_check' warnings
Message-ID: <20090118122610.GA3508@elte.hu>
References: <1232273454.23100.9.camel@localhost.localdomain> <20090118110221.GA29602@elte.hu> <1232278013.3130.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232278013.3130.8.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Sun, 2009-01-18 at 12:02 +0100, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > diff --git a/include/linux/acct.h b/include/linux/acct.h
> > > index 882dc72..a20c97c 100644
> > > --- a/include/linux/acct.h
> > > +++ b/include/linux/acct.h
> > > @@ -59,9 +59,13 @@ struct acct
> > >  	comp_t		ac_majflt;		/* Major Pagefaults */
> > >  	comp_t		ac_swaps;		/* Number of Swaps */
> > >  /* m68k had no padding here. */
> > > -#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
> > > +#ifdef __KERNEL__
> > > +#ifndef CONFIG_M68K
> > >  	__u16		ac_ahz;			/* AHZ */
> > > -#endif
> > > +#endif /* CONFIG_M68K */
> > > +#else /* __KERNEL__ */
> > > +	__u16		ac_ahz;			/* AHZ */
> > > +#endif /* __KERNEL__ */
> > 
> > that looks rather ugly.
> > 
> > Why not just flip it around to:
> > 
> > 	#if !defined(__KERNEL__) || !defined(CONFIG_M68K)
> > 
> > ? Does headers_check misinterpret that?
> > 
> 
> This will not many any difference:
> then usr/include/linux/acct.h will look like:
> #if !defined(__KERNEL__) || !defined(CONFIG_M68K)
>         __u16           ac_ahz;                 /* AHZ */
> #endif
> 
> And we will get same warning:
>   usr/include/linux/acct.h:62: leaks CONFIG_M68K to userspace where it is not valid

which would be a false positive. Sam, what would be your preference to 
annotate the code in such cases?

> > i.e. always provide the wider type to user-space.
> 
> Sorry, this will not be helpful we will still get the warning.

the problem here is that the type you export to user-space is the _wrong_ 
(narrow) type. Including types.h is one thing - exporting something to 
user-space is another thing. It might not matter in practice.

Furthermore, the 3 blocks are there as well - while there should only be 
two.

	Ingo

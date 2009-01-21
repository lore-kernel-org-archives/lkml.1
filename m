Return-Path: <linux-kernel-owner+w=401wt.eu-S1763104AbZAUA7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763104AbZAUA7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757666AbZAUA7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:59:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:48927 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431AbZAUA7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:59:09 -0500
Subject: Re: [GIT PULL -tip] fix 41 'make headers_check' warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090118172908.GC22624@elte.hu>
References: <1232273454.23100.9.camel@localhost.localdomain>
	 <20090118110221.GA29602@elte.hu>
	 <20090118125721.GA31655@uranus.ravnborg.org>
	 <20090118130059.GA32422@uranus.ravnborg.org>
	 <20090118172908.GC22624@elte.hu>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 06:28:35 +0530
Message-Id: <1232499515.3123.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 18:29 +0100, Ingo Molnar wrote:
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Sun, Jan 18, 2009 at 01:57:22PM +0100, Sam Ravnborg wrote:
> > > On Sun, Jan 18, 2009 at 12:02:21PM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > > 
> > > > > diff --git a/include/linux/acct.h b/include/linux/acct.h
> > > > > index 882dc72..a20c97c 100644
> > > > > --- a/include/linux/acct.h
> > > > > +++ b/include/linux/acct.h
> > > > > @@ -59,9 +59,13 @@ struct acct
> > > > >  	comp_t		ac_majflt;		/* Major Pagefaults */
> > > > >  	comp_t		ac_swaps;		/* Number of Swaps */
> > > > >  /* m68k had no padding here. */
> > > > > -#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
> > > > > +#ifdef __KERNEL__
> > > > > +#ifndef CONFIG_M68K
> > > > >  	__u16		ac_ahz;			/* AHZ */
> > > > > -#endif
> > > > > +#endif /* CONFIG_M68K */
> > > > > +#else /* __KERNEL__ */
> > > > > +	__u16		ac_ahz;			/* AHZ */
> > > > > +#endif /* __KERNEL__ */
> > > > 
> > > > that looks rather ugly.
> > > > 
> > > > Why not just flip it around to:
> > > > 
> > > > 	#if !defined(__KERNEL__) || !defined(CONFIG_M68K)
> > > > 
> > > > ? Does headers_check misinterpret that?
> > > 
> > > The original expression is misinterpreted by headers_check
> > > because we want the ac_ahz to stay if either of __KERNEL__
> > > or CONFIG_M68K is not defined.
> > > And unifdef does not optimize away the !defined(CONFIG_M68K)
> > > part - it has no knowledge that this is kernel internal.
> > > 
> > > So I am happy with Jaswinder's patch.
> > Almost happy.
> > I digged out my original patch and it looks like this:
> > -#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
> > +#ifndef __KERNEL__
> >         __u16           ac_ahz;                 /* AHZ */
> > +#else
> > +  #ifndef CONFIG_M68K
> > +       __u16           ac_ahz;                 /* AHZ */
> > +  #endif
> >  #endif
> > 
> > The indention can be discussed..
> > But the logic is simpler.
> 
> yes - that's the 3-block versus 2-block issue i mentioned to Jaswinder. 
> (the first version duplicated the same thing into 3 places - while the 
> logic only splits it in two)

my 7 lines patch was:
#ifdef __KERNEL__
#ifndef CONFIG_M68K
	__u16		ac_ahz;			/* AHZ */
#endif /* CONFIG_M68K */
#else /* __KERNEL__ */
	__u16		ac_ahz;			/* AHZ */
#endif /* __KERNEL__ */

and Sam's 7 line patch is:
#ifndef __KERNEL__
         __u16           ac_ahz;                 /* AHZ */
#else
  #ifndef CONFIG_M68K
         __u16           ac_ahz;                 /* AHZ */
  #endif
#endif

Ingo, please apply the patch which one you like, I just want to get rid of this warning ;-)

Thanks,
--
JSR


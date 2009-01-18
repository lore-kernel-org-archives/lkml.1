Return-Path: <linux-kernel-owner+w=401wt.eu-S1763353AbZARM7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763353AbZARM7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 07:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbZARM7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 07:59:16 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:39886 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbZARM7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 07:59:15 -0500
Date: Sun, 18 Jan 2009 14:00:59 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip] fix 41 'make headers_check' warnings
Message-ID: <20090118130059.GA32422@uranus.ravnborg.org>
References: <1232273454.23100.9.camel@localhost.localdomain> <20090118110221.GA29602@elte.hu> <20090118125721.GA31655@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118125721.GA31655@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 01:57:22PM +0100, Sam Ravnborg wrote:
> On Sun, Jan 18, 2009 at 12:02:21PM +0100, Ingo Molnar wrote:
> > 
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
> 
> The original expression is misinterpreted by headers_check
> because we want the ac_ahz to stay if either of __KERNEL__
> or CONFIG_M68K is not defined.
> And unifdef does not optimize away the !defined(CONFIG_M68K)
> part - it has no knowledge that this is kernel internal.
> 
> So I am happy with Jaswinder's patch.
Almost happy.
I digged out my original patch and it looks like this:
-#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
+#ifndef __KERNEL__
        __u16           ac_ahz;                 /* AHZ */
+#else
+  #ifndef CONFIG_M68K
+       __u16           ac_ahz;                 /* AHZ */
+  #endif
 #endif

The indention can be discussed..
But the logic is simpler.

	Sam

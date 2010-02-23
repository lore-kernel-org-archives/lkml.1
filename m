Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab0BWR4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:56:45 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37553 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab0BWR4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:56:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c/Am0MrbLdErv+02oAktGa505OnCoXeNvYA6IixX6e+RrNUTigzLsVXNLxrhi86yrC
         65A4xmAiS2Kb2s6WOL03XHnKBho1HBsbZQnZfmdqFg3QswQcfKiDuvV3P9uEZA5+QlLB
         07zZbDNCjv/v/UnZvHalQ8mXHTA8ko41CwTPE=
Date: Tue, 23 Feb 2010 23:28:07 +0530
From: Rabin Vincent <rabin@rab.in>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 04/10] ARM: ftrace: allow building without frame
 pointers
Message-ID: <20100223175807.GB5836@debian>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
 <1266090518-31120-5-git-send-email-rabin@rab.in>
 <20100222190516.GJ5055@nowhere>
 <1266931113.19540.5.camel@frodo>
 <20100223171112.GC5357@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100223171112.GC5357@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 06:11:16PM +0100, Frederic Weisbecker wrote:
> On Tue, Feb 23, 2010 at 08:18:33AM -0500, Steven Rostedt wrote:
> > On Mon, 2010-02-22 at 20:05 +0100, Frederic Weisbecker wrote:
> > > 
> > > Btw, you described that mcount is used in some gcc versions and
> > > __gnu_mcount_nc in newers.
> > > Shouldn't we have a gcc version dependency here? (not sure we can
> > > do this from Kconfig though).
> > > 
> > Maybe we can add something to recordmcount.pl?
> 
> May be yeah, with an explicit message that describes the issue.

Adding something to recordmcount.pl to detect this would be
insufficient, because this affects non-dynamic ftrace too.

> > > > +++ b/arch/arm/kernel/entry-common.S
> > > > @@ -169,6 +169,12 @@ gnu_trace:
> > > >  	ldmia	sp!, {r0-r3, ip, lr}
> > > >  	mov	pc, ip
> > > >  
> > > > +#ifdef CONFIG_OLD_MCOUNT
> > > > +/*
> > > > + * This is under an ifdef in order to force link-time errors for people trying
> > > > + * to build with !FRAME_POINTER with a GCC which doesn't use the new-style
> > > > + * mcount.
> > > > + */
> > > >  ENTRY(mcount)
> > > >  	stmdb	sp!, {r0-r3, lr}
> > > >  	ldr	r0, =ftrace_trace_function
> > > > @@ -187,6 +193,7 @@ trace:
> > > >  	mov	pc, r2
> > > >  	ldr	lr, [fp, #-4]			@ restore lr
> > > >  	ldmia	sp!, {r0-r3, pc}
> > > > +#endif
> > > >  
> > > >  #endif /* CONFIG_DYNAMIC_FTRACE */
> > > >  
> > > > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > > > index 6c22d8a..7468ffe 100644
> > > > --- a/kernel/trace/Kconfig
> > > > +++ b/kernel/trace/Kconfig
> > > > @@ -126,7 +126,7 @@ if FTRACE
> > > >  config FUNCTION_TRACER
> > > >  	bool "Kernel Function Tracer"
> > > >  	depends on HAVE_FUNCTION_TRACER
> > > > -	select FRAME_POINTER
> > > > +	select FRAME_POINTER if (!ARM_UNWIND)
> > > 
> > > 
> > > So, if I understand well. If people have ARM_UNWIND but
> > > FUNCTION_TRACER, it might crash at link time in case
> > > they don't have a recent enough gcc version to
> > > support the new -pg style?

They'd probably get an "undefined reference to mcount" message.  I
forced the link time error because otherwise they'll have runtime
problems.

> > > 
> > > That doesn't look good.
> > > 
> > > Ideally, we need HAVE_FUNCTION_TRACER to be enabled in arm
> > > only if (old gcc && frame pointers) || new gcc
> > > 
> > > And then, we need config OLD_MCOUNT:
> > > 	 old gcc && FUNCTION_TRACER
> > > 
> > > and config NEW_MCOUNT:
> > > 	new gcc && FUNCTION_TRACER
> > > 
> > > so that we can selectively build mcount or __gnu_mcount_nc.

There's more to this.  When we build with FRAME_POINTER, we need to
always build in both version of mcount.  This is to allow modules to be
built with different versions of the compiler (one which uses the old
mcount and one with the new mcount).

> > > 
> > > Hmm, I fear we can't check gcc version from Kconfig, as I'm
> > > grepping on Kconfig files...
> > 
> > 
> > I would not check gcc version through KCONFIG, but you can have the gcc
> > version checked and define another macro in a header somewhere, like
> > asm/ftrace.h. Then we could do something different while it is
> > compiling.
> 
> Yeah. I understand now why we can't do that on Kconfig time, HOSTCC
> can be different than CC.
> 
> The most important thing is to have a message that describes the issue
> if the compiler-config combination is impossible.

The easiest option to have a more obvious message than a linker error
would be to add something like this in entry-common.S:

  #if (__GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 4)) \
	&& !defined(OLD_MCOUNT)
  #warning Ftrace on GCC < 4.4 requires frame pointers
  #endif

Messages like this are also present in other places in ARM (for example
arch/arm/kernel/unwind.c), so this wouldn't be this first.

Note that the above message would help in all cases except the one where
someone builds the kernel with !fp and GCC 4.4+, and then builds a
module with an older GCC.  That would still be only a linker error.

Rabin

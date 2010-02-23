Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab0BWRLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:11:23 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:54698 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab0BWRLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:11:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mT6iWfdhsBlX5uGQA952Ck194C5qF2JXLBWpORB3wTUPG/sn7rtUA8k2pGTBv/smo4
         +VI009Y0zthxwdrlR29QhxleWbu3JG6DQpoPTemhg5lxv7m6RhFkC9/epLZuEm+IFTFd
         eUnxaMf5vYSUJqpj6iVWKJTTku89ChYzIrgM0=
Date: Tue, 23 Feb 2010 18:11:16 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 04/10] ARM: ftrace: allow building without frame
	pointers
Message-ID: <20100223171112.GC5357@nowhere>
References: <1266090518-31120-1-git-send-email-rabin@rab.in> <1266090518-31120-5-git-send-email-rabin@rab.in> <20100222190516.GJ5055@nowhere> <1266931113.19540.5.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266931113.19540.5.camel@frodo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 08:18:33AM -0500, Steven Rostedt wrote:
> On Mon, 2010-02-22 at 20:05 +0100, Frederic Weisbecker wrote:
> 
> > 
> > Btw, you described that mcount is used in some gcc versions and
> > __gnu_mcount_nc in newers.
> > Shouldn't we have a gcc version dependency here? (not sure we can
> > do this from Kconfig though).
> > 
> 
> Maybe we can add something to recordmcount.pl?



May be yeah, with an explicit message that describes the issue.


 
> > 
> > 
> > >  config DEBUG_USER
> > >  	bool "Verbose user fault messages"
> > >  	help
> > > diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
> > > index 8214bfe..e5e1e53 100644
> > > --- a/arch/arm/kernel/armksyms.c
> > > +++ b/arch/arm/kernel/armksyms.c
> > > @@ -165,6 +165,8 @@ EXPORT_SYMBOL(_find_next_bit_be);
> > >  #endif
> > >  
> > >  #ifdef CONFIG_FUNCTION_TRACER
> > > +#ifdef CONFIG_OLD_MCOUNT
> > >  EXPORT_SYMBOL(mcount);
> > > +#endif
> > >  EXPORT_SYMBOL(__gnu_mcount_nc);
> > >  #endif
> > > diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> > > index d412d7c..c98e3a3 100644
> > > --- a/arch/arm/kernel/entry-common.S
> > > +++ b/arch/arm/kernel/entry-common.S
> > > @@ -169,6 +169,12 @@ gnu_trace:
> > >  	ldmia	sp!, {r0-r3, ip, lr}
> > >  	mov	pc, ip
> > >  
> > > +#ifdef CONFIG_OLD_MCOUNT
> > > +/*
> > > + * This is under an ifdef in order to force link-time errors for people trying
> > > + * to build with !FRAME_POINTER with a GCC which doesn't use the new-style
> > > + * mcount.
> > > + */
> > >  ENTRY(mcount)
> > >  	stmdb	sp!, {r0-r3, lr}
> > >  	ldr	r0, =ftrace_trace_function
> > > @@ -187,6 +193,7 @@ trace:
> > >  	mov	pc, r2
> > >  	ldr	lr, [fp, #-4]			@ restore lr
> > >  	ldmia	sp!, {r0-r3, pc}
> > > +#endif
> > >  
> > >  #endif /* CONFIG_DYNAMIC_FTRACE */
> > >  
> > > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > > index 6c22d8a..7468ffe 100644
> > > --- a/kernel/trace/Kconfig
> > > +++ b/kernel/trace/Kconfig
> > > @@ -126,7 +126,7 @@ if FTRACE
> > >  config FUNCTION_TRACER
> > >  	bool "Kernel Function Tracer"
> > >  	depends on HAVE_FUNCTION_TRACER
> > > -	select FRAME_POINTER
> > > +	select FRAME_POINTER if (!ARM_UNWIND)
> > 
> > 
> > So, if I understand well. If people have ARM_UNWIND but
> > FUNCTION_TRACER, it might crash at link time in case
> > they don't have a recent enough gcc version to
> > support the new -pg style?
> > 
> > That doesn't look good.
> > 
> > Ideally, we need HAVE_FUNCTION_TRACER to be enabled in arm
> > only if (old gcc && frame pointers) || new gcc
> > 
> > And then, we need config OLD_MCOUNT:
> > 	 old gcc && FUNCTION_TRACER
> > 
> > and config NEW_MCOUNT:
> > 	new gcc && FUNCTION_TRACER
> > 
> > so that we can selectively build mcount or __gnu_mcount_nc.
> > 
> > Hmm, I fear we can't check gcc version from Kconfig, as I'm
> > grepping on Kconfig files...
> 
> 
> I would not check gcc version through KCONFIG, but you can have the gcc
> version checked and define another macro in a header somewhere, like
> asm/ftrace.h. Then we could do something different while it is
> compiling.


Yeah. I understand now why we can't do that on Kconfig time, HOSTCC
can be different than CC.

The most important thing is to have a message that describes the issue
if the compiler-config combination is impossible.


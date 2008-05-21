Return-Path: <linux-kernel-owner+w=401wt.eu-S937257AbYEUV22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937257AbYEUV22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbYEUV2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:28:14 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:48263 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757308AbYEUV2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:28:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroFAIIwNEhMQWqh/2dsb2JhbACBVa9J
Date: Wed, 21 May 2008 17:28:09 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Fix Immediate Values x86_64 support old gcc
Message-ID: <20080521212809.GE6158@Krystal>
References: <482AB6C5.4060604@goop.org> <20080516124811.GC4226@Krystal> <482DFD65.10300@zytor.com> <20080521133122.GA18084@Krystal> <48344239.9070003@zytor.com> <20080521160217.GA26974@Krystal> <20080521170150.GA29428@Krystal> <20080521203743.GA12982@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080521203743.GA12982@uranus.ravnborg.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:21:08 up 82 days, 17:32,  3 users,  load average: 5.80, 3.73,
	2.63
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg (sam@ravnborg.org) wrote:
> Hi Mathieu
> > Does this fix make more sense ?
> > 
> > GCC < 4, on x86_64, does not accept symbol+offset operands for "i" constraints
> > asm statements. Fallback on generic immediate values if this compiler is
> > detected.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > ---
> >  arch/x86/Makefile           |    3 +++
> >  arch/x86/kernel/Makefile    |    4 +++-
> >  include/asm-x86/immediate.h |    5 +++++
> >  include/linux/immediate.h   |    4 +++-
> >  kernel/Makefile             |    4 +++-
> >  5 files changed, 17 insertions(+), 3 deletions(-)
> > 
> > Index: linux-2.6-sched-devel/arch/x86/Makefile
> > ===================================================================
> > --- linux-2.6-sched-devel.orig/arch/x86/Makefile	2008-05-21 09:04:52.000000000 -0400
> > +++ linux-2.6-sched-devel/arch/x86/Makefile	2008-05-21 09:22:05.000000000 -0400
> > @@ -78,6 +78,9 @@
> >                  "$(CC)" -fstack-protector-all )
> >  
> >          KBUILD_CFLAGS += $(stackp-y)
> > +
> > +	export GCC_BROKEN_IMMEDIATE
> > +	GCC_BROKEN_IMMEDIATE := $(shell if [ $(call cc-version) -lt 0400 ] ; then echo "y"; fi)
> 
> So here we introduce a global environment variable that tells
> us that gcc has "BROKEN_IMMEDIATE".
> I have absolutely no clue what "BROKEN_IMMEDIATE" is so I guess others
> are in the same boat. Comment please!
> 

Yes, I guess this worth being commented, you are right. I'll write
something along the lines written in the patch header.

> Consider something like this (note: no negative logic involved):
> export USE_IMMEDIATE := $(call cc-ifversion, -ge, 0400, $(CONFIG_IMMEDIATE))
> 

Hrm, if I do that, I would have to add USE_IMMEDIATE to each
architecture's makefiles for which immediate values are supported, e.g.:

export USE_IMMEDIATE := $(CONFIG_IMMEDIATE)

The "BROKEN_IMMEDIATE" (negative) approach only needs to be defined on
x86_64 where gcc 3.x does not support symbol+offset correctly.

> Then the MAkefile fragment can be simplified as:
> > -obj-$(CONFIG_IMMEDIATE)              += immediate.o
> > +obj-$(USE_IMMEDIATE)                 += immediate.o
> 
> (Or find a better name than "USE_IMMEDIATE".
> 
> 
> >  endif
> >  
> >  # Stackpointer is addressed different for 32 bit and 64 bit x86
> > Index: linux-2.6-sched-devel/include/asm-x86/immediate.h
> > ===================================================================
> > --- linux-2.6-sched-devel.orig/include/asm-x86/immediate.h	2008-05-21 09:10:59.000000000 -0400
> > +++ linux-2.6-sched-devel/include/asm-x86/immediate.h	2008-05-21 09:15:43.000000000 -0400
> > @@ -12,6 +12,10 @@
> >  
> >  #include <asm/asm.h>
> >  
> > +#if (defined(CONFIG_X86_64) && __GNUC__ < 4)	/* Detect broken x86_64 gcc */
> > +#undef CONFIG_IMMEDIATE
> > +#else
> 
> And now in the source we use a direct check of the GNUC version. So this is a duplicate
> of GCC_BROKEN_IMMEDIATE and not sensible comments.
> "I ask myself in what way is gcc broken?"
> And you DO NOT fiddle with the CONFIG_* variables - this is just plain wrong.
> 

I could pass the USE_IMMEDIATE as a -D to the compiler flags. That would
be cleaner.

> > --- linux-2.6-sched-devel.orig/include/linux/immediate.h	2008-05-21 09:12:22.000000000 -0400
> > +++ linux-2.6-sched-devel/include/linux/immediate.h	2008-05-21 09:12:59.000000000 -0400
> > @@ -11,8 +11,10 @@
> >   */
> >  
> >  #ifdef CONFIG_IMMEDIATE
> > +#include <asm/immediate.h>	/* May undef CONFIG_IMMEDIATE */
> > +#endif
> 
> So you need to find a better way for this.
> 

I think USE_IMMEDIATE is the way to go then.

Thanks,

Mathieu

> 
> >  
> > -#include <asm/immediate.h>
> > +#ifdef CONFIG_IMMEDIATE
> >  
> >  /**
> >   * imv_set - set immediate variable (with locking)
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

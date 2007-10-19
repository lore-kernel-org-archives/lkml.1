Return-Path: <linux-kernel-owner+w=401wt.eu-S1765852AbXJSPJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765852AbXJSPJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 11:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbXJSPJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 11:09:24 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:45835 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001AbXJSPJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 11:09:22 -0400
Date: Fri, 19 Oct 2007 17:10:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Finn Thain <fthain@telegraphics.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] Make m68k cross compile like every other architecture.
Message-ID: <20071019151053.GA30825@uranus.ravnborg.org>
References: <200710101722.21126.rob@landley.net> <Pine.LNX.4.64.0710152217150.16889@anakin> <20071018211420.GA23397@uranus.ravnborg.org> <200710190138.39005.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710190138.39005.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 01:38:38AM -0500, Rob Landley wrote:
> On Thursday 18 October 2007 4:14:20 pm Sam Ravnborg wrote:
> > > Anyway, here's a try to make it autodetect m68k-linux-gnu-gcc and
> > > m68k-linux-gcc. Perhaps it can be generalized in kbuild, to allow
> > > arch/*/Makefile to set a list of possible cross-compiler prefixes?
> >
> > Here is my first try.
> > We only touch CROSS_COMPILE is empty and building for another arch.
> >
> > I can obviously move crossgcc part of this to core kbuild.
> > Any better name?
find-crossgcc

> >
> > 	Sam
> >
> >
> > diff --git a/arch/m68k/Makefile b/arch/m68k/Makefile
> > index 4a1bd44..6465bbe 100644
> > --- a/arch/m68k/Makefile
> > +++ b/arch/m68k/Makefile
> > @@ -13,17 +13,26 @@
> >  # Copyright (C) 1994 by Hamish Macdonald
> >  #
> >
> > -# test for cross compiling
> > -COMPILE_ARCH = $(shell uname -m)
> > +# usage:
> > +# CROSS_COMPILE := $(call crossgcc, foo bar /usr/bin/)
> > +# CROSS_COMPILE will be assinged the first prefix that point
> > +# to a gcc in the path
> > +crossgcc =  $(word 1, $(foreach c,$(1),                               \
> > +		$(shell set -e;                                       \
> > +		if (which $(strip $(c))$(CC)) > /dev/null 2>&1 ; then \
> > +			echo $(c);                                    \
> > +		fi)))
> 
> Searching for common cross compiler prefixes.  Cool.
> 
> What do you do if you want to use gcc as your host compiler, but m68k-pcc or 
> arm-tcc as your target compiler?  (I have no idea, CROSS_COMPILE=m68k- CC=pcc 
> HOSTCC=gcc perhaps?  Where does CC get set right now, anyway...  Ah, top 
> level Makefile:
>   CC              = $(CROSS_COMPILE)gcc
> 
> That...  should work.  Odd and roundabout, but ok...
I see no other way to do it - and it seems obvious since you guessed right.

> 
> > +ifneq ($(SUBARCH),$(ARCH))
> > +        ifeq ($(CROSS_COMPILE),)
> > +                CROSS_COMPILE := $(call crossgcc, m68k-linux-gnu-)
> > +        endif
> > +endif
> 
> Other query:
> 
> If CROSS_COMPILE isn't set, and we iterate through all the standard prefixes 
> but don't find a compiler, what's the right "fall off the end" behavior?  If 
> it falls back to using the host gcc, presumably the build will break if you 
> feed your host gcc target flags it doesn't understand, but there are 
> platforms where that sometimes doesn't seem to happen until the very end 
> (building x86_64 on x86 for example)...  Should the build just die with 
> a "You are cross compiling, set CROSS_COMPILE".
No - that would be a bug. One may set up PATH sp gcc point to the
cross-compile gcc. fallback to native (host) gcc is expected and fine.

> 
> I suppose there's the weird corner case where your hostcc is tcc and your 
> targetcc is gcc...
I do not see why thats a problem - you just need to set both CC and HOSTCC.

	Sam

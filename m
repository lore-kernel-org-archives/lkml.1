Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbYACOGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbYACOGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 09:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYACOGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 09:06:08 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:62446 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYACOGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 09:06:05 -0500
Date: Thu, 3 Jan 2008 09:03:58 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 01/11] Add basic support for gcc profiler instrumentation
In-Reply-To: <20080103083118.GB16597@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.58.0801030859370.1468@gandalf.stny.rr.com>
References: <20080103071609.478486470@goodmis.org> <20080103072226.776141236@goodmis.org>
 <20080103083118.GB16597@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Sam!

On Thu, 3 Jan 2008, Sam Ravnborg wrote:
> > ---
> >
> > Index: linux-compile.git/Documentation/stable_api_nonsense.txt
> > ===================================================================
> > --- linux-compile.git.orig/Documentation/stable_api_nonsense.txt	2008-01-03 01:02:28.000000000 -0500
> > +++ linux-compile.git/Documentation/stable_api_nonsense.txt	2008-01-03 01:02:33.000000000 -0500
> > @@ -62,6 +62,9 @@ consider the following facts about the L
> >        - different structures can contain different fields
> >        - Some functions may not be implemented at all, (i.e. some locks
> >  	compile away to nothing for non-SMP builds.)
> > +      - Parameter passing of variables from function to function can be
> > +	done in different ways (the CONFIG_REGPARM option controls
> > +	this.)
>
> As CONFIG_REGPARM affects calling convention we should add it to the
> list of symbols checked when loading modules (vermagic.h).

Good point, thanks for mentioning this.

> > Index: linux-compile.git/Makefile
> > ===================================================================
> > --- linux-compile.git.orig/Makefile	2008-01-03 01:02:28.000000000 -0500
> > +++ linux-compile.git/Makefile	2008-01-03 01:02:39.000000000 -0500
> > @@ -509,11 +509,15 @@ endif
> >
> >  include $(srctree)/arch/$(SRCARCH)/Makefile
> >
> > +ifdef CONFIG_MCOUNT
> > +KBUILD_CFLAGS	+= -pg -fno-omit-frame-pointer -fno-optimize-sibling-calls
> > +else
> >  ifdef CONFIG_FRAME_POINTER
> >  KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
> >  else
> >  KBUILD_CFLAGS	+= -fomit-frame-pointer
> >  endif
> > +endif
> Could we please move these relations to Kconfig. So we do not end up in a situation
> where CONFIG_FRAME_POINTER is set but the flag is not added.

Yes, most definitely. I thought this part was a bit sloppy, but it
"worked".  My next series will clean this up.

>
>
> >
> >  ifdef CONFIG_DEBUG_INFO
> >  KBUILD_CFLAGS	+= -g
> > Index: linux-compile.git/arch/x86/Kconfig
> > ===================================================================
> > --- linux-compile.git.orig/arch/x86/Kconfig	2008-01-03 01:02:28.000000000 -0500
> > +++ linux-compile.git/arch/x86/Kconfig	2008-01-03 01:02:33.000000000 -0500
> > @@ -28,6 +28,12 @@ config GENERIC_CMOS_UPDATE
> >  	bool
> >  	default y
> >
> > +# function tracing might turn this off:
> > +config REGPARM
> > +	bool
> > +	depends on !MCOUNT
> > +	default y
> > +
>
> Could we please define config REGPARM in _one_ Kconfig file
> and let those who want it select it.
> If you consider this x86 spacific this should be included in the naming
> as in CONFIG_X86_REGPARM - and then the above is OK.

This is pending on resolving what effects REGPARM really has on mcount.
But, I'll keep REGPARM until it's solved, and in the mean time I'll clean
it up as you asked.


>
> Defining the same config variable in several files is not good (but done too often these days).
>
> > Index: linux-compile.git/lib/mcount/Makefile
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-compile.git/lib/mcount/Makefile	2008-01-03 01:02:33.000000000 -0500
> > @@ -0,0 +1,3 @@
> > +obj-$(CONFIG_MCOUNT) += libmcount.o
> > +
> > +libmcount-objs := mcount.o
>
> Preferred syntax is now:
> libmcount-y := mcount.o

Ah! I learn something new every day :-)  Yeah, I stumbled over a few
updates in formats with the makefiles.

Thanks!

-- Steve


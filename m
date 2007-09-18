Return-Path: <linux-kernel-owner+w=401wt.eu-S1760060AbXIRR7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060AbXIRR7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756427AbXIRR7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:59:07 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:43483 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760073AbXIRR7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:59:06 -0400
Date: Tue, 18 Sep 2007 13:59:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] Immediate Values - Architecture Independent Code
Message-ID: <20070918175902.GB2915@Krystal>
References: <20070917184224.549435917@polymtl.ca> <20070917184319.658506512@polymtl.ca> <200709181847.22905.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200709181847.22905.vda.linux@googlemail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:56:15 up 50 days, 18:15,  4 users,  load average: 4.09, 1.80, 1.13
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Denys Vlasenko (vda.linux@googlemail.com) wrote:
> On Monday 17 September 2007 19:42, Mathieu Desnoyers wrote:
> > Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
> > ===================================================================
> > --- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-09-17 13:25:06.000000000 -0400
> > +++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-09-17 13:35:50.000000000 -0400
> > @@ -122,6 +122,13 @@
> >  		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
> >  	}								\
> >  									\
> > +	/* Immediate values: pointers */				\
> > +	__immediate : AT(ADDR(__immediate) - LOAD_OFFSET) {		\
> > +		VMLINUX_SYMBOL(__start___immediate) = .;		\
> > +		*(__immediate)						\
> > +		VMLINUX_SYMBOL(__stop___immediate) = .;			\
> > +	}								\
> > +									\
> 
> Why do you need an output section for that? IOW: will this work too?
> 
> .data : ... { 
> ...
> 
> 		VMLINUX_SYMBOL(__start___immediate) = .;		\
> 		*(__immediate)						\
> 		VMLINUX_SYMBOL(__stop___immediate) = .;			\
> ...
> }
> 

This last one could cause alignment problems. We either have to use the
proper ALIGN() before the section, or let AT(ADDR(__immediate) -
LOAD_OFFSET) take care of it. I prefer the latter.

> 
> > Index: linux-2.6-lttng/kernel/module.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/module.c	2007-09-17 13:25:06.000000000 -0400
> > +++ linux-2.6-lttng/kernel/module.c	2007-09-17 13:35:51.000000000 -0400
> > @@ -33,6 +33,7 @@
> >  #include <linux/cpu.h>
> >  #include <linux/moduleparam.h>
> >  #include <linux/errno.h>
> > +#include <linux/immediate.h>
> >  #include <linux/err.h>
> >  #include <linux/vermagic.h>
> >  #include <linux/notifier.h>
> > @@ -1717,6 +1718,7 @@ static struct module *load_module(void _
> >  	unsigned int unusedcrcindex;
> >  	unsigned int unusedgplindex;
> >  	unsigned int unusedgplcrcindex;
> > +	unsigned int immediateindex;
> >  	struct module *mod;
> >  	long err = 0;
> >  	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
> > @@ -1813,6 +1815,7 @@ static struct module *load_module(void _
> >  #ifdef ARCH_UNWIND_SECTION_NAME
> >  	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
> >  #endif
> > +	immediateindex = find_sec(hdr, sechdrs, secstrings, "__immediate");
> 
> 
> Do you need to frame immediateindex by #ifdef CONFIG_IMMEDIATE / #endif?

I could, but I have been told to leave the immediateindex there even though
immediate values are configured out. I guess visual hideousness is the
main argument there.

Mathieu

> --
> vda

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

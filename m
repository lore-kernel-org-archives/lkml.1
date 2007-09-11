Return-Path: <linux-kernel-owner+w=401wt.eu-S934153AbXIKT7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934153AbXIKT7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbXIKT7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:59:43 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:36452 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753634AbXIKT7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:59:42 -0400
Date: Tue, 11 Sep 2007 15:59:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: [patch 05/10] Text Edit Lock - Alternative code for i386 and x86_64
Message-ID: <20070911195933.GA23251@Krystal>
References: <20070906200124.595238505@polymtl.ca> <20070906200212.080849869@polymtl.ca> <20070907065936.GH31880@one.firstfloor.org> <20070907140442.GE9735@Krystal> <20070907223554.GA22646@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070907223554.GA22646@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:16:40 up 43 days, 19:35,  6 users,  load average: 1.25, 2.15, 1.77
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> On Fri, Sep 07, 2007 at 10:04:42AM -0400, Mathieu Desnoyers wrote:
> > * Andi Kleen (andi@firstfloor.org) wrote:
> > > On Thu, Sep 06, 2007 at 04:01:29PM -0400, Mathieu Desnoyers wrote:
> > > > +	sync_core();
> > > > +	/* Not strictly needed, but can speed CPU recovery up. */
> > > 
> > > That turned out to break on some VIA CPUs. Should be removed.
> > > 
> > 
> > Hrm, when does it break ? At boot time ? Is it the cpuid that breaks or
> 
> Yes.
> 
> > the clflush ? How do you work around the problem when sync_core or
> 
> The CLFLUSH
> 
> > clflush is called from elsewhere; does it cause a problem if I call it
> > when I update immediate values ?
> 
> Unknown currently what are the exact circumstances.
> 
> For the other cases it is ignored right now, but when we get 
> more information it might be needed to clear the CLFLUSH 
> feature bit on those CPUs.
> 

Ok, it's better to simply remove the CLFLUSH since it's not needed
anyway. Do you recommend to only remove the CLFLUSH from the _early code
(executed before alternatives are applied) or to remove the CLFLUSH from
the normal execution time code also ?

> > Is it me or __inline_memcpy is simply a copy of i386's __memcpy ?
> > Is there any reason for this name change ?
> 
> x86-64 __memcpy does something different. 
> 
> It might make more sense
> 
> At some point I hope to change the i386 setup to be more like x86-64
> anyways -- the x86-64 version is imho much better.
> 

It looks like gorund work that should be done in i386 before we start
using __inline_memcpy in alternative.c which is shared between i386 and
x86_64. I haven't seen the alternative that would touch memcpy at all
anyway, am I missing something ? Also, being "faster" is not really an
issue there, since it is not done often. The only thing that matters is
if memcpy could be touched by alternative.c.

> >   A- ugly
> >   B- breaking vim syntax highlighting. (actually, all the rest of the
> >   file becomes weird after that. The problem is similar to declaration
> >   of #defile name ({ some code }). It does not really matter as long as
> >   it is in a header, but at the middle of a C file it gets rather
> >   annoying). (it never though I would use vim as a coding style
> >   reference) ;)
> 
> Then define a macro
> 
> #define BREAKPOINTS(x) \
> 	((unsigned char [x]){ [0 ... x] = BREAKPOINT_INSTRUCTIONS })
> 
> and use that
> 

How about adding :

#define INIT_ARRAY(type, val, len) ((type [len]){ [0 ... len] = (val) })

to kernel.h ? It would be more generic.

> > And what is rather different between the 2 functions is when we want to
> > fill multiple bytes with the same pattern (I fill the unused part of my
> > immediate values bypass with 0x90 nops, but I agree that I could use
> > add_nops if it was exported).
> > 
> > Declaration of a variable length array on text_set's stack would break
> > older compilers, so I don't think it is a neat solution neither. kmalloc
> 
> All supported gccs support variable length arrays.
> 

ok

> > The idea is to mimic the local_irq_save/restore semantic, where the
> > flags argument is passed without &. This is why I use a macro instead of
> > an inline function
> 
> Sounds like a bogus idea to me.
> 

So you would prefer
unsigned long cr0;
  kernel_wp_save(&cr0)
..
  kernel_wp_restore(cr0);

to

unsigned long cr0;
  kernel_wp_save(cr0)
..
  kernel_wp_restore(cr0);

? It seems odd to me, since everyone would expect flags save/restore to
behave like local_irq_save/restore. Or I may misunderstand your point.


> > The good effect of disabling interrupts is that it would make sure no
> > interrupt handler will run with WP flag cleared on the CPU.  However, it
> 
> Yes that was my point. Not a very strong one admittedly.
> 

I agree that most kernel_wp_save/restore users should disable interrupts
before calling it (it would be a "good practice"), but I don't expect to
encapsulate irq disabling in these macros, since it is not mandatory.

Mathieu

> -Andi

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbXIGWgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbXIGWgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 18:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758651AbXIGWf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 18:35:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38694 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627AbXIGWf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 18:35:56 -0400
Date: Sat, 8 Sep 2007 00:35:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, pageexec@freemail.hu
Subject: Re: [patch 05/10] Text Edit Lock - Alternative code for i386 and x86_64
Message-ID: <20070907223554.GA22646@one.firstfloor.org>
References: <20070906200124.595238505@polymtl.ca> <20070906200212.080849869@polymtl.ca> <20070907065936.GH31880@one.firstfloor.org> <20070907140442.GE9735@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070907140442.GE9735@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 10:04:42AM -0400, Mathieu Desnoyers wrote:
> * Andi Kleen (andi@firstfloor.org) wrote:
> > On Thu, Sep 06, 2007 at 04:01:29PM -0400, Mathieu Desnoyers wrote:
> > > +	sync_core();
> > > +	/* Not strictly needed, but can speed CPU recovery up. */
> > 
> > That turned out to break on some VIA CPUs. Should be removed.
> > 
> 
> Hrm, when does it break ? At boot time ? Is it the cpuid that breaks or

Yes.

> the clflush ? How do you work around the problem when sync_core or

The CLFLUSH

> clflush is called from elsewhere; does it cause a problem if I call it
> when I update immediate values ?

Unknown currently what are the exact circumstances.

For the other cases it is ignored right now, but when we get 
more information it might be needed to clear the CLFLUSH 
feature bit on those CPUs.

> Is it me or __inline_memcpy is simply a copy of i386's __memcpy ?
> Is there any reason for this name change ?

x86-64 __memcpy does something different. 

It might make more sense

At some point I hope to change the i386 setup to be more like x86-64
anyways -- the x86-64 version is imho much better.

>   A- ugly
>   B- breaking vim syntax highlighting. (actually, all the rest of the
>   file becomes weird after that. The problem is similar to declaration
>   of #defile name ({ some code }). It does not really matter as long as
>   it is in a header, but at the middle of a C file it gets rather
>   annoying). (it never though I would use vim as a coding style
>   reference) ;)

Then define a macro

#define BREAKPOINTS(x) \
	((unsigned char [x]){ [0 ... x] = BREAKPOINT_INSTRUCTIONS })

and use that

> And what is rather different between the 2 functions is when we want to
> fill multiple bytes with the same pattern (I fill the unused part of my
> immediate values bypass with 0x90 nops, but I agree that I could use
> add_nops if it was exported).
> 
> Declaration of a variable length array on text_set's stack would break
> older compilers, so I don't think it is a neat solution neither. kmalloc

All supported gccs support variable length arrays.

> The idea is to mimic the local_irq_save/restore semantic, where the
> flags argument is passed without &. This is why I use a macro instead of
> an inline function

Sounds like a bogus idea to me.

> The good effect of disabling interrupts is that it would make sure no
> interrupt handler will run with WP flag cleared on the CPU.  However, it

Yes that was my point. Not a very strong one admittedly.

-Andi

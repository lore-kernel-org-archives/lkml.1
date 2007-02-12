Return-Path: <linux-kernel-owner+w=401wt.eu-S1030506AbXBLXmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030506AbXBLXmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030507AbXBLXmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:42:24 -0500
Received: from ozlabs.org ([203.10.76.45]:37521 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030506AbXBLXmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:42:23 -0500
Subject: Re: [q] kbuild for private asm-offsets (Re: [PATCH 6/10] lguest
	code: the little linux hypervisor.)
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <ak@muc.de>,
       virtualization@lists.osdl.org,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <E1HGbJz-0003Lc-6h@flower>
References: <1171012296.2718.26.camel@localhost.localdomain>
	 <1171012761.2718.40.camel@localhost.localdomain>
	 <1171012827.2718.42.camel@localhost.localdomain>
	 <200702091109.20061.ak@muc.de>
	 <1171024771.2718.129.camel@localhost.localdomain>
	 <20070209141728.GA26749@uranus.ravnborg.org>
	 <1171034599.2718.190.camel@localhost.localdomain>
	 <E1HGbJz-0003Lc-6h@flower>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 10:41:36 +1100
Message-Id: <1171323696.19842.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-12 at 14:34 +0100, Oleg Verych wrote:
> > I'd like my own, private "asm-offsets.h".  In this case, in
> > arch/i386/lguest/.  I guess it's a matter of extracting the core of the
> > asm-offsets.h magic and generalizing it.
> >
> > Have a good break!
> > Rusty.
> 
> If you will have time for newbie, to explain in a few words, what is it need
> for (whole idea, or key detail), and, maybe, why it is generated so ... interestingly:
> 
>             asm-offsets.c -> *.s -> *.h
>  (but this looks like interconnecting C and assembler, obviously)

Hi Oleg,

	Always happy to explain.  There's often a need to access constants in
assembler, which can only be derived from C, such as the size of a
structure, or the offset of a certain member within a structure.
Hardcoding the numbers in assembler is fragile leading to breakage when
something changes.

	So, asm-offsets.c is the solution: it uses asm() statements to emit
patterns in the assembler, with the compiler computing the actual
numbers, eg:

	#define DEFINE(sym, val) \
	        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
	DEFINE(SIZEOF_FOOBAR, sizeof(foobar));

Becomes in asm-offsets.s:
	->SIZEOF_FOOBAR $10 sizeof(foobar)  #

This gets sed'd back into asm-offsets.h:
	#define SIZEOF_FOOBAR 10 /* SIZEOF_FOOBAR  # */

This can be included from .S files (which get passed through the
pre-processor).

Hope that helps!
Rusty.


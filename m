Return-Path: <linux-kernel-owner+w=401wt.eu-S1761114AbXEZNfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114AbXEZNfF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 09:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbXEZNex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 09:34:53 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49670 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbXEZNew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 09:34:52 -0400
X-Originating-Ip: 72.143.65.211
Date: Sat, 26 May 2007 09:33:40 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MIPS: Transform old-style macros to newer "__noreturn"
 standard.
In-Reply-To: <46573B23.1090700@zytor.com>
Message-ID: <Pine.LNX.4.64.0705260924370.19438@localhost.localdomain>
References: <Pine.LNX.4.64.0705251418050.13623@localhost.localdomain>
 <46572DAF.1000108@zytor.com> <Pine.LNX.4.64.0705251458440.13906@localhost.localdomain>
 <46573B23.1090700@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, H. Peter Anvin wrote:

> Robert P. J. Day wrote:
> >
> >
> >   f() __attribute__((noreturn)) ;
> >
> > you get:
> >
> >   warning: data definition has no type or storage class
> >
> > but gcc doesn't complain if you declare it thusly:
> >
> >   __attribute__((noreturn)) f() ;
> >
> > that strikes me as a flaw in gcc, no?
> >
>
> Doesn't matter.  gcc accepts "void __attribute__((noreturn)) f();", and
> thus, one can define:
>
> #define __noreturn void __attribute__((noreturn))
>
> ... and declare functions as:
>
> __noreturn f();
>
> ... which is the syntactially sane way of doing it.

i've thought about this and, while i philosophically agree with you,
i'm not going down that road for a couple reasons.

first, there is the fact that there is already a macro definition for
__noreturn in include/linux/compiler-gcc.h:

#define __noreturn                      __attribute__((noreturn))

second, and more importantly, defining __noreturn as you suggest is
now mixing two fundamental pieces of information.  "void" is a return
type, plain and simple.  an attribute, OTOH, as i read it, is more of
a suggestion to the compiler to allow better checking of your code
and, based on future compilers, it may not even be meaningful.

all of the short forms for attributes defined in compiler-gcc.h are
exactly that -- short forms.  by adding in a return type, you're
fundamentally changing the way that short cut can be used.

yes, i *know* that __noreturn makes the return type irrelevant.  but
even the gcc manual doesn't try to take that extra step:

================================================================
A few standard library functions, such as abort and exit, cannot
return. GCC knows this automatically. Some programs define their own
functions that never return. You can declare them noreturn to tell the
compiler this fact. For example,



void fatal () __attribute__ ((noreturn));

void
fatal (...)
{
  ... /* Print error message. */ ...
  exit (1);
}

The noreturn keyword tells the compiler to assume that fatal cannot
return. It can then optimize without regard to what would happen if
fatal ever did return. This makes slightly better code. More
importantly, it helps avoid spurious warnings of uninitialized
variables.

Do not assume that registers saved by the calling function are
restored before calling the noreturn function.

It does not make sense for a noreturn function to have a return type
other than void.
^^^^^ ^^^^ ^^^^
===============================================================

  so I'm just going to stick with the pattern that's been used so far.
i realize it offends your sense of syntactic sensibility, but it's
just not worth treating that one attribute so differently from the
rest of them.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

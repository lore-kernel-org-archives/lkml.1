Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbXITNkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbXITNkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 09:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbXITNk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 09:40:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55389 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbXITNk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 09:40:29 -0400
Date: Thu, 20 Sep 2007 19:13:12 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: "Maciej W. Rozycki" <macro@linux-mips.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@pol.net>,
       linux-fbdev-devel@lists.sourceforge.net, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/video/pmag-ba-fb.c: Improve diagnostics
In-Reply-To: <Pine.LNX.4.64N.0709201342160.30788@blysk.ds.pg.gda.pl>
Message-ID: <alpine.LFD.0.999.0709201837160.17093@enigma.security.iitk.ac.in>
References: <Pine.LNX.4.64N.0709171736580.17606@blysk.ds.pg.gda.pl>
 <Pine.LNX.4.64N.0709181314300.9650@blysk.ds.pg.gda.pl>
 <20070919172412.725508d0.akpm@linux-foundation.org>
 <Pine.LNX.4.64N.0709201342160.30788@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,


On Thu, 20 Sep 2007, Maciej W. Rozycki wrote:
> 
> On Wed, 19 Sep 2007, Andrew Morton wrote:
> 
> > > patch-mips-2.6.23-rc5-20070904-pmag-ba-err-2
> > > diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/video/pmag-ba-fb.c linux-mips-2.6.23-rc5-20070904/drivers/video/pmag-ba-fb.c
> > > --- linux-mips-2.6.23-rc5-20070904.macro/drivers/video/pmag-ba-fb.c	2007-02-21 05:56:47.000000000 +0000
> > > +++ linux-mips-2.6.23-rc5-20070904/drivers/video/pmag-ba-fb.c	2007-09-18 10:56:51.000000000 +0000
> > > @@ -147,16 +147,23 @@ static int __init pmagbafb_probe(struct 
> > >  	resource_size_t start, len;
> > >  	struct fb_info *info;
> > >  	struct pmagbafb_par *par;
> > > +	int err = 0;
> > 
> > This initialisation to zero is not good.
> > 
> > Because if some error-path code forgot to do `err = -EFOO' then probe()
> > will return zero and the driver will leave things in half-initialised state
> > and will then proceed as if things had succeeded.  It will crash.
> 
>  GCC used to complain: "`foo' might be used uninitialized..." and this is 
> the usual cure; let me see if this not the case anymore (I have 4.1.2).

Even so, initializing to zero isn't quite good. You could use the
uninitialized_var() (once you've confirmed that the warning is bogus).
However, some maintainers may still nack uninitialized_var() usage,
quite legitimately.


> > So it's better to leave this local uninitialised, because we really want to
> > get that compiler warning if someone forgot to set the return value.
> 
>  Yes of course, barring the issue mentioned.  Note the message above is 
> not the same as: "`foo' is used uninitialized..." that would be reported 
> in the case which you are concerned of.

Firstly, "may be used uninitialized" can still be a bug.

Secondly, latest gcc is *horribly* buggy (and has been so for last several
releases including 4.1, 4.2 and 4.3 -- 3.x was good). See:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=33327
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=18501

We'd been hurling all sorts of abuses on gcc for quite long (when it fails
to detect these "false positive" cases), but now, it turns out it is quite
easy to write *genuinely* buggy code that still won't get any warnings,
neither the "is used" nor "may be used" one!

In short, there are three ways to fix these false positive warnings:

1. Do nothing, there are enough "uninitialized variable" warnings anyway,
   and hopefully, one day GCC would clean up its act.

2. Use uninitialized_var() to shut it up (only if it's genuinely bogus).

3. Do something like the following legendary patch [1]:

http://kegel.com/crosstool/crosstool-0.43/patches/linux-2.6.11.3/arch_alpha_kernel_srcons.patch

i.e., explicitly change the structure/logic of the function to make it
obvious enough to gcc that the variable will not be used uninitialized.


Satyam

[1] That was a funny case -- the alpha linux maintainer is also a gcc
    maintainer. Alpha even sets -Werror, so either he had to fix the
    kernel code that produced the warning, or go fix GCC to not warn
    about it -- he chose the former :-)

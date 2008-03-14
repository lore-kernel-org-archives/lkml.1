Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbYCNJaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbYCNJaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 05:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYCNJaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 05:30:05 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:55832 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbYCNJaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 05:30:01 -0400
Date: Fri, 14 Mar 2008 05:29:54 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: mws@twisted-brains.org
cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: whose job is it to include various header files?
In-Reply-To: <alpine.LFD.1.00.0803140405510.3148@localhost.localdomain>
Message-ID: <alpine.LFD.1.00.0803140518300.4434@localhost.localdomain>
References: <alpine.LFD.1.00.0803131802020.20317@localhost.localdomain> <9a8748490803131653n7f1c2bd0m12e30d82bf936d03@mail.gmail.com> <47DA1F8B.7040400@twisted-brains.org> <alpine.LFD.1.00.0803140405510.3148@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008, Robert P. J. Day wrote:

> On Fri, 14 Mar 2008, mws@twisted-brains.org wrote:
>
> > what i said in my first sentence is the imho proper way: if you
> > alter sources and includes get obsolete, remove them and fix
> > compiling again for files that formerly depended (implicit or
> > explicit) on this altered sources. not to much work for the
> > developer himself and also not exhausting the compile times.
>
> and, in my defense, that's what i *thought* i was doing, not having
> noticed that one of those "unnecessary" #includes really was
> required after all.  argh.  that was embarrassing.

  sure, let's beat this to death.

  upon reflection, i realize i was trying to deal with two different
issues.  on the one hand, there are the (countless?) header files that
don't include header files they normally should.  for instance,
imagine a file fubar.c that contains:

  ...
  #include <linux/percpu.h>
  ...
  ... some reference to GFP_KERNEL ...
  ...

but doesn't include <linux/gfp.h>, which it should 'cuz it's referring
to GFP_KERNEL.  the above will still work since percpu.h includes
slab.h, which includes gfp.h, so it all works out in the end.  and
there's simply too much of that going on to do anything about.

on the other hand, something that *is* worth fixing is what's in
percpu.h right now:
  ...
  #include <linux/string.h> /* For memset() */
  ...

since it's clear(?) that percpu.h has no need for string.h, it does
make sense to remove that include and see if that causes the build to
break because others have quietly been taking advantage of that
include.

  IMHO, then, that second case is worth trying to fix when it comes
up.  the first really isn't, but i had the two confused and thought i
had actually come across the second example.  again, my stupidity.

rday

p.s.  just for fun, i did remove that include of string.h from
percpu.h and i'm doing an allyesconfig x86 build off on the side just
to see the result.  if it still builds, then that *would* be worth a
quick patch, just to stop including stuff you don't need.  and there's
going to be *lot* less of that, i would think.

--


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================

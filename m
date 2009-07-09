Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbZGILBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbZGILBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 07:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbZGILB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 07:01:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38777 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbZGILB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 07:01:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090709101930.GJ10937@elf.ucw.cz>
References: <20090709101930.GJ10937@elf.ucw.cz> <20090704024606.GE1345@ucw.cz> <20090701120814.30741.10146.stgit@warthog.procyon.org.uk> <24530.1247050900@redhat.com> <20090704033429.GA1799@ucw.cz> <8bd0f97a0907081148vc716eeepfdaf8178b1ecbce1@mail.gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: dhowells@redhat.com, Mike Frysinger <vapier.adi@gmail.com>,
       rgetz@blackfin.uclinux.org, lethal@linux-sh.org, gerg@uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FDPIC: Ignore the loader's PT_GNU_STACK when calculating the stack size
Date: Thu, 09 Jul 2009 11:59:11 +0100
Message-ID: <24280.1247137151@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:

> > i really dont think this is realistic.  there is exactly one ldso that
> > everyone uses under FDPIC ELF, and it needs a very minuscule stack.
> 
> Not very realistic; but that argues that the patch is NOP.
>
> And if it _is_ realistic, the patch adds a bug.

No, it doesn't.  The problem is that the loader, when it is linked, is given a
sillyly large default stack size, and this causes the application to be given a
much larger stack than is strictly necessary - a stack that is drawn from a
limited pool of non-pageable RAM and that must be allocated as a contiguous
lump.

The executables should take into account the amount of stack space needed to
call into all their libraries - and that includes the loader.  You can argue
that the loader should specify the amount of extra overhead it will need, and
that this should be _added_ to the executable's stack estimate, but using the
loader's stack estimate instead of the executable's does not really make sense.

You can also argue that the executable doesn't know how much space the loader
will use, because the loader can be independently replaced; but this isn't a
good argument because the loader doesn't know how much the executable will use,
and neither know how much the various shared libs will use.  The only way to do
that is to add up all the stack estimates.

Now, it *is* perfectly reasonable to use the loader's stack estimate in the
case that the loader is run as an executable.  It could, for example, behave as
the GLIBC loader and have some functions available for shared library query and
suchlike.

David

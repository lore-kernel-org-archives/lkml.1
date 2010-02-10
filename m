Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab0BJWIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 17:08:45 -0500
Received: from verein.lst.de ([213.95.11.210]:38476 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab0BJWIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 17:08:41 -0500
Date: Wed, 10 Feb 2010 23:03:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, oleg@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       mattst88@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net,
       linux@arm.linux.org.uk, hskinnemoen@atmel.com, vapier@gentoo.org,
       starvik@axis.com, jesper.nilsson@axis.com, ysato@users.sourceforge.jp,
       takata@linux-m32r.org, gerg@uclinux.org, monstr@monstr.eu,
       ralf@linux-mips.org, jdike@addtoit.com, chris@zankel.net
Subject: Re: [PATCH 1/14] move user_enable_single_step & co prototypes to linux/ptrace.h
Message-ID: <20100210220323.GA10365@lst.de>
References: <20100202185755.GA3630@lst.de> <20100208195125.27ADD1AF@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208195125.27ADD1AF@magilla.sf.frob.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 11:51:25AM -0800, Roland McGrath wrote:
> The original thought there was that user_enable_single_step() et al might
> well be only an instruction or three on a sane machine (as if we have any
> of those!), and since there is only one call site inlining would be
> beneficial.  But I agree that there is no strong reason to care about
> inlining it.

In fact many of the implementations are small enough to inline them, but
not no architecture so far decided to inline them, and in the end it's
not exactly a fast-path.  This at least keeps the prototype the same
everywhere.

> As to the arch changes, there is only one thought I'd add to the record.
> It was always my thinking that for an arch where PTRACE_SINGLESTEP does
> text-modifying breakpoint insertion, user_enable_single_step() should not
> be provided.  That is, arch_has_single_step()=>true means that there is an
> arch facility with "pure" semantics that does not have any unexpected side
> effects.  Inserting a breakpoint might do very unexpected strange things in
> multi-threaded situations.  Aside from that, it is a peculiar side effect
> that user_{enable,disable}_single_step() should cause COW de-sharing of
> text pages and so forth.  For PTRACE_SINGLESTEP, all these peculiarities
> are the status quo ante for that arch, so having arch_ptrace() itself do
> those is one thing.  But for building other things in the future, it is
> nicer to have a uniform "pure" semantics that arch-independent code can
> expect.

For now the ptrace code is the same for real or software singlestepping.
If we grow users that care we can add a arch_has_hw_single_step macro
or just overload arch_has_single_step with different postitive return
values for the exact same type of single stepping supported.


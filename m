Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0BHTxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:53:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397Ab0BHTxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:53:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Christoph Hellwig <hch@lst.de>
X-Fcc: ~/Mail/linus
Cc: oleg@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, mattst88@gmail.com,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, vapier@gentoo.org, starvik@axis.com,
       jesper.nilsson@axis.com, ysato@users.sourceforge.jp,
       takata@linux-m32r.org, gerg@uclinux.org, monstr@monstr.eu,
       ralf@linux-mips.org, jdike@addtoit.com, chris@zankel.net
Subject: Re: [PATCH 1/14] move user_enable_single_step & co prototypes to linux/ptrace.h
In-Reply-To: Christoph Hellwig's message of  Tuesday, 2 February 2010 19:57:55 +0100 <20100202185755.GA3630@lst.de>
References: <20100202185755.GA3630@lst.de>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20100208195125.27ADD1AF@magilla.sf.frob.com>
Date: Mon,  8 Feb 2010 11:51:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original thought there was that user_enable_single_step() et al might
well be only an instruction or three on a sane machine (as if we have any
of those!), and since there is only one call site inlining would be
beneficial.  But I agree that there is no strong reason to care about
inlining it.

As to the arch changes, there is only one thought I'd add to the record.
It was always my thinking that for an arch where PTRACE_SINGLESTEP does
text-modifying breakpoint insertion, user_enable_single_step() should not
be provided.  That is, arch_has_single_step()=>true means that there is an
arch facility with "pure" semantics that does not have any unexpected side
effects.  Inserting a breakpoint might do very unexpected strange things in
multi-threaded situations.  Aside from that, it is a peculiar side effect
that user_{enable,disable}_single_step() should cause COW de-sharing of
text pages and so forth.  For PTRACE_SINGLESTEP, all these peculiarities
are the status quo ante for that arch, so having arch_ptrace() itself do
those is one thing.  But for building other things in the future, it is
nicer to have a uniform "pure" semantics that arch-independent code can
expect.

OTOH, all such arch issues are really up to the arch maintainer.  As of
today, there is nothing but ptrace using user_enable_single_step() et al so
it's a distinction without a practical difference.  If/when there are other
facilities that use user_enable_single_step() and might care, the affected
arch's can revisit the question when someone cares about the quality of the
arch support for said new facility.

So, with those caveats preserved for posteriority, all these changes
are OK with me.


Thanks,
Roland

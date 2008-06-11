Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbYFKETD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbYFKETD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 00:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbYFKESw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 00:18:52 -0400
Received: from ozlabs.org ([203.10.76.45]:43828 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbYFKESv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 00:18:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18511.21025.978328.596571@cargo.ozlabs.ibm.com>
Date: Wed, 11 Jun 2008 14:18:41 +1000
From: Paul Mackerras <paulus@samba.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: MMIO and gcc re-ordering issue
In-Reply-To: <200806101656.51211.nickpiggin@yahoo.com.au>
References: <1211852026.3286.36.camel@pasglop>
	<Pine.LNX.4.64.0806031130130.3242@t2.domain.actdsltmp>
	<alpine.LFD.1.10.0806031153360.3473@woody.linux-foundation.org>
	<200806101656.51211.nickpiggin@yahoo.com.au>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin writes:

> OK, I'm sitll not quite sure where this has ended up. I guess you are happy
> with x86 semantics as they are now. That is, all IO accesses are strongly
> ordered WRT one another and WRT cacheable memory (which includes keeping
> them within spinlocks),

My understanding was that on x86, loads could pass stores in general,
i.e. a later load could be performed before an earlier store.  I guess
that can't be true for uncached loads, but could a cacheable load be
performed before an earlier uncached store?

> - as strong as x86. guaranteed not to break drivers that work on x86,
>   but slower on some archs. To me, this is most pleasing. It is much
>   much easier to notice something is going a little slower and to work
>   out how to use weaker ordering there, than it is to debug some
>   once-in-a-bluemoon breakage caused by just the right architecture,
>   driver, etc. It totally frees up the driver writer from thinking
>   about barriers, provided they get the locking right.

I just wish we had even one actual example of things going wrong with
the current rules we have on powerpc to motivate changing to this
model.

> Now that doesn't leave waker ordering architectures lumped with "slow old
> x86 semantics". Think of it as giving them the benefit of sharing x86
> development and testing :) We can then formalise the relaxed __ accessors
> to be more complete (ie. +/- byteswapping).

That leaves a gulf between the extremely strongly ordered writel
etc. and the extremely weakly ordered __writel etc.  The current
powerpc scheme is fine for a lot of drivers but your proposal would
leave us no way to deliver it to them.

Paul.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbYE0Bee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbYE0Bee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 21:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754826AbYE0BeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 21:34:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:58679 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbYE0BeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 21:34:23 -0400
Subject: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linux Arch list <linux-arch@vger.kernel.org>
Cc: David Miller <davem@davemloft.net>, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Trent Piepho <tpiepho@freescale.com>
In-Reply-To: <Pine.LNX.4.64.0805221553400.8205@t2.domain.actdsltmp>
References: <4833524C.3040207@freescale.com>
	 <20080520.153947.84346222.davem@davemloft.net>
	 <4833542E.3040608@freescale.com>
	 <20080520.155326.195407196.davem@davemloft.net>
	 <1211516683.8297.271.camel@pasglop>
	 <Pine.LNX.4.64.0805221553400.8205@t2.domain.actdsltmp>
Content-Type: text/plain
Date: Tue, 27 May 2008 11:33:46 +1000
Message-Id: <1211852026.3286.36.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-post to linux-arch of a discussion on lkml.

Mostly due to lack of reactions :-)

Quick summary: gcc is happily re-ordering readl/writel vs. surrounding
memory accesses (and thus accesses to DMA coherent memory) which is
obviously a _BAD_THING_.

This is on all archs. Quick fix is to stick a "memory" clobber in all arch
implementations of readl/writel/... (ie, making them a barrier()).

However, I'm using that as an excuse to bring back my pet subject, which
is basically, should we instead just finally mandate the use of explicit
rmb/wmb/mb's (which boils down to barrier() on x86) to drivers who want
to order memory consistent accesses vs. MMIO ?

The reason is that on archs that are out of order, this would allow us
to get rid in the long run of some of the heavy barriers we have put in
our readl/writel implementations to make them look like x86.

Note that there are drivers that already do that (ie. explicit rmb/wmb/mb
to order coherent memory accesses vs. MMIO), such as OHCI/EHCI which
may explain why the new problem with gcc isn't more obviously hitting
people, as those turn into compiler barriers on x86.

If that approach is accepted, then I'll start auditing drivers and send
patches adding wmb/rmb/mb's to them, and in the long run, after mucho
testing, relax powerpc writel/readl implementations. Other archs can then
do the same too

If that approach is generally considered wrong, then we should probably
remove the spurrious readl/writel in drivers that do them.
 
So what are the opinions here ?

Cheers,
Ben.


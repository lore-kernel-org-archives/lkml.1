Return-Path: <linux-kernel-owner+w=401wt.eu-S1764285AbXGSAPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764285AbXGSAPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbXGSAPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:15:43 -0400
Received: from ns1.suse.de ([195.135.220.2]:33025 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbXGSAPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:15:42 -0400
Date: Thu, 19 Jul 2007 02:15:39 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Matt Mackall <mpm@selenic.com>
Cc: Rene Herman <rene.herman@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Bodo Eggert <7eggert@gmx.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070719001539.GC29728@v2.random>
References: <8GVjY-PL-25@gated-at.bofh.it> <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> <Pine.LNX.4.58.0707161523500.25779@be1.lrz> <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <20070716230719.GC11115@waste.org> <469BFB73.3070105@gmail.com> <20070716232755.GD11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716232755.GD11115@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 06:27:55PM -0500, Matt Mackall wrote:
> So it's absolutely no help in fixing our order-1 allocation problem
> because we don't want to force large pages on people.

Using kmalloc(8k) instead of alloc_page() doesn't sound a too big deal
and that will solve the problem. The whole idea is to avoid the memcpy
+ pte mangling of defrag while hopefully lowering cpu utilization in
allocations at the same time.

About 4k stacks I was generally against them, much better to fail in
fork than to risk corruption. The per-irq stack part is great feature
instead (too bad it wasn't enabled for the safer 8k stacks).

Failing in a do_no_page with variable order page size allocation is a
fatal event (the task will be killed), failing in fork is graceful,
userland can retry etc... Fork can fail for different reasons, ulimit
itself is the most likely source of fork failures. I don't think the
8k stacks have ever been a problem, yes you will run out of stack
sooner (sooner also because the 4k stacks takes less memory) but
nothing is terribly wrong if the 8k allocation fails.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZA0JIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZA0JIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 04:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZA0JIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 04:08:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40529 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZA0JIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 04:08:02 -0500
Subject: Re: [patch] SLQB slab allocator (try 2)
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <alpine.DEB.1.10.0901261219350.32192@qirst.com>
References: <20090123154653.GA14517@wotan.suse.de>
	 <1232959706.21504.7.camel@penberg-laptop> <1232960840.4863.7.camel@laptop>
	 <alpine.DEB.1.10.0901261219350.32192@qirst.com>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 10:07:52 +0100
Message-Id: <1233047272.4984.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-26 at 12:22 -0500, Christoph Lameter wrote:
> On Mon, 26 Jan 2009, Peter Zijlstra wrote:
> 
> > Then again, anything that does allocation is per definition not bounded
> > and not something we can have on latency critical paths -- so on that
> > respect its not interesting.
> 
> Well there is the problem in SLAB and SLQB that they *continue* to do
> processing after an allocation. They defer queue cleaning. So your latency
> critical paths are interrupted by the deferred queue processing.

No they're not -- well, only if you let them that is, and then its your
own fault.

Remember, -rt is about being able to preempt pretty much everything. If
the userspace task has a higher priority than the timer interrupt, the
timer interrupt just gets to wait.

Yes there is a very small hardirq window where the actual interrupt
triggers, but all that that does is a wakeup and then its gone again.

>  SLAB has
> the awful habit of gradually pushing objects out of its queued (tried to
> approximate the loss of cpu cache hotness over time). So for awhile you
> get hit every 2 seconds with some free operations to the page allocator on
> each cpu. If you have a lot of cpus then this may become an ongoing
> operation. The slab pages end up in the page allocator queues which is
> then occasionally pushed back to the buddy lists. Another relatively high
> spike there.

Like Nick has been asking, can you give a solid test case that
demonstrates this issue?

I'm thinking getting git of those cross-bar queues hugely reduces that
problem.


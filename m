Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZA0VG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZA0VG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZA0VFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:05:51 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:47675 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752480AbZA0VFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:05:49 -0500
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2009 16:05:49 EST
Date: Tue, 27 Jan 2009 15:21:58 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch] SLQB slab allocator (try 2)
In-Reply-To: <1233047272.4984.12.camel@laptop>
Message-ID: <alpine.DEB.1.10.0901271509170.3114@qirst.com>
References: <20090123154653.GA14517@wotan.suse.de>  <1232959706.21504.7.camel@penberg-laptop> <1232960840.4863.7.camel@laptop>  <alpine.DEB.1.10.0901261219350.32192@qirst.com> <1233047272.4984.12.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Peter Zijlstra wrote:

> > Well there is the problem in SLAB and SLQB that they *continue* to do
> > processing after an allocation. They defer queue cleaning. So your latency
> > critical paths are interrupted by the deferred queue processing.
>
> No they're not -- well, only if you let them that is, and then its your
> own fault.

So you can have priority over kernel threads.... Sounds very dangerous.

> Remember, -rt is about being able to preempt pretty much everything. If
> the userspace task has a higher priority than the timer interrupt, the
> timer interrupt just gets to wait.
>
> Yes there is a very small hardirq window where the actual interrupt
> triggers, but all that that does is a wakeup and then its gone again.

Never used -rt. This is an issue seen in regular kernels.

> >  SLAB has
> > the awful habit of gradually pushing objects out of its queued (tried to
> > approximate the loss of cpu cache hotness over time). So for awhile you
> > get hit every 2 seconds with some free operations to the page allocator on
> > each cpu. If you have a lot of cpus then this may become an ongoing
> > operation. The slab pages end up in the page allocator queues which is
> > then occasionally pushed back to the buddy lists. Another relatively high
> > spike there.
>
> Like Nick has been asking, can you give a solid test case that
> demonstrates this issue?

Run a loop reading tsc and see the variances?

In HPC apps a series of processors have to sync repeatedly in order to
complete operations. An event like cache cleaning can cause a disturbance
in one processor that delays this sync in the system as a whole. And
having it run at offsets separately on all processor causes the
disturbance to happen on one processor after another. In extreme cases all
syncs are delayed. We have seen this effect have a major delay on HPC app
performance.

Note that SLAB scans through all slab caches in the system and expires
queues that are active. The more slab caches there are and the more data
is in queues the longer the process takes.

> I'm thinking getting git of those cross-bar queues hugely reduces that
> problem.

The cross-bar queues are a significant problem because they mean operation
on objects that are relatively far away. So the time spend in cache
cleaning increases significantly. But as far as I can see SLQB also has
cross-bar queues like SLAB. SLUB does all necessary actions during the
actual allocation or free so there is no need to run cache cleaning.

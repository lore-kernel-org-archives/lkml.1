Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbXD1Xge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbXD1Xge (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbXD1Xge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:36:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46511 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753201AbXD1Xgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:36:33 -0400
Date: Sat, 28 Apr 2007 16:35:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arjan van de Ven <arjan@linux.intel.com>
cc: akpm@osdl.org, linux-kernel@vger.kernel
Subject: Re: Please revert [PATCH] user of the jiffies rounding patch: Slab
In-Reply-To: <4633D1A2.6010002@linux.intel.com>
Message-ID: <Pine.LNX.4.64.0704281632001.12695@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704281403140.12122@schroedinger.engr.sgi.com>
 <4633D1A2.6010002@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Arjan van de Ven wrote:

> Christoph Lameter wrote:
> > The slab reaper takes global locks. If one makes all cache reapers fire at
> > the same time as this patch does then there will be a lot of contention that
> > may result lots of interrupt holdoffs since some locks are taken
> > with interrupts disabled. The vm statistics counters are updated
> > and will content for global cachelines if this is done.
> 
> > I'd suggest to use a staggered per cpu approach instead that runs multiple
> > per cpu timers at once. But every batch of these timers must be run at an
> > offset from each other. Not at the same time please.
> 
> from kernel/timer.c
> 
> 107
> 108         /*
> 109          * We don't want all cpus firing their timers at once hitting the
> 110          * same lock or cachelines, so we skew each extra cpu with an
> extra
> 111          * 3 jiffies. This 3 jiffies came originally from the mm/ code
> which
> 112          * already did this.
> 113          * The skew is done by adding 3*cpunr, then round, then subtract
> this
> 114          * extra offset again.
> 115          */
> 116         j += cpu * 3;
> 
> 
> isn't 3 jiffies distance per cpu enough for this already ??
> That's what it used to be before as well...

Hmmm... Yes but that looks like it comes from a different function. Slab
calls

 __round_jiffies_relative(HZ, cpu))

And its description says:

/**
 * __round_jiffies_relative - function to round jiffies to a full second
 * @j: the time in (relative) jiffies that should be rounded
 * @cpu: the processor number on which the timeout will happen
 *
 * __round_jiffies_relative() rounds a time delta  in the future (in jiffies)
 * up or down to (approximately) full seconds. This is useful for timers
 * for which the exact time they fire does not matter too much, as long as
 * they fire approximately every X seconds.
 *
 * By rounding these timers to whole seconds, all such timers will fire
 * at the same time, rather than at various times spread out. The goal
 * of this is to have the CPU wake up less, which saves power.
 *
 * The exact rounding is skewed for each processor to avoid all
 * processors firing at the exact same time, which could lead
 * to lock contention or spurious cache line bouncing.
 *
 * The return value is the rounded version of the @j parameter.
 */

This is exactly the wrong thing to do.


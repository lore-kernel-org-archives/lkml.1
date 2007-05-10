Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbXEJT6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbXEJT6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXEJT56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:57:58 -0400
Received: from holomorphy.com ([66.93.40.71]:40190 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbXEJT56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:57:58 -0400
Date: Thu, 10 May 2007 12:58:40 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [RFC] Slab allocators: Drop support for destructors
Message-ID: <20070510195840.GN19966@holomorphy.com>
References: <Pine.LNX.4.64.0705101156190.10663@schroedinger.engr.sgi.com> <84144f020705101221y6070ed93he837c59053084fae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020705101221y6070ed93he837c59053084fae@mail.gmail.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Christoph Lameter <clameter@sgi.com> wrote:
>> Or are there valid reason to keep them around? It seems they were mainly
>> used for list management which required them to take a spinlock. Taking a
>> spinlock in a destructor is a bit risky since the slab allocators may run
>> the destructors anytime they decide a slab is no longer needed.
>> Or do we want to continue support destructors? If so why?

On Thu, May 10, 2007 at 10:21:08PM +0300, Pekka Enberg wrote:
> Well, constructors are on their way out too because they don't seem to
> give the performance benefit they were designed for anymore. As for
> destructors, they have been pretty useless in Linux for a long time
> now and we really don't do much "complex initialization" that requires
> undo (releasing resources).

The anti-constructor trend is counterproductive. The cache effects are
not being properly monitored and people are failing to understand the
importance of conserving cache.

Microbenchmarks where you pound the potentially preconstructed data
structures like wild monkeys are not why constructors are used. They're
to avoid burning cachelines in the cases where you need the cache for
other purposes besides building up and tearing down the structures in
question. Data structure layout becomes relevant to this; the
preconstructed cachelines need to be separated from ones that must be
clobbered regardless immediately after allocation. The effect is
cumulative and broadly dispersed. The constructor elimination patches
are incrementally filling up caches with the formerly preconstructed
objects' cachelines, where the degradation from each individual change
is so small as to be difficult to to discern or potentially even seen
to be advantageous on unrealistic microbenchmarks. The net effect of
removing constructors altogether will be degradations in real-world
workloads on account of the combined effect of the cache footprint
increases. The cache should rather be saved for userspace.

What would make this easier to see would be cache instrumentation not
available to most people. Specifically, tabulating what the various
cachelines in the cache are caching. Simulators may be useful to help
determine all that.


-- wli

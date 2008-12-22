Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbYLVD4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbYLVD4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 22:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYLVD4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 22:56:15 -0500
Received: from ozlabs.org ([203.10.76.45]:40232 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbYLVD4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 22:56:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: per-cpu stats in block device: overkill?
Date: Mon, 22 Dec 2008 14:26:09 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>, Jerome Marchand <jmarchan@redhat.com>,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
References: <200812221049.43884.rusty@rustcorp.com.au> <494EF3AA.9040100@kernel.org>
In-Reply-To: <494EF3AA.9040100@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812221426.09723.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 December 2008 12:25:54 Tejun Heo wrote:
> I'm working on local counter (local_t) allocator which is used to
> replace percpu allocation in percpu_counter and used as basis for
> percpu_ref which replaces module ref counting and will be used to
> simplify block/char lifetime rules.

Hi Tejun,

   Interesting!  Thanks to Christoph's dynamic percpu efforts, I've
been revising efforts to make alloc_percpu use the same efficient
mechanism that static percpu vars use.  We actually have this code
already, tucked away in module.c.

   This work is basically complete; the step I started this morning
is to remove the per_cpu__ prefix hackery from the per-cpu ops (in favour
of sparse annotations).  This leads to cpu_local_inc et. al. being usable
for alloc_percpu-created percpu vars, not just static ones.

> The local counter allocator allocates per-cpu pages and the space
> overhead is minimal.  If per-cpu stats in genhd is necessary, I think
> converting it to percpu local counter allocation should do it.

   Interesting; an allyesconfig boot uses 194 per-cpu allocs from
lib/percpu_counter.c at the moment.  The module.c allocator is fairly space
efficient: 4 bytes per "block" (ie. each allocation or hole) but slow,
which I figure is OK.  Packing is good though.

> BTW, why make percpu area static?

   Good question.  Archs use a simple offset for per-cpu areas: some hold
this in a register (eg. %fs for x86-32).  This means that the layout must be
"congruent" (ie. have the same inter-cpu spacing) if we allocate a new
per-cpu area (hard for non-NUMA).

  For 5 years I waited for this to be fixed, and avoided exposing the per-cpu
core, and the alloc_percpu stuff was a standin implementation.  But Christoph
L. showed that even with the size limit, there are numerous places which want
small per-cpu allocations which are optimally accessed, so I restarted work.
See Message-Id: <20081117132630.33F09DDDF5@ozlabs.org> "[PATCH 1/7] Improve
alloc_percpu: make the per cpu reserve configurable and larger." and thread.

  In addition, Mathieu and I have been discussing local_t: it's wandered
off its original purpose and we're debating what to do about it.  See
Message-ID: <alpine.DEB.1.10.0812150823370.18692@gandalf.stny.rr.com>
"local_add_return" and thread.

I look forward to always-cogent your thoughts on these issues!
Rusty.

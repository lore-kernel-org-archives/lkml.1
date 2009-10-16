Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbZJPMJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbZJPMJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 08:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbZJPMJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 08:09:58 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:63626 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896AbZJPMJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 08:09:58 -0400
Subject: Re: [PATCH] kmemleak: Do not use off-slab management with
	SLAB_NOLEAKTRACE
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <4AD770FB.5030104@cs.helsinki.fi>
References: <20091014153146.8955.19964.stgit@pc1117.cambridge.arm.com>
	 <4AD770FB.5030104@cs.helsinki.fi>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 16 Oct 2009 13:08:14 +0100
Message-Id: <1255694894.3008.40.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2009 12:08:15.0877 (UTC) FILETIME=[5764F350:01CA4E59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Thu, 2009-10-15 at 21:59 +0300, Pekka Enberg wrote:
> Catalin Marinas wrote:
> > With the slab allocator, if off-slab management is enabled for the
> > kmem_caches used by kmemleak, it leads to recursive calls into
> > kmemleak_alloc(). Off-slab management can be triggered by other config
> > options increasing the slab size, e.g. DEBUG_PAGEALLOC.
> > 
> > Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> > Cc: Christoph Lameter <cl@linux-foundation.org>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Forcing slabs to use on-slab management is pretty bad from memory 
> consumption point of view. Wouldn't it be better to annotate the 
> recursive calls somehow?

The are annotated using SLAB_NOLEAKTRACE but off-slab management uses a
general cachep and we cannot use this flag on them as we end up ignoring
kmalloc allocations. An alternative is to use GFP_ flag rather than a
SLAB_ one to track the recursive calls.

I could also rework the way hooks were added to slab.c but currently
they follow the same places as kmemcheck_slab_alloc and
lockdep_trace_alloc.

Anyway, the kmemleak caches only need off-slab management when
DEBUG_PAGEALLOC is enabled but in this case the memory consumption is
high anyway.

-- 
Catalin


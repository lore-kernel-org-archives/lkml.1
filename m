Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbYLLNqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbYLLNqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 08:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbYLLNpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 08:45:52 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:62700 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757040AbYLLNpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 08:45:51 -0500
Subject: Re: [PATCH 05/15] kmemleak: Add the slub memory allocation/freeing
	hooks
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <4941866D.5040005@cs.helsinki.fi>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182721.30323.55530.stgit@pc1117.cambridge.arm.com>
	 <4941866D.5040005@cs.helsinki.fi>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 12 Dec 2008 13:45:43 +0000
Message-Id: <1229089544.15045.24.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2008 13:45:44.0945 (UTC) FILETIME=[EE7AE610:01C95C5F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-11 at 23:30 +0200, Pekka Enberg wrote:
> Catalin Marinas wrote:
> > This patch adds the callbacks to memleak_(alloc|free) functions from the
> > slub allocator.
> > 
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Christoph Lameter <cl@linux-foundation.org>
> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Hmm, I'm not sure I understand why struct kmem_cache_cpu ->freelist is 
> never scanned. 

Did you get any false positives? Or were you expecting false negatives
because of freelist scanning which never occurred?

> For SMP, I suppose kmemleak doesn't scan the per-CPU 
> areas?

It should scan the per-CPU areas in the memleak_scan() function:

#ifdef CONFIG_SMP
	/* per-cpu sections scanning */
	for_each_possible_cpu(i)
		scan_block(__per_cpu_start + per_cpu_offset(i),
			   __per_cpu_end + per_cpu_offset(i), NULL);
#endif

>  But for UP, struct kmem_cache is allocated with kmalloc() and 
> that contains struct kmem_cache_cpu as well.

They should be scanned as well.

> And I suppose we never scan struct pages either. Otherwise ->freelist 
> there would be a problem as well.

It was scanning the mem_map arrays in the past but removed this part and
haven't seen any problems (on ARM).

Why would the ->freelist be a problem? I don't fully understand the slub
allocator. Aren't objects added to the freelist only after they were
freed? In __slab_alloc there seems to be a line:

c->page->freelist = NULL;

so the freelist won't count as a reference anymore. After freeing an
object, kmemleak no longer cares about references to it.

-- 
Catalin


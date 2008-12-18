Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753133AbYLRKvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbYLRKvU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYLRKvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:51:08 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35291 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbYLRKvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:51:07 -0500
Subject: Re: [PATCH 05/15] kmemleak: Add the slub memory allocation/freeing
	hooks
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <1229089544.15045.24.camel@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182721.30323.55530.stgit@pc1117.cambridge.arm.com>
	 <4941866D.5040005@cs.helsinki.fi>
	 <1229089544.15045.24.camel@pc1117.cambridge.arm.com>
Date: Thu, 18 Dec 2008 12:51:05 +0200
Message-Id: <1229597465.1047.54.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Fri, 2008-12-12 at 13:45 +0000, Catalin Marinas wrote:
> > Hmm, I'm not sure I understand why struct kmem_cache_cpu ->freelist is 
> > never scanned. 
> 
> Did you get any false positives? Or were you expecting false negatives
> because of freelist scanning which never occurred?

I haven't tested kmemleak so I'm just commenting on the code. I was
thinking about false negatives, not false positives.

On Fri, 2008-12-12 at 13:45 +0000, Catalin Marinas wrote:
> > For SMP, I suppose kmemleak doesn't scan the per-CPU 
> > areas?
> 
> It should scan the per-CPU areas in the memleak_scan() function:
> 
> #ifdef CONFIG_SMP
> 	/* per-cpu sections scanning */
> 	for_each_possible_cpu(i)
> 		scan_block(__per_cpu_start + per_cpu_offset(i),
> 			   __per_cpu_end + per_cpu_offset(i), NULL);
> #endif
> 
> >  But for UP, struct kmem_cache is allocated with kmalloc() and 
> > that contains struct kmem_cache_cpu as well.
> 
> They should be scanned as well.
>
> > And I suppose we never scan struct pages either. Otherwise ->freelist 
> > there would be a problem as well.
> 
> It was scanning the mem_map arrays in the past but removed this part and
> haven't seen any problems (on ARM).
> 
> Why would the ->freelist be a problem? I don't fully understand the slub
> allocator. Aren't objects added to the freelist only after they were
> freed? In __slab_alloc there seems to be a line:
> 
> c->page->freelist = NULL;
> 
> so the freelist won't count as a reference anymore. After freeing an
> object, kmemleak no longer cares about references to it.

I think we're talking about two different things here. Don't we then
have false negatives because we reach ->freelist of struct
kmem_cache_cpu which contains a pointer to an object that is free'd
(take a look at slab_free() fast-path)?

		Pekka


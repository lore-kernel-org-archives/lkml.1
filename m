Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZCaIY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZCaIY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbZCaIYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:24:38 -0400
Received: from smtp-out.google.com ([216.239.45.13]:34638 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZCaIYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:24:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=UAqMHImqu2+0wd/NOF2rsMXkeyMUdVKZ100ux1ztpOuO6rPdA1WDSseyvolfm6xTP
	hpc0THMAu60/OoatY04JQ==
Date: Tue, 31 Mar 2009 01:23:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Martin Bligh <mbligh@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] slub: scan partial list for free slabs when
 thrashing
In-Reply-To: <1238483617.26587.32.camel@penberg-laptop>
Message-ID: <alpine.DEB.2.00.0903310043060.5579@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com>  <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com>  <alpine.DEB.2.00.0903292243050.15813@chino.kir.corp.google.com>  <alpine.DEB.1.10.0903301033380.13333@qirst.com>
 <1238483617.26587.32.camel@penberg-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009, Pekka Enberg wrote:

> On Mon, 2009-03-30 at 10:37 -0400, Christoph Lameter wrote:
> > That adds fastpath overhead and it shows for small objects in your tests.
> 
> Yup, and looking at this:
> 
> +       u16 fastpath_allocs;    /* Consecutive fast allocs before slowpath */
> +       u16 slowpath_allocs;    /* Consecutive slow allocs before watermark */
> 
> How much do operations on u16 hurt on, say, x86-64?

As opposed to unsigned int?  These simply use the word variations of the 
mov, test, cmp, and inc instructions instead of long.  It's the same 
tradeoff when using the u16 slub fields within struct page except it's not 
strictly required in this instance because of size limitations, but rather 
for cacheline optimization.

> It's nice that
> sizeof(struct kmem_cache_cpu) is capped at 32 bytes but on CPUs that
> have bigger cache lines, the types could be wider.
> 

Right, this would not change the unpacked size of the struct whereas using 
unsigned int would.

Since MAX_OBJS_PER_PAGE (which should really be renamed MAX_OBJS_PER_SLAB) 
ensures there is no overflow for u16 types, the only time fastpath_allocs 
would need to be wider is when the object size is sufficiently small and 
there had been frees to the cpu slab so that it overflows.  In this 
circumstance, slowpath_allocs would simply be incremented and it would be 
corrected the next time a cpu slab does allocate beyond the threshold 
(SLAB_THRASHING_THRESHOLD should never be 1).  The chance of reaching the 
threshold on successive fastpath counter overflows grows exponentially.

And since slowpath_allocs will never overflow because it's capped at 
SLAB_THRASHING_THRESHOLD + 1 (the cpu slab will be refilled with a slab 
that will ensure slowpath_allocs will be decremented the next time the 
slowpath is invoked), overflow isn't an immediate problem with either.

> Christoph, why is struct kmem_cache_cpu not __cacheline_aligned_in_smp
> btw?
> 

This was removed in 4c93c355d5d563f300df7e61ef753d7a064411e9.

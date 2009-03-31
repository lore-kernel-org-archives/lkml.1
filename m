Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbZCaN22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbZCaN22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbZCaN2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:28:19 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:55507 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZCaN2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:28:18 -0400
Date: Tue, 31 Mar 2009 09:23:47 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: David Rientjes <rientjes@google.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] slub: scan partial list for free slabs when
 thrashing
In-Reply-To: <1238483617.26587.32.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0903310920220.24040@qirst.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com>  <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com>  <alpine.DEB.2.00.0903292243050.15813@chino.kir.corp.google.com>  <alpine.DEB.1.10.0903301033380.13333@qirst.com>
 <1238483617.26587.32.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009, Pekka Enberg wrote:

> On Sun, 29 Mar 2009, David Rientjes wrote:
> > > Whenever a cpu cache satisfies a fastpath allocation, a fastpath counter
> > > is incrememted.  This counter is cleared whenever the slowpath is
> > > invoked.  This tracks how many fastpath allocations the cpu slab has
> > > fulfilled before it must be refilled.
>
> On Mon, 2009-03-30 at 10:37 -0400, Christoph Lameter wrote:
> > That adds fastpath overhead and it shows for small objects in your tests.
>
> Yup, and looking at this:
>
> +       u16 fastpath_allocs;    /* Consecutive fast allocs before slowpath */
> +       u16 slowpath_allocs;    /* Consecutive slow allocs before watermark */
>
> How much do operations on u16 hurt on, say, x86-64? It's nice that
> sizeof(struct kmem_cache_cpu) is capped at 32 bytes but on CPUs that
> have bigger cache lines, the types could be wider.
>
> Christoph, why is struct kmem_cache_cpu not __cacheline_aligned_in_smp
> btw?

Because it is either allocated using kmalloc and aligned to a cacheline
boundary there or the kmem_cache_cpu entries come from the percpu
definition for kmem_cache_cpu. There we dont need cacheline alignment
since they are tightly packet. If the cacheline size is 64 bit then
neighboring kmem_cache_cpus fit into one cacheline which reduces cache
footprint and increased cache hotness.



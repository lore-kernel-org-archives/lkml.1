Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbZJMT4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbZJMT4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZJMT4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:56:36 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:57884 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750914AbZJMT4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:56:35 -0400
Date: Tue, 13 Oct 2009 15:48:22 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Mel Gorman <mel@csn.ul.ie>, Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
In-Reply-To: <4AD4D8B6.6010700@cs.helsinki.fi>
Message-ID: <alpine.DEB.1.10.0910131541290.7246@gentwo.org>
References: <20091007211024.442168959@gentwo.org> <20091007211053.378634196@gentwo.org> <4AD307A5.105@kernel.org> <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com> <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0910131041450.21608@gentwo.org> <alpine.DEB.1.10.0910131509170.32394@gentwo.org> <4AD4D8B6.6010700@cs.helsinki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Pekka Enberg wrote:

> I wonder how reliable these numbers are. We did similar testing a while back
> because we thought kmalloc-96 caches had weird cache behavior but finally
> figured out the anomaly was explained by the order of the tests run, not cache
> size.

Well you need to look behind these numbers to see when the allocator uses
the fastpath or slow path. Only the fast path is optimized here.

> AFAICT, we have similar artifact in these tests as well:
>
> > no this_cpu ops
> >
> > 1. Kmalloc: Repeatedly allocate then free test
> > 10000 times kmalloc(8) -> 239 cycles kfree -> 261 cycles
> > 10000 times kmalloc(16) -> 249 cycles kfree -> 208 cycles
> > 10000 times kmalloc(32) -> 215 cycles kfree -> 232 cycles
> > 10000 times kmalloc(64) -> 164 cycles kfree -> 216 cycles
>
> Notice the jump from 32 to 64 and then back to 64. One would expect we see
> linear increase as object size grows as we hit the page allocator more often,
> no?

64 is the cacheline size for the machine. At that point you have the
advantage of no overlapping data between different allocations and the
prefetcher may do a particularly good job.

> > 10000 times kmalloc(16384)/kfree -> 1002 cycles
>
> If there's 50% improvement in the kmalloc() path, why does the this_cpu()
> version seem to be roughly as fast as the mainline version?

Its not that the kmalloc() is faster. The instructions used for the
fastpath generate less cycles. Other components figure into the total
latency as well.

16k allocations for example are not handled by slub anymore. Fastpath has
no effect. The wins there is just the improved percpu handling in the page
allocator.

I have some numbers here for irqless which drops another half of the
fastpath latency (and it adds some code to the slow path, sigh):

1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 55 cycles kfree -> 251 cycles
10000 times kmalloc(16) -> 201 cycles kfree -> 261 cycles
10000 times kmalloc(32) -> 220 cycles kfree -> 261 cycles
10000 times kmalloc(64) -> 186 cycles kfree -> 224 cycles
10000 times kmalloc(128) -> 205 cycles kfree -> 125 cycles
10000 times kmalloc(256) -> 351 cycles kfree -> 267 cycles
10000 times kmalloc(512) -> 330 cycles kfree -> 310 cycles
10000 times kmalloc(1024) -> 416 cycles kfree -> 419 cycles
10000 times kmalloc(2048) -> 537 cycles kfree -> 439 cycles
10000 times kmalloc(4096) -> 458 cycles kfree -> 594 cycles
10000 times kmalloc(8192) -> 810 cycles kfree -> 678 cycles
10000 times kmalloc(16384) -> 879 cycles kfree -> 746 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 66 cycles
10000 times kmalloc(16)/kfree -> 187 cycles
10000 times kmalloc(32)/kfree -> 116 cycles
10000 times kmalloc(64)/kfree -> 107 cycles
10000 times kmalloc(128)/kfree -> 115 cycles
10000 times kmalloc(256)/kfree -> 65 cycles
10000 times kmalloc(512)/kfree -> 66 cycles
10000 times kmalloc(1024)/kfree -> 206 cycles
10000 times kmalloc(2048)/kfree -> 65 cycles
10000 times kmalloc(4096)/kfree -> 193 cycles
10000 times kmalloc(8192)/kfree -> 65 cycles
10000 times kmalloc(16384)/kfree -> 976 cycles





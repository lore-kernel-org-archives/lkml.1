Return-Path: <linux-kernel-owner+w=401wt.eu-S1761171AbZJMTpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761171AbZJMTpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761162AbZJMTpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:45:49 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51516 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761158AbZJMTps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:45:48 -0400
Message-ID: <4AD4D8B6.6010700@cs.helsinki.fi>
Date: Tue, 13 Oct 2009 22:44:54 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Mel Gorman <mel@csn.ul.ie>, Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
References: <20091007211024.442168959@gentwo.org> <20091007211053.378634196@gentwo.org> <4AD307A5.105@kernel.org> <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com> <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131041450.21608@gentwo.org> <alpine.DEB.1.10.0910131509170.32394@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910131509170.32394@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Christoph Lameter wrote:
> Here are some cycle numbers w/o the slub patches and with. I will post the
> full test results and the patches to do these in kernel tests in a new
> thread. The regression may be due to caching behavior of SLUB that will
> not change with these patches.
> 
> Alloc fastpath wins ~ 50%. kfree also has a 50% win if the fastpath is
> being used. First test does 10000 kmallocs and then frees them all.
> Second test alloc one and free one and does that 10000 times.

I wonder how reliable these numbers are. We did similar testing a while 
back because we thought kmalloc-96 caches had weird cache behavior but 
finally figured out the anomaly was explained by the order of the tests 
run, not cache size.

AFAICT, we have similar artifact in these tests as well:

> no this_cpu ops
> 
> 1. Kmalloc: Repeatedly allocate then free test
> 10000 times kmalloc(8) -> 239 cycles kfree -> 261 cycles
> 10000 times kmalloc(16) -> 249 cycles kfree -> 208 cycles
> 10000 times kmalloc(32) -> 215 cycles kfree -> 232 cycles
> 10000 times kmalloc(64) -> 164 cycles kfree -> 216 cycles

Notice the jump from 32 to 64 and then back to 64. One would expect we 
see linear increase as object size grows as we hit the page allocator 
more often, no?

> 10000 times kmalloc(128) -> 266 cycles kfree -> 275 cycles
> 10000 times kmalloc(256) -> 478 cycles kfree -> 199 cycles
> 10000 times kmalloc(512) -> 449 cycles kfree -> 201 cycles
> 10000 times kmalloc(1024) -> 484 cycles kfree -> 398 cycles
> 10000 times kmalloc(2048) -> 475 cycles kfree -> 559 cycles
> 10000 times kmalloc(4096) -> 792 cycles kfree -> 506 cycles
> 10000 times kmalloc(8192) -> 753 cycles kfree -> 679 cycles
> 10000 times kmalloc(16384) -> 968 cycles kfree -> 712 cycles
> 2. Kmalloc: alloc/free test
> 10000 times kmalloc(8)/kfree -> 292 cycles
> 10000 times kmalloc(16)/kfree -> 308 cycles
> 10000 times kmalloc(32)/kfree -> 326 cycles
> 10000 times kmalloc(64)/kfree -> 303 cycles
> 10000 times kmalloc(128)/kfree -> 257 cycles
> 10000 times kmalloc(256)/kfree -> 262 cycles
> 10000 times kmalloc(512)/kfree -> 293 cycles
> 10000 times kmalloc(1024)/kfree -> 262 cycles
> 10000 times kmalloc(2048)/kfree -> 289 cycles
> 10000 times kmalloc(4096)/kfree -> 274 cycles
> 10000 times kmalloc(8192)/kfree -> 265 cycles
> 10000 times kmalloc(16384)/kfree -> 1041 cycles
> 
> 
> with this_cpu_xx
> 
> 1. Kmalloc: Repeatedly allocate then free test
> 10000 times kmalloc(8) -> 134 cycles kfree -> 212 cycles
> 10000 times kmalloc(16) -> 109 cycles kfree -> 116 cycles

Same artifact here.

> 10000 times kmalloc(32) -> 157 cycles kfree -> 231 cycles
> 10000 times kmalloc(64) -> 168 cycles kfree -> 169 cycles
> 10000 times kmalloc(128) -> 263 cycles kfree -> 260 cycles
> 10000 times kmalloc(256) -> 430 cycles kfree -> 251 cycles
> 10000 times kmalloc(512) -> 415 cycles kfree -> 258 cycles
> 10000 times kmalloc(1024) -> 406 cycles kfree -> 432 cycles
> 10000 times kmalloc(2048) -> 457 cycles kfree -> 579 cycles
> 10000 times kmalloc(4096) -> 624 cycles kfree -> 553 cycles
> 10000 times kmalloc(8192) -> 851 cycles kfree -> 851 cycles
> 10000 times kmalloc(16384) -> 907 cycles kfree -> 722 cycles

And looking at these numbers:

> 2. Kmalloc: alloc/free test
> 10000 times kmalloc(8)/kfree -> 232 cycles
> 10000 times kmalloc(16)/kfree -> 150 cycles
> 10000 times kmalloc(32)/kfree -> 278 cycles
> 10000 times kmalloc(64)/kfree -> 263 cycles
> 10000 times kmalloc(128)/kfree -> 280 cycles
> 10000 times kmalloc(256)/kfree -> 279 cycles
> 10000 times kmalloc(512)/kfree -> 299 cycles
> 10000 times kmalloc(1024)/kfree -> 289 cycles
> 10000 times kmalloc(2048)/kfree -> 288 cycles
> 10000 times kmalloc(4096)/kfree -> 321 cycles
> 10000 times kmalloc(8192)/kfree -> 285 cycles
> 10000 times kmalloc(16384)/kfree -> 1002 cycles

If there's 50% improvement in the kmalloc() path, why does the 
this_cpu() version seem to be roughly as fast as the mainline version?

			Pekka

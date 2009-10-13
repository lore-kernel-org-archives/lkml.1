Return-Path: <linux-kernel-owner+w=401wt.eu-S1761088AbZJMTWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761088AbZJMTWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761034AbZJMTWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:22:35 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:45243 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754454AbZJMTWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:22:34 -0400
Date: Tue, 13 Oct 2009 15:14:38 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Mel Gorman <mel@csn.ul.ie>, Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
In-Reply-To: <alpine.DEB.1.10.0910131041450.21608@gentwo.org>
Message-ID: <alpine.DEB.1.10.0910131509170.32394@gentwo.org>
References: <20091007211024.442168959@gentwo.org> <20091007211053.378634196@gentwo.org> <4AD307A5.105@kernel.org> <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com> <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0910131041450.21608@gentwo.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some cycle numbers w/o the slub patches and with. I will post the
full test results and the patches to do these in kernel tests in a new
thread. The regression may be due to caching behavior of SLUB that will
not change with these patches.

Alloc fastpath wins ~ 50%. kfree also has a 50% win if the fastpath is
being used. First test does 10000 kmallocs and then frees them all.
Second test alloc one and free one and does that 10000 times.

no this_cpu ops

1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 239 cycles kfree -> 261 cycles
10000 times kmalloc(16) -> 249 cycles kfree -> 208 cycles
10000 times kmalloc(32) -> 215 cycles kfree -> 232 cycles
10000 times kmalloc(64) -> 164 cycles kfree -> 216 cycles
10000 times kmalloc(128) -> 266 cycles kfree -> 275 cycles
10000 times kmalloc(256) -> 478 cycles kfree -> 199 cycles
10000 times kmalloc(512) -> 449 cycles kfree -> 201 cycles
10000 times kmalloc(1024) -> 484 cycles kfree -> 398 cycles
10000 times kmalloc(2048) -> 475 cycles kfree -> 559 cycles
10000 times kmalloc(4096) -> 792 cycles kfree -> 506 cycles
10000 times kmalloc(8192) -> 753 cycles kfree -> 679 cycles
10000 times kmalloc(16384) -> 968 cycles kfree -> 712 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 292 cycles
10000 times kmalloc(16)/kfree -> 308 cycles
10000 times kmalloc(32)/kfree -> 326 cycles
10000 times kmalloc(64)/kfree -> 303 cycles
10000 times kmalloc(128)/kfree -> 257 cycles
10000 times kmalloc(256)/kfree -> 262 cycles
10000 times kmalloc(512)/kfree -> 293 cycles
10000 times kmalloc(1024)/kfree -> 262 cycles
10000 times kmalloc(2048)/kfree -> 289 cycles
10000 times kmalloc(4096)/kfree -> 274 cycles
10000 times kmalloc(8192)/kfree -> 265 cycles
10000 times kmalloc(16384)/kfree -> 1041 cycles


with this_cpu_xx

1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 134 cycles kfree -> 212 cycles
10000 times kmalloc(16) -> 109 cycles kfree -> 116 cycles
10000 times kmalloc(32) -> 157 cycles kfree -> 231 cycles
10000 times kmalloc(64) -> 168 cycles kfree -> 169 cycles
10000 times kmalloc(128) -> 263 cycles kfree -> 260 cycles
10000 times kmalloc(256) -> 430 cycles kfree -> 251 cycles
10000 times kmalloc(512) -> 415 cycles kfree -> 258 cycles
10000 times kmalloc(1024) -> 406 cycles kfree -> 432 cycles
10000 times kmalloc(2048) -> 457 cycles kfree -> 579 cycles
10000 times kmalloc(4096) -> 624 cycles kfree -> 553 cycles
10000 times kmalloc(8192) -> 851 cycles kfree -> 851 cycles
10000 times kmalloc(16384) -> 907 cycles kfree -> 722 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 232 cycles
10000 times kmalloc(16)/kfree -> 150 cycles
10000 times kmalloc(32)/kfree -> 278 cycles
10000 times kmalloc(64)/kfree -> 263 cycles
10000 times kmalloc(128)/kfree -> 280 cycles
10000 times kmalloc(256)/kfree -> 279 cycles
10000 times kmalloc(512)/kfree -> 299 cycles
10000 times kmalloc(1024)/kfree -> 289 cycles
10000 times kmalloc(2048)/kfree -> 288 cycles
10000 times kmalloc(4096)/kfree -> 321 cycles
10000 times kmalloc(8192)/kfree -> 285 cycles
10000 times kmalloc(16384)/kfree -> 1002 cycles


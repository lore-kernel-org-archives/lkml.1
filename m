Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYGaP1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYGaP1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYGaP1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:27:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630AbYGaP1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:27:31 -0400
Message-ID: <4891D979.6090802@linux-foundation.org>
Date: Thu, 31 Jul 2008 10:25:45 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Matt Mackall <mpm@selenic.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       vegard.nossum@gmail.com, hannes@saeurebad.de
Subject: Re: [RFC PATCH] greatly reduce SLOB external fragmentation
References: <Pine.LNX.4.64.0801072005380.23932@sbz-30.cs.Helsinki.FI> <1199906151.6245.57.camel@cinder.waste.org> <Pine.LNX.4.64.0801100037230.3071@sbz-30.cs.Helsinki.FI> <1199919548.6245.74.camel@cinder.waste.org> <Pine.LNX.4.64.0801101156150.10271@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0801101251200.14402@sbz-30.cs.Helsinki.FI> <alpine.LFD.1.00.0801100749000.3148@woody.linux-foundation.org> <Pine.LNX.4.64.0807310045020.22702@sbz-30.cs.Helsinki.FI> <alpine.LFD.1.10.0807301457020.3277@nehalem.linux-foundation.org> <1217466583.18911.226.camel@calx> <20080731141134.GP23938@one.firstfloor.org>
In-Reply-To: <20080731141134.GP23938@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Finally getting rid of SLAB is a much trickier proposition because SLUB
>> still loses in a few important corner cases.
> 
> The big issue is that we haven't really made much progress on at least
> some of these test cases (like the database benchmarks) for quite some
> time (and that wasn't for a lack of trying) :-/ Might be a fundamental
> problem.

It would be good to have more of these benchmark regressions than just TPC which requires a database setup etc etc. Preferably something that is easily runnable by everyone.

There is a fundamental difference in how frees are handled. Slub is queueless so it must use an atomic operation on the page struct of the slab that we free to (in the case that the freeing does not occur to the current cpu slab) to serialize access.

SLAB can avoid that by just stuffing the pointer to the object to be freed into a per cpu queue. Then later the queue is processed and the objects are merged into the slabs. But the later workqueue processing then causes run time variabilities which impact network performance and cause latencies. And the queuing only works in the SMP case. In the NUMA case we need to first check the locality of the object and then stuff it into alien queues (if its not local node). Then we need to expire the alien queues at some point. We have these alien queues per node which means they require locks and we have NODES * CPUS of them.




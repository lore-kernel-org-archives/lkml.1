Return-Path: <linux-kernel-owner+w=401wt.eu-S934766AbZJNPy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934766AbZJNPy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934731AbZJNPyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:54:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49827 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934737AbZJNPyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:54:24 -0400
Message-ID: <4AD5F3F8.8080603@cs.helsinki.fi>
Date: Wed, 14 Oct 2009 18:53:28 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
References: <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131041450.21608@gentwo.org> <alpine.DEB.1.10.0910131509170.32394@gentwo.org> <4AD4D8B6.6010700@cs.helsinki.fi> <alpine.DEB.1.10.0910131541290.7246@gentwo.org> <alpine.DEB.1.00.0910131305440.3529@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131625370.13756@gentwo.org> <alpine.DEB.1.00.0910131550050.15347@chino.kir.corp.google.com> <20091014133457.GB5027@csn.ul.ie> <alpine.DEB.1.10.0910141003590.9944@gentwo.org> <20091014154944.GD5027@csn.ul.ie>
In-Reply-To: <20091014154944.GD5027@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

Mel Gorman wrote:
>>> The patches mostly improve the performance of netperf UDP_STREAM by a good
>>> whack so the patches are a plus here. However, it should also be noted that
>>> SLAB was mostly faster than SLUB, particularly for large packet sizes. Refresh
>>> my memory, how do SLUB and SLAB differ in regards to off-loading large
>>> allocations to the page allocator these days?
>> SLUB offloads allocations > 8k to the page allocator.
>> SLAB does create large slabs.
>>
> 
> Allocations >8k might explain then why 8K and 16K packets for UDP_STREAM
> performance suffers. That can be marked as future possible work to sort
> out within the allocator.
> 
> However, does it explain why TCP_STREAM suffers so badly even for packet
> sizes like 2K? It's also important to note in some cases, SLAB was far
> slower even when the packet sizes were greater than 8k so I don't think
> the page allocator is an adequate explanation for TCP_STREAM.

SLAB is able to queue lots of large objects but SLUB can't do that 
because it has no queues. In SLUB, each CPU gets a page assigned to it 
that serves as a "queue" but the size of the queue gets smaller as 
object size approaches page size.

We try to offset that with higher order allocations but IIRC we don't 
increase the order linearly with object size and cap it to some 
reasonable maximum.

			Pekka

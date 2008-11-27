Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYK0Op5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYK0Op5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYK0Opp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:45:45 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:49928 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbYK0Opo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:45:44 -0500
Date: Thu, 27 Nov 2008 08:44:41 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/6] fs: Scalability of sockets/pipes allocation/deallocation
 on SMP
In-Reply-To: <492E3DEF.8030602@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0811270838320.13647@quilx.com>
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <20081121083044.GL16242@elte.hu>
 <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net>
 <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com>
 <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com>
 <20081121153453.GA23713@elte.hu> <492DDB6A.8090806@cosmosbay.com>
 <Pine.LNX.4.64.0811261935330.31159@quilx.com> <492E3DEF.8030602@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, Eric Dumazet wrote:

> with slub_min_objects=45 :
>
> # cat /sys/kernel/slab/filp/order
> 2
> # time ./socket8
> real    0m1.652s
> user    0m0.694s
> sys     0m12.367s

That may be a good value. How many processor do you have? Look at
calculate_order() in mm/slub.c:

   if (!min_objects)
                min_objects = 4 * (fls(nr_cpu_ids) + 1);

We couild increase the scaling factor there or start
with a mininum of 20 objects?


Try

	min_objects = 20 + 4 * (fls(nr_cpu_ids) + 1);

> I would say slub_min_objects=45 is the optimal value on 32bit arches to
> get acceptable performance on this workload (order=2 for filp kmem_cache)
>
> Note : SLAB here is disastrous, but you already knew that :)

Its good though to have examples where the queue management gets in the
way of performance.

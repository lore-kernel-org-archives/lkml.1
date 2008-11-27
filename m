Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbYK0G2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbYK0G2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 01:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYK0G2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 01:28:35 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:38923 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYK0G2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 01:28:34 -0500
Message-ID: <492E3DEF.8030602@cosmosbay.com>
Date: Thu, 27 Nov 2008 07:27:59 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] fs: Scalability of sockets/pipes allocation/deallocation
 on SMP
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net> <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com> <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com> <20081121153453.GA23713@elte.hu> <492DDB6A.8090806@cosmosbay.com> <Pine.LNX.4.64.0811261935330.31159@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0811261935330.31159@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 27 Nov 2008 07:28:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> On Thu, 27 Nov 2008, Eric Dumazet wrote:
> 
>> The last point is about SLUB being hit hard, unless we
>> use slub_min_order=3 at boot, or we use Christoph Lameter
>> patch (struct file RCU optimizations)
>> http://thread.gmane.org/gmane.linux.kernel/418615
>>
>> If we boot machine with slub_min_order=3, SLUB overhead disappears.
> 
> 
> I'd rather not be that drastic. Did you try increasing slub_min_objects
> instead? Try 40-100. If we find the right number then we should update
> the tuning to make sure that it pickes the right slab page sizes.
> 
> 

4096/192 = 21

with slub_min_objects=22 :

# cat /sys/kernel/slab/filp/order
1
# time ./socket8
real    0m1.725s
user    0m0.685s
sys     0m12.955s

with slub_min_objects=45 :

# cat /sys/kernel/slab/filp/order
2
# time ./socket8
real    0m1.652s
user    0m0.694s
sys     0m12.367s

with slub_min_objects=80 :

# cat /sys/kernel/slab/filp/order
3
# time ./socket8
real    0m1.642s
user    0m0.719s
sys     0m12.315s

I would say slub_min_objects=45 is the optimal value on 32bit arches to
get acceptable performance on this workload (order=2 for filp kmem_cache)

Note : SLAB here is disastrous, but you already knew that :)

real    0m8.128s
user    0m0.748s
sys     1m3.467s


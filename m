Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbYKPGJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbYKPGJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 01:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbYKPGJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 01:09:49 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:57271 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbYKPGJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 01:09:49 -0500
Message-ID: <491FB8E5.50806@cosmosbay.com>
Date: Sun, 16 Nov 2008 07:08:37 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "David S. Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
References: <491FA28B.2070003@cn.fujitsu.com>	<20081115205229.765f7ee3@infradead.org>	<20081115210334.3870cdf6.akpm@linux-foundation.org>	<491FB107.6050703@cn.fujitsu.com> <20081115215309.7f29c33c@infradead.org>
In-Reply-To: <20081115215309.7f29c33c@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 16 Nov 2008 07:08:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven a écrit :
> On Sun, 16 Nov 2008 13:35:03 +0800
> Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
>> vmalloc() is not good for performance and increasing fragment.
>> but vmalloc() is need for some subsystems' alternative malloc,
>> like cgroup's tasks file and other subsystems(about 20 subsystems).
> 
> actually what you are pointing out is that these areas need improvement
> to not need such huge blocks of memory... but only a series of smaller
> blocks instead.
> 


Just zap vmalloc()/vfree() then ?

More seriously, vmalloc()/vfree() were designed partly to make people life easier,
not to be *the* premium interface to manage kernel memory

Some parts of the kernel cannot afford the cost of vmalloc()/vfree(), so people
must think and design complex algos.

I personnaly like this cleanup too. For example bnx2 driver actually uses vmalloc() while
a kmalloc() should be OK for bnx2_alloc_rx_mem()

# grep bnx2 /proc/vmallocinfo
0xf8260000-0xf8274000   81920 bnx2_init_board+0x104/0xae0 phys=f6000000 ioremap
0xf8280000-0xf8294000   81920 bnx2_init_board+0x104/0xae0 phys=fa000000 ioremap
0xf82c1000-0xf82c3000    8192 bnx2_alloc_rx_mem+0x33/0x310 pages=1 vmalloc
0xf82d9000-0xf82db000    8192 bnx2_alloc_rx_mem+0x33/0x310 pages=1 vmalloc

I have two comments :

1) Names should be not "simple" : That is misleading. "convenient" maybe, or "slow"...

2) Since vmalloc()/vfree() is potentially a very expensive operation, we should make
   slow_malloc()/slow_free() or whatever name is chosen, uninlined. No need to try to save
   3 or 4 cpu cycles. This will save icache at least.



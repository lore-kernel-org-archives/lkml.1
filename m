Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbYFLNkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbYFLNkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbYFLNkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:40:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbYFLNkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:40:42 -0400
Date: Thu, 12 Jun 2008 09:38:33 -0400
From: Rik van Riel <riel@redhat.com>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Message-ID: <20080612093833.0fb9cdd6@bree.surriel.com>
In-Reply-To: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 12:07:34 +0200
"Zdenek Kabelac" <zdenek.kabelac@gmail.com> wrote:

> It looks like while there was a huge amount of buffers and caches -
> system was unable to allocate few pages for kmalloc in iwl3945 driver
> after resume.

It looks like this is because it wants to allocate 2**5 contiguous
pages, which is 128kB of contiguous kernel memory.
 
> <4>[53906.578855] NetworkManager: page allocation failure. order:5, mode:0x1024
> <4>[53906.578855] Pid: 2645, comm: NetworkManager Tainted: G        W
> 2.6.26-rc5 #33
> <4>[53906.578855]
> <4>[53906.578855] Call Trace:
> <4>[53906.578855]  [<ffffffff81092c70>] __alloc_pages_internal+0x460/0x590
> <4>[53906.578855]  [<ffffffffa01a87f8>] ?
> :iwl3945:iwl3945_hw_tx_queue_init+0x38/0x1a0
> <4>[53906.578855]  [<ffffffff81092dbb>] __alloc_pages+0xb/0x10
> <4>[53906.578855]  [<ffffffff81011c26>] dma_alloc_pages+0x26/0x30
> <4>[53906.578855]  [<ffffffff81011cf3>] dma_alloc_coherent+0xc3/0x2a0
> <4>[53906.578855]  [<ffffffffa01a73c3>]
> :iwl3945:iwl3945_tx_queue_init+0x63/0x1e0
> <4>[53906.578855]  [<ffffffffa01aa06e>] :iwl3945:iwl3945_hw_nic_init+0x8de/0x940
> <4>[53906.578855]  [<ffffffffa019de01>] :iwl3945:__iwl3945_up+0x91/0x640
> <4>[53906.578855]  [<ffffffffa019e968>] :iwl3945:iwl3945_mac_start+0x568/0x790
> <4>[53906.578855]  [<ffffffff8128a67d>] ? __nla_put+0x2d/0x40
> <4>[53906.578855]  [<ffffffff8128a633>] ? __nla_reserve+0x53/0x70
> <4>[53906.578855]  [<ffffffff8128a67d>] ? __nla_put+0x2d/0x40
> <4>[53906.578855]  [<ffffffffa0166def>] :mac80211:ieee80211_open+0x13f/0x590
> <4>[53906.578855]  [<ffffffff81273b48>] ? dev_set_rx_mode+0x48/0x60
> <4>[53906.578855]  [<ffffffff81275b99>] dev_open+0x89/0xf0
> <4>[53906.578855]  [<ffffffff812753c1>] dev_change_flags+0xa1/0x1e0
> <4>[53906.578855]  [<ffffffff812730b9>] ? dev_get_by_index+0x19/0x80
> <4>[53906.578855]  [<ffffffff8127e59c>] do_setlink+0x20c/0x3a0
> <4>[53906.578855]  [<ffffffff812f5cc0>] ? _read_unlock+0x30/0x60
> <4>[53906.578855]  [<ffffffff8127e83d>] rtnl_setlink+0x10d/0x150
> <4>[53906.578855]  [<ffffffff8127fa2d>] rtnetlink_rcv_msg+0x18d/0x240
> <4>[53906.578855]  [<ffffffff8127f8a0>] ? rtnetlink_rcv_msg+0x0/0x240
> <4>[53906.578855]  [<ffffffff8128a3e9>] netlink_rcv_skb+0x89/0xb0
> <4>[53906.578855]  [<ffffffff8127f889>] rtnetlink_rcv+0x29/0x40
> <4>[53906.578855]  [<ffffffff81289e05>] netlink_unicast+0x2d5/0x2f0
> <4>[53906.578855]  [<ffffffff8126e38e>] ? __alloc_skb+0x6e/0x150
> <4>[53906.578855]  [<ffffffff8128a024>] netlink_sendmsg+0x204/0x300
> <4>[53906.578855]  [<ffffffff812f5cc0>] ? _read_unlock+0x30/0x60
> <4>[53906.578855]  [<ffffffff81265ca7>] sock_sendmsg+0x127/0x140
> <4>[53906.578855]  [<ffffffff81265b09>] ? sock_recvmsg+0x139/0x150
> <4>[53906.578855]  [<ffffffff810529d0>] ? autoremove_wake_function+0x0/0x40
> <4>[53906.578855]  [<ffffffff812f5e70>] ? _spin_unlock+0x30/0x60
> <4>[53906.578855]  [<ffffffff8117bb4a>] ? __up_read+0x2a/0xb0
> <4>[53906.578855]  [<ffffffff81266a47>] ? move_addr_to_kernel+0x57/0x60
> <4>[53906.578855]  [<ffffffff8126f39c>] ? verify_iovec+0x3c/0xd0
> <4>[53906.578855]  [<ffffffff81265e49>] sys_sendmsg+0x189/0x320
> <4>[53906.578855]  [<ffffffff81266b4d>] ? sys_sendto+0xfd/0x120
> <4>[53906.578855]  [<ffffffff812f5759>] ? trace_hardirqs_on_thunk+0x35/0x3a
> <4>[53906.578855]  [<ffffffff8100c50b>] system_call_after_swapgs+0x7b/0x80
> <4>[53906.578855]
> <6>[53906.578855] Mem-info:
> <4>[53906.578855] DMA per-cpu:
> <4>[53906.578855] CPU    0: hi:    0, btch:   1 usd:   0
> <4>[53906.578855] CPU    1: hi:    0, btch:   1 usd:   0
> <4>[53906.578855] DMA32 per-cpu:
> <4>[53906.578855] CPU    0: hi:  186, btch:  31 usd:   0
> <4>[53906.578855] CPU    1: hi:  186, btch:  31 usd:   0
> <4>[53906.578855] Active:231839 inactive:178871 dirty:65 writeback:0 unstable:0
> <4>[53906.578855]  free:5997 slab:45072 mapped:27835 pagetables:7405 bounce:0
> <4>[53906.578855] DMA free:7896kB min:40kB low:48kB high:60kB
> active:308kB inactive:0kB present:15176kB pages_scanned:0
> all_unreclaimable? no
> <4>[53906.578855] lowmem_reserve[]: 0 1959 1959 1959
> <4>[53906.578855] DMA32 free:16092kB min:5640kB low:7048kB high:8460kB
> active:927048kB inactive:715484kB present:2006684kB pages_scanned:0
> all_unreclaimable? no
> <4>[53906.578855] lowmem_reserve[]: 0 0 0 0
> <4>[53906.578855] DMA: 86*4kB 112*8kB 148*16kB 38*32kB 0*64kB 0*128kB
> 0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 7896kB
> <4>[53906.578855] DMA32: 2690*4kB 369*8kB 56*16kB 30*32kB 6*64kB
> 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 16080kB

As you can see, the 128kB free areas have been pretty much exhausted
and there is still a good amount of free memory.

I am not sure why this last 128kB area was not allocated, but lets
face it - it would have blown up the next allocation anyway.

Doing such a large allocation from a driver is probably not the best
idea.

-- 
All rights reversed.

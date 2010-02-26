Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965470Ab0BZRR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:17:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:42175 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965440Ab0BZRR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:17:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=d0gIfOJJL5NIuqD9mhvJzKJPsSQZKn1pORTdkVAACbYX7LuKdORSbXscvb+CAIWfdN
         f9nFm/nuid2Vms+ExkMZVl9MxvQnthXkmSctLl8Z10xXsXUSty1rkWb4jCroCPSID0og
         jdqk8Y3dO9NHkEePd3mphIUlesHn/XwomT/aY=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1002261042020.7719@router.home>
References: <201002261232.28686.elendil@planet.nl>
	 <84144f021002260601o7ab345fer86b8bec12dbfc31e@mail.gmail.com>
	 <201002261633.17437.elendil@planet.nl>
	 <alpine.DEB.2.00.1002261042020.7719@router.home>
Date: Fri, 26 Feb 2010 19:17:55 +0200
X-Google-Sender-Auth: 5fd859d6888c783d
Message-ID: <84144f021002260917q61f7c255rf994425f3a613819@mail.gmail.com>
Subject: Re: Memory management woes - order 1 allocation failures
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@skynet.ie>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 6:43 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Fri, 26 Feb 2010, Frans Pop wrote:
>
>> On Friday 26 February 2010, Pekka Enberg wrote:
>> > > Isn't it a bit strange that cache claims so much memory that real
>> > > processes get into allocation failures?
>> >
>> > All of the failed allocations seem to be GFP_ATOMIC so it's not _that_
>> > strange.
>>
>> It's still very ugly though. And I would say it should be unnecessary.
>>
>> > Dunno if anything changed recently. What's the last known good kernel for
>> > you?
>>
>> I've not used that box very intensively in the past, but I first saw the
>> allocation failure with aptitude with either .31 or .32. I would be
>> extremely surprised if I could reproduce the problem with .30.
>> And I have done large rsyncs to the box without any problems in the past,
>> but that must have been with .24 or so kernels.
>>
>> It seems likely to me that it's related to all the other swap and
>> allocation issues we've been seeing after .30.
>
> Hmmm.. How long is the allocation that fails? SLUB can always fall back to
> order 0 allocs if the object is < PAGE_SIZE. SLAB cannot do so if it has
> decided to use a higher order slab cache for a kmalloc cache.

This is CONFIG_SLAB=y, actually. There are two different call-sites. The first
one is tty_buffer_request_room():

> aptitude: page allocation failure. order:1, mode:0x20
> [<c0029bcc>] (unwind_backtrace+0x0/0xd4) from [<c007ca18>] (__alloc_pages_nodemask+0x4ac/0x510)
> [<c007ca18>] (__alloc_pages_nodemask+0x4ac/0x510) from [<c0099f84>] (cache_alloc_refill+0x260/0x52c)
> [<c0099f84>] (cache_alloc_refill+0x260/0x52c) from [<c009a2e0>] (__kmalloc+0x90/0xd4)
> [<c009a2e0>] (__kmalloc+0x90/0xd4) from [<c0165640>] (tty_buffer_request_room+0x88/0x128)
> [<c0165640>] (tty_buffer_request_room+0x88/0x128) from [<c0165838>] (tty_insert_flip_string+0x24/0x84)
> [<c0165838>] (tty_insert_flip_string+0x24/0x84) from [<c016652c>] (pty_write+0x30/0x50)
> [<c016652c>] (pty_write+0x30/0x50) from [<c0161d84>] (n_tty_write+0x234/0x394)
> [<c0161d84>] (n_tty_write+0x234/0x394) from [<c015f594>] (tty_write+0x190/0x234)
> [<c015f594>] (tty_write+0x190/0x234) from [<c009d9e0>] (vfs_write+0xb0/0x1a4)
> [<c009d9e0>] (vfs_write+0xb0/0x1a4) from [<c009dfa8>] (sys_write+0x3c/0x68)
> [<c009dfa8>] (sys_write+0x3c/0x68) from [<c0023e00>] (ret_fast_syscall+0x0/0x28)
> Mem-info:
> Normal per-cpu:
> CPU    0: hi:   42, btch:   7 usd:  29
> active_anon:2455 inactive_anon:2471 isolated_anon:0
>  active_file:16088 inactive_file:7021 isolated_file:0
>  unevictable:0 dirty:14 writeback:0 unstable:0
>  free:555 slab_reclaimable:1371 slab_unreclaimable:746
>  mapped:4960 shmem:40 pagetables:102 bounce:0
> Normal free:2220kB min:1440kB low:1800kB high:2160kB active_anon:9820kB inactive_anon:9884kB active_file:64352kB inactive_file:28084kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:130048kB mlocked:0kB dirty:56kB writeback:0kB mapped:19840kB shmem:160kB slab_reclaimable:5484kB slab_unreclaimable:2984kB kernel_stack:520kB pagetables:408kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 0
> Normal: 493*4kB 25*8kB 3*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2220kB
> 23343 total pagecache pages
> 192 pages in swap cache
> Total swap = 979924kB
> 32768 pages of RAM
> 709 free pages
> 1173 reserved pages
> 2117 slab pages
> 13703 pages shared
> 192 pages swap cached

and the second one is sk_prot_alloc():

> sshd: page allocation failure. order:1, mode:0x20
> [<c0029bcc>] (unwind_backtrace+0x0/0xd4) from [<c007ca18>] (__alloc_pages_nodemask+0x4ac/0x510)
> [<c007ca18>] (__alloc_pages_nodemask+0x4ac/0x510) from [<c0099f84>] (cache_alloc_refill+0x260/0x52c)
> [<c0099f84>] (cache_alloc_refill+0x260/0x52c) from [<c009a378>] (kmem_cache_alloc+0x54/0x94)
> [<c009a378>] (kmem_cache_alloc+0x54/0x94) from [<c01db500>] (sk_prot_alloc+0x28/0xfc)
> [<c01db500>] (sk_prot_alloc+0x28/0xfc) from [<c01dbb88>] (sk_clone+0x18/0x1e0)
> [<c01dbb88>] (sk_clone+0x18/0x1e0) from [<c0211608>] (inet_csk_clone+0x14/0x9c)
> [<c0211608>] (inet_csk_clone+0x14/0x9c) from [<c02258b4>] (tcp_create_openreq_child+0x1c/0x3b0)
> [<c02258b4>] (tcp_create_openreq_child+0x1c/0x3b0) from [<c0223df0>] (tcp_v4_syn_recv_sock+0x4c/0x17c)
> [<c0223df0>] (tcp_v4_syn_recv_sock+0x4c/0x17c) from [<c0225738>] (tcp_check_req+0x288/0x3e8)
> [<c0225738>] (tcp_check_req+0x288/0x3e8) from [<c02232a0>] (tcp_v4_do_rcv+0xa4/0x1c4)
> [<c02232a0>] (tcp_v4_do_rcv+0xa4/0x1c4) from [<c0225138>] (tcp_v4_rcv+0x4cc/0x788)
> [<c0225138>] (tcp_v4_rcv+0x4cc/0x788) from [<c0208308>] (ip_local_deliver_finish+0x158/0x220)
> [<c0208308>] (ip_local_deliver_finish+0x158/0x220) from [<c020818c>] (ip_rcv_finish+0x380/0x3a4)
> [<c020818c>] (ip_rcv_finish+0x380/0x3a4) from [<c01e6914>] (netif_receive_skb+0x494/0x4e4)
> [<c01e6914>] (netif_receive_skb+0x494/0x4e4) from [<bf022e78>] (mv643xx_eth_poll+0x458/0x5d0 [mv643xx_eth])
> [<bf022e78>] (mv643xx_eth_poll+0x458/0x5d0 [mv643xx_eth]) from [<c01e963c>] (net_rx_action+0x78/0x184)
> [<c01e963c>] (net_rx_action+0x78/0x184) from [<c0044258>] (__do_softirq+0x78/0x10c)
> [<c0044258>] (__do_softirq+0x78/0x10c) from [<c0023074>] (asm_do_IRQ+0x74/0x94)
> [<c0023074>] (asm_do_IRQ+0x74/0x94) from [<c0023c20>] (__irq_usr+0x40/0x80)
> Exception stack(0xc22ebfb0 to 0xc22ebff8)
> bfa0:                                     0b08609e 2a07f1b8 3ea285e7 4016a094
> bfc0: f141ed11 4016a30c d81533a7 4016a30c 4016a258 4016a430 00000011 6dc729a1
> bfe0: 71a5db23 bee60c88 400cc1dc 400cbe38 20000010 ffffffff
> Mem-info:
> Normal per-cpu:
> CPU    0: hi:   42, btch:   7 usd:  18
> active_anon:2646 inactive_anon:3510 isolated_anon:0
>  active_file:4422 inactive_file:17658 isolated_file:0
>  unevictable:0 dirty:700 writeback:0 unstable:0
>  free:496 slab_reclaimable:962 slab_unreclaimable:895
>  mapped:1512 shmem:11 pagetables:138 bounce:0
> Normal free:1984kB min:1440kB low:1800kB high:2160kB active_anon:10584kB inactive_anon:14040kB active_file:17688kB inactive_file:70632kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:130048kB mlocked:0kB dirty:2800kB writeback:0kB mapped:6048kB shmem:44kB slab_reclaimable:3848kB slab_unreclaimable:3580kB kernel_stack:552kB pagetables:552kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 0
> Normal: 462*4kB 3*8kB 5*16kB 1*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1984kB
> 23048 total pagecache pages
> 956 pages in swap cache
> Swap cache stats: add 6902, delete 5946, find 190630/191220
> Free swap  = 974116kB
> Total swap = 979924kB
> 32768 pages of RAM
> 660 free pages
> 1173 reserved pages
> 1857 slab pages
> 23999 pages shared
> 956 pages swap cached

AFAICT, even in the worst case, the latter call-site is well below 4K.
I have no idea of the tty one.

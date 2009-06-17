Return-Path: <linux-kernel-owner+w=401wt.eu-S1761237AbZFQURR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237AbZFQURR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZFQURD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:17:03 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:38811 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbZFQURC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:17:02 -0400
Message-ID: <4A394F27.8060308@gmail.com>
Date: Wed, 17 Jun 2009 22:16:39 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: "David S. Miller" <davem@davemloft.net>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
References: <alpine.DEB.2.00.0906161203160.27742@p34.internal.lan> <alpine.DEB.2.00.0906161205260.27742@p34.internal.lan> <alpine.DEB.2.00.0906171227040.1089@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0906171227040.1089@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 17 Jun 2009 22:16:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes a écrit :
> On Tue, 16 Jun 2009, Justin Piszcz wrote:
> 
>> [6042655.794633] nfsd: page allocation failure. order:0, mode:0x20
> 
> That's a GFP_ATOMIC allocation.
> 
>> [6042655.794637] Pid: 7093, comm: nfsd Not tainted 2.6.29.1 #4
>> [6042655.794638] Call Trace:
>> [6042655.794640]  <IRQ>  [<ffffffff802850fd>] __alloc_pages_internal+0x3dd/0x4e0
>> [6042655.794649]  [<ffffffff802a738b>] cache_alloc_refill+0x2fb/0x570
>> [6042655.794652]  [<ffffffff802a7085>] kmem_cache_alloc+0x95/0xa0
> 
> Attempting to allocate new slab with GFP_ATOMIC, so no reclaim is 
> possible.
> 
>> [6042655.794655]  [<ffffffff8059a969>] __alloc_skb+0x49/0x150
>> [6042655.794658]  [<ffffffff805dee06>] tcp_send_ack+0x26/0x120
> 
> If alloc_skb() cannot allocate a new skbuff_head_cache buffer atomically, 
> tcp_send_ack() easily recovers, so perhaps this should be annotated with 
> __GFP_NOWARN (as in the following patch).
> 
>> [6042655.794660]  [<ffffffff805dcbd2>] tcp_rcv_established+0x7a2/0x920
>> [6042655.794663]  [<ffffffff805e417d>] tcp_v4_do_rcv+0xdd/0x210
>> [6042655.794665]  [<ffffffff805e4926>] tcp_v4_rcv+0x676/0x710
>> [6042655.794668]  [<ffffffff805c6a5c>] ip_local_deliver_finish+0x8c/0x160
>> [6042655.794670]  [<ffffffff805c6551>] ip_rcv_finish+0x191/0x330
>> [6042655.794672]  [<ffffffff805c6936>] ip_rcv+0x246/0x2e0
>> [6042655.794676]  [<ffffffff804d8e74>] e1000_clean_rx_irq+0x114/0x3a0
>> [6042655.794678]  [<ffffffff804dad70>] e1000_clean+0x180/0x2d0
>> [6042655.794681]  [<ffffffff8059f5a7>] net_rx_action+0x87/0x130
>> [6042655.794683]  [<ffffffff80259cd3>] __do_softirq+0x93/0x160
>> [6042655.794687]  [<ffffffff8022c9fc>] call_softirq+0x1c/0x30
>> [6042655.794689]  [<ffffffff8022e455>] do_softirq+0x35/0x80
>> [6042655.794691]  [<ffffffff8022e523>] do_IRQ+0x83/0x110
>> [6042655.794693]  [<ffffffff8022c2d3>] ret_from_intr+0x0/0xa
>> [6042655.794694]  <EOI>  [<ffffffff80632190>] _spin_lock+0x10/0x20
>> [6042655.794700]  [<ffffffff802bb2fc>] d_find_alias+0x1c/0x40
>> [6042655.794703]  [<ffffffff802bd96d>] d_obtain_alias+0x4d/0x140
>> [6042655.794706]  [<ffffffff8033ffd3>] exportfs_decode_fh+0x63/0x2a0
>> [6042655.794708]  [<ffffffff80343970>] nfsd_acceptable+0x0/0x110
>> [6042655.794711]  [<ffffffff8061e74a>] cache_check+0x4a/0x4d0
>> [6042655.794714]  [<ffffffff80349437>] exp_find_key+0x57/0xe0
>> [6042655.794717]  [<ffffffff80592a35>] sock_recvmsg+0xd5/0x110
>> [6042655.794719]  [<ffffffff80349552>] exp_find+0x92/0xa0
>> [6042655.794721]  [<ffffffff80343e59>] fh_verify+0x369/0x680
>> [6042655.794724]  [<ffffffff8024add9>] check_preempt_wakeup+0xf9/0x120
>> [6042655.794726]  [<ffffffff803460be>] nfsd_open+0x2e/0x180
>> [6042655.794728]  [<ffffffff80346574>] nfsd_write+0xc4/0x120
>> [6042655.794730]  [<ffffffff8034dac0>] nfsd3_proc_write+0xb0/0x150
>> [6042655.794732]  [<ffffffff8034040a>] nfsd_dispatch+0xba/0x270
>> [6042655.794736]  [<ffffffff80615a1e>] svc_process+0x49e/0x800
>> [6042655.794738]  [<ffffffff8024dc80>] default_wake_function+0x0/0x10
>> [6042655.794740]  [<ffffffff80631fd7>] __down_read+0x17/0xae
>> [6042655.794742]  [<ffffffff80340b79>] nfsd+0x199/0x2b0
>> [6042655.794743]  [<ffffffff803409e0>] nfsd+0x0/0x2b0
>> [6042655.794747]  [<ffffffff802691d7>] kthread+0x47/0x90
>> [6042655.794749]  [<ffffffff8022c8fa>] child_rip+0xa/0x20
>> [6042655.794751]  [<ffffffff80269190>] kthread+0x0/0x90
>> [6042655.794753]  [<ffffffff8022c8f0>] child_rip+0x0/0x20
>> [6042655.794754] Mem-Info:
> ...
>> [6042655.794776] Active_anon:108072 active_file:103321 inactive_anon:31621
>> [6042655.794777]  inactive_file:984722 unevictable:0 dirty:71104 writeback:0
>> unstable:0
>> [6042655.794778]  free:8659 slab:746182 mapped:8842 pagetables:5374 bounce:0
>> [6042655.794780] DMA free:9736kB min:16kB low:20kB high:24kB active_anon:0kB
>> inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
>> present:8744kB pages_scanned:0 all_unreclaimable? yes
>> [6042655.794783] lowmem_reserve[]: 0 3246 7980 7980
> 
> ZONE_DMA is inaccessible because of lowmem_reserve, assuming you have 4K 
> pages: 9736K free < (16K min + (7980 pages * 4K /page)).
> 
>> [6042655.794787] DMA32 free:21420kB min:6656kB low:8320kB high:9984kB
>> active_anon:52420kB inactive_anon:38552kB active_file:146252kB
>> inactive_file:1651512kB unevictable:0kB present:3324312kB pages_scanned:0
>> all_unreclaimable? no
>> [6042655.794789] lowmem_reserve[]: 0 0 4734 4734
> 
> Likewise for ZONE_DMA32: 21420K free < (6656K min + (4734 pages * 
> 4K/page)).
> 
>> [6042655.794793] Normal free:3480kB min:9708kB low:12132kB high:14560kB
>> active_anon:379868kB inactive_anon:87932kB active_file:267032kB
>> inactive_file:2287376kB unevictable:0kB present:4848000kB pages_scanned:0
>> all_unreclaimable? no
>> [6042655.794795] lowmem_reserve[]: 0 0 0 0
> 
> And ZONE_NORMAL is oom: 3480K free < 9708K min.
> 
> 
> ipv4: don't warn about skb ack allocation failures
> 
> tcp_send_ack() will recover from alloc_skb() allocation failures, so avoid 
> emitting warnings.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2442,7 +2442,7 @@ void tcp_send_ack(struct sock *sk)
>  	 * tcp_transmit_skb() will set the ownership to this
>  	 * sock.
>  	 */
> -	buff = alloc_skb(MAX_TCP_HEADER, GFP_ATOMIC);
> +	buff = alloc_skb(MAX_TCP_HEADER, GFP_ATOMIC | __GFP_NOWARN);
>  	if (buff == NULL) {
>  		inet_csk_schedule_ack(sk);
>  		inet_csk(sk)->icsk_ack.ato = TCP_ATO_MIN;

I count more than 800 GFP_ATOMIC allocations in net/ tree.

Most (if not all) of them can recover in case of failures.

Should we add __GFP_NOWARN to all of them ?

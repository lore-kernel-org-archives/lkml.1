Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbZFJOmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbZFJOmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 10:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757114AbZFJOmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 10:42:02 -0400
Received: from fmailhost04.isp.att.net ([204.127.217.104]:63478 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641AbZFJOlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 10:41:55 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A2FC62C.6030407@lwfinger.net>
Date: Wed, 10 Jun 2009 09:41:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, npiggin@suse.de
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>	 <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>	 <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>	 <4A2BCC6F.8090004@redhat.com>	 <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>	 <20090608101739.GA15377@csn.ul.ie>	 <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>	 <20090608110303.GD15377@csn.ul.ie>	 <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>	 <20090608141212.GE15070@csn.ul.ie> <1244531201.5024.3.camel@penberg-laptop>	 <alpine.DEB.2.00.0906090046000.28701@chino.kir.corp.google.com>	 <1244534315.5024.34.camel@penberg-laptop>	 <alpine.DEB.2.00.0906090105270.28701@chino.kir.corp.google.com> <1244536124.5024.41.camel@penberg-laptop>
In-Reply-To: <1244536124.5024.41.camel@penberg-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 65ffda5..2bbacfc 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1484,6 +1484,56 @@ static inline int node_match(struct kmem_cache_cpu *c, int node)
>  	return 1;
>  }
>  
> +static int count_free(struct page *page)
> +{
> +	return page->objects - page->inuse;
> +}
> +
> +static unsigned long count_partial(struct kmem_cache_node *n,
> +					int (*get_count)(struct page *))
> +{
> +	unsigned long flags;
> +	unsigned long x = 0;
> +	struct page *page;
> +
> +	spin_lock_irqsave(&n->list_lock, flags);
> +	list_for_each_entry(page, &n->partial, lru)
> +		x += get_count(page);
> +	spin_unlock_irqrestore(&n->list_lock, flags);
> +	return x;
> +}
> +
> +static noinline void
> +slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
> +{
> +	int node;
> +
> +	printk(KERN_WARNING
> +		"SLUB: Unable to allocate memory on node %d (gfp=%x)\n",
> +		nid, gfpflags);
> +	printk(KERN_WARNING "  cache: %s, object size: %d, buffer size: %d, "
> +		"default order: %d, min order: %d\n", s->name, s->objsize,
> +		s->size, oo_order(s->oo), oo_order(s->min));
> +
> +	for_each_online_node(node) {
> +		struct kmem_cache_node *n = get_node(s, node);
> +		unsigned long nr_slabs;
> +		unsigned long nr_objs;
> +		unsigned long nr_free;
> +
> +		if (!n)
> +			continue;
> +
> +		nr_slabs = atomic_long_read(&n->nr_slabs);
> +		nr_objs = atomic_long_read(&n->total_objects);
> +		nr_free = count_partial(n, count_free);
> +
> +		printk(KERN_WARNING
> +			"  node %d: slabs: %ld, objs: %ld, free: %ld\n",
> +			node, nr_slabs, nr_objs, nr_free);
> +	}
> +}
> +
>  /*
>   * Slow path. The lockless freelist is empty or we need to perform
>   * debugging duties.
> @@ -1565,6 +1615,7 @@ new_slab:
>  		c->page = new;
>  		goto load_freelist;
>  	}
> +	slab_out_of_memory(s, gfpflags, node);
>  	return NULL;
>  debug:
>  	if (!alloc_debug_processing(s, c->page, object, addr))
> @@ -3318,20 +3369,6 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
>  }
>  
>  #ifdef CONFIG_SLUB_DEBUG
> -static unsigned long count_partial(struct kmem_cache_node *n,
> -					int (*get_count)(struct page *))
> -{
> -	unsigned long flags;
> -	unsigned long x = 0;
> -	struct page *page;
> -
> -	spin_lock_irqsave(&n->list_lock, flags);
> -	list_for_each_entry(page, &n->partial, lru)
> -		x += get_count(page);
> -	spin_unlock_irqrestore(&n->list_lock, flags);
> -	return x;
> -}
> -
>  static int count_inuse(struct page *page)
>  {
>  	return page->inuse;
> @@ -3342,11 +3379,6 @@ static int count_total(struct page *page)
>  	return page->objects;
>  }
>  
> -static int count_free(struct page *page)
> -{
> -	return page->objects - page->inuse;
> -}
> -
>  static int validate_slab(struct kmem_cache *s, struct page *page,
>  						unsigned long *map)
>  {

With the above patch installed, I pushed my system hard enough to get
the O(1) allocation failures. This time they were triggered with a
'make -j8' on the kernel. No, I don't have that many CPUs, but I
figured that the extra make jobs might stress memory. My kernel is
2.6.30-rc8 from the wireless-testing tree. Everything matches Linus's
tree except drivers/net/wireless/, which contains what is essentially
2.6.31 code.

The dmesg output starting with the first allocation failure is:

cc1: page allocation failure. order:1, mode:0x4020
Pid: 6577, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b4d1f>] ? unfreeze_slab+0x4c/0xbd
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff802b7e60>] __kmalloc+0x119/0x194
 [<ffffffff803e7bee>] pskb_expand_head+0x52/0x166
 [<ffffffffa02913d6>] ieee80211_skb_resize+0x91/0xc7 [mac80211]
 [<ffffffffa0291c0f>] ieee80211_master_start_xmit+0x298/0x319 [mac80211]
 [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
 [<ffffffff803ef55c>] ? dev_hard_start_xmit+0x5b/0x2a8
 [<ffffffff804005ee>] __qdisc_run+0xed/0x1fe
 [<ffffffff803efb08>] dev_queue_xmit+0x24c/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffffa0291957>] ieee80211_subif_start_xmit+0x54b/0x56b [mac80211]
 [<ffffffffa029162b>] ? ieee80211_subif_start_xmit+0x21f/0x56b [mac80211]
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff803e7790>] ? __kfree_skb+0x82/0x86
 [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
 [<ffffffff803ef55c>] ? dev_hard_start_xmit+0x5b/0x2a8
 [<ffffffff804005ee>] __qdisc_run+0xed/0x1fe
 [<ffffffff803efb08>] dev_queue_xmit+0x24c/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff802b4038>] ? add_partial+0x1a/0x69
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff802b790b>] ? __kmalloc_node_track_caller+0xd3/0x144
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff803e872d>] ? __alloc_skb+0x6f/0x143
 [<ffffffff80422ec9>] __tcp_push_pending_frames+0x2a/0x81
 [<ffffffff80417590>] tcp_sendmsg+0x8f8/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffffa054c3f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
 [<ffffffffa054c486>] xs_sendpages+0x8d/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bfc11>] ? nfs3_xdr_fhandle+0x0/0x2e [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa054972f>] rpc_call_sync+0x3f/0x5d [sunrpc]
 [<ffffffffa05bdcd0>] nfs3_rpc_wrapper+0x22/0x5c [nfs]
 [<ffffffffa05be40c>] nfs3_proc_getattr+0x5b/0x81 [nfs]
 [<ffffffffa05b1e22>] __nfs_revalidate_inode+0xbd/0x1c9 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05d0529>] ? nfs_have_delegation+0x79/0x82 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05acb60>] nfs_lookup_revalidate+0x265/0x49c [nfs]
 [<ffffffff802ccfa9>] ? __d_lookup+0xba/0x16a
 [<ffffffff802cd047>] ? __d_lookup+0x158/0x16a
 [<ffffffff802cceef>] ? __d_lookup+0x0/0x16a
 [<ffffffffa0550992>] ? rpcauth_lookupcred+0x77/0x9f [sunrpc]
 [<ffffffff802c49c6>] do_lookup+0x166/0x1bb
 [<ffffffff802c66b7>] __link_path_walk+0x8f8/0xd58
 [<ffffffff802c6d1d>] path_walk+0x69/0xd4
 [<ffffffff802c6fb6>] do_path_lookup+0x187/0x1df
 [<ffffffff802bdf80>] ? get_empty_filp+0xe9/0x14e
 [<ffffffff802c7c4b>] do_filp_open+0x105/0x909
 [<ffffffff802d0bb6>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802bb2ea>] do_sys_open+0x56/0xd6
 [<ffffffff802bb393>] sys_open+0x1b/0x1d
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  15
CPU    1: hi:  186, btch:  31 usd:  65
Active_anon:128724 active_file:123018 inactive_anon:47276
 inactive_file:355583 unevictable:8 dirty:18 writeback:0 unstable:0
 free:3621 slab:77881 mapped:18629 pagetables:4056 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:12380kB min:6904kB low:8628kB high:10356kB
active_anon:514896kB inactive_anon:189104kB active_file:492072kB
inactive_file:1422332kB unevictable:32kB present:2997292kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 2821*4kB 1*8kB 3*16kB 1*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 12332kB
479694 total pagecache pages
969 pages in swap cache
Swap cache stats: add 4523, delete 3554, find 2913/3063
Free swap  = 2091884kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
382252 pages shared
441407 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
phy0: failed to reallocate TX buffer
cc1: page allocation failure. order:1, mode:0x4020
Pid: 6577, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 <IRQ>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b4d1f>] ? unfreeze_slab+0x4c/0xbd
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff802b78f5>] __kmalloc_node_track_caller+0xbd/0x144
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff803e872d>] __alloc_skb+0x6f/0x143
 [<ffffffffa02d131d>] setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffffa02d192e>] b43_dma_rx+0x319/0x4ff [b43]
 [<ffffffffa02c55d3>] b43_interrupt_tasklet+0x699/0x7fe [b43]
 [<ffffffff8023f684>] ? tasklet_action+0x44/0xdb
 [<ffffffff8023f6c0>] tasklet_action+0x80/0xdb
 [<ffffffff8023fdc7>] __do_softirq+0xb1/0x186
 [<ffffffff8020cc7c>] call_softirq+0x1c/0x28
 <EOI>  [<ffffffff8020e54d>] do_softirq+0x39/0x8a
 [<ffffffff803efc0e>] ? dev_queue_xmit+0x352/0x384
 [<ffffffff8023fc57>] local_bh_enable+0xb5/0xcf
 [<ffffffff803efc0e>] dev_queue_xmit+0x352/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff802b4038>] ? add_partial+0x1a/0x69
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff802b790b>] ? __kmalloc_node_track_caller+0xd3/0x144
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff803e872d>] ? __alloc_skb+0x6f/0x143
 [<ffffffff80422ec9>] __tcp_push_pending_frames+0x2a/0x81
 [<ffffffff80417590>] tcp_sendmsg+0x8f8/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffffa054c3f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
 [<ffffffffa054c486>] xs_sendpages+0x8d/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bfc11>] ? nfs3_xdr_fhandle+0x0/0x2e [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa054972f>] rpc_call_sync+0x3f/0x5d [sunrpc]
 [<ffffffffa05bdcd0>] nfs3_rpc_wrapper+0x22/0x5c [nfs]
 [<ffffffffa05be40c>] nfs3_proc_getattr+0x5b/0x81 [nfs]
 [<ffffffffa05b1e22>] __nfs_revalidate_inode+0xbd/0x1c9 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05d0529>] ? nfs_have_delegation+0x79/0x82 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05acb60>] nfs_lookup_revalidate+0x265/0x49c [nfs]
 [<ffffffff802ccfa9>] ? __d_lookup+0xba/0x16a
 [<ffffffff802cd047>] ? __d_lookup+0x158/0x16a
 [<ffffffff802cceef>] ? __d_lookup+0x0/0x16a
 [<ffffffffa0550992>] ? rpcauth_lookupcred+0x77/0x9f [sunrpc]
 [<ffffffff802c49c6>] do_lookup+0x166/0x1bb
 [<ffffffff802c66b7>] __link_path_walk+0x8f8/0xd58
 [<ffffffff802c6d1d>] path_walk+0x69/0xd4
 [<ffffffff802c6fb6>] do_path_lookup+0x187/0x1df
 [<ffffffff802bdf80>] ? get_empty_filp+0xe9/0x14e
 [<ffffffff802c7c4b>] do_filp_open+0x105/0x909
 [<ffffffff802d0bb6>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802bb2ea>] do_sys_open+0x56/0xd6
 [<ffffffff802bb393>] sys_open+0x1b/0x1d
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  15
CPU    1: hi:  186, btch:  31 usd:  65
Active_anon:128724 active_file:123018 inactive_anon:47276
 inactive_file:355583 unevictable:8 dirty:18 writeback:0 unstable:0
 free:3621 slab:77881 mapped:18629 pagetables:4056 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:12380kB min:6904kB low:8628kB high:10356kB
active_anon:514896kB inactive_anon:189104kB active_file:492072kB
inactive_file:1422332kB unevictable:32kB present:2997292kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 2821*4kB 1*8kB 3*16kB 1*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 12332kB
479694 total pagecache pages
969 pages in swap cache
Swap cache stats: add 4523, delete 3554, find 2913/3063
Free swap  = 2091884kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
382252 pages shared
441407 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
cc1: page allocation failure. order:1, mode:0x4020
Pid: 6577, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 <IRQ>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff802b78f5>] __kmalloc_node_track_caller+0xbd/0x144
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff803e872d>] __alloc_skb+0x6f/0x143
 [<ffffffffa02d131d>] setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffffa02d192e>] b43_dma_rx+0x319/0x4ff [b43]
 [<ffffffffa02c55d3>] b43_interrupt_tasklet+0x699/0x7fe [b43]
 [<ffffffff8023f684>] ? tasklet_action+0x44/0xdb
 [<ffffffff8023f6c0>] tasklet_action+0x80/0xdb
 [<ffffffff8023fdc7>] __do_softirq+0xb1/0x186
 [<ffffffff8020cc7c>] call_softirq+0x1c/0x28
 <EOI>  [<ffffffff8020e54d>] do_softirq+0x39/0x8a
 [<ffffffff803efc0e>] ? dev_queue_xmit+0x352/0x384
 [<ffffffff8023fc57>] local_bh_enable+0xb5/0xcf
 [<ffffffff803efc0e>] dev_queue_xmit+0x352/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff802b4038>] ? add_partial+0x1a/0x69
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff802b790b>] ? __kmalloc_node_track_caller+0xd3/0x144
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff803e872d>] ? __alloc_skb+0x6f/0x143
 [<ffffffff80422ec9>] __tcp_push_pending_frames+0x2a/0x81
 [<ffffffff80417590>] tcp_sendmsg+0x8f8/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffffa054c3f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
 [<ffffffffa054c486>] xs_sendpages+0x8d/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bfc11>] ? nfs3_xdr_fhandle+0x0/0x2e [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa054972f>] rpc_call_sync+0x3f/0x5d [sunrpc]
 [<ffffffffa05bdcd0>] nfs3_rpc_wrapper+0x22/0x5c [nfs]
 [<ffffffffa05be40c>] nfs3_proc_getattr+0x5b/0x81 [nfs]
 [<ffffffffa05b1e22>] __nfs_revalidate_inode+0xbd/0x1c9 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05d0529>] ? nfs_have_delegation+0x79/0x82 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05acb60>] nfs_lookup_revalidate+0x265/0x49c [nfs]
 [<ffffffff802ccfa9>] ? __d_lookup+0xba/0x16a
 [<ffffffff802cd047>] ? __d_lookup+0x158/0x16a
 [<ffffffff802cceef>] ? __d_lookup+0x0/0x16a
 [<ffffffffa0550992>] ? rpcauth_lookupcred+0x77/0x9f [sunrpc]
 [<ffffffff802c49c6>] do_lookup+0x166/0x1bb
 [<ffffffff802c66b7>] __link_path_walk+0x8f8/0xd58
 [<ffffffff802c6d1d>] path_walk+0x69/0xd4
 [<ffffffff802c6fb6>] do_path_lookup+0x187/0x1df
 [<ffffffff802bdf80>] ? get_empty_filp+0xe9/0x14e
 [<ffffffff802c7c4b>] do_filp_open+0x105/0x909
 [<ffffffff802d0bb6>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802bb2ea>] do_sys_open+0x56/0xd6
 [<ffffffff802bb393>] sys_open+0x1b/0x1d
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  15
CPU    1: hi:  186, btch:  31 usd:  65
Active_anon:128724 active_file:123018 inactive_anon:47276
 inactive_file:355583 unevictable:8 dirty:18 writeback:0 unstable:0
 free:3621 slab:77881 mapped:18629 pagetables:4056 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:12380kB min:6904kB low:8628kB high:10356kB
active_anon:514896kB inactive_anon:189104kB active_file:492072kB
inactive_file:1422332kB unevictable:32kB present:2997292kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 2821*4kB 1*8kB 3*16kB 1*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 12332kB
479694 total pagecache pages
969 pages in swap cache
Swap cache stats: add 4523, delete 3554, find 2913/3063
Free swap  = 2091884kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
382252 pages shared
441407 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
cc1: page allocation failure. order:1, mode:0x4020
Pid: 6577, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 <IRQ>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff802b78f5>] __kmalloc_node_track_caller+0xbd/0x144
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff803e872d>] __alloc_skb+0x6f/0x143
 [<ffffffffa02d131d>] setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffffa02d192e>] b43_dma_rx+0x319/0x4ff [b43]
 [<ffffffffa02c55d3>] b43_interrupt_tasklet+0x699/0x7fe [b43]
 [<ffffffff8023f684>] ? tasklet_action+0x44/0xdb
 [<ffffffff8023f6c0>] tasklet_action+0x80/0xdb
 [<ffffffff8023fdc7>] __do_softirq+0xb1/0x186
 [<ffffffff8020cc7c>] call_softirq+0x1c/0x28
 <EOI>  [<ffffffff8020e54d>] do_softirq+0x39/0x8a
 [<ffffffff803efc0e>] ? dev_queue_xmit+0x352/0x384
 [<ffffffff8023fc57>] local_bh_enable+0xb5/0xcf
 [<ffffffff803efc0e>] dev_queue_xmit+0x352/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff802b4038>] ? add_partial+0x1a/0x69
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff802b790b>] ? __kmalloc_node_track_caller+0xd3/0x144
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff803e872d>] ? __alloc_skb+0x6f/0x143
 [<ffffffff80422ec9>] __tcp_push_pending_frames+0x2a/0x81
 [<ffffffff80417590>] tcp_sendmsg+0x8f8/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffffa054c3f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
 [<ffffffffa054c486>] xs_sendpages+0x8d/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bfc11>] ? nfs3_xdr_fhandle+0x0/0x2e [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa054972f>] rpc_call_sync+0x3f/0x5d [sunrpc]
 [<ffffffffa05bdcd0>] nfs3_rpc_wrapper+0x22/0x5c [nfs]
 [<ffffffffa05be40c>] nfs3_proc_getattr+0x5b/0x81 [nfs]
 [<ffffffffa05b1e22>] __nfs_revalidate_inode+0xbd/0x1c9 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05d0529>] ? nfs_have_delegation+0x79/0x82 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05acb60>] nfs_lookup_revalidate+0x265/0x49c [nfs]
 [<ffffffff802ccfa9>] ? __d_lookup+0xba/0x16a
 [<ffffffff802cd047>] ? __d_lookup+0x158/0x16a
 [<ffffffff802cceef>] ? __d_lookup+0x0/0x16a
 [<ffffffffa0550992>] ? rpcauth_lookupcred+0x77/0x9f [sunrpc]
 [<ffffffff802c49c6>] do_lookup+0x166/0x1bb
 [<ffffffff802c66b7>] __link_path_walk+0x8f8/0xd58
 [<ffffffff802c6d1d>] path_walk+0x69/0xd4
 [<ffffffff802c6fb6>] do_path_lookup+0x187/0x1df
 [<ffffffff802bdf80>] ? get_empty_filp+0xe9/0x14e
 [<ffffffff802c7c4b>] do_filp_open+0x105/0x909
 [<ffffffff802d0bb6>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802bb2ea>] do_sys_open+0x56/0xd6
 [<ffffffff802bb393>] sys_open+0x1b/0x1d
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  15
CPU    1: hi:  186, btch:  31 usd:  65
Active_anon:128724 active_file:123018 inactive_anon:47276
 inactive_file:355583 unevictable:8 dirty:18 writeback:0 unstable:0
 free:3621 slab:77881 mapped:18629 pagetables:4056 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:12380kB min:6904kB low:8628kB high:10356kB
active_anon:514896kB inactive_anon:189104kB active_file:492072kB
inactive_file:1422332kB unevictable:32kB present:2997292kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 2821*4kB 1*8kB 3*16kB 1*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 12332kB
479694 total pagecache pages
969 pages in swap cache
Swap cache stats: add 4523, delete 3554, find 2913/3063
Free swap  = 2091884kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
382252 pages shared
441407 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
cc1: page allocation failure. order:1, mode:0x4020
Pid: 6577, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 <IRQ>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff802b78f5>] __kmalloc_node_track_caller+0xbd/0x144
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff803e872d>] __alloc_skb+0x6f/0x143
 [<ffffffffa02d131d>] setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffffa02d192e>] b43_dma_rx+0x319/0x4ff [b43]
 [<ffffffffa02c55d3>] b43_interrupt_tasklet+0x699/0x7fe [b43]
 [<ffffffff8023f684>] ? tasklet_action+0x44/0xdb
 [<ffffffff8023f6c0>] tasklet_action+0x80/0xdb
 [<ffffffff8023fdc7>] __do_softirq+0xb1/0x186
 [<ffffffff8020cc7c>] call_softirq+0x1c/0x28
 <EOI>  [<ffffffff8020e54d>] do_softirq+0x39/0x8a
 [<ffffffff803efc0e>] ? dev_queue_xmit+0x352/0x384
 [<ffffffff8023fc57>] local_bh_enable+0xb5/0xcf
 [<ffffffff803efc0e>] dev_queue_xmit+0x352/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff802b4038>] ? add_partial+0x1a/0x69
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff802b790b>] ? __kmalloc_node_track_caller+0xd3/0x144
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff803e872d>] ? __alloc_skb+0x6f/0x143
 [<ffffffff80422ec9>] __tcp_push_pending_frames+0x2a/0x81
 [<ffffffff80417590>] tcp_sendmsg+0x8f8/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffffa054c3f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
 [<ffffffffa054c486>] xs_sendpages+0x8d/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bfc11>] ? nfs3_xdr_fhandle+0x0/0x2e [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa054972f>] rpc_call_sync+0x3f/0x5d [sunrpc]
 [<ffffffffa05bdcd0>] nfs3_rpc_wrapper+0x22/0x5c [nfs]
 [<ffffffffa05be40c>] nfs3_proc_getattr+0x5b/0x81 [nfs]
 [<ffffffffa05b1e22>] __nfs_revalidate_inode+0xbd/0x1c9 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05d0529>] ? nfs_have_delegation+0x79/0x82 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05acb60>] nfs_lookup_revalidate+0x265/0x49c [nfs]
 [<ffffffff802ccfa9>] ? __d_lookup+0xba/0x16a
 [<ffffffff802cd047>] ? __d_lookup+0x158/0x16a
 [<ffffffff802cceef>] ? __d_lookup+0x0/0x16a
 [<ffffffffa0550992>] ? rpcauth_lookupcred+0x77/0x9f [sunrpc]
 [<ffffffff802c49c6>] do_lookup+0x166/0x1bb
 [<ffffffff802c66b7>] __link_path_walk+0x8f8/0xd58
 [<ffffffff802c6d1d>] path_walk+0x69/0xd4
 [<ffffffff802c6fb6>] do_path_lookup+0x187/0x1df
 [<ffffffff802bdf80>] ? get_empty_filp+0xe9/0x14e
 [<ffffffff802c7c4b>] do_filp_open+0x105/0x909
 [<ffffffff802d0bb6>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802bb2ea>] do_sys_open+0x56/0xd6
 [<ffffffff802bb393>] sys_open+0x1b/0x1d
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  15
CPU    1: hi:  186, btch:  31 usd:  65
Active_anon:128724 active_file:123018 inactive_anon:47276
 inactive_file:355583 unevictable:8 dirty:18 writeback:0 unstable:0
 free:3621 slab:77881 mapped:18629 pagetables:4056 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:12380kB min:6904kB low:8628kB high:10356kB
active_anon:514896kB inactive_anon:189104kB active_file:492072kB
inactive_file:1422332kB unevictable:32kB present:2997292kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 2821*4kB 1*8kB 3*16kB 1*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 12332kB
479694 total pagecache pages
969 pages in swap cache
Swap cache stats: add 4523, delete 3554, find 2913/3063
Free swap  = 2091884kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
382252 pages shared
441407 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
cc1: page allocation failure. order:1, mode:0x4020
Pid: 6577, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 <IRQ>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff802b78f5>] __kmalloc_node_track_caller+0xbd/0x144
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff803e872d>] __alloc_skb+0x6f/0x143
 [<ffffffffa02d131d>] setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffffa02d192e>] b43_dma_rx+0x319/0x4ff [b43]
 [<ffffffffa02c55d3>] b43_interrupt_tasklet+0x699/0x7fe [b43]
 [<ffffffff8023f684>] ? tasklet_action+0x44/0xdb
 [<ffffffff8023f6c0>] tasklet_action+0x80/0xdb
 [<ffffffff8023fdc7>] __do_softirq+0xb1/0x186
 [<ffffffff8020cc7c>] call_softirq+0x1c/0x28
 <EOI>  [<ffffffff8020e54d>] do_softirq+0x39/0x8a
 [<ffffffff803efc0e>] ? dev_queue_xmit+0x352/0x384
 [<ffffffff8023fc57>] local_bh_enable+0xb5/0xcf
 [<ffffffff803efc0e>] dev_queue_xmit+0x352/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff802b4038>] ? add_partial+0x1a/0x69
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff802b790b>] ? __kmalloc_node_track_caller+0xd3/0x144
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff803e872d>] ? __alloc_skb+0x6f/0x143
 [<ffffffff80422ec9>] __tcp_push_pending_frames+0x2a/0x81
 [<ffffffff80417590>] tcp_sendmsg+0x8f8/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffffa054c3f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
 [<ffffffffa054c486>] xs_sendpages+0x8d/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bfc11>] ? nfs3_xdr_fhandle+0x0/0x2e [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa054972f>] rpc_call_sync+0x3f/0x5d [sunrpc]
 [<ffffffffa05bdcd0>] nfs3_rpc_wrapper+0x22/0x5c [nfs]
 [<ffffffffa05be40c>] nfs3_proc_getattr+0x5b/0x81 [nfs]
 [<ffffffffa05b1e22>] __nfs_revalidate_inode+0xbd/0x1c9 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05d0529>] ? nfs_have_delegation+0x79/0x82 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05acb60>] nfs_lookup_revalidate+0x265/0x49c [nfs]
 [<ffffffff802ccfa9>] ? __d_lookup+0xba/0x16a
 [<ffffffff802cd047>] ? __d_lookup+0x158/0x16a
 [<ffffffff802cceef>] ? __d_lookup+0x0/0x16a
 [<ffffffffa0550992>] ? rpcauth_lookupcred+0x77/0x9f [sunrpc]
 [<ffffffff802c49c6>] do_lookup+0x166/0x1bb
 [<ffffffff802c66b7>] __link_path_walk+0x8f8/0xd58
 [<ffffffff802c6d1d>] path_walk+0x69/0xd4
 [<ffffffff802c6fb6>] do_path_lookup+0x187/0x1df
 [<ffffffff802bdf80>] ? get_empty_filp+0xe9/0x14e
 [<ffffffff802c7c4b>] do_filp_open+0x105/0x909
 [<ffffffff802d0bb6>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802bb2ea>] do_sys_open+0x56/0xd6
 [<ffffffff802bb393>] sys_open+0x1b/0x1d
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  15
CPU    1: hi:  186, btch:  31 usd:  65
Active_anon:128724 active_file:123018 inactive_anon:47276
 inactive_file:355583 unevictable:8 dirty:18 writeback:0 unstable:0
 free:3621 slab:77881 mapped:18629 pagetables:4056 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:12380kB min:6904kB low:8628kB high:10356kB
active_anon:514896kB inactive_anon:189104kB active_file:492072kB
inactive_file:1422332kB unevictable:32kB present:2997292kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 2821*4kB 1*8kB 3*16kB 1*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 12332kB
479694 total pagecache pages
969 pages in swap cache
Swap cache stats: add 4523, delete 3554, find 2913/3063
Free swap  = 2091884kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
382252 pages shared
441407 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
cc1: page allocation failure. order:1, mode:0x4020
Pid: 6577, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 <IRQ>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff802b78f5>] __kmalloc_node_track_caller+0xbd/0x144
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff803e872d>] __alloc_skb+0x6f/0x143
 [<ffffffffa02d131d>] setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffffa02d192e>] b43_dma_rx+0x319/0x4ff [b43]
 [<ffffffffa02c55d3>] b43_interrupt_tasklet+0x699/0x7fe [b43]
 [<ffffffff8023f684>] ? tasklet_action+0x44/0xdb
 [<ffffffff8023f6c0>] tasklet_action+0x80/0xdb
 [<ffffffff8023fdc7>] __do_softirq+0xb1/0x186
 [<ffffffff8020cc7c>] call_softirq+0x1c/0x28
 <EOI>  [<ffffffff8020e54d>] do_softirq+0x39/0x8a
 [<ffffffff803efc0e>] ? dev_queue_xmit+0x352/0x384
 [<ffffffff8023fc57>] local_bh_enable+0xb5/0xcf
 [<ffffffff803efc0e>] dev_queue_xmit+0x352/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff802b4038>] ? add_partial+0x1a/0x69
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff802b790b>] ? __kmalloc_node_track_caller+0xd3/0x144
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff803e872d>] ? __alloc_skb+0x6f/0x143
 [<ffffffff80422ec9>] __tcp_push_pending_frames+0x2a/0x81
 [<ffffffff80417590>] tcp_sendmsg+0x8f8/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffffa054c3f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
 [<ffffffffa054c486>] xs_sendpages+0x8d/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bfc11>] ? nfs3_xdr_fhandle+0x0/0x2e [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa054972f>] rpc_call_sync+0x3f/0x5d [sunrpc]
 [<ffffffffa05bdcd0>] nfs3_rpc_wrapper+0x22/0x5c [nfs]
 [<ffffffffa05be40c>] nfs3_proc_getattr+0x5b/0x81 [nfs]
 [<ffffffffa05b1e22>] __nfs_revalidate_inode+0xbd/0x1c9 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05d0529>] ? nfs_have_delegation+0x79/0x82 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05acb60>] nfs_lookup_revalidate+0x265/0x49c [nfs]
 [<ffffffff802ccfa9>] ? __d_lookup+0xba/0x16a
 [<ffffffff802cd047>] ? __d_lookup+0x158/0x16a
 [<ffffffff802cceef>] ? __d_lookup+0x0/0x16a
 [<ffffffffa0550992>] ? rpcauth_lookupcred+0x77/0x9f [sunrpc]
 [<ffffffff802c49c6>] do_lookup+0x166/0x1bb
 [<ffffffff802c66b7>] __link_path_walk+0x8f8/0xd58
 [<ffffffff802c6d1d>] path_walk+0x69/0xd4
 [<ffffffff802c6fb6>] do_path_lookup+0x187/0x1df
 [<ffffffff802bdf80>] ? get_empty_filp+0xe9/0x14e
 [<ffffffff802c7c4b>] do_filp_open+0x105/0x909
 [<ffffffff802d0bb6>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802bb2ea>] do_sys_open+0x56/0xd6
 [<ffffffff802bb393>] sys_open+0x1b/0x1d
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  15
CPU    1: hi:  186, btch:  31 usd:  65
Active_anon:128724 active_file:123018 inactive_anon:47276
 inactive_file:355583 unevictable:8 dirty:18 writeback:0 unstable:0
 free:3621 slab:77881 mapped:18629 pagetables:4056 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:12380kB min:6904kB low:8628kB high:10356kB
active_anon:514896kB inactive_anon:189104kB active_file:492072kB
inactive_file:1422332kB unevictable:32kB present:2997292kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 2821*4kB 1*8kB 3*16kB 1*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 12332kB
479694 total pagecache pages
969 pages in swap cache
Swap cache stats: add 4523, delete 3554, find 2913/3063
Free swap  = 2091884kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
382252 pages shared
441407 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
cc1: page allocation failure. order:1, mode:0x4020
Pid: 6577, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 <IRQ>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff802b78f5>] __kmalloc_node_track_caller+0xbd/0x144
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff803e872d>] __alloc_skb+0x6f/0x143
 [<ffffffffa02d131d>] setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffffa02d192e>] b43_dma_rx+0x319/0x4ff [b43]
 [<ffffffffa02c55d3>] b43_interrupt_tasklet+0x699/0x7fe [b43]
 [<ffffffff8023f684>] ? tasklet_action+0x44/0xdb
 [<ffffffff8023f6c0>] tasklet_action+0x80/0xdb
 [<ffffffff8023fdc7>] __do_softirq+0xb1/0x186
 [<ffffffff8020cc7c>] call_softirq+0x1c/0x28
 <EOI>  [<ffffffff8020e54d>] do_softirq+0x39/0x8a
 [<ffffffff803efc0e>] ? dev_queue_xmit+0x352/0x384
 [<ffffffff8023fc57>] local_bh_enable+0xb5/0xcf
 [<ffffffff803efc0e>] dev_queue_xmit+0x352/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff802b4038>] ? add_partial+0x1a/0x69
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff802b790b>] ? __kmalloc_node_track_caller+0xd3/0x144
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff803e872d>] ? __alloc_skb+0x6f/0x143
 [<ffffffff80422ec9>] __tcp_push_pending_frames+0x2a/0x81
 [<ffffffff80417590>] tcp_sendmsg+0x8f8/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffffa054c3f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
 [<ffffffffa054c486>] xs_sendpages+0x8d/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bfc11>] ? nfs3_xdr_fhandle+0x0/0x2e [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa054972f>] rpc_call_sync+0x3f/0x5d [sunrpc]
 [<ffffffffa05bdcd0>] nfs3_rpc_wrapper+0x22/0x5c [nfs]
 [<ffffffffa05be40c>] nfs3_proc_getattr+0x5b/0x81 [nfs]
 [<ffffffffa05b1e22>] __nfs_revalidate_inode+0xbd/0x1c9 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05d0529>] ? nfs_have_delegation+0x79/0x82 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05acb60>] nfs_lookup_revalidate+0x265/0x49c [nfs]
 [<ffffffff802ccfa9>] ? __d_lookup+0xba/0x16a
 [<ffffffff802cd047>] ? __d_lookup+0x158/0x16a
 [<ffffffff802cceef>] ? __d_lookup+0x0/0x16a
 [<ffffffffa0550992>] ? rpcauth_lookupcred+0x77/0x9f [sunrpc]
 [<ffffffff802c49c6>] do_lookup+0x166/0x1bb
 [<ffffffff802c66b7>] __link_path_walk+0x8f8/0xd58
 [<ffffffff802c6d1d>] path_walk+0x69/0xd4
 [<ffffffff802c6fb6>] do_path_lookup+0x187/0x1df
 [<ffffffff802bdf80>] ? get_empty_filp+0xe9/0x14e
 [<ffffffff802c7c4b>] do_filp_open+0x105/0x909
 [<ffffffff802d0bb6>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802bb2ea>] do_sys_open+0x56/0xd6
 [<ffffffff802bb393>] sys_open+0x1b/0x1d
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  15
CPU    1: hi:  186, btch:  31 usd:  65
Active_anon:128724 active_file:123018 inactive_anon:47276
 inactive_file:355583 unevictable:8 dirty:18 writeback:0 unstable:0
 free:3621 slab:77881 mapped:18629 pagetables:4056 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:12380kB min:6904kB low:8628kB high:10356kB
active_anon:514896kB inactive_anon:189104kB active_file:492072kB
inactive_file:1422332kB unevictable:32kB present:2997292kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 2821*4kB 1*8kB 3*16kB 1*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 12332kB
479694 total pagecache pages
969 pages in swap cache
Swap cache stats: add 4523, delete 3554, find 2913/3063
Free swap  = 2091884kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
382238 pages shared
441414 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
cc1: page allocation failure. order:1, mode:0x4020
Pid: 6577, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 <IRQ>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff802b78f5>] __kmalloc_node_track_caller+0xbd/0x144
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff803e872d>] __alloc_skb+0x6f/0x143
 [<ffffffffa02d131d>] setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffffa02d192e>] b43_dma_rx+0x319/0x4ff [b43]
 [<ffffffffa02c55d3>] b43_interrupt_tasklet+0x699/0x7fe [b43]
 [<ffffffff8023f684>] ? tasklet_action+0x44/0xdb
 [<ffffffff8023f6c0>] tasklet_action+0x80/0xdb
 [<ffffffff8023fdc7>] __do_softirq+0xb1/0x186
 [<ffffffff8020cc7c>] call_softirq+0x1c/0x28
 <EOI>  [<ffffffff8020e54d>] do_softirq+0x39/0x8a
 [<ffffffff803efc0e>] ? dev_queue_xmit+0x352/0x384
 [<ffffffff8023fc57>] local_bh_enable+0xb5/0xcf
 [<ffffffff803efc0e>] dev_queue_xmit+0x352/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff802b4038>] ? add_partial+0x1a/0x69
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff802b790b>] ? __kmalloc_node_track_caller+0xd3/0x144
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff803e872d>] ? __alloc_skb+0x6f/0x143
 [<ffffffff80422ec9>] __tcp_push_pending_frames+0x2a/0x81
 [<ffffffff80417590>] tcp_sendmsg+0x8f8/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffffa054c3f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
 [<ffffffffa054c486>] xs_sendpages+0x8d/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bfc11>] ? nfs3_xdr_fhandle+0x0/0x2e [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa054972f>] rpc_call_sync+0x3f/0x5d [sunrpc]
 [<ffffffffa05bdcd0>] nfs3_rpc_wrapper+0x22/0x5c [nfs]
 [<ffffffffa05be40c>] nfs3_proc_getattr+0x5b/0x81 [nfs]
 [<ffffffffa05b1e22>] __nfs_revalidate_inode+0xbd/0x1c9 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05d0529>] ? nfs_have_delegation+0x79/0x82 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05acb60>] nfs_lookup_revalidate+0x265/0x49c [nfs]
 [<ffffffff802ccfa9>] ? __d_lookup+0xba/0x16a
 [<ffffffff802cd047>] ? __d_lookup+0x158/0x16a
 [<ffffffff802cceef>] ? __d_lookup+0x0/0x16a
 [<ffffffffa0550992>] ? rpcauth_lookupcred+0x77/0x9f [sunrpc]
 [<ffffffff802c49c6>] do_lookup+0x166/0x1bb
 [<ffffffff802c66b7>] __link_path_walk+0x8f8/0xd58
 [<ffffffff802c6d1d>] path_walk+0x69/0xd4
 [<ffffffff802c6fb6>] do_path_lookup+0x187/0x1df
 [<ffffffff802bdf80>] ? get_empty_filp+0xe9/0x14e
 [<ffffffff802c7c4b>] do_filp_open+0x105/0x909
 [<ffffffff802d0bb6>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802bb2ea>] do_sys_open+0x56/0xd6
 [<ffffffff802bb393>] sys_open+0x1b/0x1d
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  15
CPU    1: hi:  186, btch:  31 usd:  65
Active_anon:128724 active_file:123018 inactive_anon:47276
 inactive_file:355620 unevictable:8 dirty:18 writeback:0 unstable:0
 free:3621 slab:77881 mapped:18629 pagetables:4056 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:12380kB min:6904kB low:8628kB high:10356kB
active_anon:514896kB inactive_anon:189104kB active_file:492072kB
inactive_file:1422480kB unevictable:32kB present:2997292kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 2821*4kB 1*8kB 3*16kB 1*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 12332kB
479694 total pagecache pages
969 pages in swap cache
Swap cache stats: add 4523, delete 3554, find 2913/3063
Free swap  = 2091884kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
382238 pages shared
441414 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
cc1: page allocation failure. order:1, mode:0x4020
Pid: 6577, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 <IRQ>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff802b78f5>] __kmalloc_node_track_caller+0xbd/0x144
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff803e872d>] __alloc_skb+0x6f/0x143
 [<ffffffffa02d131d>] setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffffa02d192e>] b43_dma_rx+0x319/0x4ff [b43]
 [<ffffffffa02c55d3>] b43_interrupt_tasklet+0x699/0x7fe [b43]
 [<ffffffff8023f684>] ? tasklet_action+0x44/0xdb
 [<ffffffff8023f6c0>] tasklet_action+0x80/0xdb
 [<ffffffff8023fdc7>] __do_softirq+0xb1/0x186
 [<ffffffff8020cc7c>] call_softirq+0x1c/0x28
 <EOI>  [<ffffffff8020e54d>] do_softirq+0x39/0x8a
 [<ffffffff803efc0e>] ? dev_queue_xmit+0x352/0x384
 [<ffffffff8023fc57>] local_bh_enable+0xb5/0xcf
 [<ffffffff803efc0e>] dev_queue_xmit+0x352/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff802b4038>] ? add_partial+0x1a/0x69
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff802b790b>] ? __kmalloc_node_track_caller+0xd3/0x144
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff803e872d>] ? __alloc_skb+0x6f/0x143
 [<ffffffff80422ec9>] __tcp_push_pending_frames+0x2a/0x81
 [<ffffffff80417590>] tcp_sendmsg+0x8f8/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffffa054c3f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
 [<ffffffffa054c486>] xs_sendpages+0x8d/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bfc11>] ? nfs3_xdr_fhandle+0x0/0x2e [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa054972f>] rpc_call_sync+0x3f/0x5d [sunrpc]
 [<ffffffffa05bdcd0>] nfs3_rpc_wrapper+0x22/0x5c [nfs]
 [<ffffffffa05be40c>] nfs3_proc_getattr+0x5b/0x81 [nfs]
 [<ffffffffa05b1e22>] __nfs_revalidate_inode+0xbd/0x1c9 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05d0529>] ? nfs_have_delegation+0x79/0x82 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05acb60>] nfs_lookup_revalidate+0x265/0x49c [nfs]
 [<ffffffff802ccfa9>] ? __d_lookup+0xba/0x16a
 [<ffffffff802cd047>] ? __d_lookup+0x158/0x16a
 [<ffffffff802cceef>] ? __d_lookup+0x0/0x16a
 [<ffffffffa0550992>] ? rpcauth_lookupcred+0x77/0x9f [sunrpc]
 [<ffffffff802c49c6>] do_lookup+0x166/0x1bb
 [<ffffffff802c66b7>] __link_path_walk+0x8f8/0xd58
 [<ffffffff802c6d1d>] path_walk+0x69/0xd4
 [<ffffffff802c6fb6>] do_path_lookup+0x187/0x1df
 [<ffffffff802bdf80>] ? get_empty_filp+0xe9/0x14e
 [<ffffffff802c7c4b>] do_filp_open+0x105/0x909
 [<ffffffff802d0bb6>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802bb2ea>] do_sys_open+0x56/0xd6
 [<ffffffff802bb393>] sys_open+0x1b/0x1d
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  15
CPU    1: hi:  186, btch:  31 usd:  65
Active_anon:128724 active_file:123018 inactive_anon:47276
 inactive_file:355620 unevictable:8 dirty:18 writeback:0 unstable:0
 free:3621 slab:77881 mapped:18629 pagetables:4056 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:12380kB min:6904kB low:8628kB high:10356kB
active_anon:514896kB inactive_anon:189104kB active_file:492072kB
inactive_file:1422480kB unevictable:32kB present:2997292kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 2821*4kB 1*8kB 3*16kB 1*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 12332kB
479694 total pagecache pages
969 pages in swap cache
Swap cache stats: add 4523, delete 3554, find 2913/3063
Free swap  = 2091884kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
382238 pages shared
441414 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
__ratelimit: 23 callbacks suppressed
rpciod/0: page allocation failure. order:1, mode:0x4020
Pid: 3085, comm: rpciod/0 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b4d1f>] ? unfreeze_slab+0x4c/0xbd
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff802b7e60>] __kmalloc+0x119/0x194
 [<ffffffff803e7bee>] pskb_expand_head+0x52/0x166
 [<ffffffff80460180>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffffa02913d6>] ieee80211_skb_resize+0x91/0xc7 [mac80211]
 [<ffffffffa0291815>] ieee80211_subif_start_xmit+0x409/0x56b [mac80211]
 [<ffffffffa029162b>] ? ieee80211_subif_start_xmit+0x21f/0x56b [mac80211]
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff803e7790>] ? __kfree_skb+0x82/0x86
 [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
 [<ffffffff803ef55c>] ? dev_hard_start_xmit+0x5b/0x2a8
 [<ffffffff804005ee>] __qdisc_run+0xed/0x1fe
 [<ffffffff803efb08>] dev_queue_xmit+0x24c/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff8023fc6b>] ? local_bh_enable+0xc9/0xcf
 [<ffffffff80422e9d>] tcp_push_one+0x2f/0x31
 [<ffffffff80417439>] tcp_sendmsg+0x7a1/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff803e0f6e>] ? sock_sendmsg+0xdf/0xf8
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffff803e39b3>] sock_no_sendpage+0x9b/0xaa
 [<ffffffff804176de>] tcp_sendpage+0x48/0x5ec
 [<ffffffffa054c525>] xs_sendpages+0x12c/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bf9c3>] ? nfs3_xdr_writeargs+0x0/0x87 [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054faa1>] rpc_async_schedule+0x10/0x12 [sunrpc]
 [<ffffffff8024af33>] worker_thread+0x1fa/0x30a
 [<ffffffff8024aedc>] ? worker_thread+0x1a3/0x30a
 [<ffffffffa054fa91>] ? rpc_async_schedule+0x0/0x12 [sunrpc]
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8024ad39>] ? worker_thread+0x0/0x30a
 [<ffffffff8024ad39>] ? worker_thread+0x0/0x30a
 [<ffffffff8024ec21>] kthread+0x56/0x83
 [<ffffffff8020cb7a>] child_rip+0xa/0x20
 [<ffffffff8020c57c>] ? restore_args+0x0/0x30
 [<ffffffff8024ebcb>] ? kthread+0x0/0x83
 [<ffffffff8020cb70>] ? child_rip+0x0/0x20
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 154
CPU    1: hi:  186, btch:  31 usd: 173
Active_anon:147694 active_file:116688 inactive_anon:47252
 inactive_file:344419 unevictable:8 dirty:5 writeback:0 unstable:0
 free:2692 slab:76878 mapped:19321 pagetables:4204 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:8664kB min:6904kB low:8628kB high:10356kB
active_anon:590776kB inactive_anon:189008kB active_file:466752kB
inactive_file:1377660kB unevictable:32kB present:2997292kB
pages_scanned:70 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 1898*4kB 12*8kB 8*16kB 1*32kB 0*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 8744kB
462221 total pagecache pages
966 pages in swap cache
Swap cache stats: add 4555, delete 3589, find 2917/3067
Free swap  = 2091764kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
373616 pages shared
454599 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
cc1: page allocation failure. order:1, mode:0x4020
Pid: 8867, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b4d1f>] ? unfreeze_slab+0x4c/0xbd
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff802b7e60>] __kmalloc+0x119/0x194
 [<ffffffff803e7bee>] pskb_expand_head+0x52/0x166
 [<ffffffffa02913d6>] ieee80211_skb_resize+0x91/0xc7 [mac80211]
 [<ffffffffa0291c0f>] ieee80211_master_start_xmit+0x298/0x319 [mac80211]
 [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
 [<ffffffff803ef55c>] ? dev_hard_start_xmit+0x5b/0x2a8
 [<ffffffff804005ee>] __qdisc_run+0xed/0x1fe
 [<ffffffff803efb08>] dev_queue_xmit+0x24c/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffffa0291957>] ieee80211_subif_start_xmit+0x54b/0x56b [mac80211]
 [<ffffffffa029162b>] ? ieee80211_subif_start_xmit+0x21f/0x56b [mac80211]
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff803e7790>] ? __kfree_skb+0x82/0x86
 [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
 [<ffffffff803ef55c>] ? dev_hard_start_xmit+0x5b/0x2a8
 [<ffffffff804005ee>] __qdisc_run+0xed/0x1fe
 [<ffffffff803efb08>] dev_queue_xmit+0x24c/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff803e33a8>] ? release_sock+0xcd/0xd6
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff80422e9d>] tcp_push_one+0x2f/0x31
 [<ffffffff80417439>] tcp_sendmsg+0x7a1/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff803e0f6e>] ? sock_sendmsg+0xdf/0xf8
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffff803e39b3>] sock_no_sendpage+0x9b/0xaa
 [<ffffffff804176de>] tcp_sendpage+0x48/0x5ec
 [<ffffffffa054c525>] xs_sendpages+0x12c/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bf9c3>] ? nfs3_xdr_writeargs+0x0/0x87 [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
kswapd0: page allocation failure. order:1, mode:0x4020
Pid: 229, comm: kswapd0 Not tainted 2.6.30-rc8-wl #164
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa05bb774>] nfs_write_rpcsetup+0x215/0x237 [nfs]
Call Trace:
 [<ffffffffa05bd257>] nfs_flush_one+0xa2/0xd9 [nfs]
 [<ffffffffa05b82d9>] nfs_pageio_doio+0x32/0x5b [nfs]
 [<ffffffffa05b83ec>] nfs_pageio_complete+0x9/0xb [nfs]
 [<ffffffffa05bbeae>] nfs_writepages+0x101/0x13a [nfs]
 [<ffffffffa05bd1b5>] ? nfs_flush_one+0x0/0xd9 [nfs]
 [<ffffffffa05bd043>] nfs_write_mapping+0x63/0x9e [nfs]
 [<ffffffffa05bd0a7>] nfs_wb_all+0x12/0x14 [nfs]
 [<ffffffffa05b0145>] nfs_file_flush+0x8a/0xb1 [nfs]
 [<ffffffff802bb18d>] filp_close+0x40/0x63
 [<ffffffff802bb255>] sys_close+0xa5/0xe4
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
 <IRQ> Node 0  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  89
CPU    1: hi:  186, btch:  31 usd:  85
Active_anon:151538 active_file:114269 inactive_anon:47211
 inactive_file:340887 unevictable:8 dirty:36 writeback:0 unstable:2
 free:5246 slab:76536 mapped:19364 pagetables:4251 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:18880kB min:6904kB low:8628kB high:10356kB
active_anon:606152kB inactive_anon:188844kB active_file:457076kB
inactive_file:1363548kB unevictable:32kB present:2997292kB
pages_scanned:69 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB  [<ffffffff802b6362>] new_slab+0xcf/0x28b
5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB 1*1024kB 0*2048kB
0*4096kB = 2104kB
Node 0 DMA32: 4459*4kB 1*8kB  [<ffffffff802b4d1f>] ?
unfreeze_slab+0x4c/0xbd
3*16kB 0*32kB 1*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB
0*4096kB = 18852kB
456290 total pagecache pages
966 pages in swap cache
Swap cache stats: add 4587, delete 3621, find 2934/3084
Free swap  = 2091636kB
Total swap = 2104444kB
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff802b78f5>] __kmalloc_node_track_caller+0xbd/0x144
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff803e872d>] __alloc_skb+0x6f/0x143
 [<ffffffffa02d131d>] setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffffa01aaee5>] ? ssb_pci_read32+0x46/0x54 [ssb]
 [<ffffffffa02d192e>] b43_dma_rx+0x319/0x4ff [b43]
 [<ffffffffa02c55d3>] b43_interrupt_tasklet+0x699/0x7fe [b43]
 [<ffffffff8023f684>] ? tasklet_action+0x44/0xdb
 [<ffffffff8023f6c0>] tasklet_action+0x80/0xdb
 [<ffffffff8023fdc7>] __do_softirq+0xb1/0x186
 [<ffffffff8020cc7c>] call_softirq+0x1c/0x28
 [<ffffffff8020e54d>] do_softirq+0x39/0x8a
 [<ffffffff8023f988>] irq_exit+0x4e/0x88
 [<ffffffff8020de2d>] do_IRQ+0xac/0xc3
 [<ffffffff8020c4d3>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8046013e>] ? _spin_unlock_irq+0x2d/0x30
 [<ffffffff80296a35>] ? __remove_mapping+0xac/0xc6
 [<ffffffff802971b3>] ? shrink_page_list+0x558/0x69f
 [<ffffffff80296262>] ? isolate_pages_global+0x179/0x219
 [<ffffffff8046013c>] ? _spin_unlock_irq+0x2b/0x30
 [<ffffffff8025ce77>] ? trace_hardirqs_on_caller+0x10b/0x12f
 [<ffffffff80297937>] ? shrink_list+0x2a1/0x5b6
 [<ffffffff80460180>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffff80297ed7>] ? shrink_zone+0x28b/0x335
 [<ffffffff8033a0d4>] ? __up_read+0x92/0x9a
 [<ffffffff802980c3>] ? shrink_slab+0x142/0x154
 [<ffffffff80298837>] ? kswapd+0x4b1/0x692
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff802960e9>] ? isolate_pages_global+0x0/0x219
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff80298386>] ? kswapd+0x0/0x692
 [<ffffffff80298386>] ? kswapd+0x0/0x692
 [<ffffffff8024ec21>] ? kthread+0x56/0x83
 [<ffffffff8020cb7a>] ? child_rip+0xa/0x20
 [<ffffffff8020c57c>] ? restore_args+0x0/0x30
 [<ffffffff8024ebcb>] ? kthread+0x0/0x83
 [<ffffffff8020cb70>] ? child_rip+0x0/0x20
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  89
CPU    1: hi:  186, btch:  31 usd:  85
Active_anon:151538 active_file:114269 inactive_anon:47211
 inactive_file:340887 unevictable:8 dirty:36 writeback:0 unstable:2
 free:5246 slab:76536 mapped:19364 pagetables:4251 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:18880kB min:6904kB low:8628kB high:10356kB
active_anon:606152kB inactive_anon:188844kB active_file:457076kB
inactive_file:1363548kB unevictable:32kB present:2997292kB
pages_scanned:69 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 4459*4kB 1*8kB 3*16kB 0*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 18852kB
456290 total pagecache pages
966 pages in swap cache
Swap cache stats: add 4587, delete 3621, find 2934/3084
Free swap  = 2091636kB
Total swap = 2104444kB
769872 pages RAM
769872 pages RAM
21377 pages reserved
371529 pages shared
456955 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
21377 pages reserved
  node 0: slabs: 96, objs: 672, free: 0
371529 pages shared
456955 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
phy0: failed to reallocate TX buffer
kswapd0: page allocation failure. order:1, mode:0x4020
Pid: 229, comm: kswapd0 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 <IRQ>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff802b78f5>] __kmalloc_node_track_caller+0xbd/0x144
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff803e872d>] __alloc_skb+0x6f/0x143
 [<ffffffffa02d131d>] setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff8025ce5d>] ? trace_hardirqs_on_caller+0xf1/0x12f
 [<ffffffffa01aaee5>] ? ssb_pci_read32+0x46/0x54 [ssb]
 [<ffffffffa02d192e>] b43_dma_rx+0x319/0x4ff [b43]
 [<ffffffffa02c55d3>] b43_interrupt_tasklet+0x699/0x7fe [b43]
 [<ffffffff80243f1f>] ? run_timer_softirq+0x259/0x268
 [<ffffffff80243dfc>] ? run_timer_softirq+0x136/0x268
 [<ffffffff8023f684>] ? tasklet_action+0x44/0xdb
 [<ffffffff8023f6c0>] tasklet_action+0x80/0xdb
 [<ffffffff8023fdc7>] __do_softirq+0xb1/0x186
 [<ffffffff8020cc7c>] call_softirq+0x1c/0x28
 [<ffffffff8020e54d>] do_softirq+0x39/0x8a
 [<ffffffff8023f988>] irq_exit+0x4e/0x88
 [<ffffffff8020de2d>] do_IRQ+0xac/0xc3
 [<ffffffff8020c4d3>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8046013e>] ? _spin_unlock_irq+0x2d/0x30
 [<ffffffff80296a35>] ? __remove_mapping+0xac/0xc6
 [<ffffffff802971b3>] ? shrink_page_list+0x558/0x69f
 [<ffffffff80296262>] ? isolate_pages_global+0x179/0x219
 [<ffffffff8046013c>] ? _spin_unlock_irq+0x2b/0x30
 [<ffffffff8025ce77>] ? trace_hardirqs_on_caller+0x10b/0x12f
 [<ffffffff80297937>] ? shrink_list+0x2a1/0x5b6
 [<ffffffff80460180>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffff80297ed7>] ? shrink_zone+0x28b/0x335
 [<ffffffff8033a0d4>] ? __up_read+0x92/0x9a
 [<ffffffff802980c3>] ? shrink_slab+0x142/0x154
 [<ffffffff80298837>] ? kswapd+0x4b1/0x692
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff802960e9>] ? isolate_pages_global+0x0/0x219
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff80298386>] ? kswapd+0x0/0x692
 [<ffffffff80298386>] ? kswapd+0x0/0x692
 [<ffffffff8024ec21>] ? kthread+0x56/0x83
 [<ffffffff8020cb7a>] ? child_rip+0xa/0x20
 [<ffffffff8020c57c>] ? restore_args+0x0/0x30
 [<ffffffff8024ebcb>] ? kthread+0x0/0x83
 [<ffffffff8020cb70>] ? child_rip+0x0/0x20
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  89
CPU    1: hi:  186, btch:  31 usd:  84
Active_anon:151538 active_file:114269 inactive_anon:47211
 inactive_file:340887 unevictable:8 dirty:36 writeback:0 unstable:2
 free:5246 slab:76536 mapped:19364 pagetables:4251 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:18880kB min:6904kB low:8628kB high:10356kB
active_anon:606152kB inactive_anon:188844kB active_file:457076kB
inactive_file:1363548kB unevictable:32kB present:2997292kB
pages_scanned:69 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 4459*4kB 1*8kB 3*16kB 0*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 18852kB
456290 total pagecache pages
966 pages in swap cache
Swap cache stats: add 4587, delete 3621, find 2934/3084
Free swap  = 2091636kB
Total swap = 2104444kB
cc1: page allocation failure. order:1, mode:0x4020
Pid: 8867, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b4d1f>] ? unfreeze_slab+0x4c/0xbd
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff802b7e60>] __kmalloc+0x119/0x194
 [<ffffffff803e7bee>] pskb_expand_head+0x52/0x166
 [<ffffffffa02913d6>] ieee80211_skb_resize+0x91/0xc7 [mac80211]
 [<ffffffffa0291c0f>] ieee80211_master_start_xmit+0x298/0x319 [mac80211]
 [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
 [<ffffffff803ef55c>] ? dev_hard_start_xmit+0x5b/0x2a8
 [<ffffffff804005ee>] __qdisc_run+0xed/0x1fe
 [<ffffffff803efb08>] dev_queue_xmit+0x24c/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffffa0291957>] ieee80211_subif_start_xmit+0x54b/0x56b [mac80211]
 [<ffffffffa029162b>] ? ieee80211_subif_start_xmit+0x21f/0x56b [mac80211]
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff803e7790>] ? __kfree_skb+0x82/0x86
 [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
 [<ffffffff803ef55c>] ? dev_hard_start_xmit+0x5b/0x2a8
 [<ffffffff804005ee>] __qdisc_run+0xed/0x1fe
 [<ffffffff803efb08>] dev_queue_xmit+0x24c/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff80422e9d>] tcp_push_one+0x2f/0x31
 [<ffffffff80417439>] tcp_sendmsg+0x7a1/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff803e0f6e>] ? sock_sendmsg+0xdf/0xf8
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffff803e39b3>] sock_no_sendpage+0x9b/0xaa
 [<ffffffff804176de>] tcp_sendpage+0x48/0x5ec
 [<ffffffffa054c525>] xs_sendpages+0x12c/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bf9c3>] ? nfs3_xdr_writeargs+0x0/0x87 [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa05bb774>] nfs_write_rpcsetup+0x215/0x237 [nfs]
 [<ffffffffa05bd257>] nfs_flush_one+0xa2/0xd9 [nfs]
 [<ffffffffa05b82d9>] nfs_pageio_doio+0x32/0x5b [nfs]
 [<ffffffffa05b83ec>] nfs_pageio_complete+0x9/0xb [nfs]
 [<ffffffffa05bbeae>] nfs_writepages+0x101/0x13a [nfs]
 [<ffffffffa05bd1b5>] ? nfs_flush_one+0x0/0xd9 [nfs]
 [<ffffffffa05bd043>] nfs_write_mapping+0x63/0x9e [nfs]
 [<ffffffffa05bd0a7>] nfs_wb_all+0x12/0x14 [nfs]
 [<ffffffffa05b0145>] nfs_file_flush+0x8a/0xb1 [nfs]
 [<ffffffff802bb18d>] filp_close+0x40/0x63
 [<ffffffff802bb255>] sys_close+0xa5/0xe4
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  89
CPU    1: hi:  186, btch:  31 usd:  51
Active_anon:151575 active_file:114269 inactive_anon:47211
 inactive_file:340887 unevictable:8 dirty:36 writeback:0 unstable:2
 free:5246 slab:76536 mapped:19364 pagetables:4251 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:18880kB min:6904kB low:8628kB high:10356kB
active_anon:606300kB inactive_anon:188844kB active_file:457076kB
inactive_file:1363548kB unevictable:32kB present:2997292kB
pages_scanned:69 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 4459*4kB 1*8kB 3*16kB 0*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 18852kB
456290 total pagecache pages
966 pages in swap cache
Swap cache stats: add 4587, delete 3621, find 2934/3084
Free swap  = 2091636kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
371534 pages shared
456983 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
kswapd0: page allocation failure. order:1, mode:0x4020
Pid: 229, comm: kswapd0 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 <IRQ>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff802b78f5>] __kmalloc_node_track_caller+0xbd/0x144
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff803e872d>] __alloc_skb+0x6f/0x143
 [<ffffffffa02d131d>] setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffffa01aaee5>] ? ssb_pci_read32+0x46/0x54 [ssb]
 [<ffffffffa02d192e>] b43_dma_rx+0x319/0x4ff [b43]
 [<ffffffffa02c55d3>] b43_interrupt_tasklet+0x699/0x7fe [b43]
 [<ffffffff80243f1f>] ? run_timer_softirq+0x259/0x268
 [<ffffffff80243dfc>] ? run_timer_softirq+0x136/0x268
 [<ffffffff8023f684>] ? tasklet_action+0x44/0xdb
 [<ffffffff8023f6c0>] tasklet_action+0x80/0xdb
 [<ffffffff8023fdc7>] __do_softirq+0xb1/0x186
 [<ffffffff8020cc7c>] call_softirq+0x1c/0x28
 [<ffffffff8020e54d>] do_softirq+0x39/0x8a
 [<ffffffff8023f988>] irq_exit+0x4e/0x88
 [<ffffffff8020de2d>] do_IRQ+0xac/0xc3
 [<ffffffff8020c4d3>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8046013e>] ? _spin_unlock_irq+0x2d/0x30
 [<ffffffff80296a35>] ? __remove_mapping+0xac/0xc6
 [<ffffffff802971b3>] ? shrink_page_list+0x558/0x69f
 [<ffffffff80296262>] ? isolate_pages_global+0x179/0x219
 [<ffffffff8046013c>] ? _spin_unlock_irq+0x2b/0x30
 [<ffffffff8025ce77>] ? trace_hardirqs_on_caller+0x10b/0x12f
 [<ffffffff80297937>] ? shrink_list+0x2a1/0x5b6
 [<ffffffff80460180>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffff80297ed7>] ? shrink_zone+0x28b/0x335
 [<ffffffff8033a0d4>] ? __up_read+0x92/0x9a
 [<ffffffff802980c3>] ? shrink_slab+0x142/0x154
 [<ffffffff80298837>] ? kswapd+0x4b1/0x692
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff802960e9>] ? isolate_pages_global+0x0/0x219
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff80298386>] ? kswapd+0x0/0x692
 [<ffffffff80298386>] ? kswapd+0x0/0x692
 [<ffffffff8024ec21>] ? kthread+0x56/0x83
 [<ffffffff8020cb7a>] ? child_rip+0xa/0x20
 [<ffffffff8020c57c>] ? restore_args+0x0/0x30
 [<ffffffff8024ebcb>] ? kthread+0x0/0x83
 [<ffffffff8020cb70>] ? child_rip+0x0/0x20
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  89
CPU    1: hi:  186, btch:  31 usd:  51
Active_anon:151575 active_file:114269 inactive_anon:47211
 inactive_file:340887 unevictable:8 dirty:36 writeback:0 unstable:2
 free:5246 slab:76536 mapped:19364 pagetables:4251 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:18880kB min:6904kB low:8628kB high:10356kB
active_anon:606300kB inactive_anon:188844kB active_file:457076kB
inactive_file:1363548kB unevictable:32kB present:2997292kB
pages_scanned:69 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 4459*4kB 1*8kB 3*16kB 0*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 18852kB
456290 total pagecache pages
966 pages in swap cache
Swap cache stats: add 4587, delete 3621, find 2934/3084
Free swap  = 2091636kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
371535 pages shared
456983 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
cc1: page allocation failure. order:1, mode:0x4020
Pid: 8867, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b4d1f>] ? unfreeze_slab+0x4c/0xbd
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff802b7e60>] __kmalloc+0x119/0x194
 [<ffffffff803e7bee>] pskb_expand_head+0x52/0x166
 [<ffffffff80460180>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffffa02913d6>] ieee80211_skb_resize+0x91/0xc7 [mac80211]
 [<ffffffffa0291815>] ieee80211_subif_start_xmit+0x409/0x56b [mac80211]
 [<ffffffffa029162b>] ? ieee80211_subif_start_xmit+0x21f/0x56b [mac80211]
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff803e7790>] ? __kfree_skb+0x82/0x86
 [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
 [<ffffffff803ef55c>] ? dev_hard_start_xmit+0x5b/0x2a8
 [<ffffffff804005ee>] __qdisc_run+0xed/0x1fe
 [<ffffffff803efb08>] dev_queue_xmit+0x24c/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff802b40a2>] ? get_partial_node+0x1b/0x8a
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff803e33a8>] ? release_sock+0xcd/0xd6
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff803e3497>] ? lock_sock_nested+0xe6/0xf5
 [<ffffffff80422ec9>] __tcp_push_pending_frames+0x2a/0x81
 [<ffffffff80417590>] tcp_sendmsg+0x8f8/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff803e11f7>] ? kernel_sendmsg+0x34/0x49
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffffa054c3f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
 [<ffffffffa054c583>] xs_sendpages+0x18a/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bf9c3>] ? nfs3_xdr_writeargs+0x0/0x87 [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa05bb774>] nfs_write_rpcsetup+0x215/0x237 [nfs]
 [<ffffffffa05bd257>] nfs_flush_one+0xa2/0xd9 [nfs]
 [<ffffffffa05b82d9>] nfs_pageio_doio+0x32/0x5b [nfs]
 [<ffffffffa05b83ec>] nfs_pageio_complete+0x9/0xb [nfs]
 [<ffffffffa05bbeae>] nfs_writepages+0x101/0x13a [nfs]
 [<ffffffffa05bd1b5>] ? nfs_flush_one+0x0/0xd9 [nfs]
 [<ffffffffa05bd043>] nfs_write_mapping+0x63/0x9e [nfs]
 [<ffffffffa05bd0a7>] nfs_wb_all+0x12/0x14 [nfs]
 [<ffffffffa05b0145>] nfs_file_flush+0x8a/0xb1 [nfs]
 [<ffffffff802bb18d>] filp_close+0x40/0x63
 [<ffffffff802bb255>] sys_close+0xa5/0xe4
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  89
CPU    1: hi:  186, btch:  31 usd:  51
Active_anon:151575 active_file:114269 inactive_anon:47211
 inactive_file:340887 unevictable:8 dirty:36 writeback:0 unstable:2
 free:5246 slab:76536 mapped:19364 pagetables:4251 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:18880kB min:6904kB low:8628kB high:10356kB
active_anon:606300kB inactive_anon:188844kB active_file:457076kB
inactive_file:1363548kB unevictable:32kB present:2997292kB
pages_scanned:69 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 4459*4kB 1*8kB 3*16kB 0*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 18852kB
456290 total pagecache pages
966 pages in swap cache
Swap cache stats: add 4587, delete 3621, find 2934/3084
Free swap  = 2091636kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
371535 pages shared
456983 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
kswapd0: page allocation failure. order:1, mode:0x4020
Pid: 229, comm: kswapd0 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 <IRQ>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff802b78f5>] __kmalloc_node_track_caller+0xbd/0x144
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff803e872d>] __alloc_skb+0x6f/0x143
 [<ffffffffa02d131d>] setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffffa01aaee5>] ? ssb_pci_read32+0x46/0x54 [ssb]
 [<ffffffffa02d192e>] b43_dma_rx+0x319/0x4ff [b43]
 [<ffffffffa02c55d3>] b43_interrupt_tasklet+0x699/0x7fe [b43]
 [<ffffffff80243f1f>] ? run_timer_softirq+0x259/0x268
 [<ffffffff80243dfc>] ? run_timer_softirq+0x136/0x268
 [<ffffffff8023f684>] ? tasklet_action+0x44/0xdb
 [<ffffffff8023f6c0>] tasklet_action+0x80/0xdb
 [<ffffffff8023fdc7>] __do_softirq+0xb1/0x186
 [<ffffffff8020cc7c>] call_softirq+0x1c/0x28
 [<ffffffff8020e54d>] do_softirq+0x39/0x8a
 [<ffffffff8023f988>] irq_exit+0x4e/0x88
 [<ffffffff8020de2d>] do_IRQ+0xac/0xc3
 [<ffffffff8020c4d3>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8046013e>] ? _spin_unlock_irq+0x2d/0x30
 [<ffffffff80296a35>] ? __remove_mapping+0xac/0xc6
 [<ffffffff802971b3>] ? shrink_page_list+0x558/0x69f
 [<ffffffff80296262>] ? isolate_pages_global+0x179/0x219
 [<ffffffff8046013c>] ? _spin_unlock_irq+0x2b/0x30
 [<ffffffff8025ce77>] ? trace_hardirqs_on_caller+0x10b/0x12f
 [<ffffffff80297937>] ? shrink_list+0x2a1/0x5b6
 [<ffffffff80460180>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffff80297ed7>] ? shrink_zone+0x28b/0x335
 [<ffffffff8033a0d4>] ? __up_read+0x92/0x9a
 [<ffffffff802980c3>] ? shrink_slab+0x142/0x154
 [<ffffffff80298837>] ? kswapd+0x4b1/0x692
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff802960e9>] ? isolate_pages_global+0x0/0x219
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff80298386>] ? kswapd+0x0/0x692
 [<ffffffff80298386>] ? kswapd+0x0/0x692
 [<ffffffff8024ec21>] ? kthread+0x56/0x83
 [<ffffffff8020cb7a>] ? child_rip+0xa/0x20
 [<ffffffff8020c57c>] ? restore_args+0x0/0x30
 [<ffffffff8024ebcb>] ? kthread+0x0/0x83
 [<ffffffff8020cb70>] ? child_rip+0x0/0x20
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  89
CPU    1: hi:  186, btch:  31 usd:  51
Active_anon:151575 active_file:114269 inactive_anon:47211
 inactive_file:340887 unevictable:8 dirty:36 writeback:0 unstable:2
 free:5246 slab:76536 mapped:19364 pagetables:4251 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:18880kB min:6904kB low:8628kB high:10356kB
active_anon:606300kB inactive_anon:188844kB active_file:457076kB
inactive_file:1363548kB unevictable:32kB present:2997292kB
pages_scanned:69 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 4459*4kB 1*8kB 3*16kB 0*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 18852kB
456290 total pagecache pages
966 pages in swap cache
Swap cache stats: add 4587, delete 3621, find 2934/3084
Free swap  = 2091636kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
371535 pages shared
456983 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
cc1: page allocation failure. order:1, mode:0x4020
Pid: 8867, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 <IRQ>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff802b7e60>] __kmalloc+0x119/0x194
 [<ffffffff803e7bee>] pskb_expand_head+0x52/0x166
 [<ffffffff80460180>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffffa02913d6>] ieee80211_skb_resize+0x91/0xc7 [mac80211]
 [<ffffffffa0291815>] ieee80211_subif_start_xmit+0x409/0x56b [mac80211]
 [<ffffffffa029162b>] ? ieee80211_subif_start_xmit+0x21f/0x56b [mac80211]
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff803e7790>] ? __kfree_skb+0x82/0x86
 [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
 [<ffffffff803ef55c>] ? dev_hard_start_xmit+0x5b/0x2a8
 [<ffffffff804005ee>] __qdisc_run+0xed/0x1fe
 [<ffffffff803ed179>] net_tx_action+0xd9/0x156
 [<ffffffff8023fdc7>] __do_softirq+0xb1/0x186
 [<ffffffff8020cc7c>] call_softirq+0x1c/0x28
 <EOI>  [<ffffffff8020e54d>] do_softirq+0x39/0x8a
 [<ffffffff803efc0e>] ? dev_queue_xmit+0x352/0x384
 [<ffffffff8023fc57>] local_bh_enable+0xb5/0xcf
 [<ffffffff803efc0e>] dev_queue_xmit+0x352/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff802b40a2>] ? get_partial_node+0x1b/0x8a
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff803e33a8>] ? release_sock+0xcd/0xd6
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff803e3497>] ? lock_sock_nested+0xe6/0xf5
 [<ffffffff80422ec9>] __tcp_push_pending_frames+0x2a/0x81
 [<ffffffff80417590>] tcp_sendmsg+0x8f8/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff803e11f7>] ? kernel_sendmsg+0x34/0x49
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffffa054c3f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
 [<ffffffffa054c583>] xs_sendpages+0x18a/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bf9c3>] ? nfs3_xdr_writeargs+0x0/0x87 [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa05bb774>] nfs_write_rpcsetup+0x215/0x237 [nfs]
 [<ffffffffa05bd257>] nfs_flush_one+0xa2/0xd9 [nfs]
 [<ffffffffa05b82d9>] nfs_pageio_doio+0x32/0x5b [nfs]
 [<ffffffffa05b83ec>] nfs_pageio_complete+0x9/0xb [nfs]
 [<ffffffffa05bbeae>] nfs_writepages+0x101/0x13a [nfs]
 [<ffffffffa05bd1b5>] ? nfs_flush_one+0x0/0xd9 [nfs]
 [<ffffffffa05bd043>] nfs_write_mapping+0x63/0x9e [nfs]
 [<ffffffffa05bd0a7>] nfs_wb_all+0x12/0x14 [nfs]
 [<ffffffffa05b0145>] nfs_file_flush+0x8a/0xb1 [nfs]
 [<ffffffff802bb18d>] filp_close+0x40/0x63
 [<ffffffff802bb255>] sys_close+0xa5/0xe4
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  89
CPU    1: hi:  186, btch:  31 usd:  51
Active_anon:151575 active_file:114269 inactive_anon:47211
 inactive_file:340887 unevictable:8 dirty:36 writeback:0 unstable:2
 free:5246 slab:76536 mapped:19364 pagetables:4251 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:18880kB min:6904kB low:8628kB high:10356kB
active_anon:606300kB inactive_anon:188844kB active_file:457076kB
inactive_file:1363548kB unevictable:32kB present:2997292kB
pages_scanned:69 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 4459*4kB 1*8kB 3*16kB 0*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 18852kB
456290 total pagecache pages
966 pages in swap cache
Swap cache stats: add 4587, delete 3621, find 2934/3084
Free swap  = 2091636kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
371535 pages shared
456983 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
kswapd0: page allocation failure. order:1, mode:0x4020
Pid: 229, comm: kswapd0 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 <IRQ>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff802b78f5>] __kmalloc_node_track_caller+0xbd/0x144
 [<ffffffffa02d131d>] ? setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffff803e872d>] __alloc_skb+0x6f/0x143
 [<ffffffffa02d131d>] setup_rx_descbuffer+0x4b/0x2d7 [b43]
 [<ffffffffa01aaee5>] ? ssb_pci_read32+0x46/0x54 [ssb]
 [<ffffffffa02d192e>] b43_dma_rx+0x319/0x4ff [b43]
 [<ffffffffa02c55d3>] b43_interrupt_tasklet+0x699/0x7fe [b43]
 [<ffffffff80243f1f>] ? run_timer_softirq+0x259/0x268
 [<ffffffff80243dfc>] ? run_timer_softirq+0x136/0x268
 [<ffffffff8023f684>] ? tasklet_action+0x44/0xdb
 [<ffffffff8023f6c0>] tasklet_action+0x80/0xdb
 [<ffffffff8023fdc7>] __do_softirq+0xb1/0x186
 [<ffffffff8020cc7c>] call_softirq+0x1c/0x28
 [<ffffffff8020e54d>] do_softirq+0x39/0x8a
 [<ffffffff8023f988>] irq_exit+0x4e/0x88
 [<ffffffff8020de2d>] do_IRQ+0xac/0xc3
 [<ffffffff8020c4d3>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff8046013e>] ? _spin_unlock_irq+0x2d/0x30
 [<ffffffff80296a35>] ? __remove_mapping+0xac/0xc6
 [<ffffffff802971b3>] ? shrink_page_list+0x558/0x69f
 [<ffffffff80296262>] ? isolate_pages_global+0x179/0x219
 [<ffffffff8046013c>] ? _spin_unlock_irq+0x2b/0x30
 [<ffffffff8025ce77>] ? trace_hardirqs_on_caller+0x10b/0x12f
 [<ffffffff80297937>] ? shrink_list+0x2a1/0x5b6
 [<ffffffff80460180>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffff80297ed7>] ? shrink_zone+0x28b/0x335
 [<ffffffff8033a0d4>] ? __up_read+0x92/0x9a
 [<ffffffff802980c3>] ? shrink_slab+0x142/0x154
 [<ffffffff80298837>] ? kswapd+0x4b1/0x692
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff802960e9>] ? isolate_pages_global+0x0/0x219
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff80298386>] ? kswapd+0x0/0x692
 [<ffffffff80298386>] ? kswapd+0x0/0x692
 [<ffffffff8024ec21>] ? kthread+0x56/0x83
 [<ffffffff8020cb7a>] ? child_rip+0xa/0x20
 [<ffffffff8020c57c>] ? restore_args+0x0/0x30
 [<ffffffff8024ebcb>] ? kthread+0x0/0x83
 [<ffffffff8020cb70>] ? child_rip+0x0/0x20
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  89
CPU    1: hi:  186, btch:  31 usd:  51
Active_anon:151575 active_file:114269 inactive_anon:47211
 inactive_file:340887 unevictable:8 dirty:36 writeback:0 unstable:2
 free:5246 slab:76536 mapped:19364 pagetables:4251 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:18880kB min:6904kB low:8628kB high:10356kB
active_anon:606300kB inactive_anon:188844kB active_file:457076kB
inactive_file:1363548kB unevictable:32kB present:2997292kB
pages_scanned:69 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 4459*4kB 1*8kB 3*16kB 0*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 18852kB
456290 total pagecache pages
966 pages in swap cache
Swap cache stats: add 4587, delete 3621, find 2934/3084
Free swap  = 2091636kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
371535 pages shared
456983 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
protocol 0008 is buggy, dev eth1
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
protocol 0008 is buggy, dev eth1
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
protocol 0008 is buggy, dev eth1
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
protocol 0008 is buggy, dev eth1
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
protocol 0008 is buggy, dev eth1
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
protocol 0008 is buggy, dev eth1
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
protocol 0008 is buggy, dev eth1
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
protocol 0008 is buggy, dev eth1
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
protocol 0008 is buggy, dev eth1
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
protocol 0008 is buggy, dev eth1
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
769872 pages RAM
21377 pages reserved
371535 pages shared
456983 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 96, objs: 672, free: 0
b43-phy0 debug: DMA RX: setup_rx_descbuffer() failed
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
phy0: failed to reallocate TX buffer
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
phy0: failed to reallocate TX buffer
__ratelimit: 73 callbacks suppressed
cc1: page allocation failure. order:1, mode:0x4020
Pid: 9042, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b4d1f>] ? unfreeze_slab+0x4c/0xbd
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff802b7e60>] __kmalloc+0x119/0x194
 [<ffffffff803e7bee>] pskb_expand_head+0x52/0x166
 [<ffffffff80460180>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffffa02913d6>] ieee80211_skb_resize+0x91/0xc7 [mac80211]
 [<ffffffffa0291815>] ieee80211_subif_start_xmit+0x409/0x56b [mac80211]
 [<ffffffffa029162b>] ? ieee80211_subif_start_xmit+0x21f/0x56b [mac80211]
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff803e7790>] ? __kfree_skb+0x82/0x86
 [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
 [<ffffffff803ef55c>] ? dev_hard_start_xmit+0x5b/0x2a8
 [<ffffffff804005ee>] __qdisc_run+0xed/0x1fe
 [<ffffffff803efb08>] dev_queue_xmit+0x24c/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff802b40a2>] ? get_partial_node+0x1b/0x8a
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff802b790b>] ? __kmalloc_node_track_caller+0xd3/0x144
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff803e872d>] ? __alloc_skb+0x6f/0x143
 [<ffffffff80422ec9>] __tcp_push_pending_frames+0x2a/0x81
 [<ffffffff80417590>] tcp_sendmsg+0x8f8/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffffa054c3f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
 [<ffffffffa054c486>] xs_sendpages+0x8d/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bfc11>] ? nfs3_xdr_fhandle+0x0/0x2e [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa054972f>] rpc_call_sync+0x3f/0x5d [sunrpc]
 [<ffffffffa05bdcd0>] nfs3_rpc_wrapper+0x22/0x5c [nfs]
 [<ffffffffa05be40c>] nfs3_proc_getattr+0x5b/0x81 [nfs]
 [<ffffffffa05b1e22>] __nfs_revalidate_inode+0xbd/0x1c9 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05d0529>] ? nfs_have_delegation+0x79/0x82 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05acb60>] nfs_lookup_revalidate+0x265/0x49c [nfs]
 [<ffffffff802ccfa9>] ? __d_lookup+0xba/0x16a
 [<ffffffff802cd047>] ? __d_lookup+0x158/0x16a
 [<ffffffff802cceef>] ? __d_lookup+0x0/0x16a
 [<ffffffffa0550992>] ? rpcauth_lookupcred+0x77/0x9f [sunrpc]
 [<ffffffff802c49c6>] do_lookup+0x166/0x1bb
 [<ffffffff802c66b7>] __link_path_walk+0x8f8/0xd58
 [<ffffffff802c6d1d>] path_walk+0x69/0xd4
 [<ffffffff802c6fb6>] do_path_lookup+0x187/0x1df
 [<ffffffff802bdf80>] ? get_empty_filp+0xe9/0x14e
 [<ffffffff802c7c4b>] do_filp_open+0x105/0x909
 [<ffffffff802d0bb6>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802bb2ea>] do_sys_open+0x56/0xd6
 [<ffffffff802bb393>] sys_open+0x1b/0x1d
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  13
CPU    1: hi:  186, btch:  31 usd: 173
Active_anon:163559 active_file:111927 inactive_anon:47119
 inactive_file:334673 unevictable:8 dirty:23 writeback:0 unstable:0
 free:2704 slab:75670 mapped:19336 pagetables:4281 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:8712kB min:6904kB low:8628kB high:10356kB
active_anon:654236kB inactive_anon:188476kB active_file:447708kB
inactive_file:1338692kB unevictable:32kB present:2997292kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 1910*4kB 6*8kB 6*16kB 0*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 8744kB
447641 total pagecache pages
962 pages in swap cache
Swap cache stats: add 4651, delete 3689, find 2934/3084
Free swap  = 2091380kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
365043 pages shared
466540 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 97, objs: 679, free: 0
phy0: failed to reallocate TX buffer
cc1: page allocation failure. order:1, mode:0x4020
Pid: 10081, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b4d1f>] ? unfreeze_slab+0x4c/0xbd
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff802b7e60>] __kmalloc+0x119/0x194
 [<ffffffff803e7bee>] pskb_expand_head+0x52/0x166
 [<ffffffffa02913d6>] ieee80211_skb_resize+0x91/0xc7 [mac80211]
 [<ffffffffa0291c0f>] ieee80211_master_start_xmit+0x298/0x319 [mac80211]
 [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
 [<ffffffff803ef55c>] ? dev_hard_start_xmit+0x5b/0x2a8
 [<ffffffff804005ee>] __qdisc_run+0xed/0x1fe
 [<ffffffff803efb08>] dev_queue_xmit+0x24c/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffffa0291957>] ieee80211_subif_start_xmit+0x54b/0x56b [mac80211]
 [<ffffffffa029162b>] ? ieee80211_subif_start_xmit+0x21f/0x56b [mac80211]
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff803e7790>] ? __kfree_skb+0x82/0x86
 [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
 [<ffffffff803ef55c>] ? dev_hard_start_xmit+0x5b/0x2a8
 [<ffffffff804005ee>] __qdisc_run+0xed/0x1fe
 [<ffffffff803efb08>] dev_queue_xmit+0x24c/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff802b790b>] ? __kmalloc_node_track_caller+0xd3/0x144
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff803e872d>] ? __alloc_skb+0x6f/0x143
 [<ffffffff80422ec9>] __tcp_push_pending_frames+0x2a/0x81
 [<ffffffff80417590>] tcp_sendmsg+0x8f8/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffffa054c3f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
 [<ffffffffa054c486>] xs_sendpages+0x8d/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bfc11>] ? nfs3_xdr_fhandle+0x0/0x2e [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa054972f>] rpc_call_sync+0x3f/0x5d [sunrpc]
 [<ffffffffa05bdcd0>] nfs3_rpc_wrapper+0x22/0x5c [nfs]
 [<ffffffffa05be40c>] nfs3_proc_getattr+0x5b/0x81 [nfs]
 [<ffffffffa05b1e22>] __nfs_revalidate_inode+0xbd/0x1c9 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05d0529>] ? nfs_have_delegation+0x79/0x82 [nfs]
 [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
 [<ffffffffa05acb60>] nfs_lookup_revalidate+0x265/0x49c [nfs]
 [<ffffffff802ccfa9>] ? __d_lookup+0xba/0x16a
 [<ffffffff802cd047>] ? __d_lookup+0x158/0x16a
 [<ffffffff802cceef>] ? __d_lookup+0x0/0x16a
 [<ffffffffa0550992>] ? rpcauth_lookupcred+0x77/0x9f [sunrpc]
 [<ffffffff802c49c6>] do_lookup+0x166/0x1bb
 [<ffffffff802c66b7>] __link_path_walk+0x8f8/0xd58
 [<ffffffff802c6d1d>] path_walk+0x69/0xd4
 [<ffffffff802c6fb6>] do_path_lookup+0x187/0x1df
 [<ffffffff802bdf80>] ? get_empty_filp+0xe9/0x14e
 [<ffffffff802c7c4b>] do_filp_open+0x105/0x909
 [<ffffffff802d0bb6>] ? alloc_fd+0x11d/0x12e
 [<ffffffff802bb2ea>] do_sys_open+0x56/0xd6
 [<ffffffff802bb393>] sys_open+0x1b/0x1d
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  60
CPU    1: hi:  186, btch:  31 usd: 132
Active_anon:162603 active_file:111766 inactive_anon:47119
 inactive_file:332454 unevictable:8 dirty:11 writeback:0 unstable:0
 free:6493 slab:75317 mapped:19281 pagetables:4242 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:23868kB min:6904kB low:8628kB high:10356kB
active_anon:650412kB inactive_anon:188476kB active_file:447064kB
inactive_file:1329816kB unevictable:32kB present:2997292kB
pages_scanned:154 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 5688*4kB 1*8kB 3*16kB 0*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 23768kB
445272 total pagecache pages
946 pages in swap cache
Swap cache stats: add 4659, delete 3713, find 2934/3084
Free swap  = 2091348kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
357698 pages shared
466721 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 0
phy0: failed to reallocate TX buffer
cc1: page allocation failure. order:1, mode:0x4020
Pid: 10064, comm: cc1 Not tainted 2.6.30-rc8-wl #164
Call Trace:
 [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
 [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
 [<ffffffff802b6362>] new_slab+0xcf/0x28b
 [<ffffffff802b4d1f>] ? unfreeze_slab+0x4c/0xbd
 [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
 [<ffffffff802b7e60>] __kmalloc+0x119/0x194
 [<ffffffff803e7bee>] pskb_expand_head+0x52/0x166
 [<ffffffff80460180>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffffa02913d6>] ieee80211_skb_resize+0x91/0xc7 [mac80211]
 [<ffffffffa0291815>] ieee80211_subif_start_xmit+0x409/0x56b [mac80211]
 [<ffffffffa029162b>] ? ieee80211_subif_start_xmit+0x21f/0x56b [mac80211]
 [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff803e7790>] ? __kfree_skb+0x82/0x86
 [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
 [<ffffffff803ef55c>] ? dev_hard_start_xmit+0x5b/0x2a8
 [<ffffffff804005ee>] __qdisc_run+0xed/0x1fe
 [<ffffffff803efb08>] dev_queue_xmit+0x24c/0x384
 [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
 [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
 [<ffffffff803e33a8>] ? release_sock+0xcd/0xd6
 [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
 [<ffffffff8040f093>] ip_local_out+0x20/0x24
 [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
 [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
 [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
 [<ffffffff80422e9d>] tcp_push_one+0x2f/0x31
 [<ffffffff80417439>] tcp_sendmsg+0x7a1/0x9fe
 [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
 [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff803e0f6e>] ? sock_sendmsg+0xdf/0xf8
 [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
 [<ffffffff803e39b3>] sock_no_sendpage+0x9b/0xaa
 [<ffffffff804176de>] tcp_sendpage+0x48/0x5ec
 [<ffffffffa054c525>] xs_sendpages+0x12c/0x1af [sunrpc]
 [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
 [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
 [<ffffffffa05bf9c3>] ? nfs3_xdr_writeargs+0x0/0x87 [nfs]
 [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
 [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
 [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
 [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
 [<ffffffffa05bb774>] nfs_write_rpcsetup+0x215/0x237 [nfs]
 [<ffffffffa05bd257>] nfs_flush_one+0xa2/0xd9 [nfs]
 [<ffffffffa05b82d9>] nfs_pageio_doio+0x32/0x5b [nfs]
 [<ffffffffa05b83ec>] nfs_pageio_complete+0x9/0xb [nfs]
 [<ffffffffa05bbeae>] nfs_writepages+0x101/0x13a [nfs]
 [<ffffffffa05bd1b5>] ? nfs_flush_one+0x0/0xd9 [nfs]
 [<ffffffffa05bd043>] nfs_write_mapping+0x63/0x9e [nfs]
 [<ffffffffa05bd0a7>] nfs_wb_all+0x12/0x14 [nfs]
 [<ffffffffa05b0145>] nfs_file_flush+0x8a/0xb1 [nfs]
 [<ffffffff802bb18d>] filp_close+0x40/0x63
 [<ffffffff802bb255>] sys_close+0xa5/0xe4
 [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:  42
CPU    1: hi:  186, btch:  31 usd: 207
Active_anon:165674 active_file:111453 inactive_anon:47087
 inactive_file:331621 unevictable:8 dirty:11 writeback:0 unstable:0
 free:4632 slab:75221 mapped:19318 pagetables:4242 bounce:0
Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
present:15220kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2927 2927 2927
Node 0 DMA32 free:16424kB min:6904kB low:8628kB high:10356kB
active_anon:662696kB inactive_anon:188348kB active_file:445812kB
inactive_file:1326484kB unevictable:32kB present:2997292kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
1*1024kB 0*2048kB 0*4096kB = 2104kB
Node 0 DMA32: 3831*4kB 1*8kB 3*16kB 0*32kB 1*64kB 1*128kB 1*256kB
1*512kB 0*1024kB 0*2048kB 0*4096kB = 16340kB
444199 total pagecache pages
962 pages in swap cache
Swap cache stats: add 4683, delete 3721, find 2934/3084
Free swap  = 2091252kB
Total swap = 2104444kB
769872 pages RAM
21377 pages reserved
358924 pages shared
469842 pages non-shared
SLUB: Unable to allocate memory on node -1 (gfp=20)
  cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
order: 3, min order: 1
  node 0: slabs: 95, objs: 665, free: 2
phy0: failed to reallocate TX buffer

If you need the rest of the dmesg output, or anything else, please let
me know.

Larry

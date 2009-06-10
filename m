Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbZFJPo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbZFJPo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 11:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758382AbZFJPoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 11:44:21 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48788 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136AbZFJPoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:44:19 -0400
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, npiggin@suse.de,
       yanmin.zhang@linux.intel.com, akpm@linux-foundation.org
In-Reply-To: <4A2FC62C.6030407@lwfinger.net>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net>
	 <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com>
	 <4A2BCC6F.8090004@redhat.com>
	 <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com>
	 <20090608101739.GA15377@csn.ul.ie>
	 <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>
	 <20090608110303.GD15377@csn.ul.ie>
	 <Pine.LNX.4.64.0906081657001.7036@melkki.cs.Helsinki.FI>
	 <20090608141212.GE15070@csn.ul.ie> <1244531201.5024.3.camel@penberg-laptop>
	 <alpine.DEB.2.00.0906090046000.28701@chino.kir.corp.google.com>
	 <1244534315.5024.34.camel@penberg-laptop>
	 <alpine.DEB.2.00.0906090105270.28701@chino.kir.corp.google.com>
	 <1244536124.5024.41.camel@penberg-laptop>  <4A2FC62C.6030407@lwfinger.net>
Date: Wed, 10 Jun 2009 18:44:19 +0300
Message-Id: <1244648659.23799.26.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-10 at 09:41 -0500, Larry Finger wrote:
> With the above patch installed, I pushed my system hard enough to get
> the O(1) allocation failures. This time they were triggered with a
> 'make -j8' on the kernel. No, I don't have that many CPUs, but I
> figured that the extra make jobs might stress memory. My kernel is
> 2.6.30-rc8 from the wireless-testing tree. Everything matches Linus's
> tree except drivers/net/wireless/, which contains what is essentially
> 2.6.31 code.
> 
> The dmesg output starting with the first allocation failure is:
> 
> cc1: page allocation failure. order:1, mode:0x4020
> Pid: 6577, comm: cc1 Not tainted 2.6.30-rc8-wl #164
> Call Trace:
>  [<ffffffff80292a7b>] __alloc_pages_internal+0x43d/0x45e
>  [<ffffffff802b1f1f>] alloc_pages_current+0xbe/0xc6
>  [<ffffffff802b6362>] new_slab+0xcf/0x28b
>  [<ffffffff802b4d1f>] ? unfreeze_slab+0x4c/0xbd
>  [<ffffffff802b672e>] __slab_alloc+0x210/0x44c
>  [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
>  [<ffffffff803e7bee>] ? pskb_expand_head+0x52/0x166
>  [<ffffffff802b7e60>] __kmalloc+0x119/0x194
>  [<ffffffff803e7bee>] pskb_expand_head+0x52/0x166
>  [<ffffffffa02913d6>] ieee80211_skb_resize+0x91/0xc7 [mac80211]
>  [<ffffffffa0291c0f>] ieee80211_master_start_xmit+0x298/0x319 [mac80211]
>  [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
>  [<ffffffff803ef55c>] ? dev_hard_start_xmit+0x5b/0x2a8
>  [<ffffffff804005ee>] __qdisc_run+0xed/0x1fe
>  [<ffffffff803efb08>] dev_queue_xmit+0x24c/0x384
>  [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
>  [<ffffffffa0291957>] ieee80211_subif_start_xmit+0x54b/0x56b [mac80211]
>  [<ffffffffa029162b>] ? ieee80211_subif_start_xmit+0x21f/0x56b [mac80211]
>  [<ffffffff8025cea8>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff803e7790>] ? __kfree_skb+0x82/0x86
>  [<ffffffff803ef72a>] dev_hard_start_xmit+0x229/0x2a8
>  [<ffffffff803ef55c>] ? dev_hard_start_xmit+0x5b/0x2a8
>  [<ffffffff804005ee>] __qdisc_run+0xed/0x1fe
>  [<ffffffff803efb08>] dev_queue_xmit+0x24c/0x384
>  [<ffffffff803efa2f>] ? dev_queue_xmit+0x173/0x384
>  [<ffffffff8040fec9>] ip_finish_output+0x217/0x25c
>  [<ffffffff802b4038>] ? add_partial+0x1a/0x69
>  [<ffffffff8040ffaa>] ip_output+0x9c/0xa1
>  [<ffffffff8040f093>] ip_local_out+0x20/0x24
>  [<ffffffff8040f900>] ip_queue_xmit+0x2e0/0x337
>  [<ffffffff8042087e>] tcp_transmit_skb+0x5f7/0x63a
>  [<ffffffff802b790b>] ? __kmalloc_node_track_caller+0xd3/0x144
>  [<ffffffff80422d89>] tcp_write_xmit+0x83f/0x924
>  [<ffffffff803e872d>] ? __alloc_skb+0x6f/0x143
>  [<ffffffff80422ec9>] __tcp_push_pending_frames+0x2a/0x81
>  [<ffffffff80417590>] tcp_sendmsg+0x8f8/0x9fe
>  [<ffffffff803e0f6e>] sock_sendmsg+0xdf/0xf8
>  [<ffffffff8024efec>] ? autoremove_wake_function+0x0/0x38
>  [<ffffffff8023695c>] ? finish_task_switch+0x3b/0xdc
>  [<ffffffff803e11f7>] kernel_sendmsg+0x34/0x49
>  [<ffffffffa054c3f0>] xs_send_kvec+0x7a/0x83 [sunrpc]
>  [<ffffffffa054c486>] xs_sendpages+0x8d/0x1af [sunrpc]
>  [<ffffffffa054c6b1>] xs_tcp_send_request+0x52/0x149 [sunrpc]
>  [<ffffffffa054b470>] xprt_transmit+0x178/0x234 [sunrpc]
>  [<ffffffffa05bfc11>] ? nfs3_xdr_fhandle+0x0/0x2e [nfs]
>  [<ffffffffa0548d02>] call_transmit+0x20e/0x250 [sunrpc]
>  [<ffffffffa054f8a7>] __rpc_execute+0x86/0x244 [sunrpc]
>  [<ffffffffa054fa8d>] rpc_execute+0x28/0x2c [sunrpc]
>  [<ffffffffa054963c>] rpc_run_task+0x56/0x5e [sunrpc]
>  [<ffffffffa054972f>] rpc_call_sync+0x3f/0x5d [sunrpc]
>  [<ffffffffa05bdcd0>] nfs3_rpc_wrapper+0x22/0x5c [nfs]
>  [<ffffffffa05be40c>] nfs3_proc_getattr+0x5b/0x81 [nfs]
>  [<ffffffffa05b1e22>] __nfs_revalidate_inode+0xbd/0x1c9 [nfs]
>  [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
>  [<ffffffffa05d0529>] ? nfs_have_delegation+0x79/0x82 [nfs]
>  [<ffffffffa05d04b0>] ? nfs_have_delegation+0x0/0x82 [nfs]
>  [<ffffffffa05acb60>] nfs_lookup_revalidate+0x265/0x49c [nfs]
>  [<ffffffff802ccfa9>] ? __d_lookup+0xba/0x16a
>  [<ffffffff802cd047>] ? __d_lookup+0x158/0x16a
>  [<ffffffff802cceef>] ? __d_lookup+0x0/0x16a
>  [<ffffffffa0550992>] ? rpcauth_lookupcred+0x77/0x9f [sunrpc]
>  [<ffffffff802c49c6>] do_lookup+0x166/0x1bb
>  [<ffffffff802c66b7>] __link_path_walk+0x8f8/0xd58
>  [<ffffffff802c6d1d>] path_walk+0x69/0xd4
>  [<ffffffff802c6fb6>] do_path_lookup+0x187/0x1df
>  [<ffffffff802bdf80>] ? get_empty_filp+0xe9/0x14e
>  [<ffffffff802c7c4b>] do_filp_open+0x105/0x909
>  [<ffffffff802d0bb6>] ? alloc_fd+0x11d/0x12e
>  [<ffffffff802bb2ea>] do_sys_open+0x56/0xd6
>  [<ffffffff802bb393>] sys_open+0x1b/0x1d
>  [<ffffffff8020baab>] system_call_fastpath+0x16/0x1b
> Mem-Info:
> Node 0 DMA per-cpu:
> CPU    0: hi:    0, btch:   1 usd:   0
> CPU    1: hi:    0, btch:   1 usd:   0
> Node 0 DMA32 per-cpu:
> CPU    0: hi:  186, btch:  31 usd:  15
> CPU    1: hi:  186, btch:  31 usd:  65
> Active_anon:128724 active_file:123018 inactive_anon:47276
>  inactive_file:355583 unevictable:8 dirty:18 writeback:0 unstable:0
>  free:3621 slab:77881 mapped:18629 pagetables:4056 bounce:0
> Node 0 DMA free:2104kB min:32kB low:40kB high:48kB active_anon:0kB
> inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
> present:15220kB pages_scanned:0 all_unreclaimable? yes
> lowmem_reserve[]: 0 2927 2927 2927
> Node 0 DMA32 free:12380kB min:6904kB low:8628kB high:10356kB
> active_anon:514896kB inactive_anon:189104kB active_file:492072kB
> inactive_file:1422332kB unevictable:32kB present:2997292kB
> pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 0 0 0
> Node 0 DMA: 4*4kB 3*8kB 5*16kB 2*32kB 4*64kB 1*128kB 2*256kB 0*512kB
> 1*1024kB 0*2048kB 0*4096kB = 2104kB
> Node 0 DMA32: 2821*4kB 1*8kB 3*16kB 1*32kB 1*64kB 1*128kB 1*256kB
> 1*512kB 0*1024kB 0*2048kB 0*4096kB = 12332kB
> 479694 total pagecache pages
> 969 pages in swap cache
> Swap cache stats: add 4523, delete 3554, find 2913/3063
> Free swap  = 2091884kB
> Total swap = 2104444kB
> 769872 pages RAM
> 21377 pages reserved
> 382252 pages shared
> 441407 pages non-shared
> SLUB: Unable to allocate memory on node -1 (gfp=20)
>   cache: kmalloc-4096, object size: 4096, buffer size: 4168, default
> order: 3, min order: 1
>   node 0: slabs: 95, objs: 665, free: 0
> phy0: failed to reallocate TX buffer

Aha, SLUB thinks the minimum order for 4096 is 1. I guess you have
CONFIG_SLUB_DEBUG enabled? If yes, something like to following should
help. Christoph, are you okay with this patch?

			Pekka

diff --git a/mm/slub.c b/mm/slub.c
index 65ffda5..2c93c30 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2334,6 +2334,8 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 
 }
 
+#define MAX_DEBUG_SIZE (3 * sizeof(void *) + 2 * sizeof(struct track))
+
 static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 		const char *name, size_t size,
 		size_t align, unsigned long flags,
@@ -2346,6 +2348,9 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 	s->align = align;
 	s->flags = kmem_cache_flags(size, flags, name, ctor);
 
+	if ((size + MAX_DEBUG_SIZE) >= PAGE_SIZE)
+		flags &= ~(SLAB_POISON|SLAB_RED_ZONE|SLAB_STORE_USER);
+
 	if (!calculate_sizes(s, -1))
 		goto error;
 



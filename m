Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbZJKIKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbZJKIKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 04:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbZJKIJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 04:09:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173AbZJKIJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 04:09:55 -0400
Date: Sun, 11 Oct 2009 01:09:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: 2.6.32-rc2-xxx: bdev_lock: inconsistent {SOFTIRQ-ON-W} ->
 {IN-SOFTIRQ-W} usage
Message-Id: <20091011010910.7fdf357c.akpm@linux-foundation.org>
In-Reply-To: <20091007035310.GA30833@x200>
References: <20091007035310.GA30833@x200>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009 07:53:10 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Happened during page allocation failure:
>
> ...
>
>  <IRQ>  [<ffffffff81064540>] print_usage_bug+0x190/0x1f0
>  [<ffffffff81064a2f>] mark_lock+0x48f/0x690
>  [<ffffffff810653c0>] ? check_usage_forwards+0x0/0x110
>  [<ffffffff81066584>] __lock_acquire+0x6e4/0x1cf0
>  [<ffffffff8103bef2>] ? vprintk+0x2e2/0x530
>  [<ffffffff8130f970>] ? _spin_unlock+0x30/0x50
>  [<ffffffff81063c3d>] ? trace_hardirqs_off+0xd/0x10
>  [<ffffffff812835f3>] ? netpoll_send_skb+0x213/0x260
>  [<ffffffff8130bd3f>] ? printk+0x67/0x69
>  [<ffffffff81067bec>] lock_acquire+0x5c/0x80
>  [<ffffffff810dd537>] ? nr_blockdev_pages+0x17/0x80
>  [<ffffffff8130faf6>] _spin_lock+0x36/0x50
>  [<ffffffff810dd537>] ? nr_blockdev_pages+0x17/0x80
>  [<ffffffff810dd537>] nr_blockdev_pages+0x17/0x80
>  [<ffffffff8107ff29>] show_free_areas+0x99/0x7f0
>  [<ffffffff81063c3d>] ? trace_hardirqs_off+0xd/0x10
>  [<ffffffff8130f912>] ? _spin_unlock_irqrestore+0x42/0x70
>  [<ffffffff8103b8e5>] ? release_console_sem+0x1e5/0x230
>  [<ffffffff8103bef2>] ? vprintk+0x2e2/0x530
>  [<ffffffff8106f01d>] ? __module_text_address+0xd/0x70
>  [<ffffffff810102e1>] ? print_context_stack+0x81/0xf0
>  [<ffffffff8130bd3f>] ? printk+0x67/0x69
>  [<ffffffff8100ee98>] ? dump_trace+0x128/0x300
>  [<ffffffff81010167>] ? show_trace_log_lvl+0x57/0x70
>  [<ffffffff8117cd54>] show_mem+0x24/0x1e0
>  [<ffffffff8130bb64>] ? dump_stack+0x72/0x7b
>  [<ffffffff81081d98>] __alloc_pages_nodemask+0x628/0x6c0
>  [<ffffffff8130f970>] ? _spin_unlock+0x30/0x50
>  [<ffffffff810aa1fb>] __slab_alloc+0x57b/0x710
>  [<ffffffff81064c9c>] ? mark_held_locks+0x6c/0x90
>  [<ffffffff8126baaf>] ? __netdev_alloc_skb+0x1f/0x40
>  [<ffffffff810aa7d5>] ? kmem_cache_alloc+0xc5/0x110
>  [<ffffffff810ab087>] __kmalloc_track_caller+0x117/0x150
>  [<ffffffff8126baaf>] ? __netdev_alloc_skb+0x1f/0x40
>  [<ffffffff8126ac9e>] __alloc_skb+0x6e/0x170
>  [<ffffffff8126baaf>] __netdev_alloc_skb+0x1f/0x40
>  [<ffffffff8123ca6b>] ? rtl8139_poll+0x4b/0x400
>  [<ffffffff8123cb66>] rtl8139_poll+0x146/0x400
>  [<ffffffff81272e63>] net_rx_action+0x183/0x260
>  [<ffffffff81272ddc>] ? net_rx_action+0xfc/0x260
>  [<ffffffff81041510>] __do_softirq+0xd0/0x180
>  [<ffffffff8100c4bc>] call_softirq+0x1c/0x30
>  [<ffffffff8100e81d>] do_softirq+0x7d/0xc0
>  [<ffffffff81040fdd>] irq_exit+0x8d/0xb0
>  [<ffffffff8100da37>] do_IRQ+0x77/0xf0
>  [<ffffffff8100bc93>] ret_from_intr+0x0/0xf
>  <EOI>  [<ffffffff8130f938>] ? _spin_unlock_irqrestore+0x68/0x70
>  [<ffffffff81185bac>] ? debug_check_no_obj_freed+0x17c/0x1f0
>  [<ffffffff81080b71>] ? free_hot_cold_page+0xd1/0x320
>  [<ffffffff81080df9>] ? __pagevec_free+0x39/0x50
>  [<ffffffff81084748>] ? release_pages+0x228/0x240
>  [<ffffffff810a1d5d>] ? free_pages_and_swap_cache+0x8d/0xb0
>  [<ffffffff810984e8>] ? exit_mmap+0x188/0x1a0
>  [<ffffffff81038827>] ? mmput+0x57/0xe0
>  [<ffffffff8103d0fc>] ? exit_mm+0xfc/0x140
>  [<ffffffff8103f230>] ? do_exit+0x6f0/0x780
>  [<ffffffff81057546>] ? up_read+0x26/0x30
>  [<ffffffff8100bd2d>] ? retint_swapgs+0xe/0x13
>  [<ffffffff8103f301>] ? do_group_exit+0x41/0xc0
>  [<ffffffff8103f392>] ? sys_exit_group+0x12/0x20
>  [<ffffffff8100b36b>] ? system_call_fastpath+0x16/0x1b

Yep, we knew about that but appear to have forgotten about it.  Let's just
revert:


From: Andrew Morton <akpm@linux-foundation.org>

Revert

    commit 71de1ccbe1fb40203edd3beb473f8580d917d2ca
    Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    AuthorDate: Mon Sep 21 17:01:31 2009 -0700
    Commit:     Linus Torvalds <torvalds@linux-foundation.org>
    CommitDate: Tue Sep 22 07:17:27 2009 -0700

        mm: oom analysis: add buffer cache information to show_free_areas()
    

show_free_areas() is called during page allocation failures, and page
allocation failures can occur in any calling context.

But nr_blockdev_pages() takes VFS locks which should not be taken from
hard IRQ context (at least).  The result is lockdep warnings (and
deadlockability) during page allocation failures.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/page_alloc.c~revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas mm/page_alloc.c
--- a/mm/page_alloc.c~revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas
+++ a/mm/page_alloc.c
@@ -2183,7 +2183,7 @@ void show_free_areas(void)
 	printk("active_anon:%lu inactive_anon:%lu isolated_anon:%lu\n"
 		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
 		" unevictable:%lu"
-		" dirty:%lu writeback:%lu unstable:%lu buffer:%lu\n"
+		" dirty:%lu writeback:%lu unstable:%lu\n"
 		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
 		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
@@ -2196,7 +2196,6 @@ void show_free_areas(void)
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
 		global_page_state(NR_UNSTABLE_NFS),
-		nr_blockdev_pages(),
 		global_page_state(NR_FREE_PAGES),
 		global_page_state(NR_SLAB_RECLAIMABLE),
 		global_page_state(NR_SLAB_UNRECLAIMABLE),
_



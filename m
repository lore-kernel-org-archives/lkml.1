Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbXKERm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbXKERm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbXKERmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:42:17 -0500
Received: from frankvm.xs4all.nl ([80.126.170.174]:43708 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751269AbXKERmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:42:16 -0500
Date: Mon, 5 Nov 2007 18:42:14 +0100
From: Frank van Maarseveen <frankvm@frankvm.com>
To: linux-kernel@vger.kernel.org
Subject: VM/networking crash cause #1: page allocation failure (order:1, GFP_ATOMIC)
Message-ID: <20071105174214.GA10729@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For quite some time I'm seeing occasional lockups spread over 50 different
machines I'm maintaining. Symptom: a page allocation failure with order:1,
GFP_ATOMIC, while there is plenty of memory, as it seems (lots of free
pages, almost no swap used) followed by a lockup (everything dead). I've
collected all (12) crash cases which occurred the last 10 weeks on 50
machines total (i.e. 1 crash every 41 weeks on average). The kernel
messages are summarized to show the interesting part (IMO) they have
in common. Over the years this has become the crash cause #1 for stable
kernels for me (fglrx doesn't count ;).

One note: I suspect that reporting a GFP_ATOMIC allocation failure in an
network driver via that same driver (netconsole) may not be the smartest
thing to do and this could be responsible for the lockup itself. However,
the initial page allocation failure remains and I'm not sure how to
address that problem.

I still think the issue is memory fragmentation but if so, it looks
a bit extreme to me: One system with 2GB of ram crashed after a day,
merely running a couple of TCP server programs. All systems have either
1 or 2GB ram and at least 1G of (merely unused) swap.


2.6.22.10: lokka kswapd0: page allocation failure. order:1, mode:0x4020
Nov  5 12:58:27 lokka __alloc_skb+0x4d/0x110 
Nov  5 12:58:27 lokka __netdev_alloc_skb+0x23/0x50 
Nov  5 12:58:27 lokka e1000_alloc_rx_buffers+0x127/0x320  
Nov  5 12:58:27 lokka e1000_clean_rx_irq+0x299/0x510 
Nov  5 12:58:27 lokka e1000_intr+0x80/0x140 
Nov  5 12:58:27 lokka e1000_intr+0x80/0x140
Nov  5 12:58:27 lokka handle_IRQ_event+0x28/0x60
Nov  5 12:58:27 lokka handle_fasteoi_irq+0x6e/0xd0
Nov  5 12:58:27 lokka do_IRQ+0x4a/0xa0
...
Nov  5 12:58:27 lokka Active:139432 inactive:152030 dirty:4406 writeback:4 unstable:0 
Nov  5 12:58:27 lokka  free:89531 slab:122946 mapped:4421 pagetables:295 bounce:0 
...
Nov  5 12:58:27 lokka Swap cache: add 16, delete 16, find 0/0, race 0+0 
Nov  5 12:58:27 lokka Free swap  = 1004004kB 
Nov  5 12:58:27 lokka Total swap = 1004052kB 
Nov  5 12:58:27 lokka Free swap:       1004004kB 
Nov  5 12:58:27 lokka 523912 pages of RAM 
Nov  5 12:58:27 lokka 294536 pages of HIGHMEM 


2.6.21.6: somero ftxpd: page allocation failure. order:1, mode:0x20 
Oct 29 11:48:07 somero __alloc_skb+0x4c/0x110
Oct 29 11:48:07 somero __netdev_alloc_skb+0x1d/0x50
Oct 29 11:48:07 somero tg3_alloc_rx_skb+0x74/0x150
Oct 29 11:48:07 somero tg3_rx+0x35a/0x440
Oct 29 11:48:07 somero tg3_poll+0x77/0x1e0
Oct 29 11:48:07 somero net_rx_action+0x99/0x190
Oct 29 11:48:07 somero __do_softirq+0x80/0xf0
Oct 29 11:48:07 somero do_softirq+0x3c/0x40
Oct 29 11:48:07 somero irq_exit+0x45/0x50
Oct 29 11:48:07 somero do_IRQ+0x50/0xa0
...
Oct 29 11:48:07 somero Active:227052 inactive:48283 dirty:3423 writeback:0 unstable:0 
Oct 29 11:48:07 somero  free:113487 slab:109249 mapped:177942 pagetables:645 bounce:0 
...
Oct 29 11:48:07 somero Swap cache: add 428601, delete 422625, find 84672794/84685901, race 0+7 
Oct 29 11:48:07 somero Free swap  = 1901644kB 
Oct 29 11:48:07 somero Total swap = 2008116kB 
Oct 29 11:48:07 somero Free swap:       1901644kB 
Oct 29 11:48:07 somero 521862 pages of RAM 
Oct 29 11:48:07 somero 292486 pages of HIGHMEM 


2.6.22.10: naantali kswapd0: page allocation failure. order:1, mode:0x4020
(uptime: one day, merely running a couple of TCP server programs)
Oct 26 11:27:01 naantali __alloc_skb+0x4d/0x110
Oct 26 11:27:01 naantali tcp_collapse+0x17e/0x3b0
Oct 26 11:27:01 naantali tcp_prune_queue+0x7f/0x1c0
Oct 26 11:27:01 naantali tcp_data_queue+0x487/0x720
Oct 26 11:27:01 naantali tcp_rcv_established+0x3a0/0x6e0
Oct 26 11:27:01 naantali tcp_v4_do_rcv+0xe9/0x100
Oct 26 11:27:01 naantali tcp_v4_rcv+0x7f1/0x8d0
Oct 26 11:27:01 naantali ip_local_deliver+0xef/0x250
Oct 26 11:27:01 naantali ip_rcv+0x264/0x560
Oct 26 11:27:01 naantali netif_receive_skb+0x2ad/0x320
Oct 26 11:27:01 naantali process_backlog+0x91/0x120
Oct 26 11:27:01 naantali net_rx_action+0x8d/0x170
Oct 26 11:27:01 naantali __do_softirq+0x78/0x100
Oct 26 11:27:01 naantali do_softirq+0x3c/0x40
Oct 26 11:27:01 naantali irq_exit+0x45/0x50
Oct 26 11:27:01 naantali do_IRQ+0x4f/0xa0
...
Oct 26 11:27:01 naantali Active:115770 inactive:257188 dirty:10243 writeback:1920 unstable:0
Oct 26 11:27:01 naantali  free:41073 slab:97335 mapped:2540 pagetables:149 bounce:0
...
Oct 26 11:27:01 naantali Swap cache: add 90, delete 88, find 18/28, race 0+0
Oct 26 11:27:01 naantali Free swap  = 2008048kB
Oct 26 11:27:01 naantali Total swap = 2008084kB
Oct 26 11:27:01 naantali Free swap:       2008048kB
Oct 26 11:27:01 naantali 524144 pages of RAM
Oct 26 11:27:01 naantali 294768 pages of HIGHMEM


2.6.21.6: koli ftxpd: page allocation failure. order:1, mode:0x20
Oct 12 14:56:44 koli __alloc_skb+0x4c/0x110 
Oct 12 14:56:44 koli __netdev_alloc_skb+0x1d/0x50
Oct 12 14:56:44 koli tg3_alloc_rx_skb+0x74/0x150
Oct 12 14:56:44 koli tg3_rx+0x35a/0x440
Oct 12 14:56:44 koli tg3_poll+0x77/0x1e0
Oct 12 14:56:44 koli net_rx_action+0x99/0x190
Oct 12 14:56:44 koli __do_softirq+0x80/0xf0
Oct 12 14:56:44 koli do_softirq+0x3c/0x40
Oct 12 14:56:44 koli irq_exit+0x45/0x50
Oct 12 14:56:44 koli do_IRQ+0x50/0xa0


2.6.21.6: salla swirl: page allocation failure. order:1, mode:0x20
Oct  1 08:51:58 salla __alloc_skb+0x4c/0x110
Oct  1 08:51:58 salla __netdev_alloc_skb+0x1d/0x50
Oct  1 08:51:58 salla e1000_alloc_rx_buffers+0x140/0x340
Oct  1 08:51:58 salla e1000_clean_rx_irq+0x2c9/0x520
Oct  1 08:51:58 salla e1000_intr+0x7f/0x150
Oct  1 08:51:58 salla handle_IRQ_event+0x26/0x60
Oct  1 08:51:58 salla handle_fasteoi_irq+0x6b/0xd0
Oct  1 08:51:58 salla do_IRQ+0x4b/0xa0


2.6.22.6: lokka ftxpd: page allocation failure. order:1, mode:0x4020
Sep 17 10:34:49 lokka __alloc_skb+0x4d/0x110
Sep 17 10:34:49 lokka tcp_collapse+0x17e/0x3b0
Sep 17 10:34:49 lokka tcp_prune_queue+0x7f/0x1c0
Sep 17 10:34:49 lokka tcp_data_queue+0x487/0x720
Sep 17 10:34:49 lokka tcp_rcv_established+0x3a0/0x6e0
Sep 17 10:34:49 lokka tcp_v4_do_rcv+0xe9/0x100
Sep 17 10:34:49 lokka tcp_v4_rcv+0x7f1/0x8d0
Sep 17 10:34:49 lokka ip_local_deliver+0xef/0x250
Sep 17 10:34:49 lokka ip_rcv+0x264/0x560
Sep 17 10:34:49 lokka netif_receive_skb+0x2ad/0x320
Sep 17 10:34:49 lokka process_backlog+0x91/0x120
Sep 17 10:34:49 lokka net_rx_action+0x8d/0x170
Sep 17 10:34:49 lokka __do_softirq+0x78/0x100
Sep 17 10:34:49 lokka do_softirq+0x3c/0x40
Sep 17 10:34:49 lokka irq_exit+0x45/0x50
Sep 17 10:34:49 lokka do_IRQ+0x4f/0xa0


2.6.21.6: karvio swapper: page allocation failure. order:1, mode:0x20
Sep 17 10:48:48 karvio __alloc_skb+0x4c/0x110
Sep 17 10:48:48 karvio __netdev_alloc_skb+0x1d/0x50
Sep 17 10:48:48 karvio e1000_alloc_rx_buffers+0x140/0x340
Sep 17 10:48:48 karvio e1000_clean_rx_irq+0x2c9/0x520
Sep 17 10:48:48 karvio e1000_intr+0x7f/0x150
Sep 17 10:48:48 karvio handle_IRQ_event+0x26/0x60
Sep 17 10:48:48 karvio handle_fasteoi_irq+0x6b/0xd0
Sep 17 10:48:48 karvio do_IRQ+0x4b/0xa0


2.6.21.6: nivala ftxpd: page allocation failure. order:1, mode:0x20
Sep 20 10:32:49 nivala __alloc_skb+0x4c/0x110
Sep 20 10:32:49 nivala __netdev_alloc_skb+0x1d/0x50
Sep 20 10:32:49 nivala e1000_alloc_rx_buffers+0x140/0x340
Sep 20 10:32:49 nivala e1000_clean_rx_irq+0x2f6/0x520
Sep 20 10:32:49 nivala e1000_intr+0x7f/0x150
Sep 20 10:32:49 nivala handle_IRQ_event+0x26/0x60
Sep 20 10:32:49 nivala handle_fasteoi_irq+0x6b/0xd0
Sep 20 10:32:49 nivala do_IRQ+0x4b/0xa0


2.6.21.7: lahti ftxpd: page allocation failure. order:1, mode:0x20
Sep  3 09:46:11 lahti __alloc_skb+0x4c/0x110 
Sep  3 09:46:11 lahti __netdev_alloc_skb+0x1d/0x50
Sep  3 09:46:11 lahti tg3_alloc_rx_skb+0x74/0x150
Sep  3 09:46:11 lahti tg3_rx+0x35a/0x440
Sep  3 09:46:11 lahti tg3_poll+0x77/0x1e0
Sep  3 09:46:11 lahti net_rx_action+0x99/0x190
Sep  3 09:46:11 lahti __do_softirq+0x80/0xf0
Sep  3 09:46:11 lahti do_softirq+0x3c/0x40
Sep  3 09:46:11 lahti irq_exit+0x45/0x50
Sep  3 09:46:11 lahti do_IRQ+0x50/0xa0


2.6.21.6: ropi ftxpd: page allocation failure. order:1, mode:0x20
Aug 30 10:40:46 ropi __alloc_skb+0x4c/0x110 
Aug 30 10:40:46 ropi tcp_collapse+0x152/0x390
Aug 30 10:40:46 ropi tcp_prune_queue+0x84/0x1d0 
Aug 30 10:40:46 ropi tcp_data_queue+0x4a6/0x760 
Aug 30 10:40:46 ropi tcp_rcv_established+0x3ed/0x740
Aug 30 10:40:46 ropi tcp_v4_do_rcv+0xd0/0xe0  
Aug 30 10:40:46 ropi tcp_v4_rcv+0x7d2/0x890 
Aug 30 10:40:46 ropi ip_local_deliver+0xf2/0x260
Aug 30 10:40:46 ropi ip_rcv+0x259/0x510
Aug 30 10:40:46 ropi netif_receive_skb+0x280/0x2f0
Aug 30 10:40:46 ropi process_backlog+0x8d/0x140
Aug 30 10:40:46 ropi net_rx_action+0x99/0x190
Aug 30 10:40:46 ropi __do_softirq+0x80/0xf0
Aug 30 10:40:46 ropi do_softirq+0x3c/0x40
Aug 30 10:40:46 ropi irq_exit+0x45/0x50 
Aug 30 10:40:46 ropi do_IRQ+0x50/0xa0


2.6.21.6: ivalo swapper: page allocation failure. order:1, mode:0x20
Aug 30 10:46:58 ivalo __alloc_skb+0x4c/0x110
Aug 30 10:46:58 ivalo __netdev_alloc_skb+0x1d/0x50
Aug 30 10:46:58 ivalo e1000_alloc_rx_buffers+0x140/0x340
Aug 30 10:46:58 ivalo e1000_clean_rx_irq+0x2c9/0x520
Aug 30 10:46:58 ivalo e1000_intr+0x7f/0x150
Aug 30 10:46:58 ivalo handle_IRQ_event+0x26/0x60
Aug 30 10:46:58 ivalo handle_fasteoi_irq+0x6b/0xd0
Aug 30 10:46:58 ivalo do_IRQ+0x4b/0xa0


2.6.21.7: lokka ftxpd: page allocation failure. order:1, mode:0x20
Aug 31 16:30:02 lokka __alloc_skb+0x4c/0x110 
Aug 31 16:30:02 lokka __netdev_alloc_skb+0x1d/0x50
Aug 31 16:30:02 lokka e1000_alloc_rx_buffers+0x140/0x340
Aug 31 16:30:02 lokka e1000_clean_rx_irq+0x2c9/0x520
Aug 31 16:30:02 lokka e1000_intr+0x7f/0x150
Aug 31 16:30:02 lokka handle_IRQ_event+0x26/0x60
Aug 31 16:30:02 lokka handle_fasteoi_irq+0x6b/0xd0
Aug 31 16:30:02 lokka do_IRQ+0x4b/0xa0

-- 
Frank

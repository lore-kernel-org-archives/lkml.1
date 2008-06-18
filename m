Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbYFRPbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbYFRPbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 11:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbYFRPa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 11:30:56 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4767 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYFRPaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:30:55 -0400
Date: Wed, 18 Jun 2008 17:30:45 +0200
From: Miquel van Smoorenburg <miquels@cistron.nl>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, miquels@cistron.nl
Subject: [PATCH] tcp.c: calculate tcp_mem based on low memory instead of
	all memory
Message-ID: <20080618153042.GA27663@xs4all.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-NCC-RegID: nl.xs4all
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started upgrading a bunch of machines in my nntp server farm
to a recent kernel- 2.6.25.x. They were running 2.6.11.12 on
32 bits, and I upgraded them to 2.6.25.x on 64 bits.

All went fine until I noticed a few machines didn't have a 64
bit capable processor, so I had to keep them on a 32 bit kernel.
These are machines with dual xeons 3 Ghz and 8 GB of RAM.

On the 32 bit machines I keep getting the error below, and a flood
of these on a 9600 baud serial console essentially kills the machine:

diablo invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
Pid: 4459, comm: diablo Not tainted 2.6.25.7-rc1 #1
 [<c0249660>] oom_kill_process+0x120/0x210
 [<c0227ff8>] __capable+0x8/0x20
 [<c0249898>] badness+0x128/0x1c0
 [<c0249b1c>] out_of_memory+0x17c/0x1c0
 [<c024bdf4>] __alloc_pages+0x254/0x350
 [<c03b75ad>] tcp_sendmsg+0x5cd/0xb50
 [<c0381672>] sock_aio_write+0xe2/0x100
 [<c02681e7>] do_sync_write+0xc7/0x110
 [<c0232f20>] autoremove_wake_function+0x0/0x50
 [<c0268af3>] vfs_write+0x133/0x140
 [<c0269131>] sys_write+0x41/0x70
 [<c0202e5e>] syscall_call+0x7/0xb

After some investigation, I found out that the values of
/proc/sys/net/ipv4/tcp_mem are quite different between
these two versions:

2.6.11.12:
$ cat tcp_mem 
98304	131072	196608

2.6.25:
# cat tcp_mem 
804672	1072896	1609344

Somwehere between 2.6.11.12 and 2.6.25, the calculation method of
the tcp_mem array was changed. Now 1609344 pages is 6.5 GB,
and that will ofcourse never fit in x86_32's low memory ..

I am not quite sure what the correct solution is here, I think
something like the patch below.

Alternatively we could use the existing calculation but limit 'limit'
to 3/4 of (totalram_pages - totalhigh_pages) if (totalhigh_pages > 0) ?


linux-2.6.26-tcp_mem-lowmem.patch

[PATCH] tcp.c: calculate tcp_mem based on low memory instead of all memory

The tcp_mem array which contains limits on the total amount of
memory used by TCP sockets is calculated based on nr_all_pages.
On a 32 bits x86 system, we should base this on the number of
lowmem pages.

Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>

--- linux-2.6.26-rc6.orig/net/ipv4/tcp.c	2008-06-12 23:22:24.000000000 +0200
+++ linux-2.6.26-rc6/net/ipv4/tcp.c	2008-06-16 15:04:16.000000000 +0200
@@ -260,6 +260,8 @@
 #include <linux/socket.h>
 #include <linux/random.h>
 #include <linux/bootmem.h>
+#include <linux/highmem.h>
+#include <linux/swap.h>
 #include <linux/cache.h>
 #include <linux/err.h>
 #include <linux/crypto.h>
@@ -2616,7 +2618,7 @@
 void __init tcp_init(void)
 {
 	struct sk_buff *skb = NULL;
-	unsigned long limit;
+	unsigned long nr_pages, limit;
 	int order, i, max_share;
 
 	BUILD_BUG_ON(sizeof(struct tcp_skb_cb) > sizeof(skb->cb));
@@ -2685,8 +2687,9 @@
 	 * is up to 1/2 at 256 MB, decreasing toward zero with the amount of
 	 * memory, with a floor of 128 pages.
 	 */
-	limit = min(nr_all_pages, 1UL<<(28-PAGE_SHIFT)) >> (20-PAGE_SHIFT);
-	limit = (limit * (nr_all_pages >> (20-PAGE_SHIFT))) >> (PAGE_SHIFT-11);
+	nr_pages = totalram_pages - totalhigh_pages;
+	limit = min(nr_pages, 1UL<<(28-PAGE_SHIFT)) >> (20-PAGE_SHIFT);
+	limit = (limit * (nr_pages >> (20-PAGE_SHIFT))) >> (PAGE_SHIFT-11);
 	limit = max(limit, 128UL);
 	sysctl_tcp_mem[0] = limit / 4 * 3;
 	sysctl_tcp_mem[1] = limit;


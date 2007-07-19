Return-Path: <linux-kernel-owner+w=401wt.eu-S966034AbXGSTYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966034AbXGSTYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965972AbXGSTXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:23:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38696 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965963AbXGSTXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:23:10 -0400
Date: Thu, 19 Jul 2007 21:22:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070719192256.GA22151@elte.hu>
References: <20070716091236.GA10718@elte.hu> <469F867C.7020707@intel.com> <20070719160713.GA3807@elte.hu> <200707192113.26878.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707192113.26878.olaf.kirch@oracle.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Olaf Kirch <olaf.kirch@oracle.com> wrote:

> Here's a somewhat drastic modification that should not change any 
> timing, but just verifies whether my patch is to blame at all. Can you 
> give it a try?

> @@ -1027,7 +1027,7 @@ static inline void netif_rx_complete(str
>  	 * But at least it doesn't penalize the non-netpoll
>  	 * code path. */
>  	if (test_bit(__LINK_STATE_POLL_LIST_FROZEN, &dev->state))
> -		return;
> +		BUG();

ok, i tried the patch below, and it gave this (single) warning:

 Calling initcall 0xc02f5c17: init_netconsole+0x0/0x67()
 netconsole: device eth0 not up yet, forcing it
 netconsole: timeout waiting for carrier
 console [netcon0] enabled
 WARNING: at include/linux/netdevice.h:1030 netif_rx_complete()
  [<c0105e3e>] show_trace_log_lvl+0x19/0x2e
  [<c0105f37>] show_trace+0x12/0x14
  [<c0105f4d>] dump_stack+0x14/0x16
  [<c02c4fef>] e1000_clean+0x1f4/0x26f
  [<c03d0f6f>] netpoll_poll+0x8b/0x357
  [<c03d0e80>] netpoll_send_skb+0xe8/0x14c
  [<c03d1502>] netpoll_send_udp+0x258/0x260
  [<c02f5cea>] write_msg+0x53/0x8d
  [<c012c5ba>] __call_console_drivers+0x4e/0x5a
  [<c012c623>] _call_console_drivers+0x5d/0x61
  [<c012cc42>] release_console_sem+0x120/0x1c1
  [<c012d446>] register_console+0x22e/0x236
  [<c02f5c6c>] init_netconsole+0x55/0x67
  [<c05e48e5>] kernel_init+0x154/0x2d9
  [<c0105c53>] kernel_thread_helper+0x7/0x10
  =======================
 e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
 netconsole: network logging started
 initcall 0xc02f5c17: init_netconsole+0x0/0x67() returned 0.
 initcall 0xc02f5c17 ran for 4012 msecs: init_netconsole+0x0/0x67()
 Calling initcall 0xc0600ff9: spi_transport_init+0x0/0x27()
 initcall 0xc0600ff9: spi_transport_init+0x0/0x27() returned 0.


	Ingo

---
 include/linux/netdevice.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-cfs-2.6.23-git.q.prev3/include/linux/netdevice.h
===================================================================
--- linux-cfs-2.6.23-git.q.prev3.orig/include/linux/netdevice.h
+++ linux-cfs-2.6.23-git.q.prev3/include/linux/netdevice.h
@@ -1027,7 +1027,7 @@ static inline void netif_rx_complete(str
 	 * But at least it doesn't penalize the non-netpoll
 	 * code path. */
 	if (test_bit(__LINK_STATE_POLL_LIST_FROZEN, &dev->state))
-		return;
+		WARN_ON(1);
 #endif
 
 	local_irq_save(flags);

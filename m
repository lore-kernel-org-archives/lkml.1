Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZLWUWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZLWUWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 15:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757002AbZLWUW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 15:22:29 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58168 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752623AbZLWUW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 15:22:28 -0500
Date: Wed, 23 Dec 2009 23:22:26 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, leoli@freescale.com
Subject: Re: ucc_geth broken in 2.6.32 by
 864fdf884e82bacbe8ca5e93bd43393a61d2e2b4
Message-ID: <20091223202226.GA8185@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20091223174019.GB762@caffeine.csclub.uwaterloo.ca>
 <20091223180415.GA12987@oksana.dev.rtsoft.ru>
 <20091223200948.GF760@caffeine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091223200948.GF760@caffeine.csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 03:09:48PM -0500, Lennart Sorensen wrote:
[...]
> So there result is:
> 
> Unable to handle kernel paging request for data at address 0x00000058
> Faulting instruction address: 0xc024f2fc
> Oops: Kernel access of bad area, sig: 11 [#1]
> RC8360 CM
> Modules linked in: rclibapi xeno_native max6369_wdt ucc_geth_driver spi_mpc8xxx ltc4215 lm75
> NIP: c024f2fc LR: e30aa0a4 CTR: c024f2e8
> REGS: df857ca0 TRAP: 0300   Not tainted  (2.6.32-trunk-8360e)
> MSR: 00009032 <EE,ME,IR,DR>  CR: 44042088  XER: 00000000
> DAR: 00000058, DSISR: 20000000
> TASK = df848c90[4] 'events/0' THREAD: df856000
> GPR00: e30aa0a4 df857d50 df848c90 00000000 00000640 00000001 c0428df4 dfa40b80
> GPR08: 000000c8 e30ad2b8 df084360 c024f2e8 44042082 1001af90 e30ad2b8 00000000
> GPR16: 00000048 00000001 00000000 00000000 df08436c df08440c 00000190 df08455c
> GPR24: df0844ec df0842c0 df084000 180005ea dfa40b80 00000000 df0842c0 00000000
> NIP [c024f2fc] skb_recycle_check+0x14/0x100
> LR [e30aa0a4] ucc_geth_poll+0xd8/0x4e0 [ucc_geth_driver]
> Call Trace:
> [df857d50] [c000b03c] __ipipe_grab_irq+0x3c/0xa4 (unreliable)
> [df857d60] [e30aa0a4] ucc_geth_poll+0xd8/0x4e0 [ucc_geth_driver]

This I can reproduce. It seems it's a long standing bug that
becomes easily reproducible with quiesce/activate sequence.
The driver doesn't handle empty queue correctly, i.e. it ignores
the empty queue check if netdev queue is stopped, which makes no
sense.

Can you try this patch in addition to previous (i.e. both should
be applied)?

Thanks!

diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
index 2f73e3f..b22de51 100644
--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -3275,7 +3275,7 @@ static int ucc_geth_tx(struct net_device *dev, u8 txQ)
 		/* Handle the transmitted buffer and release */
 		/* the BD to be used with the current frame  */
 
-		if ((bd == ugeth->txBd[txQ]) && (netif_queue_stopped(dev) == 0))
+		if (bd == ugeth->txBd[txQ]) /* queue empty? */
 			break;
 
 		dev->stats.tx_packets++;

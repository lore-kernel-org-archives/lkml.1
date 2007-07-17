Return-Path: <linux-kernel-owner+w=401wt.eu-S935473AbXGQSHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935473AbXGQSHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934306AbXGQSHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:07:14 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14022 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933947AbXGQSHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:07:11 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Tue, 17 Jul 2007 20:06:10 +0200
User-Agent: KMail/1.9.1
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
References: <20070716091236.GA10718@elte.hu> <200707171607.08644.olaf.kirch@oracle.com> <20070717165720.GA4386@elte.hu>
In-Reply-To: <20070717165720.GA4386@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707172006.11664.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tuesday 17 July 2007 18:57, Ingo Molnar wrote:
> i've done the patch below, but it did not change the timeouts nor did it 
> solve the 'no network' problem. netconsole output hung earlier as well.
Hm, pity.

To rule out any e1000 problem, can you try the the following please,
both with HZ=250 and HZ=1000?

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
---
---
 drivers/net/e1000/e1000_main.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: build-2.6/drivers/net/e1000/e1000_main.c
===================================================================
--- build-2.6.orig/drivers/net/e1000/e1000_main.c
+++ build-2.6/drivers/net/e1000/e1000_main.c
@@ -3871,10 +3871,17 @@ e1000_intr(int irq, void *data)
 		adapter->total_rx_bytes = 0;
 		adapter->total_rx_packets = 0;
 		__netif_rx_schedule(netdev);
-	} else
+	} else {
 		/* this really should not happen! if it does it is basically a
 		 * bug, but not a hard error, so enable ints and continue */
+		static unsigned int been_here = 0;
+
+		been_here++;
+		if (net_ratelimit())
+			printk(KERN_NOTICE "e1000_intr and rx_sched set (%u); state=0x%lx\n",
+					been_here, netdev->state);
 		e1000_irq_enable(adapter);
+	}
 #else
 	/* Writing IMC and IMS is needed for 82547.
 	 * Due to Hub Link bus being occupied, an interrupt

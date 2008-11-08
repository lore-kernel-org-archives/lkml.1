Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYKHMFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYKHMFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 07:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYKHME6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 07:04:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:9757 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYKHME4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 07:04:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=LHqLPGjsyapQQswLEDLFnGMEvbJXlfuU2vfhGzelnuiquhjDJtmcz3XlsNawZW9GiT
         Ek4zWB+7BLVI9HtgNuVkp8GjkysR1/w1FDQGC+x5OM0AtUtpmB97ILYZlB17FUa+FKPN
         6BLt/iFBXSeh6tRpeF/K0XU5hgD4YRIBI4cDk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for November 7
Date: Sat, 8 Nov 2008 12:57:44 +0100
User-Agent: KMail/1.9.10
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "David S. Miller" <davem@davemloft.net>
References: <20081107205457.f64dea59.sfr@canb.auug.org.au>
In-Reply-To: <20081107205457.f64dea59.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811081257.45184.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday 07 November 2008, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20081106:

The following patch fixes the panic on loopback device registration
(patch is an interdiff between old and new version of "net: Guaranetee
the proper ordering of the loopback device." fix from Eric).

[ I'm sure this will get fixed in -net tree (if not fixed already)
  but at the moment it is needed for linux-next. ]

---
 net/core/dev.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

Index: b/net/core/dev.c
===================================================================
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4913,21 +4913,6 @@ static int __init net_dev_init(void)
 	if (register_pernet_subsys(&netdev_net_ops))
 		goto out;
 
-	/* The loopback device is special if any other network devices
-	 * is present in a network namespace the loopback device must
-	 * be present. Since we now dynamically allocate and free the
-	 * loopback device ensure this invariant is maintained by
-	 * keeping the loopback device as the first device on the
-	 * list of network devices.  Ensuring the loopback devices
-	 * is the first device that appears and the last network device
-	 * that disappears.
-	 */
-	if (register_pernet_device(&loopback_net_ops))
-		goto out;
-
-	if (register_pernet_device(&default_device_ops))
-		goto out;
-
 	/*
 	 *	Initialise the packet receive queues.
 	 */
@@ -4944,10 +4929,25 @@ static int __init net_dev_init(void)
 		queue->backlog.weight = weight_p;
 	}
 
-	netdev_dma_register();
-
 	dev_boot_phase = 0;
 
+	/* The loopback device is special if any other network devices
+	 * is present in a network namespace the loopback device must
+	 * be present. Since we now dynamically allocate and free the
+	 * loopback device ensure this invariant is maintained by
+	 * keeping the loopback device as the first device on the
+	 * list of network devices.  Ensuring the loopback devices
+	 * is the first device that appears and the last network device
+	 * that disappears.
+	 */
+	if (register_pernet_device(&loopback_net_ops))
+		goto out;
+
+	if (register_pernet_device(&default_device_ops))
+		goto out;
+
+	netdev_dma_register();
+
 	open_softirq(NET_TX_SOFTIRQ, net_tx_action);
 	open_softirq(NET_RX_SOFTIRQ, net_rx_action);
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYGHWIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYGHWIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 18:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYGHWIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 18:08:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:63645 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbYGHWIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 18:08:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,326,1212390000"; 
   d="scan'208";a="586797817"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [RESEND NET-NEXT PATCH 11/20] igb: reenable CRC stripping in hardware
To: jeff@garzik.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Auke Kok <auke-jan.h.kok@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 08 Jul 2008 15:08:29 -0700
Message-ID: <20080708220800.1518.10572.stgit@localhost.localdomain>
In-Reply-To: <20080708220046.1518.88457.stgit@localhost.localdomain>
References: <20080708220046.1518.88457.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2008 22:08:29.0590 (UTC) FILETIME=[2727B360:01C8E147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Auke Kok <auke-jan.h.kok@intel.com>

We can remove a clunky workaround for not having the hardware
strip the CRC. 82575 silicon as well as the older PCI Express
e1000e hardware all work OK in this respect.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 drivers/net/igb/igb_main.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index e8ef541..ae329c0 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -1664,10 +1664,12 @@ static void igb_setup_rctl(struct igb_adapter *adapter)
 		E1000_RCTL_LBM_NO | E1000_RCTL_RDMTS_HALF |
 		(adapter->hw.mac.mc_filter_type << E1000_RCTL_MO_SHIFT);
 
-	/* disable the stripping of CRC because it breaks
-	 * BMC firmware connected over SMBUS
-	rctl |= E1000_RCTL_SECRC;
+	/*
+	 * enable stripping of CRC. It's unlikely this will break BMC
+	 * redirection as it did with e1000. Newer features require
+	 * that the HW strips the CRC.
 	*/
+	rctl |= E1000_RCTL_SECRC;
 
 	rctl &= ~E1000_RCTL_SBP;
 
@@ -3743,7 +3745,6 @@ static bool igb_clean_rx_irq_adv(struct igb_ring *rx_ring,
 			}
 		}
 send_up:
-		pskb_trim(skb, skb->len - 4);
 		i++;
 		if (i == rx_ring->count)
 			i = 0;


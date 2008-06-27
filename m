Return-Path: <linux-kernel-owner+w=401wt.eu-S1763021AbYF0SEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763021AbYF0SEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760681AbYF0SBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:01:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:62499 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761379AbYF0SBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:01:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,716,1204531200"; 
   d="scan'208";a="3659417"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [NET-NEXT PATCH 11/18] igb: reenable CRC stripping in hardware
To: jeff@garzik.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net
Date: Fri, 27 Jun 2008 11:01:12 -0700
Message-ID: <20080627180109.22428.31734.stgit@localhost.localdomain>
In-Reply-To: <20080627175921.22428.52767.stgit@localhost.localdomain>
References: <20080627175921.22428.52767.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2008 18:01:12.0734 (UTC) FILETIME=[C927E3E0:01C8D87F]
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
index 501ab4e..27fca76 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -1637,10 +1637,12 @@ static void igb_setup_rctl(struct igb_adapter *adapter)
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
 
@@ -3717,7 +3719,6 @@ static bool igb_clean_rx_irq_adv(struct igb_ring *rx_ring,
 			}
 		}
 send_up:
-		pskb_trim(skb, skb->len - 4);
 		i++;
 		if (i == rx_ring->count)
 			i = 0;


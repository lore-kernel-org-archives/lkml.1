Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab0BEGco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 01:32:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60938
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117Ab0BEGcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 01:32:42 -0500
Date: Thu, 04 Feb 2010 22:32:55 -0800 (PST)
Message-Id: <20100204.223255.146893399.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, nicholasx.d.nunley@intel.com
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100205165059.0b5d5363.sfr@canb.auug.org.au>
References: <20100205165059.0b5d5363.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 5 Feb 2010 16:50:59 +1100

> Hi Dave,
> 
> After merging the scsi-post-merge tree, today's linux-next build (powerpc
> allyesconfig and i386 defconfig) failed like this:
> 
> drivers/net/e1000e/built-in.o: In function `e1000_has_link':
> (.opd+0x1d58): multiple definition of `e1000_has_link'
> drivers/net/e1000/built-in.o:(.opd+0x588): first defined here
> 
> Caused by commit b548192acaebcb05d6a87d1e94f19835b1a18a8b ("e1000: Report
> link status in ethtool when interface is down").
> 
> I have reverted that commit for today.

Damn namespace pollution, this is one of a zillion reasons
I prefer drivers are written in one sorce file, then people
can name their functions however they like and they're all
marked static so it doesn't cause problems like this.

I've fixed it up as follows in net-next-2.6

Thanks!

e1000e: Fix namespace conflicts wrt. e1000_has_link

Reported by Stephen Rothwell.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/e1000e/e1000.h   |    2 +-
 drivers/net/e1000e/ethtool.c |    2 +-
 drivers/net/e1000e/netdev.c  |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/e1000e/e1000.h b/drivers/net/e1000e/e1000.h
index 318bdb2..c2ec095 100644
--- a/drivers/net/e1000e/e1000.h
+++ b/drivers/net/e1000e/e1000.h
@@ -459,7 +459,7 @@ extern int e1000e_setup_tx_resources(struct e1000_adapter *adapter);
 extern void e1000e_free_rx_resources(struct e1000_adapter *adapter);
 extern void e1000e_free_tx_resources(struct e1000_adapter *adapter);
 extern void e1000e_update_stats(struct e1000_adapter *adapter);
-extern bool e1000_has_link(struct e1000_adapter *adapter);
+extern bool e1000e_has_link(struct e1000_adapter *adapter);
 extern void e1000e_set_interrupt_capability(struct e1000_adapter *adapter);
 extern void e1000e_reset_interrupt_capability(struct e1000_adapter *adapter);
 
diff --git a/drivers/net/e1000e/ethtool.c b/drivers/net/e1000e/ethtool.c
index 0aa50c2..b33e3cb 100644
--- a/drivers/net/e1000e/ethtool.c
+++ b/drivers/net/e1000e/ethtool.c
@@ -202,7 +202,7 @@ static u32 e1000_get_link(struct net_device *netdev)
 	if (!netif_carrier_ok(netdev))
 		mac->get_link_status = 1;
 
-	return e1000_has_link(adapter);
+	return e1000e_has_link(adapter);
 }
 
 static int e1000_set_spd_dplx(struct e1000_adapter *adapter, u16 spddplx)
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 14a80f8..ffa37c6 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -3472,7 +3472,7 @@ static void e1000_print_link_info(struct e1000_adapter *adapter)
 	       ((ctrl & E1000_CTRL_TFCE) ? "TX" : "None" )));
 }
 
-bool e1000_has_link(struct e1000_adapter *adapter)
+bool e1000e_has_link(struct e1000_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
 	bool link_active = 0;
@@ -3553,7 +3553,7 @@ static void e1000_watchdog_task(struct work_struct *work)
 	u32 link, tctl;
 	int tx_pending = 0;
 
-	link = e1000_has_link(adapter);
+	link = e1000e_has_link(adapter);
 	if ((netif_carrier_ok(netdev)) && link) {
 		e1000e_enable_receives(adapter);
 		goto link_up;
-- 
1.6.6.1


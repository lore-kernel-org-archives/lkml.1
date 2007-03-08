Return-Path: <linux-kernel-owner+w=401wt.eu-S2992782AbXCHAXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992782AbXCHAXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992799AbXCHAXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:23:24 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41056 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992782AbXCHAXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:23:23 -0500
Date: Wed, 7 Mar 2007 16:23:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "J.A. =?ISO-8859-1?Q?Magall=F3n" ?= <jamagallon@ono.com>
Cc: linux-kernel@vger.kernel.org, Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: e1000 oops on boot [Re: 2.6.21-rc2-mm2]
Message-Id: <20070307162315.76f2a60b.akpm@linux-foundation.org>
In-Reply-To: <20070308010323.58b80d96@werewolf-wl>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
	<20070308010323.58b80d96@werewolf-wl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007 01:03:23 +0100
"J.A. Magall__n" <jamagallon@ono.com> wrote:

> On Tue, 6 Mar 2007 00:44:08 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm2/
> > 
> 
> e1000 gave this on a warm boot:
> 
> http://belly.cps.unizar.es/~magallon/oops/IMG_1510.JPG
> 
> Any idea ?


e1000_intr() did a jump-to-zero.

This might be because e1000 is calling request_irq() before everything is
set up.  We used to have that fixed, but it got reverted because it broke
other things (msi, iirc).

The below will apppear in -rc3-mm1 (hopefully later today) and it will
hopefully fix that crash.



From: Auke Kok <auke-jan.h.kok@intel.com>

DEBUG_SHIRQ code exposed that e1000 was not ready for incoming interrupts
after having called pci_request_irq.  This obviously requires us to finish our
software setup which assigns the irq handler before we request the irq.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_main.c |   66 +++++++++++++++++++++----------
 1 files changed, 45 insertions(+), 21 deletions(-)

diff -puN drivers/net/e1000/e1000_main.c~e1000-fix-be-ready-for-incoming-irq-at-pci_request_irq drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000-fix-be-ready-for-incoming-irq-at-pci_request_irq
+++ a/drivers/net/e1000/e1000_main.c
@@ -522,14 +522,15 @@ e1000_release_manageability(struct e1000
 	}
 }
 
-int
-e1000_up(struct e1000_adapter *adapter)
+/**
+ * e1000_configure - configure the hardware for RX and TX
+ * @adapter = private board structure
+ **/
+static void e1000_configure(struct e1000_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 	int i;
 
-	/* hardware has been reset, we need to reload some things */
-
 	e1000_set_multi(netdev);
 
 	e1000_restore_vlan(adapter);
@@ -548,14 +549,20 @@ e1000_up(struct e1000_adapter *adapter)
 	}
 
 	adapter->tx_queue_len = netdev->tx_queue_len;
+}
+
+int e1000_up(struct e1000_adapter *adapter)
+{
+	/* hardware has been reset, we need to reload some things */
+	e1000_configure(adapter);
+
+	clear_bit(__E1000_DOWN, &adapter->flags);
 
 #ifdef CONFIG_E1000_NAPI
-	netif_poll_enable(netdev);
+	netif_poll_enable(adapter->netdev);
 #endif
 	e1000_irq_enable(adapter);
 
-	clear_bit(__E1000_DOWN, &adapter->flags);
-
 	/* fire a link change interrupt to start the watchdog */
 	E1000_WRITE_REG(&adapter->hw, ICS, E1000_ICS_LSC);
 	return 0;
@@ -640,15 +647,15 @@ e1000_down(struct e1000_adapter *adapter
 	 * reschedule our watchdog timer */
 	set_bit(__E1000_DOWN, &adapter->flags);
 
+#ifdef CONFIG_E1000_NAPI
+	netif_poll_disable(netdev);
+#endif
 	e1000_irq_disable(adapter);
 
 	del_timer_sync(&adapter->tx_fifo_stall_timer);
 	del_timer_sync(&adapter->watchdog_timer);
 	del_timer_sync(&adapter->phy_info_timer);
 
-#ifdef CONFIG_E1000_NAPI
-	netif_poll_disable(netdev);
-#endif
 	netdev->tx_queue_len = adapter->tx_queue_len;
 	adapter->link_speed = 0;
 	adapter->link_duplex = 0;
@@ -1410,21 +1417,17 @@ e1000_open(struct net_device *netdev)
 		return -EBUSY;
 
 	/* allocate transmit descriptors */
-	if ((err = e1000_setup_all_tx_resources(adapter)))
+	err = e1000_setup_all_tx_resources(adapter);
+	if (err)
 		goto err_setup_tx;
 
 	/* allocate receive descriptors */
-	if ((err = e1000_setup_all_rx_resources(adapter)))
-		goto err_setup_rx;
-
-	err = e1000_request_irq(adapter);
+	err = e1000_setup_all_rx_resources(adapter);
 	if (err)
-		goto err_req_irq;
+		goto err_setup_rx;
 
 	e1000_power_up_phy(adapter);
 
-	if ((err = e1000_up(adapter)))
-		goto err_up;
 	adapter->mng_vlan_id = E1000_MNG_VLAN_NONE;
 	if ((adapter->hw.mng_cookie.status &
 			  E1000_MNG_DHCP_COOKIE_STATUS_VLAN_SUPPORT)) {
@@ -1437,12 +1440,33 @@ e1000_open(struct net_device *netdev)
 	    e1000_check_mng_mode(&adapter->hw))
 		e1000_get_hw_control(adapter);
 
+	/* before we allocate an interrupt, we must be ready to handle it.
+	 * Setting DEBUG_SHIRQ in the kernel makes it fire an interrupt
+	 * as soon as we call pci_request_irq, so we have to setup our
+	 * clean_rx handler before we do so.  */
+	e1000_configure(adapter);
+
+	err = e1000_request_irq(adapter);
+	if (err)
+		goto err_req_irq;
+
+	/* From here on the code is the same as e1000_up() */
+	clear_bit(__E1000_DOWN, &adapter->flags);
+
+#ifdef CONFIG_E1000_NAPI
+	netif_poll_enable(netdev);
+#endif
+
+	e1000_irq_enable(adapter);
+
+	/* fire a link status change interrupt to start the watchdog */
+	E1000_WRITE_REG(&adapter->hw, ICS, E1000_ICS_LSC);
+
 	return E1000_SUCCESS;
 
-err_up:
-	e1000_power_down_phy(adapter);
-	e1000_free_irq(adapter);
 err_req_irq:
+	e1000_release_hw_control(adapter);
+	e1000_power_down_phy(adapter);
 	e1000_free_all_rx_resources(adapter);
 err_setup_rx:
 	e1000_free_all_tx_resources(adapter);
_


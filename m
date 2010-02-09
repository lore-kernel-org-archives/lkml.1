Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab0BIAko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 19:40:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:56569 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab0BIAkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 19:40:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,432,1262592000"; 
   d="scan'208";a="490750092"
Subject: Re: [Ilw] Re: PROBLEM: iwlagn kernel 2.6.32.3 ooops
From: reinette chatre <reinette.chatre@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux Kernel-Liste <linux-kernel@vger.kernel.org>,
       "lkml@Think-Future.de" <lkml@Think-Future.de>
In-Reply-To: <1265670039.2551.1828.camel@rchatre-DESK>
References: <20100206170348.GB9411@localhost>
	 <20100208143118.e8e5a1ee.akpm@linux-foundation.org>
	 <1265670039.2551.1828.camel@rchatre-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 16:40:34 -0800
Message-ID: <1265676034.2551.1833.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 15:00 -0800, Chatre, Reinette wrote:
> 
> On Mon, 2010-02-08 at 14:31 -0800, Andrew Morton wrote:
> > On Sat, 6 Feb 2010 18:03:50 +0100
> > lkml@Think-Future.de wrote:

> > > [252109.496953] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
> > > [252109.496961] iwlagn: Copyright(c) 2003-2009 Intel Corporation
> > > [252109.497071] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> > > [252109.497094] iwlagn 0000:03:00.0: setting latency timer to 64
> > > [252109.497156] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
> > > [252109.547060] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
> > > [252109.547202] iwlagn 0000:03:00.0: irq 29 for MSI/MSI-X
> > > [252109.548104] phy14: Selected rate control algorithm 'iwl-agn-rs'
> > > [252109.921801] udev: renamed network interface wlan0 to eth1
> > > [252110.693015] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-4965-2.ucode
> > > [252110.810198] iwlagn 0000:03:00.0: loaded firmware version 228.61.2.24
> > > [252110.989598] ------------[ cut here ]------------
> > > [252110.989620] WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1151 iwl_tx_cmd_complete+0x2ed/0x330 [iwlcore]()
> > 

Could you please run with the patch below and check if the new error
message appears?

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 921dc4a..6911995 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -759,6 +759,8 @@ void iwl_rx_handle(struct iwl_priv *priv)
 	u8 fill_rx = 0;
 	u32 count = 8;
 	int total_empty;
+	bool valid;
+	int len;
 
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
@@ -791,6 +793,11 @@ void iwl_rx_handle(struct iwl_priv *priv)
 				 priv->hw_params.rx_buf_size + 256,
 				 PCI_DMA_FROMDEVICE);
 		pkt = (struct iwl_rx_packet *)rxb->skb->data;
+		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+		valid = (len >= sizeof(__le32) + sizeof(struct iwl_cmd_header));
+		/* Make sure we can at least parse the header */
+		if (!valid)
+			IWL_ERR(priv, "Invalid packet from device.\n");
 
 		/* Reclaim a command buffer only if this packet is a response
 		 *   to a (driver-originated) command.
@@ -809,7 +816,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
 		 *   rx_handlers table.  See iwl_setup_rx_handlers() */
-		if (priv->rx_handlers[pkt->hdr.cmd]) {
+		if (valid && priv->rx_handlers[pkt->hdr.cmd]) {
 			IWL_DEBUG_RX(priv, "r = %d, i = %d, %s, 0x%02x\n", r,
 				i, get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
 			priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
@@ -822,7 +829,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 				pkt->hdr.cmd);
 		}
 
-		if (reclaim) {
+		if (valid && reclaim) {
 			/* Invoke any callbacks, transfer the skb to caller, and
 			 * fire off the (possibly) blocking iwl_send_cmd()
 			 * as we reclaim the driver command queue */



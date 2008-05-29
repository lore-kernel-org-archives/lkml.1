Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYE2CHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYE2CHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 22:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYE2CGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 22:06:50 -0400
Received: from dsl093-193-175.stl1.dsl.speakeasy.net ([66.93.193.175]:54276
	"EHLO hades.sngx.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751342AbYE2CGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 22:06:49 -0400
Message-ID: <483E1005.3080804@sngx.net>
Date: Wed, 28 May 2008 21:08:05 -0500
From: James Cammarata <jimi@sngx.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: add ability to clear stats via ethtool - e1000/pcnet32
References: <482DA5B6.1020606@sngx.net> <482DB46A.8020103@cosmosbay.com> <482EF192.4070707@sngx.net> <482F5113.5090703@cosmosbay.com> <482F610D.2080108@sngx.net> <20080518003104.GK28241@solarflare.com> <482FBA09.80201@sngx.net> <483E0AAE.2020107@sngx.net>
In-Reply-To: <483E0AAE.2020107@sngx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missed an errant define in some copied code (from the get_stats function in e1000_main.c).

Signed-off-by: James Cammarata <jimi@sngx.net>
---

--- linux-2.6.25.4/drivers/net/e1000/e1000_main.c	2008-05-15 10:00:12.000000000 -0500
+++ linux-2.6.25.4-jcammara/drivers/net/e1000/e1000_main.c	2008-05-28 21:06:19.000000000 -0500
@@ -141,6 +141,7 @@ static void e1000_free_tx_resources(stru
 static void e1000_free_rx_resources(struct e1000_adapter *adapter,
                              struct e1000_rx_ring *rx_ring);
 void e1000_update_stats(struct e1000_adapter *adapter);
+void e1000_clear_stats(struct e1000_adapter *adapter);
 
 static int e1000_init_module(void);
 static void e1000_exit_module(void);
@@ -3819,6 +3820,29 @@ e1000_update_stats(struct e1000_adapter 
 	spin_unlock_irqrestore(&adapter->stats_lock, flags);
 }
 
+void
+e1000_clear_stats(struct e1000_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	unsigned long flags;
+
+	/*
+	 * Prevent stats update while adapter is being reset, or if the pci
+	 * connection is down.
+	 */
+	if (adapter->link_speed == 0)
+		return;
+	if (pci_channel_offline(pdev))
+		return;
+
+	spin_lock_irqsave(&adapter->stats_lock, flags);
+
+	memset(&adapter->stats, 0, sizeof(struct e1000_hw_stats));
+	memset(&adapter->net_stats, 0, sizeof(struct net_device_stats));
+
+	spin_unlock_irqrestore(&adapter->stats_lock, flags);
+}
+
 /**
  * e1000_intr_msi - Interrupt Handler
  * @irq: interrupt number


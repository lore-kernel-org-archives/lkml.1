Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbZDTNDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbZDTNDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 09:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbZDTNDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 09:03:37 -0400
Received: from dns.vivotek.com ([211.21.25.250]:21896 "EHLO edge.vivotek.tw"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752897AbZDTNDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 09:03:36 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 09:03:35 EDT
From: <jon.lin@vatics.com>
To: <davem@davemloft.net>
CC: <dada1@cosmosbay.com>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <jon.lin@vatics.com>
Date: Mon, 20 Apr 2009 20:58:01 +0800
Subject: [PATCH 2.6.29.1 1/1] 8139too: fix HW initial flow
Thread-Topic: [PATCH 2.6.29.1 1/1] 8139too: fix HW initial flow
Thread-Index: AcnBt6LCwscjlqmYTNuQvyyEnAKdYQ==
Message-ID: <0E04AEADD178614A86F3017CC5FA693B4959924809@MS.vivotek.tw>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
Content-Type: text/plain; charset="big5"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n3KD3vqu016413

From: Jonathan Lin <jon.lin@vatics.com>

While ifconfig eth0 up kernel calls open() of 8139 driver(8139too.c).
In rtl8139_hw_start() of rtl8139_open(), 8139 driver enable RX before setting up the DMA buffer address. In this interval where RX was enabled and DMA buffer address is not yet set up, any incoming broadcast packet would be send to a strange physical address:
0x003e8800 which is the default value of DMA buffer address.
Unfortunately, this address is used by Linux kernel. So kernel panics.
This patch fix it by setting up DMA buffer address before RX enabled and everything is fine even under broadcast packets attack.

Signed-off-by: Jonathan Lin <jon.lin@vatics.com>

--- linux-2.6.29.1/drivers/net/8139too.c.orig   2009-04-19 17:50:38.000000000 +0800
+++ linux-2.6.29.1/drivers/net/8139too.c        2009-04-19 17:52:51.000000000 +0800
@@ -1382,6 +1382,10 @@ static void rtl8139_hw_start (struct net
        RTL_W32_F (MAC0 + 0, le32_to_cpu (*(__le32 *) (dev->dev_addr + 0)));
        RTL_W32_F (MAC0 + 4, le16_to_cpu (*(__le16 *) (dev->dev_addr + 4)));

+       tp->cur_rx = 0;
+       /* init Rx ring buffer DMA address BEFORE Rx enabled*/
+       RTL_W32_F (RxBuf, tp->rx_ring_dma);
+
        /* Must enable Tx/Rx before setting transfer thresholds! */
        RTL_W8 (ChipCmd, CmdRxEnb | CmdTxEnb);

@@ -1389,8 +1393,6 @@ static void rtl8139_hw_start (struct net
        RTL_W32 (RxConfig, tp->rx_config);
        RTL_W32 (TxConfig, rtl8139_tx_config);

-       tp->cur_rx = 0;
-
        rtl_check_media (dev, 1);

        if (tp->chipset >= CH_8139B) {
@@ -1405,9 +1407,6 @@ static void rtl8139_hw_start (struct net
        /* Lock Config[01234] and BMCR register writes */
        RTL_W8 (Cfg9346, Cfg9346_Lock);

-       /* init Rx ring buffer DMA address */
-       RTL_W32_F (RxBuf, tp->rx_ring_dma);
-
        /* init Tx buffer DMA addresses */
        for (i = 0; i < NUM_TX_DESC; i++)
                RTL_W32_F (TxAddr0 + (i * 4), tp->tx_bufs_dma + (tp->tx_buf[i] - tp->tx_bufs));
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

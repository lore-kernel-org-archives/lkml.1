Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYJKItX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYJKItX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 04:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbYJKItO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 04:49:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:57801 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbYJKItN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 04:49:13 -0400
Message-ID: <b2cdc9f30810110149k7ca4f331q872a200465a9eb0e@mail.gmail.com>
Date: Sat, 11 Oct 2008 09:49:12 +0100
From: "Alex Bennee" <kernel-hacker@bennee.com>
To: "=?ISO-8859-1?Q?Bruno_Pr=E9mont?=" <bonbons@linux-vserver.org>
Subject: Re: rtl8169_get_stats seems to be adding random crap to rx_missed_errors count
Cc: linux-kernel@vger.kernel.org, "Francois Romieu" <romieu@fr.zoreil.com>,
       torvalds@linux-foundation.org
In-Reply-To: <b2cdc9f30810102342t5bb07d82m94a4bffab2b68673@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <b2cdc9f30810100947s699dbc76ia72023b08e064816@mail.gmail.com>
	 <b2cdc9f30810100953i680c2d02s8352bb109d494bf1@mail.gmail.com>
	 <20081010232724.1447f915@neptune.home>
	 <b2cdc9f30810102342t5bb07d82m94a4bffab2b68673@mail.gmail.com>
X-Google-Sender-Auth: 113b71c908e4f75a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2008 at 7:42 AM, Alex Bennee <kernel-hacker@bennee.com> wrote:
> On Fri, Oct 10, 2008 at 10:27 PM, Bruno Prémont
> <bonbons@linux-vserver.org> wrote:
>> Hi Alex,
>>
>> This issue has already been reported in
>>  http://lkml.org/lkml/2008/10/9/235
>> and a patch exists.
>>
>> Could you verify that patch #0009 at URL below fixes the issue for you:
>>  http://userweb.kernel.org/~romieu/r8169/2.6.27-rc9/20081007/
>
> I can confirm that patch works for me. I have further reviewed the
> code and it looks OK to me from here. Should I just forward the patch
> and tag it to the mailing list or is it now in a tree that gets picked
> up?


>From 96b79ad3d9e8c15a0118810e91f0e28ce5575493 Mon Sep 17 00:00:00 2001
From: Francois Romieu <romieu@fr.zoreil.com>
Date: Wed, 10 Sep 2008 22:28:56 +0200
Subject: [PATCH] r8169: fix RxMissed register access

- the register is defined for the 8169 chipset only and there is
  no 8169 beyond RTL_GIGA_MAC_VER_06.
- only the lower 3 bytes of the register are valid

Fixes:
1. http://bugzilla.kernel.org/show_bug.cgi?id=10180
2. http://bugzilla.kernel.org/show_bug.cgi?id=11062 (bits of)

Tested by Hermann Gausterer and Adam Huffman.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Edward Hsu <edward_hsu@realtek.com.tw>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Tested-by: Alex Bennee <kernel-hacker@bennee.com>
---
 drivers/net/r8169.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 0f6f974..4190ee7 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2099,8 +2099,6 @@ static void rtl_hw_start_8168(struct net_device *dev)

 	RTL_R8(IntrMask);

-	RTL_W32(RxMissed, 0);
-
 	rtl_set_rx_mode(dev);

 	RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
@@ -2143,8 +2141,6 @@ static void rtl_hw_start_8101(struct net_device *dev)

 	RTL_R8(IntrMask);

-	RTL_W32(RxMissed, 0);
-
 	rtl_set_rx_mode(dev);

 	RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
@@ -2922,6 +2918,17 @@ static int rtl8169_poll(struct napi_struct
*napi, int budget)
 	return work_done;
 }

+static void rtl8169_rx_missed(struct net_device *dev, void __iomem *ioaddr)
+{
+	struct rtl8169_private *tp = netdev_priv(dev);
+
+	if (tp->mac_version > RTL_GIGA_MAC_VER_06)
+		return;
+
+	dev->stats.rx_missed_errors += (RTL_R32(RxMissed) & 0xffffff);
+	RTL_W32(RxMissed, 0);
+}
+
 static void rtl8169_down(struct net_device *dev)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
@@ -2939,9 +2946,7 @@ core_down:

 	rtl8169_asic_down(ioaddr);

-	/* Update the error counts. */
-	dev->stats.rx_missed_errors += RTL_R32(RxMissed);
-	RTL_W32(RxMissed, 0);
+	rtl8169_rx_missed(dev, ioaddr);

 	spin_unlock_irq(&tp->lock);

@@ -3063,8 +3068,7 @@ static struct net_device_stats
*rtl8169_get_stats(struct net_device *dev)

 	if (netif_running(dev)) {
 		spin_lock_irqsave(&tp->lock, flags);
-		dev->stats.rx_missed_errors += RTL_R32(RxMissed);
-		RTL_W32(RxMissed, 0);
+		rtl8169_rx_missed(dev, ioaddr);
 		spin_unlock_irqrestore(&tp->lock, flags);
 	}

@@ -3089,8 +3093,7 @@ static int rtl8169_suspend(struct pci_dev *pdev,
pm_message_t state)

 	rtl8169_asic_down(ioaddr);

-	dev->stats.rx_missed_errors += RTL_R32(RxMissed);
-	RTL_W32(RxMissed, 0);
+	rtl8169_rx_missed(dev, ioaddr);

 	spin_unlock_irq(&tp->lock);

-- 
1.5.6.4

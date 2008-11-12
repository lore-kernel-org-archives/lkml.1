Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbYKLAef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbYKLAef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbYKLA0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:34 -0500
Received: from kroah.org ([198.145.64.141]:42330 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752299AbYKLA0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:31 -0500
Date: Tue, 11 Nov 2008 16:23:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ivan Vecera <ivecera@redhat.com>,
       Edward Hsu <edward_hsu@realtek.com.tw>,
       Jeff Garzik <jgarzik@redhat.com>,
       Martin Capitanio <martin@capitanio.org>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: [patch 22/49] r8169: fix RxMissed register access
Message-ID: <20081112002339.GW10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="r8169-fix-rxmissed-register-access.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

Upstream as 523a609496dbc3897e530db2a2f27650d125ea00

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2092,8 +2092,6 @@ static void rtl_hw_start_8168(struct net
 
 	RTL_R8(IntrMask);
 
-	RTL_W32(RxMissed, 0);
-
 	rtl_set_rx_mode(dev);
 
 	RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
@@ -2136,8 +2134,6 @@ static void rtl_hw_start_8101(struct net
 
 	RTL_R8(IntrMask);
 
-	RTL_W32(RxMissed, 0);
-
 	rtl_set_rx_mode(dev);
 
 	RTL_W8(ChipCmd, CmdTxEnb | CmdRxEnb);
@@ -2915,6 +2911,17 @@ static int rtl8169_poll(struct napi_stru
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
@@ -2932,9 +2939,7 @@ core_down:
 
 	rtl8169_asic_down(ioaddr);
 
-	/* Update the error counts. */
-	dev->stats.rx_missed_errors += RTL_R32(RxMissed);
-	RTL_W32(RxMissed, 0);
+	rtl8169_rx_missed(dev, ioaddr);
 
 	spin_unlock_irq(&tp->lock);
 
@@ -3056,8 +3061,7 @@ static struct net_device_stats *rtl8169_
 
 	if (netif_running(dev)) {
 		spin_lock_irqsave(&tp->lock, flags);
-		dev->stats.rx_missed_errors += RTL_R32(RxMissed);
-		RTL_W32(RxMissed, 0);
+		rtl8169_rx_missed(dev, ioaddr);
 		spin_unlock_irqrestore(&tp->lock, flags);
 	}
 
@@ -3082,8 +3086,7 @@ static int rtl8169_suspend(struct pci_de
 
 	rtl8169_asic_down(ioaddr);
 
-	dev->stats.rx_missed_errors += RTL_R32(RxMissed);
-	RTL_W32(RxMissed, 0);
+	rtl8169_rx_missed(dev, ioaddr);
 
 	spin_unlock_irq(&tp->lock);
 

-- 

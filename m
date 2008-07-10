Return-Path: <linux-kernel-owner+w=401wt.eu-S1758584AbYGJNwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbYGJNwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756557AbYGJNwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:52:33 -0400
Received: from usagi.ingate.se ([193.180.23.12]:55100 "EHLO usagi.ingate.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273AbYGJNwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:52:32 -0400
X-Greylist: delayed 1261 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jul 2008 09:52:32 EDT
Message-ID: <48760F22.8040208@ingate.com>
Date: Thu, 10 Jul 2008 15:31:14 +0200
From: Marcus Sundberg <marcus@ingate.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.26-rc9] r8169: Avoid thrashing PCI conf space on RTL_GIGA_MAC_VER_20.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (usagi.ingate.se [193.180.23.12]); Thu, 10 Jul 2008 15:31:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The magic write to register 0x82 will often cause PCI config space on
my 8168 (PCI ID 10ec:8168, revision 2. mounted in an LG P300 laptop)
to be filled with ones during driver load, and thus breaking NIC
operation until reboot. If it does not happen on first driver load it
can easily be reproduced by unloading and loading the driver a few
times.

The magic write was added long ago by this commit:

Author: François Romieu <romieu@fr.zoreil.com>
Date:   Sat Jan 10 06:00:46 2004 -0500

     [netdrvr r8169] Merge of changes done by Realtek to rtl8169_init_one():
     - phy capability settings allows lower or equal capability as suggested
       in Realtek's changes;
     - I/O voodoo;
     - no need to s/mdio_write/RTL8169_WRITE_GMII_REG/;
     - s/rtl8169_hw_PHY_config/rtl8169_hw_phy_config/;
     - rtl8169_hw_phy_config(): ad-hoc struct "phy_magic" to limit duplication
       of code (yep, the u16 -> int conversions should work as expected);
     - variable renames and whitepace changes ignored.

As the 8168 wasn't supported by that version this patch simply removes
the bogus write from mac versions <= RTL_GIGA_MAC_VER_06.

Signed-off-by: Marcus Sundberg <marcus@ingate.com>
---
The magic write is not present in the r8168 driver from RealTek either.
Does anyone know what it's supposed to do?

//Marcus

  drivers/net/r8169.c |    6 ++++--
  1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 6572425..42d7c0a 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1438,8 +1438,10 @@ static void rtl8169_init_phy(struct net_device *dev, struct rtl8169_private *tp)

  	rtl_hw_phy_config(dev);

-	dprintk("Set MAC Reg C+CR Offset 0x82h = 0x01h\n");
-	RTL_W8(0x82, 0x01);
+	if (tp->mac_version <= RTL_GIGA_MAC_VER_06) {
+		dprintk("Set MAC Reg C+CR Offset 0x82h = 0x01h\n");
+		RTL_W8(0x82, 0x01);
+	}

  	pci_write_config_byte(tp->pci_dev, PCI_LATENCY_TIMER, 0x40);

-- 
---------------------------------------+--------------------------
   Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
  Software Developer, Ingate Systems AB |  http://www.ingate.com/

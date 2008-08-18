Return-Path: <linux-kernel-owner+w=401wt.eu-S1763190AbYHRTqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763190AbYHRTqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932104AbYHRTmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:42:19 -0400
Received: from mx1.suse.de ([195.135.220.2]:49611 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765444AbYHRTmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:42:17 -0400
Date: Mon, 18 Aug 2008 12:20:49 -0700
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
       alan@lxorguk.ukuu.org.uk, Marcus Sundberg <marcus@ingate.com>,
       Francois Romieu <romieu@fr.zoreil.com>, Karsten Keil <kkeil@suse.de>
Subject: [patch 42/49] r8169: avoid thrashing PCI conf space above
	RTL_GIGA_MAC_VER_06
Message-ID: <20080818192049.GQ10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="r8169-avoid-thrashing-pci-conf-space-above-rtl_giga_mac_ver_06.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcus Sundberg <marcus@ingate.com>

commit 77332894c21165404496c56763d7df6c15c4bb09 upstream

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

[The change above makes sense for the 8101/8102 too -- Ueimor]

Signed-off-by: Marcus Sundberg <marcus@ingate.com>
Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1438,8 +1438,10 @@ static void rtl8169_init_phy(struct net_
 
 	rtl_hw_phy_config(dev);
 
-	dprintk("Set MAC Reg C+CR Offset 0x82h = 0x01h\n");
-	RTL_W8(0x82, 0x01);
+	if (tp->mac_version <= RTL_GIGA_MAC_VER_06) {
+		dprintk("Set MAC Reg C+CR Offset 0x82h = 0x01h\n");
+		RTL_W8(0x82, 0x01);
+	}
 
 	pci_write_config_byte(tp->pci_dev, PCI_LATENCY_TIMER, 0x40);
 

-- 

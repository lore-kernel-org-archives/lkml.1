Return-Path: <linux-kernel-owner+w=401wt.eu-S1764398AbYBGAAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764398AbYBGAAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764236AbYBFXyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:54:40 -0500
Received: from mail.suse.de ([195.135.220.2]:45207 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764227AbYBFXyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:54:39 -0500
Date: Wed, 6 Feb 2008 15:51:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [patch 13/73] sky2: disable rx checksum on Yukon XL
Message-ID: <20080206235123.GN13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=sky2-xl-chksum
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Stephen Hemminger <shemminger@linux-foundation.org>

Backport of 8b31cfbcd1b54362ef06c85beb40e65a349169a2

The Marvell Yukon XL chipset appears to have a hardware glitch
where it will repeat the checksum of the last packet. Of course, this is
timing sensitive and only happens sometimes...

More info: http://bugzilla.kernel.org/show_bug.cgi?id=9381

As a workaround just disable hardware checksumming by default on
this chip version. The earlier workaround for PCIX, dual port
was also on Yukon XL so don't need to disable checksumming there.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/sky2.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -1307,15 +1307,11 @@ static int sky2_up(struct net_device *de
 	 */
 	if (otherdev && netif_running(otherdev) &&
  	    (cap = pci_find_capability(hw->pdev, PCI_CAP_ID_PCIX))) {
- 		struct sky2_port *osky2 = netdev_priv(otherdev);
  		u16 cmd;
 
  		cmd = sky2_pci_read16(hw, cap + PCI_X_CMD);
  		cmd &= ~PCI_X_CMD_MAX_SPLIT;
  		sky2_pci_write16(hw, cap + PCI_X_CMD, cmd);
-
- 		sky2->rx_csum = 0;
- 		osky2->rx_csum = 0;
  	}
 
 	if (netif_msg_ifup(sky2))
@@ -4017,7 +4013,7 @@ static __devinit struct net_device *sky2
 	sky2->duplex = -1;
 	sky2->speed = -1;
 	sky2->advertising = sky2_supported_modes(hw);
-	sky2->rx_csum = 1;
+	sky2->rx_csum = (hw->chip_id != CHIP_ID_YUKON_XL);
 	sky2->wol = wol;
 
 	spin_lock_init(&sky2->phy_lock);

-- 

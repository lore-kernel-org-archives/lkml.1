Return-Path: <linux-kernel-owner+w=401wt.eu-S933963AbYBGAcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963AbYBGAcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764034AbYBGAA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:00:27 -0500
Received: from ns.suse.de ([195.135.220.2]:46761 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764147AbYBGAAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:00:23 -0500
Date: Wed, 6 Feb 2008 15:54:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com,
       chrisw@sous-sol.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       david.harris@cpni-inc.com, csnook@redhat.com, jeff@garzik.org,
       Jay Cliburn <jacliburn@bellsouth.net>
Subject: [patch 71/73] atl1: fix frame length bug
Message-ID: <20080206235437.GT13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="atl1-fix-frame-length-bug.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Jay Cliburn <jacliburn@bellsouth.net>


Upstream commit: 2a49128f0a6edee337174ea341c1d6d7565be350

The driver sets up the hardware to accept a frame with max length
equal to MTU + Ethernet header + FCS + VLAN tag, but we neglect to
add the VLAN tag size to the ingress buffer.  When a VLAN-tagged
frame arrives, the hardware passes it, but bad things happen
because the buffer is too small.  This patch fixes that.

Thanks to David Harris for reporting the bug and testing the fix.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Tested-by: David Harris <david.harris@cpni-inc.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atl1/atl1_main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -121,7 +121,7 @@ static int __devinit atl1_sw_init(struct
 	struct atl1_hw *hw = &adapter->hw;
 	struct net_device *netdev = adapter->netdev;
 
-	hw->max_frame_size = netdev->mtu + ETH_HLEN + ETH_FCS_LEN;
+	hw->max_frame_size = netdev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
 	hw->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
 
 	adapter->wol = 0;
@@ -689,7 +689,7 @@ static int atl1_change_mtu(struct net_de
 {
 	struct atl1_adapter *adapter = netdev_priv(netdev);
 	int old_mtu = netdev->mtu;
-	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;
+	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
 
 	if ((max_frame < ETH_ZLEN + ETH_FCS_LEN) ||
 	    (max_frame > MAX_JUMBO_FRAME_SIZE)) {
@@ -854,8 +854,8 @@ static u32 atl1_configure(struct atl1_ad
 	/* set Interrupt Clear Timer */
 	iowrite16(adapter->ict, hw->hw_addr + REG_CMBDISDMA_TIMER);
 
-	/* set MTU, 4 : VLAN */
-	iowrite32(hw->max_frame_size + 4, hw->hw_addr + REG_MTU);
+	/* set max frame size hw will accept */
+	iowrite32(hw->max_frame_size, hw->hw_addr + REG_MTU);
 
 	/* jumbo size & rrd retirement timer */
 	value = (((u32) hw->rx_jumbo_th & RXQ_JMBOSZ_TH_MASK)

-- 

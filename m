Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477Ab0AZXz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab0AZXz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331Ab0AZXzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:55:52 -0500
Received: from kroah.org ([198.145.64.141]:35353 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab0AZXnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:46 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:27 2010
Message-Id: <20100126233927.843428460@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [53/98] [SCSI] fcoe: Fix getting san mac for VLAN interface
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yi Zou <yi.zou@intel.com>

commit 5bab87e6d465d54a2b5899e0f583d42f00dbee2e upstream.

Make sure we are get the SAN MAC address from the real netdev if the input
netdev is a VLAN device.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/fcoe/fcoe.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -160,6 +160,7 @@ static int fcoe_interface_setup(struct f
 {
 	struct fcoe_ctlr *fip = &fcoe->ctlr;
 	struct netdev_hw_addr *ha;
+	struct net_device *real_dev;
 	u8 flogi_maddr[ETH_ALEN];
 
 	fcoe->netdev = netdev;
@@ -173,8 +174,10 @@ static int fcoe_interface_setup(struct f
 
 	/* look for SAN MAC address, if multiple SAN MACs exist, only
 	 * use the first one for SPMA */
+	real_dev = (netdev->priv_flags & IFF_802_1Q_VLAN) ?
+		vlan_dev_real_dev(netdev) : netdev;
 	rcu_read_lock();
-	for_each_dev_addr(netdev, ha) {
+	for_each_dev_addr(real_dev, ha) {
 		if ((ha->type == NETDEV_HW_ADDR_T_SAN) &&
 		    (is_valid_ether_addr(ha->addr))) {
 			memcpy(fip->ctl_src_addr, ha->addr, ETH_ALEN);



Return-Path: <linux-kernel-owner+w=401wt.eu-S1764343AbXKOGrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764343AbXKOGrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757512AbXKOGm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:42:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55131 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761932AbXKOGm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:42:56 -0500
Date: Wed, 14 Nov 2007 22:40:52 -0800
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
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 10/16] sky2: status ring race fix
Message-ID: <20071115064052.GJ18951@kroah.com>
References: <20071115060353.071060513@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sky2-status-race.patch"
In-Reply-To: <20071115063921.GA18827@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen Hemminger <shemminger@linux-foundation.org>

patch ab5adecb2d02f3688719dfb5936a82833fcc3955 in mainline.

The D-Link PCI-X board (and maybe others) can lie about status
ring entries. It seems it will update the register for last status
index before completing the DMA for the ring entry. To avoid reading
stale data, zap the old entry and check.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sky2.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -2246,20 +2246,26 @@ static int sky2_status_intr(struct sky2_
 	while (hw->st_idx != hwidx) {
 		struct sky2_port *sky2;
 		struct sky2_status_le *le  = hw->st_le + hw->st_idx;
-		unsigned port = le->css & CSS_LINK_BIT;
+		unsigned port;
 		struct net_device *dev;
 		struct sk_buff *skb;
 		u32 status;
 		u16 length;
+		u8 opcode = le->opcode;
+
+		if (!(opcode & HW_OWNER))
+			break;
 
 		hw->st_idx = RING_NEXT(hw->st_idx, STATUS_RING_SIZE);
 
+		port = le->css & CSS_LINK_BIT;
 		dev = hw->dev[port];
 		sky2 = netdev_priv(dev);
 		length = le16_to_cpu(le->length);
 		status = le32_to_cpu(le->status);
 
-		switch (le->opcode & ~HW_OWNER) {
+		le->opcode = 0;
+		switch (opcode & ~HW_OWNER) {
 		case OP_RXSTAT:
 			++rx[port];
 			skb = sky2_receive(dev, length, status);
@@ -2352,7 +2358,7 @@ static int sky2_status_intr(struct sky2_
 		default:
 			if (net_ratelimit())
 				printk(KERN_WARNING PFX
-				       "unknown status opcode 0x%x\n", le->opcode);
+				       "unknown status opcode 0x%x\n", opcode);
 		}
 	}
 

-- 

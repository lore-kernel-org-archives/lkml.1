Return-Path: <linux-kernel-owner+w=401wt.eu-S1761176AbXLMHCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761176AbXLMHCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761488AbXLMG4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:56:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55130 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761474AbXLMG4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:56:10 -0500
Date: Wed, 12 Dec 2007 22:51:44 -0800
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
       Ayaz Abdulla <aabdulla@nvidia.com>, Alex Howells <astinus@gentoo.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: [patch 15/60] forcedeth boot delay fix
Message-ID: <20071213065144.GP6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="forcedeth-boot-delay-fix.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ayaz Abdulla <aabdulla@nvidia.com>

patch 9e555930bd873d238f5f7b9d76d3bf31e6e3ce93 in mainline.

Fix a long boot delay in the forcedeth driver.  During initialization, the
timeout for the handshake between mgmt unit and driver can be very long.
The patch reduces the timeout by eliminating a extra loop around the
timeout logic.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=9308

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Alex Howells <astinus@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/forcedeth.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -5280,19 +5280,15 @@ static int __devinit nv_probe(struct pci
 		if (readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_SYNC_PHY_INIT) {
 			np->mac_in_use = readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_MGMT_ST;
 			dprintk(KERN_INFO "%s: mgmt unit is running. mac in use %x.\n", pci_name(pci_dev), np->mac_in_use);
-			for (i = 0; i < 5000; i++) {
-				msleep(1);
-				if (nv_mgmt_acquire_sema(dev)) {
-					/* management unit setup the phy already? */
-					if ((readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_SYNC_MASK) ==
-					    NVREG_XMITCTL_SYNC_PHY_INIT) {
-						/* phy is inited by mgmt unit */
-						phyinitialized = 1;
-						dprintk(KERN_INFO "%s: Phy already initialized by mgmt unit.\n", pci_name(pci_dev));
-					} else {
-						/* we need to init the phy */
-					}
-					break;
+			if (nv_mgmt_acquire_sema(dev)) {
+				/* management unit setup the phy already? */
+				if ((readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_SYNC_MASK) ==
+				    NVREG_XMITCTL_SYNC_PHY_INIT) {
+					/* phy is inited by mgmt unit */
+					phyinitialized = 1;
+					dprintk(KERN_INFO "%s: Phy already initialized by mgmt unit.\n", pci_name(pci_dev));
+				} else {
+					/* we need to init the phy */
 				}
 			}
 		}

-- 

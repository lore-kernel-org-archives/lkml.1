Return-Path: <linux-kernel-owner+w=401wt.eu-S1764101AbZGAAw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764101AbZGAAw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761381AbZGAAe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:28 -0400
Received: from kroah.org ([198.145.64.141]:60144 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761084AbZGAAeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:18 2009
Message-Id: <20090701002418.606152665@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@vyatta.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 020/108] sky2: dont look for VPD size
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=sky2-don-t-look-for-vpd-size.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen Hemminger <shemminger@vyatta.com>

[ Upstream commit 6cc90a5a6061428358d0f726a53fb44af5254111 ]

The code to compute VPD size didn't handle some systems that use
chip without VPD. Also some of the newer chips use some additional
registers to store the actual size, and wasn't worth putting the
additional complexity in, so just remove the code.

No big loss since the code to set the VPD size was only a
convenience so that utilities would not read the extra space past
the end of the available VPD.

Move the first PCI config read earlier to detect bad hardware
where it returns all ones and refuse loading driver before furthur
damage.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Tested-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sky2.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -4365,6 +4365,22 @@ static int __devinit sky2_probe(struct p
 		goto err_out;
 	}
 
+	/* Get configuration information
+	 * Note: only regular PCI config access once to test for HW issues
+	 *       other PCI access through shared memory for speed and to
+	 *	 avoid MMCONFIG problems.
+	 */
+	err = pci_read_config_dword(pdev, PCI_DEV_REG2, &reg);
+	if (err) {
+		dev_err(&pdev->dev, "PCI read config failed\n");
+		goto err_out;
+	}
+
+	if (~reg == 0) {
+		dev_err(&pdev->dev, "PCI configuration read error\n");
+		goto err_out;
+	}
+
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
 		dev_err(&pdev->dev, "cannot obtain PCI resources\n");
@@ -4390,21 +4406,6 @@ static int __devinit sky2_probe(struct p
 		}
 	}
 
-	/* Get configuration information
-	 * Note: only regular PCI config access once to test for HW issues
-	 *       other PCI access through shared memory for speed and to
-	 *	 avoid MMCONFIG problems.
-	 */
-	err = pci_read_config_dword(pdev, PCI_DEV_REG2, &reg);
-	if (err) {
-		dev_err(&pdev->dev, "PCI read config failed\n");
-		goto err_out_free_regions;
-	}
-
-	/* size of available VPD, only impact sysfs */
-	err = pci_vpd_truncate(pdev, 1ul << (((reg & PCI_VPD_ROM_SZ) >> 14) + 8));
-	if (err)
-		dev_warn(&pdev->dev, "Can't set VPD size\n");
 
 #ifdef __BIG_ENDIAN
 	/* The sk98lin vendor driver uses hardware byte swapping but



Return-Path: <linux-kernel-owner+w=401wt.eu-S933851AbYDQB1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933851AbYDQB1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761135AbYDQBJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:09:26 -0400
Received: from sous-sol.org ([216.99.217.87]:58995 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760272AbYDQBJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:09:25 -0400
Message-Id: <20080417010352.370426951@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:09 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Francois Romieu <romieu@fr.zoreil.com>, Jeff Garzik <jeff@garzik.org>,
       Daniel Drake <dsd@gentoo.org>
Subject: sis190: read the mac address from the eeprom first
Content-Disposition: inline; filename=sis190-read-the-mac-address-from-the-eeprom-first.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Francois Romieu <romieu@fr.zoreil.com>

upstream commit: 563e0ae06ff18f0b280f11cf706ba0172255ce52

Reading a serie of zero from the cmos sram area do not work
well with is_valid_ether_addr(). Let's read the mac address
from the eeprom first as it seems more reliable.

Fix for http://bugzilla.kernel.org/show_bug.cgi?id=9831

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>

dsd@gentoo.org notes:
This patch fixes http://bugs.gentoo.org/207706

Cc: Daniel Drake <dsd@gentoo.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/sis190.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/net/sis190.c
+++ b/drivers/net/sis190.c
@@ -1632,13 +1632,18 @@ static inline void sis190_init_rxfilter(
 
 static int sis190_get_mac_addr(struct pci_dev *pdev, struct net_device *dev)
 {
-	u8 from;
+	int rc;
+
+	rc = sis190_get_mac_addr_from_eeprom(pdev, dev);
+	if (rc < 0) {
+		u8 reg;
 
-	pci_read_config_byte(pdev, 0x73, &from);
+		pci_read_config_byte(pdev, 0x73, &reg);
 
-	return (from & 0x00000001) ?
-		sis190_get_mac_addr_from_apc(pdev, dev) :
-		sis190_get_mac_addr_from_eeprom(pdev, dev);
+		if (reg & 0x00000001)
+			rc = sis190_get_mac_addr_from_apc(pdev, dev);
+	}
+	return rc;
 }
 
 static void sis190_set_speed_auto(struct net_device *dev)

-- 

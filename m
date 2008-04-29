Return-Path: <linux-kernel-owner+w=401wt.eu-S1763586AbYD2R3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763586AbYD2R3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759009AbYD2RVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:21:33 -0400
Received: from mx1.suse.de ([195.135.220.2]:52240 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758959AbYD2RVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:21:31 -0400
Date: Tue, 29 Apr 2008 10:18:50 -0700
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
       linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [23/37] b43: Workaround invalid bluetooth settings
Message-ID: <20080429171850.GX14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43-workaround-invalid-bluetooth-settings.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Michael Buesch <mb@bu3sch.de>

commit 1855ba7812dbd294fcfc083dc7d3b14d3b1f38db upstream.

This adds a workaround for invalid bluetooth SPROM settings
on ASUS PCI cards.
This will stop the microcode from poking with the BT GPIO line.
This fixes data transmission on this device, as the BT GPIO line
is used for something TX related on this device
(probably the power amplifier or the radio).
This also adds a modparam knob to help debugging this in the future,
as more devices with this bug may show up.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/wireless/b43/main.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -78,6 +78,11 @@ static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
+static int modparam_btcoex = 1;
+module_param_named(btcoex, modparam_btcoex, int, 0444);
+MODULE_PARM_DESC(btcoex, "Enable Bluetooth coexistance (default on)");
+
+
 static const struct ssb_device_id b43_ssb_tbl[] = {
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 5),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 6),
@@ -3339,6 +3344,8 @@ static void b43_bluetooth_coext_enable(s
 	struct ssb_sprom *sprom = &dev->dev->bus->sprom;
 	u32 hf;
 
+	if (!modparam_btcoex)
+		return;
 	if (!(sprom->boardflags_lo & B43_BFL_BTCOEXIST))
 		return;
 	if (dev->phy.type != B43_PHYTYPE_B && !dev->phy.gmode)
@@ -3350,11 +3357,13 @@ static void b43_bluetooth_coext_enable(s
 	else
 		hf |= B43_HF_BTCOEX;
 	b43_hf_write(dev, hf);
-	//TODO
 }
 
 static void b43_bluetooth_coext_disable(struct b43_wldev *dev)
-{				//TODO
+{
+	if (!modparam_btcoex)
+		return;
+	//TODO
 }
 
 static void b43_imcfglo_timeouts_workaround(struct b43_wldev *dev)
@@ -4002,6 +4011,8 @@ static int b43_one_core_attach(struct ss
 
 static void b43_sprom_fixup(struct ssb_bus *bus)
 {
+	struct pci_dev *pdev;
+
 	/* boardflags workarounds */
 	if (bus->boardinfo.vendor == SSB_BOARDVENDOR_DELL &&
 	    bus->chip_id == 0x4301 && bus->boardinfo.rev == 0x74)
@@ -4009,6 +4020,14 @@ static void b43_sprom_fixup(struct ssb_b
 	if (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE &&
 	    bus->boardinfo.type == 0x4E && bus->boardinfo.rev > 0x40)
 		bus->sprom.boardflags_lo |= B43_BFL_PACTRL;
+	if (bus->bustype == SSB_BUSTYPE_PCI) {
+		pdev = bus->host_pci;
+		if (pdev->vendor == PCI_VENDOR_ID_BROADCOM &&
+		    pdev->device == 0x4318 &&
+		    pdev->subsystem_vendor == PCI_VENDOR_ID_ASUSTEK &&
+		    pdev->subsystem_device == 0x100F)
+			bus->sprom.boardflags_lo &= ~B43_BFL_BTCOEXIST;
+	}
 }
 
 static void b43_wireless_exit(struct ssb_device *dev, struct b43_wl *wl)

-- 

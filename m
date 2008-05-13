Return-Path: <linux-kernel-owner+w=401wt.eu-S1763210AbYEMUV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763210AbYEMUV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932091AbYEMUPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:15:36 -0400
Received: from ns1.suse.de ([195.135.220.2]:38286 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086AbYEMUPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:15:34 -0400
Date: Tue, 13 May 2008 13:12:25 -0700
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
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 23/37] i2c-piix4: Blacklist two mainboards
Message-ID: <20080513201225.GX31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i2c-piix4-blacklist-two-mainboards.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit c2fc54fcd340cbee47510aa84c346aab3440ba09 upstream

We had a report that running sensors-detect on a Sapphire AM2RD790
motherbord killed the CPU. While the exact cause is still unknown,
I'd rather play it safe and prevent any access to the SMBus on that
machine by not letting the i2c-piix4 driver attach to the SMBus host
device on that machine. Also blacklist a similar board made by DFI.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/busses/i2c-piix4.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -108,7 +108,27 @@ static unsigned short piix4_smba;
 static struct pci_driver piix4_driver;
 static struct i2c_adapter piix4_adapter;
 
-static struct dmi_system_id __devinitdata piix4_dmi_table[] = {
+static struct dmi_system_id __devinitdata piix4_dmi_blacklist[] = {
+	{
+		.ident = "Sapphire AM2RD790",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "SAPPHIRE Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "PC-AM2RD790"),
+		},
+	},
+	{
+		.ident = "DFI Lanparty UT 790FX",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "DFI Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "LP UT 790FX"),
+		},
+	},
+	{ }
+};
+
+/* The IBM entry is in a separate table because we only check it
+   on Intel-based systems */
+static struct dmi_system_id __devinitdata piix4_dmi_ibm[] = {
 	{
 		.ident = "IBM",
 		.matches = { DMI_MATCH(DMI_SYS_VENDOR, "IBM"), },
@@ -123,8 +143,16 @@ static int __devinit piix4_setup(struct 
 
 	dev_info(&PIIX4_dev->dev, "Found %s device\n", pci_name(PIIX4_dev));
 
+	/* On some motherboards, it was reported that accessing the SMBus
+	   caused severe hardware problems */
+	if (dmi_check_system(piix4_dmi_blacklist)) {
+		dev_err(&PIIX4_dev->dev,
+			"Accessing the SMBus on this system is unsafe!\n");
+		return -EPERM;
+	}
+
 	/* Don't access SMBus on IBM systems which get corrupted eeproms */
-	if (dmi_check_system(piix4_dmi_table) &&
+	if (dmi_check_system(piix4_dmi_ibm) &&
 			PIIX4_dev->vendor == PCI_VENDOR_ID_INTEL) {
 		dev_err(&PIIX4_dev->dev, "IBM system detected; this module "
 			"may corrupt your serial eeprom! Refusing to load "

-- 

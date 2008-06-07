Return-Path: <linux-kernel-owner+w=401wt.eu-S1763072AbYFGBSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763072AbYFGBSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760191AbYFGBJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:26 -0400
Received: from sous-sol.org ([216.99.217.87]:42489 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758916AbYFGBJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:20 -0400
Message-Id: <20080607010559.637299265@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:28 -0700
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
       Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 13/50] i2c-nforce2: Disable the second SMBus channel on the DFI Lanparty NF4 Expert
Content-Disposition: inline; filename=i2c-nforce2-disable-the-second-smbus-channel-on-the-dfi-lanparty-nf4-expert.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jean Delvare <khali@linux-fr.org>

commit 08851d6eb4eeb0894f4d095dfdf8ab61c435ad57 in upstream

There is a strange chip at 0x2e on the second SMBus channel of the
DFI Lanparty NF4 Expert motherboard. Accessing the chip reboots the
system. As there's nothing interesting on this SMBus channel, the
easiest and safest thing to do is to disable it on that board.

This is a better fix to bug #5889 than the it87 driver update that was
done originally:
http://bugzilla.kernel.org/show_bug.cgi?id=5889

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/i2c/busses/i2c-nforce2.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-nforce2.c
+++ b/drivers/i2c/busses/i2c-nforce2.c
@@ -50,6 +50,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/dmi.h>
 #include <asm/io.h>
 
 MODULE_LICENSE("GPL");
@@ -109,6 +110,18 @@ struct nforce2_smbus {
 /* Misc definitions */
 #define MAX_TIMEOUT	100
 
+/* We disable the second SMBus channel on these boards */
+static struct dmi_system_id __devinitdata nforce2_dmi_blacklist2[] = {
+	{
+		.ident = "DFI Lanparty NF4 Expert",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "DFI Corp,LTD"),
+			DMI_MATCH(DMI_BOARD_NAME, "LP UT NF4 Expert"),
+		},
+	},
+	{ }
+};
+
 static struct pci_driver nforce2_driver;
 
 static void nforce2_abort(struct i2c_adapter *adap)
@@ -367,10 +380,17 @@ static int __devinit nforce2_probe(struc
 		smbuses[0].base = 0;	/* to have a check value */
 	}
 	/* SMBus adapter 2 */
-	res2 = nforce2_probe_smb(dev, 5, NFORCE_PCI_SMB2, &smbuses[1], "SMB2");
-	if (res2 < 0) {
-		dev_err(&dev->dev, "Error probing SMB2.\n");
-		smbuses[1].base = 0;	/* to have a check value */
+	if (dmi_check_system(nforce2_dmi_blacklist2)) {
+		dev_err(&dev->dev, "Disabling SMB2 for safety reasons.\n");
+		res2 = -EPERM;
+		smbuses[1].base = 0;
+	} else {
+		res2 = nforce2_probe_smb(dev, 5, NFORCE_PCI_SMB2, &smbuses[1],
+					 "SMB2");
+		if (res2 < 0) {
+			dev_err(&dev->dev, "Error probing SMB2.\n");
+			smbuses[1].base = 0;	/* to have a check value */
+		}
 	}
 	if ((res1 < 0) && (res2 < 0)) {
 		/* we did not find even one of the SMBuses, so we give up */

-- 

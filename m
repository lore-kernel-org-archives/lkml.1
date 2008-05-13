Return-Path: <linux-kernel-owner+w=401wt.eu-S1762946AbYEMUUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762946AbYEMUUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761149AbYEMUPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:15:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762281AbYEMUPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:15:18 -0400
Date: Tue, 13 May 2008 13:12:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jeff Garzik l <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <htejun@gmail.com>, Ryan Roth <ryan.roth@ch2m.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 21/37] ata_piix: verify SIDPR access before enabling it
Message-ID: <20080513201220.GV31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ata_piix-verify-sidpr-access-before-enabling-it.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Tejun Heo <htejun@gmail.com>

commit cb6716c879ecf49e2af344926c6a476821812061 upstream

On certain configurations (certain macbooks), even though all the
conditions for SIDPR access described in the datasheet are met,
actually reading those registers just returns 0 and have no effect on
write.  Verify SIDPR is actually working before enabling it.

This is reported by Ryan Roth in bz#10512.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Ryan Roth <ryan.roth@ch2m.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ata_piix.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1531,6 +1531,8 @@ static void __devinit piix_init_sidpr(st
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	struct piix_host_priv *hpriv = host->private_data;
+	struct ata_device *dev0 = &host->ports[0]->link.device[0];
+	u32 scontrol;
 	int i;
 
 	/* check for availability */
@@ -1549,6 +1551,29 @@ static void __devinit piix_init_sidpr(st
 		return;
 
 	hpriv->sidpr = pcim_iomap_table(pdev)[PIIX_SIDPR_BAR];
+
+	/* SCR access via SIDPR doesn't work on some configurations.
+	 * Give it a test drive by inhibiting power save modes which
+	 * we'll do anyway.
+	 */
+	scontrol = piix_sidpr_read(dev0, SCR_CONTROL);
+
+	/* if IPM is already 3, SCR access is probably working.  Don't
+	 * un-inhibit power save modes as BIOS might have inhibited
+	 * them for a reason.
+	 */
+	if ((scontrol & 0xf00) != 0x300) {
+		scontrol |= 0x300;
+		piix_sidpr_write(dev0, SCR_CONTROL, scontrol);
+		scontrol = piix_sidpr_read(dev0, SCR_CONTROL);
+
+		if ((scontrol & 0xf00) != 0x300) {
+			dev_printk(KERN_INFO, host->dev, "SCR access via "
+				   "SIDPR is available but doesn't work\n");
+			return;
+		}
+	}
+
 	host->ports[0]->ops = &piix_sidpr_sata_ops;
 	host->ports[1]->ops = &piix_sidpr_sata_ops;
 }

-- 

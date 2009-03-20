Return-Path: <linux-kernel-owner+w=401wt.eu-S1760692AbZCTXRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbZCTXRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbZCTXNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:13:43 -0400
Received: from kroah.org ([198.145.64.141]:53091 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757467AbZCTXNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:13:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:27:10 2009
Message-Id: <20090320222710.508333389@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:26:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 10/32] ata_piix: add workaround for Samsung DB-P70
References: <20090320222611.872315885@mini.kroah.org>
Content-Disposition: inline; filename=ata_piix-add-workaround-for-samsung-db-p70.patch
In-Reply-To: <20090320231037.GA2732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit e9c1670c2a14ef9cc20d86b24b829f3947aad34e upstream.

Samsung DB-P70 somehow botched the first ICH9 SATA port.  The board
doesn't expose the first port but somehow SStatus reports link online
while failing SRST protocol leading to repeated probe failures and
thus long boot delay.

Because the BIOS doesn't carry any identifying DMI information, the
port can't be blacklisted safely.  Fortunately, the controller does
have subsystem vendor and ID set.  It's unclear whether the subsystem
IDs are used only for the board but it can be safely worked around by
disabling SIDPR access and just using SRST works around the problem.
Even when the workaround is triggered on an unaffected board the only
side effect will be missing SCR access.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Joseph Jang <josephjang@gmail.com>
Reported-by: Jonghyon Sohn <mrsohn@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ata_piix.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1363,6 +1363,39 @@ static const int *__devinit piix_init_sa
 	return map;
 }
 
+static bool piix_no_sidpr(struct ata_host *host)
+{
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+
+	/*
+	 * Samsung DB-P70 only has three ATA ports exposed and
+	 * curiously the unconnected first port reports link online
+	 * while not responding to SRST protocol causing excessive
+	 * detection delay.
+	 *
+	 * Unfortunately, the system doesn't carry enough DMI
+	 * information to identify the machine but does have subsystem
+	 * vendor and device set.  As it's unclear whether the
+	 * subsystem vendor/device is used only for this specific
+	 * board, the port can't be disabled solely with the
+	 * information; however, turning off SIDPR access works around
+	 * the problem.  Turn it off.
+	 *
+	 * This problem is reported in bnc#441240.
+	 *
+	 * https://bugzilla.novell.com/show_bug.cgi?id=441420
+	 */
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL && pdev->device == 0x2920 &&
+	    pdev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG &&
+	    pdev->subsystem_device == 0xb049) {
+		dev_printk(KERN_WARNING, host->dev,
+			   "Samsung DB-P70 detected, disabling SIDPR\n");
+		return true;
+	}
+
+	return false;
+}
+
 static void __devinit piix_init_sidpr(struct ata_host *host)
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
@@ -1376,6 +1409,10 @@ static void __devinit piix_init_sidpr(st
 		if (hpriv->map[i] == IDE)
 			return;
 
+	/* is it blacklisted? */
+	if (piix_no_sidpr(host))
+		return;
+
 	if (!(host->ports[0]->flags & PIIX_FLAG_SIDPR))
 		return;
 



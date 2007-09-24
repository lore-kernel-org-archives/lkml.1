Return-Path: <linux-kernel-owner+w=401wt.eu-S1761934AbXIXQde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761934AbXIXQde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760630AbXIXQ0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:26:23 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47468 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760571AbXIXQ0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:26:21 -0400
Date: Mon, 24 Sep 2007 09:21:18 -0700
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
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [24/50] firewire: fw-ohci: ignore failure of pci_set_power_state
	(fix suspend regression)
Message-ID: <20070924162118.GY13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="firewire-fw-ohci-ignore-failure-of-pci_set_power_state.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Minor regression since 2.6.22-rc1:  If the experimental firewire-ohci
driver instead of ohci1394 was loaded, iBook G3 and older PowerBooks
refused to suspend.

Same as commit 5511142870046a7bed947d51ec9b320856ee120a plus format
string touch-ups from 8a8cea2734808522f02941ea16125810ee42c9c7,
"firewire: missing newline in printk".  Original patch description:

Fixes (papers over) "Sleep problems with kernels >= 2.6.21 on powerpc",
http://lkml.org/lkml/2007/8/25/155.  The issue is that the FireWire
controller's pci_dev.current_state of iBook G3 and presumably older
PowerBooks is still in PCI_UNKNOWN instead of PCI_D0 when the firewire
driver's .suspend method is called.

Like it was suggested earlier in http://lkml.org/lkml/2006/10/24/13, we
do not fail .suspend anymore if pci_set_power_state failed.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-ohci.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -1934,14 +1934,12 @@ static int pci_suspend(struct pci_dev *p
 	free_irq(pdev->irq, ohci);
 	err = pci_save_state(pdev);
 	if (err) {
-		fw_error("pci_save_state failed with %d", err);
+		fw_error("pci_save_state failed with %d\n", err);
 		return err;
 	}
 	err = pci_set_power_state(pdev, pci_choose_state(pdev, state));
-	if (err) {
-		fw_error("pci_set_power_state failed with %d", err);
-		return err;
-	}
+	if (err)
+		fw_error("pci_set_power_state failed with %d\n", err);
 
 	return 0;
 }
@@ -1955,7 +1953,7 @@ static int pci_resume(struct pci_dev *pd
 	pci_restore_state(pdev);
 	err = pci_enable_device(pdev);
 	if (err) {
-		fw_error("pci_enable_device failed with %d", err);
+		fw_error("pci_enable_device failed with %d\n", err);
 		return err;
 	}
 

-- 

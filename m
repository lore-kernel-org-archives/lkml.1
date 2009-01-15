Return-Path: <linux-kernel-owner+w=401wt.eu-S936384AbZAOWv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936384AbZAOWv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763252AbZAOWEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:04:12 -0500
Received: from kroah.org ([198.145.64.141]:39224 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934107AbZAOWEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:04:02 -0500
Date: Thu, 15 Jan 2009 14:02:12 -0800
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
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 85/85] PCI PM: Split PCI Express port suspend-resume
Message-ID: <20090115220212.GH17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-pm-split-pci-express-port-suspend-resume.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit a79d682f789730dfabaebbb507c87a90c0671a62 upstream

Suspend-resume of PCI Express ports has recently been moved into
_suspend_late() and _resume_early() callbacks, but some functions
executed from there should not be called with interrupts disabled,
eg. pci_enable_device().  For this reason, split the suspend-resume
of PCI Express ports into parts to be executed with interrupts
disabled and with interrupts enabled.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pcie/portdrv_pci.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -41,7 +41,6 @@ static int pcie_portdrv_restore_config(s
 {
 	int retval;
 
-	pci_restore_state(dev);
 	retval = pci_enable_device(dev);
 	if (retval)
 		return retval;
@@ -50,23 +49,32 @@ static int pcie_portdrv_restore_config(s
 }
 
 #ifdef CONFIG_PM
-static int pcie_portdrv_suspend_late(struct pci_dev *dev, pm_message_t state)
+static int pcie_portdrv_suspend(struct pci_dev *dev, pm_message_t state)
 {
-	int ret = pcie_port_device_suspend(dev, state);
+	return pcie_port_device_suspend(dev, state);
+
+}
 
-	if (!ret)
-		ret = pcie_portdrv_save_config(dev);
-	return ret;
+static int pcie_portdrv_suspend_late(struct pci_dev *dev, pm_message_t state)
+{
+	return pci_save_state(dev);
 }
 
 static int pcie_portdrv_resume_early(struct pci_dev *dev)
 {
+	return pci_restore_state(dev);
+}
+
+static int pcie_portdrv_resume(struct pci_dev *dev)
+{
 	pcie_portdrv_restore_config(dev);
 	return pcie_port_device_resume(dev);
 }
 #else
+#define pcie_portdrv_suspend NULL
 #define pcie_portdrv_suspend_late NULL
 #define pcie_portdrv_resume_early NULL
+#define pcie_portdrv_resume NULL
 #endif
 
 /*
@@ -221,6 +229,7 @@ static pci_ers_result_t pcie_portdrv_slo
 
 	/* If fatal, restore cfg space for possible link reset at upstream */
 	if (dev->error_state == pci_channel_io_frozen) {
+		pci_restore_state(dev);
 		pcie_portdrv_restore_config(dev);
 		pci_enable_pcie_error_reporting(dev);
 	}
@@ -282,8 +291,10 @@ static struct pci_driver pcie_portdriver
 	.probe		= pcie_portdrv_probe,
 	.remove		= pcie_portdrv_remove,
 
+	.suspend	= pcie_portdrv_suspend,
 	.suspend_late	= pcie_portdrv_suspend_late,
 	.resume_early	= pcie_portdrv_resume_early,
+	.resume		= pcie_portdrv_resume,
 
 	.err_handler 	= &pcie_portdrv_err_handler,
 };


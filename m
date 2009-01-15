Return-Path: <linux-kernel-owner+w=401wt.eu-S936064AbZAOWux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936064AbZAOWux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765664AbZAOWEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:04:11 -0500
Received: from kroah.org ([198.145.64.141]:39200 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934099AbZAOWEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:04:00 -0500
Date: Thu, 15 Jan 2009 14:02:08 -0800
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
Subject: [patch 83/85] PCI: Suspend and resume PCI Express ports with
	interrupts disabled
Message-ID: <20090115220208.GF17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-suspend-and-resume-pci-express-ports-with-interrupts-disabled.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit 90d25f246ddefbb743764f8d45ae97e545a6ee86 upstream

I don't see why the suspend and resume of PCI Express ports should be
handled with interrupts enabled and it may even lead to problems in
some situations.  For this reason, move the suspending and resuming
of PCI Express ports into ->suspend_late() and ->resume_early()
callbacks executed with interrupts disabled.

This patch addresses the regression from 2.6.26 tracked as
http://bugzilla.kernel.org/show_bug.cgi?id=12121 .

Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pcie/portdrv_pci.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -50,7 +50,7 @@ static int pcie_portdrv_restore_config(s
 }
 
 #ifdef CONFIG_PM
-static int pcie_portdrv_suspend(struct pci_dev *dev, pm_message_t state)
+static int pcie_portdrv_suspend_late(struct pci_dev *dev, pm_message_t state)
 {
 	int ret = pcie_port_device_suspend(dev, state);
 
@@ -59,14 +59,14 @@ static int pcie_portdrv_suspend(struct p
 	return ret;
 }
 
-static int pcie_portdrv_resume(struct pci_dev *dev)
+static int pcie_portdrv_resume_early(struct pci_dev *dev)
 {
 	pcie_portdrv_restore_config(dev);
 	return pcie_port_device_resume(dev);
 }
 #else
-#define pcie_portdrv_suspend NULL
-#define pcie_portdrv_resume NULL
+#define pcie_portdrv_suspend_late NULL
+#define pcie_portdrv_resume_early NULL
 #endif
 
 /*
@@ -282,8 +282,8 @@ static struct pci_driver pcie_portdriver
 	.probe		= pcie_portdrv_probe,
 	.remove		= pcie_portdrv_remove,
 
-	.suspend	= pcie_portdrv_suspend,
-	.resume		= pcie_portdrv_resume,
+	.suspend_late	= pcie_portdrv_suspend_late,
+	.resume_early	= pcie_portdrv_resume_early,
 
 	.err_handler 	= &pcie_portdrv_err_handler,
 };


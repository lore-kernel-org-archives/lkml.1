Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbXC3VRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbXC3VRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbXC3VQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:16:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51672 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbXC3VL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:11:56 -0400
Date: Fri, 30 Mar 2007 14:06:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, justin@jmicron.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 27/37] jmicron: make ide jmicron driver play nice with
	libata ones
Message-ID: <20070330210634.GD29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="jmicron-make-ide-jmicron-driver-play-nice-with-libata-ones.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <htejun@gmail.com>

jmicron: make ide jmicron driver play nice with libata ones

When libata is configured, the device is configured such that SATA and
PATA ports live in separate functions with different programming
interfaces.  pata_jmicron and ide jmicron drivers can drive only the
PATA part.

This patch makes jmicron match PCI class code such that it doesn't
attach itself to the SATA part preventing the proper ahci driver from
attaching.

This change is suggested by Bartlomiej.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: justin@jmicron.com
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/ide/pci/jmicron.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -240,12 +240,31 @@ static int __devinit jmicron_init_one(st
 	return 0;
 }
 
+/* If libata is configured, jmicron PCI quirk will configure it such
+ * that the SATA ports are in AHCI function while the PATA ports are
+ * in a separate IDE function.  In such cases, match device class and
+ * attach only to IDE.  If libata isn't configured, keep the old
+ * behavior for backward compatibility.
+ */
+#if defined(CONFIG_ATA) || defined(CONFIG_ATA_MODULE)
+#define JMB_CLASS	PCI_CLASS_STORAGE_IDE << 8
+#define JMB_CLASS_MASK	0xffff00
+#else
+#define JMB_CLASS	0
+#define JMB_CLASS_MASK	0
+#endif
+
 static struct pci_device_id jmicron_pci_tbl[] = {
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
-	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361,
+	  PCI_ANY_ID, PCI_ANY_ID, JMB_CLASS, JMB_CLASS_MASK, 0},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363,
+	  PCI_ANY_ID, PCI_ANY_ID, JMB_CLASS, JMB_CLASS_MASK, 1},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365,
+	  PCI_ANY_ID, PCI_ANY_ID, JMB_CLASS, JMB_CLASS_MASK, 2},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366,
+	  PCI_ANY_ID, PCI_ANY_ID, JMB_CLASS, JMB_CLASS_MASK, 3},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368,
+	  PCI_ANY_ID, PCI_ANY_ID, JMB_CLASS, JMB_CLASS_MASK, 4},
 	{ 0, },
 };
 

-- 

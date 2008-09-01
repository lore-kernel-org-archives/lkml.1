Return-Path: <linux-kernel-owner+w=401wt.eu-S1759380AbYIAUdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbYIAUdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 16:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYIAUdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 16:33:12 -0400
Received: from master.nsys.by ([194.158.194.5]:52342 "EHLO master.nsys.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbYIAUdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 16:33:11 -0400
Message-ID: <48BC515B.1090509@nsys.by>
Date: Mon, 01 Sep 2008 23:32:27 +0300
From: Vladislav Bogdanov <slava_reg@nsys.by>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Douglas Thompson <dougthompson@xmission.com>,
       Tim Small <tim@buttersideup.com>, Greg KH <greg@kroah.com>,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] Make i82443bxgx_edac coexist with intel_agp
References: <20080831161011.GD3695@cs181140183.pp.htv.fi>
In-Reply-To: <20080831161011.GD3695@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.1.1 (master.nsys.by [194.158.194.186]); Mon, 01 Sep 2008 23:32:32 +0300 (EEST)
X-DCC-dmv.com-Metrics: master.nsys.by 1181; Body=7 Fuz1=7 Fuz2=7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

Here is working patch for 443BX/GX MCH suppport in a EDAC.
It makes i82443bxgx_edac coexist with intel_agp using the same approach
as several other EDAC drivers.
Tested on Intel's L443GX with redhat's 2.6.18 with whole EDAC subsystem
backported a while ago.

I'm not subscribed to lkml so please CC me in replies to that list.

[root@host ~]# dmesg|grep -iE '(AGP|EDAC)'
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected an Intel 440GX Chipset.
agpgart: AGP aperture is 64M @ 0xf8000000
EDAC MC: Ver: 2.1.0 Jun 27 2008
EDAC MC0: Giving out device to 'i82443bxgx_edac' 'I82443BXGX': DEV 0000:00:00.0
EDAC PCI0: Giving out device to module 'i82443bxgx_edac' controller 'EDAC PCI controller': DEV '0000:00:00.0' (POLLED)

Signed-off-by: Vladislav Bogdanov <slava@nsys.by>
---
--- a/drivers/edac/i82443bxgx_edac.c	2008-02-18 15:04:39.000000000 +0200
+++ a/drivers/edac/i82443bxgx_edac.c	2008-09-01 00:14:45.000000000 +0300
@@ -114,6 +114,12 @@ struct i82443bxgx_edacmc_error_info {
 
 static struct edac_pci_ctl_info *i82443bxgx_pci;
 
+static struct pci_dev *mci_pdev;	/* init dev: in case that AGP code has
+					 * already registered driver
+					 */
+
+static int i82443bxgx_registered = 1;
+
 static void i82443bxgx_edacmc_get_error_info(struct mem_ctl_info *mci,
 				struct i82443bxgx_edacmc_error_info
 				*info)
@@ -345,10 +351,17 @@ EXPORT_SYMBOL_GPL(i82443bxgx_edacmc_prob
 static int __devinit i82443bxgx_edacmc_init_one(struct pci_dev *pdev,
 						const struct pci_device_id *ent)
 {
+	int rc;
+
 	debugf0("MC: " __FILE__ ": %s()\n", __func__);
 
 	/* don't need to call pci_device_enable() */
-	return i82443bxgx_edacmc_probe1(pdev, ent->driver_data);
+	rc = i82443bxgx_edacmc_probe1(pdev, ent->driver_data);
+
+	if (mci_pdev == NULL)
+		mci_pdev = pci_dev_get(pdev);
+
+	return rc;
 }
 
 static void __devexit i82443bxgx_edacmc_remove_one(struct pci_dev *pdev)
@@ -387,15 +400,61 @@ static struct pci_driver i82443bxgx_edac
 
 static int __init i82443bxgx_edacmc_init(void)
 {
+	int pci_rc;
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
 
-	return pci_register_driver(&i82443bxgx_edacmc_driver);
+	pci_rc = pci_register_driver(&i82443bxgx_edacmc_driver);
+	if (pci_rc < 0)
+		goto fail0;
+
+	if (mci_pdev == NULL) {
+		const struct pci_device_id *id = &i82443bxgx_pci_tbl[0];
+		int i = 0;
+		i82443bxgx_registered = 0;
+
+		while (mci_pdev == NULL && id->vendor != 0) {
+			mci_pdev = pci_get_device(id->vendor,
+					id->device, NULL);
+			i++;
+			id = &i82443bxgx_pci_tbl[i];
+		}
+		if (!mci_pdev) {
+			debugf0("i82443bxgx pci_get_device fail\n");
+			pci_rc = -ENODEV;
+			goto fail1;
+		}
+
+		pci_rc = i82443bxgx_edacmc_init_one(mci_pdev, i82443bxgx_pci_tbl);
+
+		if (pci_rc < 0) {
+			debugf0("i82443bxgx init fail\n");
+			pci_rc = -ENODEV;
+			goto fail1;
+		}
+	}
+
+	return 0;
+
+fail1:
+	pci_unregister_driver(&i82443bxgx_edacmc_driver);
+
+fail0:
+	if (mci_pdev != NULL)
+		pci_dev_put(mci_pdev);
+
+	return pci_rc;
 }
 
 static void __exit i82443bxgx_edacmc_exit(void)
 {
 	pci_unregister_driver(&i82443bxgx_edacmc_driver);
+
+	if (!i82443bxgx_registered)
+		i82443bxgx_edacmc_remove_one(mci_pdev);
+
+	if (mci_pdev)
+		pci_dev_put(mci_pdev);
 }
 
 module_init(i82443bxgx_edacmc_init);


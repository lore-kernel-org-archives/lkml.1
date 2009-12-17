Return-Path: <linux-kernel-owner+w=401wt.eu-S1763755AbZLQBXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763755AbZLQBXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763708AbZLQBVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:21:18 -0500
Received: from kroah.org ([198.145.64.141]:41518 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763713AbZLQBVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:21:05 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:08 2009
Message-Id: <20091217011608.830966337@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhu Yi <yi.zhu@intel.com>, "John W. Linville" <linville@tuxdriver.com>
Subject: [83/90] ipw2100: fix rebooting hang with driver loaded
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhu Yi <yi.zhu@intel.com>

commit 52ce3e9a7db754b78cf2cbabc87013f921b25b28 upstream.

Add PCI .shutdown method so that we can disable the device during
shutdown or reboot. Without this, the reboot doesn't work well on
some platforms.

This fixes http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2124

Tested-by: pablo <pablolm2005@gmail.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ipw2x00/ipw2100.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -6487,6 +6487,16 @@ static int ipw2100_resume(struct pci_dev
 }
 #endif
 
+static void ipw2100_shutdown(struct pci_dev *pci_dev)
+{
+	struct ipw2100_priv *priv = pci_get_drvdata(pci_dev);
+
+	/* Take down the device; powers it off, etc. */
+	ipw2100_down(priv);
+
+	pci_disable_device(pci_dev);
+}
+
 #define IPW2100_DEV_ID(x) { PCI_VENDOR_ID_INTEL, 0x1043, 0x8086, x }
 
 static struct pci_device_id ipw2100_pci_id_table[] __devinitdata = {
@@ -6550,6 +6560,7 @@ static struct pci_driver ipw2100_pci_dri
 	.suspend = ipw2100_suspend,
 	.resume = ipw2100_resume,
 #endif
+	.shutdown = ipw2100_shutdown,
 };
 
 /**



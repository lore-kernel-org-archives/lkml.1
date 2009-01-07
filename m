Return-Path: <linux-kernel-owner+w=401wt.eu-S1761144AbZAGTXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144AbZAGTXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758212AbZAGTWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:22:38 -0500
Received: from mga05.intel.com ([192.55.52.89]:62294 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757705AbZAGTW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:22:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,339,1228118400"; 
   d="scan'208";a="655323919"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: netdev@vger.kernel.org
Cc: wimax@linuxwimax.org, greg@kroah.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wimax@intel.com
Subject: [PATCH 4/4] i2400m/usb: wrap USB power saving in #ifdef CONFIG_PM
Date: Wed,  7 Jan 2009 11:22:22 -0800
Message-Id: <0e511f3772ac9887551bec34ee682fa5bf63fb69.1231355768.git.inaky@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1231355768.git.inaky@linux.intel.com>
References: <cover.1231355768.git.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code was assuming PM was always enabled, which is not
correct. Code which accesses members in the struct usb_device that are
dependant on CONFIG_PM must be protected the same.

Reported by Randy Dunlap from a build error in the linux-next tree on
07/01/2009.

Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wimax/i2400m/usb.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wimax/i2400m/usb.c b/drivers/net/wimax/i2400m/usb.c
index 6d4b65f..c6d9346 100644
--- a/drivers/net/wimax/i2400m/usb.c
+++ b/drivers/net/wimax/i2400m/usb.c
@@ -397,11 +397,13 @@ int i2400mu_probe(struct usb_interface *iface,
 	i2400m->bus_fw_name = I2400MU_FW_FILE_NAME;
 	i2400m->bus_bm_mac_addr_impaired = 0;
 
+#ifdef CONFIG_PM
 	iface->needs_remote_wakeup = 1;		/* autosuspend (15s delay) */
 	device_init_wakeup(dev, 1);
 	usb_autopm_enable(i2400mu->usb_iface);
 	usb_dev->autosuspend_delay = 15 * HZ;
 	usb_dev->autosuspend_disabled = 0;
+#endif
 
 	result = i2400m_setup(i2400m, I2400M_BRI_MAC_REINIT);
 	if (result < 0) {
@@ -493,7 +495,9 @@ int i2400mu_suspend(struct usb_interface *iface, pm_message_t pm_msg)
 	int result = 0;
 	struct device *dev = &iface->dev;
 	struct i2400mu *i2400mu = usb_get_intfdata(iface);
+#ifdef CONFIG_PM
 	struct usb_device *usb_dev = i2400mu->usb_dev;
+#endif
 	struct i2400m *i2400m = &i2400mu->i2400m;
 
 	d_fnstart(3, dev, "(iface %p pm_msg %u)\n", iface, pm_msg.event);
@@ -503,11 +507,13 @@ int i2400mu_suspend(struct usb_interface *iface, pm_message_t pm_msg)
 	atomic_dec(&i2400mu->do_autopm);
 	result = i2400m_cmd_enter_powersave(i2400m);
 	atomic_inc(&i2400mu->do_autopm);
+#ifdef CONFIG_PM
 	if (result < 0 && usb_dev->auto_pm == 0) {
 		/* System suspend, can't fail */
 		dev_err(dev, "failed to suspend, will reset on resume\n");
 		result = 0;
 	}
+#endif
 	if (result < 0)
 		goto error_enter_powersave;
 	i2400mu_notification_release(i2400mu);
-- 
1.5.6.5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761018AbXHCLPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018AbXHCLPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 07:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbXHCLP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 07:15:29 -0400
Received: from swsoft-mipt-nat.sw.ru ([195.214.233.10]:53537 "EHLO iris"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757344AbXHCLP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 07:15:28 -0400
X-Greylist: delayed 2169 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Aug 2007 07:15:28 EDT
Date: Fri, 3 Aug 2007 14:39:24 +0400
From: "Denis V. Lunev" <den@openvz.org>
To: dev@openvz.org, gregkh@suse.de, akpm@linux-foundation.org
Cc: devel@openvz.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pci_get_device call from interrupt in reboot fixups
Message-ID: <20070803103924.GA23786@iris.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following calltrace is possible now:
 handle_sysrq
   machine_emergency_restart
     mach_reboot_fixups
       pci_get_device
         pci_get_subsys
	   down_read
The patch obtains PCI device during initialization to avoid bothering PCI
search engine in interrupt. Devices used in this code are not supposed to
be pluggable, so it looks safe to keep them.

Signed-off-by: Denis V. Lunev <den@openvz.org>
---

diff --git a/arch/i386/kernel/reboot_fixups.c b/arch/i386/kernel/reboot_fixups.c
index 03e1cce..873ad55 100644
--- a/arch/i386/kernel/reboot_fixups.c
+++ b/arch/i386/kernel/reboot_fixups.c
@@ -37,6 +37,7 @@ struct device_fixup {
 	unsigned int vendor;
 	unsigned int device;
 	void (*reboot_fixup)(struct pci_dev *);
+	struct pci_dev *dev;
 };
 
 static struct device_fixup fixups_table[] = {
@@ -49,20 +50,35 @@ static struct device_fixup fixups_table[] = {
  * is a fixup, we call it and we expect to never return from it. if we
  * do return, we keep looking and then eventually fall back to the
  * standard mach_reboot on return.
+ *
+ * Unfortunately, this code can be called from an interrupt and it is
+ * impossible to get PCI device directly. So, lets prepare the list
+ * beforehand.
  */
 void mach_reboot_fixups(void)
 {
 	struct device_fixup *cur;
-	struct pci_dev *dev;
 	int i;
 
 	for (i=0; i < ARRAY_SIZE(fixups_table); i++) {
 		cur = &(fixups_table[i]);
-		dev = pci_get_device(cur->vendor, cur->device, NULL);
-		if (!dev)
+		if (cur->dev == NULL)
 			continue;
 
-		cur->reboot_fixup(dev);
+		cur->reboot_fixup(cur->dev);
+	}
+}
+
+int mach_fixup_init(void)
+{
+	struct device_fixup *cur;
+	int i;
+
+	for (i=0; i < ARRAY_SIZE(fixups_table); i++) {
+		cur = &(fixups_table[i]);
+		cur->dev = pci_get_device(cur->vendor, cur->device, NULL);
 	}
+	return 0;
 }
 
+module_init(mach_fixup_init);

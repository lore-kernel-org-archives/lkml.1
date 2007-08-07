Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbXHGJNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbXHGJNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 05:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbXHGJMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 05:12:50 -0400
Received: from swsoft-mipt-nat.sw.ru ([195.214.233.10]:56778 "EHLO iris"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751367AbXHGJMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 05:12:50 -0400
Date: Tue, 7 Aug 2007 13:13:18 +0400
From: "Denis V. Lunev" <den@openvz.org>
To: den@openvz.org, dev@openvz.org, akpm@linux-foundation.org, gregkh@suse.de
Cc: devel@openvz.org, linux-kernel@vger.kernel.org, xemul@openvz.org
Subject: [PATCH] pci_get_device call from interrupt in reboot fixups
	(description fixed)
Message-ID: <20070807091318.GA14417@iris.sw.ru>
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
The patch skips reboot fixup if called from sysrq-B code.

Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 reboot_fixups.c |    6 ++++++
  1 file changed, 6 insertions(+)

--- ./arch/i386/kernel/reboot_fixups.c.fixup2	2007-08-07 12:30:30.000000000 +0400
+++ ./arch/i386/kernel/reboot_fixups.c	2007-08-07 12:31:22.000000000 +0400
@@ -11,6 +11,7 @@
 #include <asm/delay.h>
 #include <linux/pci.h>
 #include <linux/reboot_fixups.h>
+#include <linux/interrupt.h>
 
 static void cs5530a_warm_reset(struct pci_dev *dev)
 {
@@ -43,6 +44,11 @@ void mach_reboot_fixups(void)
 	struct pci_dev *dev;
 	int i;
 
+	/* we can be called from sysrq-B code. In such a case it is
+	 * prohibited to dig PCI */
+	if (in_interrupt())
+		return;
+
 	for (i=0; i < ARRAY_SIZE(fixups_table); i++) {
 		cur = &(fixups_table[i]);
 		dev = pci_get_device(cur->vendor, cur->device, NULL);

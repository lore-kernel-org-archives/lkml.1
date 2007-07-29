Return-Path: <linux-kernel-owner+w=401wt.eu-S933315AbXG2PNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315AbXG2PNA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764864AbXG2PBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:01:03 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47885 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764273AbXG2PBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:01:00 -0400
Date: Sun, 29 Jul 2007 17:00:37 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: [2.6.23 regression fix] acpi_ec_remove(): fix use-after-free
Message-ID: <20070729150036.GL16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an obvious use-after-free introduced by
commit 837012ede14a8fc088be3682c964da7fc6af026b.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/drivers/acpi/ec.c.old	2007-07-28 07:59:49.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/acpi/ec.c	2007-07-28 08:00:25.000000000 +0200
@@ -730,14 +730,14 @@
 static int acpi_ec_remove(struct acpi_device *device, int type)
 {
 	struct acpi_ec *ec;
-	struct acpi_ec_query_handler *handler;
+	struct acpi_ec_query_handler *handler, *tmp;
 
 	if (!device)
 		return -EINVAL;
 
 	ec = acpi_driver_data(device);
 	mutex_lock(&ec->lock);
-	list_for_each_entry(handler, &ec->list, node) {
+	list_for_each_entry_safe(handler, tmp, &ec->list, node) {
 		list_del(&handler->node);
 		kfree(handler);
 	}


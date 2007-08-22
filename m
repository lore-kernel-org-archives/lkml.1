Return-Path: <linux-kernel-owner+w=401wt.eu-S933824AbXHVRVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933824AbXHVRVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764370AbXHVRUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:20:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:54889 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758779AbXHVRUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:20:48 -0400
Message-Id: <20070822170732.517188445@arndb.de>
References: <20070822170124.764128591@arndb.de>
User-Agent: quilt/0.45-1
Date: Wed, 22 Aug 2007 19:01:28 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: paulus@samba.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, Maximilian <maxim@de.ibm.com>,
       Arnd Bergmann <arnd.bergmann@de.ibm.com>
Subject: [patch 4/5] axonram: do not delete gendisks queue in error path
Content-Disposition: inline; filename=37801.diff
X-Provags-ID: V01U2FsdGVkX1+Rk7KoiFQ5YqNXQbq7mlTt9vRwu3q0h5Y8N+K
 1d46r5iW7M4kRIHY/3KD90KEmMs348mZnRZF1ikfGtvAtR8mz4
 XJb8HHG4Ap2+tzffWubUg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxim Shchetynin <maxim@de.ibm.com>
On exit do not delete gendisk's queue because this is already done by
del_gendisk(). Doing it twice may cause memory damage.

Signed-off-by: Maximilian <maxim@de.ibm.com>
Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
---

Index: linux-2.6/arch/powerpc/sysdev/axonram.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/axonram.c
+++ linux-2.6/arch/powerpc/sysdev/axonram.c
@@ -281,8 +281,6 @@ failed:
 		if (bank->irq_id != NO_IRQ)
 			free_irq(bank->irq_id, device);
 		if (bank->disk != NULL) {
-			if (bank->disk->queue != NULL)
-				blk_cleanup_queue(bank->disk->queue);
 			if (bank->disk->major > 0)
 				unregister_blkdev(bank->disk->major,
 						bank->disk->disk_name);
@@ -310,7 +308,6 @@ axon_ram_remove(struct of_device *device
 
 	device_remove_file(&device->dev, &dev_attr_ecc);
 	free_irq(bank->irq_id, device);
-	blk_cleanup_queue(bank->disk->queue);
 	unregister_blkdev(bank->disk->major, bank->disk->disk_name);
 	del_gendisk(bank->disk);
 	iounmap((void __iomem *) bank->io_addr);

--


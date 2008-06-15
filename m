Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbYFOSXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbYFOSXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 14:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759046AbYFOSXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 14:23:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:62097 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758968AbYFOSXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 14:23:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=MSuNsjOBoWtgc2pblurrCIA7nspWHOQWpW9+lWJwkMAcieqDHePeTKOOwulOFoFo7U
         rJ6VELpJPy6kwKeik9BLs53ES5sdpZoGKuMqKuTYA4G9jzkPkWHjL1k/I5QjztrdTRst
         F7JFkJ98xCZeKfI0P8tSivdgxKwtsrO6Y3aiQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide-cs: fix releasing I/O resources
Date: Sun, 15 Jun 2008 20:23:58 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806152023.59096.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hwif content is already freed after ide_release() call so cache
hwif->io_ports.{data,ctl}_addr in local variables in ide_detach().

This fixes 2.6.26 regression.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
for 2.6.26

 drivers/ide/legacy/ide-cs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -135,13 +135,17 @@ static void ide_detach(struct pcmcia_dev
 {
     ide_info_t *info = link->priv;
     ide_hwif_t *hwif = info->hwif;
+    unsigned long data_addr, ctl_addr;
 
     DEBUG(0, "ide_detach(0x%p)\n", link);
 
+    data_addr = hwif->io_ports.data_addr;
+    ctl_addr  = hwif->io_ports.ctl_addr;
+
     ide_release(link);
 
-    release_region(hwif->io_ports.ctl_addr, 1);
-    release_region(hwif->io_ports.data_addr, 8);
+    release_region(ctl_addr, 1);
+    release_region(data_addr, 8);
 
     kfree(info);
 } /* ide_detach */

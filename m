Return-Path: <linux-kernel-owner+w=401wt.eu-S1752237AbYLCIPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbYLCIPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 03:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYLCIPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 03:15:11 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:34985 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYLCIPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 03:15:10 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Jeff Garzik <jgarzik@redhat.com>,
       Alexandru Romanescu <a_romanescu@yahoo.co.uk>,
       Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/1] ATA: piix, fix pointer deref on suspend
Date: Wed,  3 Dec 2008 09:13:46 +0100
Message-Id: <1228292026-23586-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've found this issue in the mmotm 2008-12-02-17-08.

--

Commit
ata_piix: add borked Tecra M4 to broken suspend list
introduced DMI variables checking, but they can be null, so that
we possibly dereference null.

Check if they are null and avoid checks in that case.

Solves:
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff8043da97>] piix_pci_device_suspend+0x117/0x230

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Alexandru Romanescu <a_romanescu@yahoo.co.uk>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/ata/ata_piix.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index d6d97d8..c11936e 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1072,7 +1072,14 @@ static int piix_broken_suspend(void)
 	 * matching is necessary because dmi_system_id.matches is
 	 * limited to four entries.
 	 */
-	if (!strcmp(dmi_get_system_info(DMI_SYS_VENDOR), "TOSHIBA") &&
+	if (dmi_get_system_info(DMI_SYS_VENDOR) &&
+	    dmi_get_system_info(DMI_PRODUCT_NAME) &&
+	    dmi_get_system_info(DMI_PRODUCT_VERSION) &&
+	    dmi_get_system_info(DMI_PRODUCT_SERIAL) &&
+	    dmi_get_system_info(DMI_BOARD_VENDOR) &&
+	    dmi_get_system_info(DMI_BOARD_NAME) &&
+	    dmi_get_system_info(DMI_BOARD_VERSION) &&
+	    !strcmp(dmi_get_system_info(DMI_SYS_VENDOR), "TOSHIBA") &&
 	    !strcmp(dmi_get_system_info(DMI_PRODUCT_NAME), "000000") &&
 	    !strcmp(dmi_get_system_info(DMI_PRODUCT_VERSION), "000000") &&
 	    !strcmp(dmi_get_system_info(DMI_PRODUCT_SERIAL), "000000") &&
-- 
1.6.0.4


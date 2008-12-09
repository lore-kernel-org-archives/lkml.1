Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbYLIUyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbYLIUyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbYLIUxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:53:45 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:42552 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbYLIUxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:53:44 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Jeff Garzik <jgarzik@redhat.com>,
       Alexandru Romanescu <a_romanescu@yahoo.co.uk>,
       Tejun Heo <tj@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2 v2] ATA: piix, fix pointer deref on suspend
Date: Tue,  9 Dec 2008 21:52:28 +0100
Message-Id: <1228855948-22886-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.5
In-Reply-To: <1228855948-22886-1-git-send-email-jirislaby@gmail.com>
References: <493E0689.6020302@garzik.org>
 <1228855948-22886-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/ata/ata_piix.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index d6d97d8..5fdf167 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1072,13 +1072,13 @@ static int piix_broken_suspend(void)
 	 * matching is necessary because dmi_system_id.matches is
 	 * limited to four entries.
 	 */
-	if (!strcmp(dmi_get_system_info(DMI_SYS_VENDOR), "TOSHIBA") &&
-	    !strcmp(dmi_get_system_info(DMI_PRODUCT_NAME), "000000") &&
-	    !strcmp(dmi_get_system_info(DMI_PRODUCT_VERSION), "000000") &&
-	    !strcmp(dmi_get_system_info(DMI_PRODUCT_SERIAL), "000000") &&
-	    !strcmp(dmi_get_system_info(DMI_BOARD_VENDOR), "TOSHIBA") &&
-	    !strcmp(dmi_get_system_info(DMI_BOARD_NAME), "Portable PC") &&
-	    !strcmp(dmi_get_system_info(DMI_BOARD_VERSION), "Version A0"))
+	if (dmi_match(DMI_SYS_VENDOR, "TOSHIBA") &&
+	    dmi_match(DMI_PRODUCT_NAME, "000000") &&
+	    dmi_match(DMI_PRODUCT_VERSION, "000000") &&
+	    dmi_match(DMI_PRODUCT_SERIAL, "000000") &&
+	    dmi_match(DMI_BOARD_VENDOR, "TOSHIBA") &&
+	    dmi_match(DMI_BOARD_NAME, "Portable PC") &&
+	    dmi_match(DMI_BOARD_VERSION, "Version A0"))
 		return 1;
 
 	return 0;
-- 
1.6.0.5


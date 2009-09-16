Return-Path: <linux-kernel-owner+w=401wt.eu-S1758292AbZIPWTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbZIPWTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758103AbZIPWTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:19:42 -0400
Received: from kroah.org ([198.145.64.141]:49781 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321AbZIPWS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:18:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:15:06 2009
Message-Id: <20090916221505.894792349@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:13:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 02/10] powerpc/ps3: Workaround for flash memory I/O error
References: <20090916221320.283781925@mini.kroah.org>
Content-Disposition: inline; filename=powerpc-ps3-workaround-for-flash-memory-i-o-error.patch
In-Reply-To: <20090916221529.GA28162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Geoff Levand <geoffrey.levand@am.sony.com>

commit bc00351edd5c1b84d48c3fdca740fedfce4ae6ce upstream.

A workaround for flash memory I/O errors when the PS3 internal
hard disk has not been formatted for OtherOS use.

This error condition mainly effects 'Live CD' users who have not
formatted the PS3's internal hard disk for OtherOS.

Fixes errors similar to these when using the ps3-flash-util
or ps3-boot-game-os programs:

  ps3flash read failed 0x2050000
  os_area_header_read: read error: os_area_header: Input/output error
  main:627: os_area_read_hp error.
  ERROR: can't change boot flag

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ps3/ps3stor_lib.c |   65 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 62 insertions(+), 3 deletions(-)

--- a/drivers/ps3/ps3stor_lib.c
+++ b/drivers/ps3/ps3stor_lib.c
@@ -23,6 +23,65 @@
 #include <asm/lv1call.h>
 #include <asm/ps3stor.h>
 
+/*
+ * A workaround for flash memory I/O errors when the internal hard disk
+ * has not been formatted for OtherOS use.  Delay disk close until flash
+ * memory is closed.
+ */
+
+static struct ps3_flash_workaround {
+	int flash_open;
+	int disk_open;
+	struct ps3_system_bus_device *disk_sbd;
+} ps3_flash_workaround;
+
+static int ps3stor_open_hv_device(struct ps3_system_bus_device *sbd)
+{
+	int error = ps3_open_hv_device(sbd);
+
+	if (error)
+		return error;
+
+	if (sbd->match_id == PS3_MATCH_ID_STOR_FLASH)
+		ps3_flash_workaround.flash_open = 1;
+
+	if (sbd->match_id == PS3_MATCH_ID_STOR_DISK)
+		ps3_flash_workaround.disk_open = 1;
+
+	return 0;
+}
+
+static int ps3stor_close_hv_device(struct ps3_system_bus_device *sbd)
+{
+	int error;
+
+	if (sbd->match_id == PS3_MATCH_ID_STOR_DISK
+		&& ps3_flash_workaround.disk_open
+		&& ps3_flash_workaround.flash_open) {
+		ps3_flash_workaround.disk_sbd = sbd;
+		return 0;
+	}
+
+	error = ps3_close_hv_device(sbd);
+
+	if (error)
+		return error;
+
+	if (sbd->match_id == PS3_MATCH_ID_STOR_DISK)
+		ps3_flash_workaround.disk_open = 0;
+
+	if (sbd->match_id == PS3_MATCH_ID_STOR_FLASH) {
+		ps3_flash_workaround.flash_open = 0;
+
+		if (ps3_flash_workaround.disk_sbd) {
+			ps3_close_hv_device(ps3_flash_workaround.disk_sbd);
+			ps3_flash_workaround.disk_open = 0;
+			ps3_flash_workaround.disk_sbd = NULL;
+		}
+	}
+
+	return 0;
+}
 
 static int ps3stor_probe_access(struct ps3_storage_device *dev)
 {
@@ -90,7 +149,7 @@ int ps3stor_setup(struct ps3_storage_dev
 	int error, res, alignment;
 	enum ps3_dma_page_size page_size;
 
-	error = ps3_open_hv_device(&dev->sbd);
+	error = ps3stor_open_hv_device(&dev->sbd);
 	if (error) {
 		dev_err(&dev->sbd.core,
 			"%s:%u: ps3_open_hv_device failed %d\n", __func__,
@@ -166,7 +225,7 @@ fail_free_irq:
 fail_sb_event_receive_port_destroy:
 	ps3_sb_event_receive_port_destroy(&dev->sbd, dev->irq);
 fail_close_device:
-	ps3_close_hv_device(&dev->sbd);
+	ps3stor_close_hv_device(&dev->sbd);
 fail:
 	return error;
 }
@@ -193,7 +252,7 @@ void ps3stor_teardown(struct ps3_storage
 			"%s:%u: destroy event receive port failed %d\n",
 			__func__, __LINE__, error);
 
-	error = ps3_close_hv_device(&dev->sbd);
+	error = ps3stor_close_hv_device(&dev->sbd);
 	if (error)
 		dev_err(&dev->sbd.core,
 			"%s:%u: ps3_close_hv_device failed %d\n", __func__,



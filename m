Return-Path: <linux-kernel-owner+w=401wt.eu-S1759846AbYBKRWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846AbYBKRWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbYBKRWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:22:39 -0500
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:60640 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757866AbYBKRWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:22:38 -0500
Date: Mon, 11 Feb 2008 18:22:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] dmi: Prevent linked list corruption
Message-ID: <20080211182235.14a5a641@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the same item to a given linked list more than once is guaranteed
to break and corrupt the list. This is however what we do in dmi_scan
since commit 79da4721117fcf188b4b007b775738a530f574da.

Given that there is absolutely no interest in saving empty OEM
strings anyway, I propose the simple and efficient fix below: we
discard the empty OEM strings altogether.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
The empty OEM strings weren't even added with the correct entry type
(0 instead of DMI_DEV_TYPE_OEM_STRING.)

 drivers/firmware/dmi_scan.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- linux-2.6.25-rc1.orig/drivers/firmware/dmi_scan.c	2008-02-11 16:15:10.000000000 +0100
+++ linux-2.6.25-rc1/drivers/firmware/dmi_scan.c	2008-02-11 18:03:27.000000000 +0100
@@ -217,10 +217,6 @@ static void __init dmi_save_devices(cons
 	}
 }
 
-static struct dmi_device empty_oem_string_dev = {
-	.name = dmi_empty_string,
-};
-
 static void __init dmi_save_oem_strings_devices(const struct dmi_header *dm)
 {
 	int i, count = *(u8 *)(dm + 1);
@@ -229,10 +225,8 @@ static void __init dmi_save_oem_strings_
 	for (i = 1; i <= count; i++) {
 		char *devname = dmi_string(dm, i);
 
-		if (!strcmp(devname, dmi_empty_string)) {
-			list_add(&empty_oem_string_dev.list, &dmi_devices);
+		if (!strcmp(devname, dmi_empty_string))
 			continue;
-		}
 
 		dev = dmi_alloc(sizeof(*dev));
 		if (!dev) {

-- 
Jean Delvare

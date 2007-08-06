Return-Path: <linux-kernel-owner+w=401wt.eu-S1764093AbXHFMVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764093AbXHFMVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 08:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbXHFMVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 08:21:02 -0400
Received: from ns2.suse.de ([195.135.220.15]:38788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbXHFMVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 08:21:01 -0400
Date: Mon, 6 Aug 2007 14:20:59 +0200
From: Olaf Hering <olh@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] fix crash in sbp2_remove_device() when dma_set_mask() fails
Message-ID: <20070806122059.GA1951@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-DOS: I got your 640K Real Mode Right Here Buddy!
X-Homeland-Security: You are not supposed to read this line! You are a terrorist!
User-Agent: Mutt und vi sind doch schneller als Notes (und GroupWise)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix crash in sbp2_remove_device() when dma_set_mask() fails.

Signed-off-by: Olaf Hering <olh@suse.de>

---
 drivers/ieee1394/sbp2.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -929,13 +929,14 @@ static void sbp2_remove_device(struct sb
 	if (!lu)
 		return;
 
-	hi = lu->hi;
-
 	if (lu->shost) {
 		scsi_remove_host(lu->shost);
 		scsi_host_put(lu->shost);
 	}
 	flush_scheduled_work();
+	hi = lu->hi;
+	if (!hi)
+		return;
 	sbp2util_remove_command_orb_pool(lu);
 
 	list_del(&lu->lu_list);
@@ -977,8 +978,7 @@ static void sbp2_remove_device(struct sb
 
 	lu->ud->device.driver_data = NULL;
 
-	if (hi)
-		module_put(hi->host->driver->owner);
+	module_put(hi->host->driver->owner);
 
 	kfree(lu);
 }

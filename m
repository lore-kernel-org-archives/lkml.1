Return-Path: <linux-kernel-owner+w=401wt.eu-S1759980AbXHKJvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980AbXHKJvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 05:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbXHKJvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 05:51:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35040 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbXHKJvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 05:51:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 11 Aug 2007 11:51:16 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: fix sbp2_remove_device for error cases
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Olaf Hering <olh@suse.de>
In-Reply-To: <tkrat.743d7d7e44325432@s5r6.in-berlin.de>
Message-ID: <tkrat.123975b91520704c@s5r6.in-berlin.de>
References: <20070806122059.GA1951@suse.de>
 <tkrat.743d7d7e44325432@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Date: 
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: sbp2: fix sbp2_remove_device for error cases

Bug found by Olaf Hering <olh@suse.de>:
sbp2util_remove_command_orb_pool requires a valid lu->hi pointer.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -513,9 +513,9 @@ static int sbp2util_create_command_orb_p
 	return 0;
 }
 
-static void sbp2util_remove_command_orb_pool(struct sbp2_lu *lu)
+static void sbp2util_remove_command_orb_pool(struct sbp2_lu *lu,
+					     struct hpsb_host *host)
 {
-	struct hpsb_host *host = lu->hi->host;
 	struct list_head *lh, *next;
 	struct sbp2_command_info *cmd;
 	unsigned long flags;
@@ -922,15 +922,16 @@ static void sbp2_remove_device(struct sb
 
 	if (!lu)
 		return;
-
 	hi = lu->hi;
+	if (!hi)
+		goto no_hi;
 
 	if (lu->shost) {
 		scsi_remove_host(lu->shost);
 		scsi_host_put(lu->shost);
 	}
 	flush_scheduled_work();
-	sbp2util_remove_command_orb_pool(lu);
+	sbp2util_remove_command_orb_pool(lu, hi->host);
 
 	list_del(&lu->lu_list);
 
@@ -971,9 +972,8 @@ static void sbp2_remove_device(struct sb
 
 	lu->ud->device.driver_data = NULL;
 
-	if (hi)
-		module_put(hi->host->driver->owner);
-
+	module_put(hi->host->driver->owner);
+no_hi:
 	kfree(lu);
 }
 

-- 
Stefan Richter
-=====-=-=== =--- -=-==
http://arcgraph.de/sr/


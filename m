Return-Path: <linux-kernel-owner+w=401wt.eu-S1757805AbYGVF0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805AbYGVF0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756568AbYGVFWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:22:32 -0400
Received: from ns.suse.de ([195.135.220.2]:53759 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756750AbYGVFWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:22:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ben Collins <ben.collins@ubuntu.com>
Subject: [PATCH 15/79] device create: ieee1394: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:39 -0700
Message-Id: <1216703983-21448-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: Ben Collins <ben.collins@ubuntu.com>
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ieee1394/dv1394.c    |    7 ++++---
 drivers/ieee1394/raw1394.c   |    4 ++--
 drivers/ieee1394/video1394.c |    6 +++---
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
index 9d19aec..b6eb2cf 100644
--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -2296,9 +2296,10 @@ static void dv1394_add_host(struct hpsb_host *host)
 
 	ohci = (struct ti_ohci *)host->hostdata;
 
-	device_create(hpsb_protocol_class, NULL, MKDEV(
-		IEEE1394_MAJOR,	IEEE1394_MINOR_BLOCK_DV1394 * 16 + (id<<2)),
-		"dv1394-%d", id);
+	device_create_drvdata(hpsb_protocol_class, NULL,
+			      MKDEV(IEEE1394_MAJOR,
+				    IEEE1394_MINOR_BLOCK_DV1394 * 16 + (id<<2)), NULL,
+			      "dv1394-%d", id);
 
 	dv1394_init(ohci, DV1394_NTSC, MODE_RECEIVE);
 	dv1394_init(ohci, DV1394_NTSC, MODE_TRANSMIT);
diff --git a/drivers/ieee1394/raw1394.c b/drivers/ieee1394/raw1394.c
index 96f2847..6fa9e4a 100644
--- a/drivers/ieee1394/raw1394.c
+++ b/drivers/ieee1394/raw1394.c
@@ -3010,10 +3010,10 @@ static int __init init_raw1394(void)
 	hpsb_register_highlevel(&raw1394_highlevel);
 
 	if (IS_ERR
-	    (device_create(
+	    (device_create_drvdata(
 	      hpsb_protocol_class, NULL,
 	      MKDEV(IEEE1394_MAJOR, IEEE1394_MINOR_BLOCK_RAW1394 * 16),
-	      RAW1394_DEVICE_NAME))) {
+	      NULL, RAW1394_DEVICE_NAME))) {
 		ret = -EFAULT;
 		goto out_unreg;
 	}
diff --git a/drivers/ieee1394/video1394.c b/drivers/ieee1394/video1394.c
index 069b9f6..25db6e6 100644
--- a/drivers/ieee1394/video1394.c
+++ b/drivers/ieee1394/video1394.c
@@ -1341,9 +1341,9 @@ static void video1394_add_host (struct hpsb_host *host)
 	hpsb_set_hostinfo_key(&video1394_highlevel, host, ohci->host->id);
 
 	minor = IEEE1394_MINOR_BLOCK_VIDEO1394 * 16 + ohci->host->id;
-	device_create(hpsb_protocol_class, NULL,
-		      MKDEV(IEEE1394_MAJOR, minor),
-		      "%s-%d", VIDEO1394_DRIVER_NAME, ohci->host->id);
+	device_create_drvdata(hpsb_protocol_class, NULL,
+			      MKDEV(IEEE1394_MAJOR, minor), NULL,
+			      "%s-%d", VIDEO1394_DRIVER_NAME, ohci->host->id);
 }
 
 
-- 
1.5.6.3


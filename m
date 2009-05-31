Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbZEaGns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbZEaGns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 02:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZEaGnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 02:43:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:47195 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbZEaGnj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 02:43:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,278,1241420400"; 
   d="scan'208,223";a="695118053"
From: "Xu, Dongxiao" <dongxiao.xu@intel.com>
To: "greg@kroah.com" <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Nashif, Anas" <anas.nashif@intel.com>,
       "Obara, Marcin" <marcin.obara@intel.com>
Date: Sun, 31 May 2009 14:43:39 +0800
Subject: [Patch 02/08] Staging: heci - fix wrong order of device_lock and
 file_lock
Thread-Topic: [Patch 02/08] Staging: heci - fix wrong order of device_lock
 and file_lock
Thread-Index: AcnhuyGeYeJ8QpOARyyzz5Ms+h5smw==
Message-ID: <EADF0A36011179459010BDF5142A457501C9BF2AE0@pdsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5c4db44364f204d168d2bbb70310728a54aabcd7 Mon Sep 17 00:00:00 2001
From: Dongxiao Xu <dongxiao.xu@intel.com>
Date: Sun, 31 May 2009 22:44:09 +0800
Subject: [PATCH] heci: fix wrong order of device_lock and file_lock

When the two locks are nested, the code should always first acquire file_lock,
and then acquire device_lock in order not to generate dead-lock race.

Signed-off-by: Dongxiao Xu <dongxiao.xu@intel.com>
---
 drivers/staging/heci/io_heci.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/heci/io_heci.c b/drivers/staging/heci/io_heci.c
index ff6d294..26882a2 100644
--- a/drivers/staging/heci/io_heci.c
+++ b/drivers/staging/heci/io_heci.c
@@ -277,14 +277,16 @@ int heci_ioctl_connect_client(struct iamt_heci_device *dev, int if_num,
 		}
 		goto end;
 	}
+	spin_unlock_bh(&dev->device_lock);
+
 	spin_lock(&file_ext->file_lock);
+	spin_lock_bh(&dev->device_lock);
 	if (file_ext->state != HECI_FILE_CONNECTING) {
 		rets = -ENODEV;
-		spin_unlock(&file_ext->file_lock);
 		spin_unlock_bh(&dev->device_lock);
+		spin_unlock(&file_ext->file_lock);
 		goto end;
 	}
-	spin_unlock(&file_ext->file_lock);
 	/* prepare the output buffer */
 	client = (struct heci_client *) res_msg.data;
 	client->max_msg_length = dev->me_clients[i].props.max_msg_length;
@@ -312,6 +314,7 @@ int heci_ioctl_connect_client(struct iamt_heci_device *dev, int if_num,
 			      &dev->ctrl_wr_list.heci_cb.cb_list);
 	}
 	spin_unlock_bh(&dev->device_lock);
+	spin_unlock(&file_ext->file_lock);
 	err = wait_event_timeout(dev->wait_recvd_msg,
 			(HECI_FILE_CONNECTED == file_ext->state
 			 || HECI_FILE_DISCONNECTED == file_ext->state),
-- 
1.6.0.rc1


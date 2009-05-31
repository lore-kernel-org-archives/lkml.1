Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbZEaGqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbZEaGqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 02:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbZEaGql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 02:46:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:40594 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbZEaGqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 02:46:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,278,1241420400"; 
   d="scan'208,223";a="417225374"
From: "Xu, Dongxiao" <dongxiao.xu@intel.com>
To: "greg@kroah.com" <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Nashif, Anas" <anas.nashif@intel.com>,
       "Obara, Marcin" <marcin.obara@intel.com>
Date: Sun, 31 May 2009 14:43:51 +0800
Subject: [Patch 05/08] Staging: heci - fix typos and add wait after
 disconnect
Thread-Topic: [Patch 05/08] Staging: heci - fix typos and add wait after
 disconnect
Thread-Index: Acnhuyi5fCfPiZMORlKr0OLW9LpE4A==
Message-ID: <EADF0A36011179459010BDF5142A457501C9BF2AE3@pdsmsx502.ccr.corp.intel.com>
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

>From fb611bebfc017d25cd8b90c25fa988162bc12713 Mon Sep 17 00:00:00 2001
From: Dongxiao Xu <dongxiao.xu@intel.com>
Date: Sun, 31 May 2009 22:46:10 +0800
Subject: [PATCH] heci: fix typos and add wait after disconnect.

 - Fix typo for enum HECI_WRITE.
 - Fix timeout issue. If the time period is greater or equal 15s, it's timeout.
 - Add 10ms wait time after disconnect, to ensure that hardware is ready.
   Otherwise in the next time connection, hardware resource may be busy.

Signed-off-by: Dongxiao Xu <dongxiao.xu@intel.com>
---
 drivers/staging/heci/heci_init.c |    1 +
 drivers/staging/heci/heci_main.c |    2 +-
 drivers/staging/heci/interrupt.c |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/heci/heci_init.c b/drivers/staging/heci/heci_init.c
index a8a0da9..06ea196 100644
--- a/drivers/staging/heci/heci_init.c
+++ b/drivers/staging/heci/heci_init.c
@@ -1012,6 +1012,7 @@ int heci_disconnect_host_client(struct iamt_heci_device *dev,
 	if (dev->host_buffer_is_empty) {
 		dev->host_buffer_is_empty = 0;
 		if (heci_disconnect(dev, file_ext)) {
+			mdelay(10); /* Wait for hardware disconnection ready */
 			list_add_tail(&priv_cb->cb_list,
 				&dev->ctrl_rd_list.heci_cb.cb_list);
 		} else {
diff --git a/drivers/staging/heci/heci_main.c b/drivers/staging/heci/heci_main.c
index 1e5c26d..1e2f3db 100644
--- a/drivers/staging/heci/heci_main.c
+++ b/drivers/staging/heci/heci_main.c
@@ -1088,7 +1088,7 @@ static ssize_t heci_write(struct file *file, const char __user *ubuf,
 	if (file_ext == &dev->iamthif_file_ext) {
 		priv_write_cb = find_pthi_read_list_entry(dev, file);
 		if ((priv_write_cb != NULL) &&
-		     (((currtime - priv_write_cb->read_time) >
+		     (((currtime - priv_write_cb->read_time) >=
 			    IAMTHIF_READ_TIMER) ||
 		      (file_ext->reading_state == HECI_READ_COMPLETE))) {
 			(*offset) = 0;
diff --git a/drivers/staging/heci/interrupt.c b/drivers/staging/heci/interrupt.c
index 2db1851..b7ce73b 100644
--- a/drivers/staging/heci/interrupt.c
+++ b/drivers/staging/heci/interrupt.c
@@ -1054,7 +1054,7 @@ static int heci_bh_write_handler(struct io_heci_list *cmpl_list,
 				list_del(&priv_cb_pos->cb_list);
 				if ((HECI_WRITING == file_ext->writing_state) &&
 					(priv_cb_pos->major_file_operations ==
-						HECI_WRITING) &&
+						HECI_WRITE) &&
 					(file_ext != &dev->iamthif_file_ext)) {
 					DBG("HECI WRITE COMPLETE\n");
 					file_ext->writing_state =
-- 
1.6.0.rc1


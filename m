Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbZFFDCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbZFFDCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 23:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZFFDA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 23:00:56 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:62860 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbZFFDAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 23:00:49 -0400
X-IronPort-AV: E=Sophos;i="4.41,314,1241395200"; 
   d="scan'208";a="317953944"
Date: Fri, 5 Jun 2009 19:34:16 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-usb@vger.kernel.org, greg@kroah.com,
       linux-scsi@vger.kernel.org, netdev@vger.kernel.org, arjan@infradead.org
Subject: [PATCH 7/7] initdev:kernel:Await block device discovery
Message-ID: <20090606023416.GA5798@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-4; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the initdev infrastructure to wait for a root device to become available.
This should make most uses of the kernel rootwait parameter unnecessary. The
only time it should be necessary is when the root device might not be attached
at boot time.

Signed-off-by: David VomLehn <dvomlehn@cisco>
---
 init/do_mounts.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index dd7ee5f..36a92ae 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -358,6 +358,18 @@ void __init mount_root(void)
 #endif
 }
 
+/**
+ * root_present - determine whether the root device is available yet
+ *
+ * Returns true if the root device is available, false if not. The check to
+ * see if the root device is available is done by check to see whether it
+ * has been assigned a major/minor device number.
+ */
+static bool root_present(void)
+{
+	return name_to_dev_t(saved_root_name) != 0;
+}
+
 /*
  * Prepare the namespace - decide what/where to mount, load ramdisks, etc.
  */
@@ -398,12 +410,21 @@ void __init prepare_namespace(void)
 		goto out;
 
 	/* wait for any asynchronous scanning to complete */
-	if ((ROOT_DEV == 0) && root_wait) {
+	if (ROOT_DEV == 0) {
 		printk(KERN_INFO "Waiting for root device %s...\n",
 			saved_root_name);
-		while (driver_probe_done() != 0 ||
-			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
-			msleep(100);
+		if (root_wait) {
+			while (driver_probe_done() != 0 ||
+				(ROOT_DEV = name_to_dev_t(saved_root_name)) ==
+					0)
+				msleep(100);
+		}
+
+		else {
+			initdev_wait(INITDEV_BLOCK_TYPE, root_present);
+			ROOT_DEV = name_to_dev_t(saved_root_name);
+		}
+
 		async_synchronize_full();
 	}
 

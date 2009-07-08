Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbZGHKSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbZGHKSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZGHKRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:17:50 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47520 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197AbZGHKRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:17:49 -0400
Subject: [PATCH] Free struct device in fw_dev_release()
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Ming Lei <tom.leiming@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Wed, 08 Jul 2009 11:17:40 +0100
Message-ID: <20090708101740.27241.64092.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.387.geb0c.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2009 10:17:40.0877 (UTC) FILETIME=[53514BD0:01C9FFB5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The f_dev in _request_firmware() is allocated via the fw_setup_device()
and fw_register_device() calls and its class set to firmware_class (the
class release function is fw_dev_release).

Commit 6acf70f078ca replaced the kfree(dev) in fw_dev_release() with a
put_device() call but my understanding is that the release function is
called via put_device -> kobject_put -> kref_put -> koject_release etc.
and it should call kfree since it's the last to see this device
structure alive.

Because of that, the _request_firmware() function on its -ENOENT error
path only calls device_unregister(f_dev) which would eventually call
fw_dev_release() but there is no kfree (the subsequent put_device call
would just make the kref negative).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Acked-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/base/firmware_class.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index ddeb819..fc46653 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -357,7 +357,7 @@ static void fw_dev_release(struct device *dev)
 	kfree(fw_priv->pages);
 	kfree(fw_priv->fw_id);
 	kfree(fw_priv);
-	put_device(dev);
+	kfree(dev);
 
 	module_put(THIS_MODULE);
 }
@@ -408,13 +408,11 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	if (retval) {
 		dev_err(device, "%s: device_register failed\n", __func__);
 		put_device(f_dev);
-		goto error_kfree_fw_id;
+		return retval;
 	}
 	*dev_p = f_dev;
 	return 0;
 
-error_kfree_fw_id:
-	kfree(fw_priv->fw_id);
 error_kfree:
 	kfree(f_dev);
 	kfree(fw_priv);


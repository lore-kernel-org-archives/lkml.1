Return-Path: <linux-kernel-owner+w=401wt.eu-S1761695AbYBOWcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761695AbYBOWcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761578AbYBOWbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:31:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760095AbYBOWbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:31:04 -0500
Date: Fri, 15 Feb 2008 17:31:09 -0500 (EST)
Message-Id: <20080215.173109.45743443.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [APPENDIX PATCH 06/13] dm: tidy local_init
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tidies local_init() as preparation for request-based dm.
No functional change.

This patch is just a clean up of the codes and not functionally
related to request-based dm.  But included here due to literal
dependency.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

Index: 2.6.25-rc1/drivers/md/dm.c
===================================================================
--- 2.6.25-rc1.orig/drivers/md/dm.c
+++ 2.6.25-rc1/drivers/md/dm.c
@@ -150,40 +150,40 @@ static struct kmem_cache *_tio_cache;
 
 static int __init local_init(void)
 {
-	int r;
+	int r = -ENOMEM;
 
 	/* allocate a slab for the dm_ios */
 	_io_cache = KMEM_CACHE(dm_io, 0);
 	if (!_io_cache)
-		return -ENOMEM;
+		return r;
 
 	/* allocate a slab for the target ios */
 	_tio_cache = KMEM_CACHE(dm_target_io, 0);
-	if (!_tio_cache) {
-		kmem_cache_destroy(_io_cache);
-		return -ENOMEM;
-	}
+	if (!_tio_cache)
+		goto out_free_io_cache;
 
 	r = dm_uevent_init();
-	if (r) {
-		kmem_cache_destroy(_tio_cache);
-		kmem_cache_destroy(_io_cache);
-		return r;
-	}
+	if (r)
+		goto out_free_tio_cache;
 
 	_major = major;
 	r = register_blkdev(_major, _name);
-	if (r < 0) {
-		kmem_cache_destroy(_tio_cache);
-		kmem_cache_destroy(_io_cache);
-		dm_uevent_exit();
-		return r;
-	}
+	if (r < 0)
+		goto out_uevent_exit;
 
 	if (!_major)
 		_major = r;
 
 	return 0;
+
+out_uevent_exit:
+	dm_uevent_exit();
+out_free_tio_cache:
+	kmem_cache_destroy(_tio_cache);
+out_free_io_cache:
+	kmem_cache_destroy(_io_cache);
+
+	return r;
 }
 
 static void local_exit(void)

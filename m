Return-Path: <linux-kernel-owner+w=401wt.eu-S1762671AbYCDH0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762671AbYCDH0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 02:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYCDH0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 02:26:36 -0500
Received: from smtp.nokia.com ([192.100.105.134]:36058 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbYCDH0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 02:26:35 -0500
Subject: [GIT PULL] UBI fixes for 2.6.25-rc4
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Mar 2008 09:21:03 +0200
Message-Id: <1204615263.23706.19.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 04 Mar 2008 07:25:55.0735 (UTC) FILETIME=[FC262A70:01C87DC8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull UBI fixes from 'for-linus' branch of

git://git.infradead.org/~dedekind/ubi-2.6.git for-linus

to receive the following updates:

 drivers/mtd/ubi/build.c |    4 ++--
 drivers/mtd/ubi/ubi.h   |   10 +++++-----
 drivers/mtd/ubi/vmt.c   |    4 +++-
 drivers/mtd/ubi/vtbl.c  |    1 +
 4 files changed, 11 insertions(+), 8 deletions(-)

Adrian Bunk (1):
      UBI: mtd/ubi/vtbl.c: fix memory leak

Artem Bityutskiy (1):
      UBI: fix error message

Harvey Harrison (1):
      UBI: fix sparse errors in ubi.h

S.Çağlar Onur (1):
      UBI: silence warning

commit f7f0283776b6fe33f87f6a2ef15b1feb49ef6dac
Author: Adrian Bunk <bunk@kernel.org>
Date:   Mon Mar 3 20:07:52 2008 +0200

    UBI: mtd/ubi/vtbl.c: fix memory leak
    
    This patch fixes a memory leak introduced by commit
    4ccf8cffa963c7b5bdc6d455ea9417084ee49aa8 and spotted by the Coverity
    checker.
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index 56fc3fb..af36b12 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -519,6 +519,7 @@ static int init_volumes(struct ubi_device *ubi, const struct ubi_scan_info *si,
 			if (ubi->autoresize_vol_id != -1) {
 				ubi_err("more then one auto-resize volume (%d "
 					"and %d)", ubi->autoresize_vol_id, i);
+				kfree(vol);
 				return -EINVAL;
 			}
 

commit 8eee9f100b1cc3d1b0a701a8626c54422af3c987
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Fri Feb 15 10:47:51 2008 +0200

    UBI: fix sparse errors in ubi.h
    
    In C, signed 1-bit bitfields can only take the values 0 and -1, only 0 and 1
    are ever assigned in current code.  Make them unsigned bitfields.
    
    Fixes the (repeated) sparse errors:
    drivers/mtd/ubi/ubi.h:220:15: error: dubious one-bit signed bitfield
    drivers/mtd/ubi/ubi.h:221:17: error: dubious one-bit signed bitfield
    drivers/mtd/ubi/ubi.h:222:18: error: dubious one-bit signed bitfield
    drivers/mtd/ubi/ubi.h:223:16: error: dubious one-bit signed bitfield
    drivers/mtd/ubi/ubi.h:224:20: error: dubious one-bit signed bitfield
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Cc: Artem Bityutskiy <dedekind@infradead.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 4577106..a548c1d 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -217,11 +217,11 @@ struct ubi_volume {
 	void *upd_buf;
 
 	int *eba_tbl;
-	int checked:1;
-	int corrupted:1;
-	int upd_marker:1;
-	int updating:1;
-	int changing_leb:1;
+	unsigned int checked:1;
+	unsigned int corrupted:1;
+	unsigned int upd_marker:1;
+	unsigned int updating:1;
+	unsigned int changing_leb:1;
 
 #ifdef CONFIG_MTD_UBI_GLUEBI
 	/*

commit 19cd7b7de1804a50264dfd5c6ba3c6d332362a77
Author: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date:   Tue Feb 12 16:32:35 2008 +0200

    UBI: fix error message
    
    Make it print "UBI error: cannot attach mtd4"
    instead of "UBI error: cannot attach 4"
    
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 6ac81e3..2759604 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1000,8 +1000,8 @@ static int __init ubi_init(void)
 		mutex_unlock(&ubi_devices_mutex);
 		if (err < 0) {
 			put_mtd_device(mtd);
-			printk(KERN_ERR "UBI error: cannot attach %s\n",
-			       p->name);
+			printk(KERN_ERR "UBI error: cannot attach mtd%d\n",
+			       mtd->index);
 			goto out_detach;
 		}
 	}

commit fc398769ac5cbfdf4dc16a7ba657b284abcc92f5
Author: S.Çağlar Onur <caglar@pardus.org.tr>
Date:   Tue Feb 12 13:25:06 2008 +0200

    UBI: silence warning
    
    drivers/mtd/ubi/vmt.c: In function `ubi_create_volume':
    drivers/mtd/ubi/vmt.c:379: warning: statement with no effect
    
    Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index a3ca225..5be58d8 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -376,7 +376,9 @@ out_sysfs:
 	get_device(&vol->dev);
 	volume_sysfs_close(vol);
 out_gluebi:
-	ubi_destroy_gluebi(vol);
+	if (ubi_destroy_gluebi(vol))
+		dbg_err("cannot destroy gluebi for volume %d:%d",
+			ubi->ubi_num, vol_id);
 out_cdev:
 	cdev_del(&vol->cdev);
 out_mapping:

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)


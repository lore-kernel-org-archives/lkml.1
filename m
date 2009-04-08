Return-Path: <linux-kernel-owner+w=401wt.eu-S1762786AbZDHHJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762786AbZDHHJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760876AbZDHHIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:08:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60542 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759175AbZDHHIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:08:48 -0400
Message-ID: <49DC4DA9.5060401@cn.fujitsu.com>
Date: Wed, 08 Apr 2009 15:09:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: tyhicks@linux.vnet.ibm.com
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ecryptfs-devel@lists.launchpad.net
Subject: [PATCH 6/6] ecryptfs: use memdup_user()
References: <49DC4CC0.9050805@cn.fujitsu.com>
In-Reply-To: <49DC4CC0.9050805@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove open-coded memdup_user().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/ecryptfs/miscdev.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/ecryptfs/miscdev.c b/fs/ecryptfs/miscdev.c
index a67fea6..dda3c58 100644
--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -418,18 +418,13 @@ ecryptfs_miscdev_write(struct file *file, const char __user *buf,
 
 	if (count == 0)
 		goto out;
-	data = kmalloc(count, GFP_KERNEL);
-	if (!data) {
-		printk(KERN_ERR "%s: Out of memory whilst attempting to "
-		       "kmalloc([%zd], GFP_KERNEL)\n", __func__, count);
+
+	data = memdup_user(buf, count);
+	if (IS_ERR(data)) {
+		printk(KERN_ERR "%s: memdup_user returned error [%ld]\n",
+		       __func__, PTR_ERR(data));
 		goto out;
 	}
-	rc = copy_from_user(data, buf, count);
-	if (rc) {
-		printk(KERN_ERR "%s: copy_from_user returned error [%d]\n",
-		       __func__, rc);
-		goto out_free;
-	}
 	sz = count;
 	i = 0;
 	switch (data[i++]) {
-- 
1.5.4.rc3



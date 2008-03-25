Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbYCYGRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbYCYGRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 02:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbYCYGRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 02:17:06 -0400
Received: from ns2.suse.de ([195.135.220.15]:46129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757210AbYCYGRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 02:17:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, <balajirrao@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/2] driver core: debug for bad dev_attr_show() return value.
Date: Mon, 24 Mar 2008 23:16:54 -0700
Message-Id: <1206425814-20831-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080325060503.GB20741@suse.de>
References: <20080325060503.GB20741@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Try to find the culprit who caused
http://bugzilla.kernel.org/show_bug.cgi?id=10150

Cc: <balajirrao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    5 +++++
 fs/sysfs/file.c     |    8 +++++++-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7de543d..24198ad 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -19,6 +19,7 @@
 #include <linux/kdev_t.h>
 #include <linux/notifier.h>
 #include <linux/genhd.h>
+#include <linux/kallsyms.h>
 #include <asm/semaphore.h>
 
 #include "base.h"
@@ -68,6 +69,10 @@ static ssize_t dev_attr_show(struct kobject *kobj, struct attribute *attr,
 
 	if (dev_attr->show)
 		ret = dev_attr->show(dev, dev_attr, buf);
+	if (ret >= (ssize_t)PAGE_SIZE) {
+		print_symbol("dev_attr_show: %s returned bad count\n",
+				(unsigned long)dev_attr->show);
+	}
 	return ret;
 }
 
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index a271c87..baa663e 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -12,6 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/kobject.h>
+#include <linux/kallsyms.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
 #include <linux/list.h>
@@ -86,7 +87,12 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 	 * The code works fine with PAGE_SIZE return but it's likely to
 	 * indicate truncated result or overflow in normal use cases.
 	 */
-	BUG_ON(count >= (ssize_t)PAGE_SIZE);
+	if (count >= (ssize_t)PAGE_SIZE) {
+		print_symbol("fill_read_buffer: %s returned bad count\n",
+			(unsigned long)ops->show);
+		/* Try to struggle along */
+		count = PAGE_SIZE - 1;
+	}
 	if (count >= 0) {
 		buffer->needs_read_fill = 0;
 		buffer->count = count;
-- 
1.5.4.3


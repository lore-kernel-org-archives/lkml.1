Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbYD2LYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbYD2LYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYD2LYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:24:13 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:6818 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbYD2LYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:24:12 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Paul Mackerras <paulus@au.ibm.com>
Subject: [PATCH 8/12] powerpc: assign PDE->data before gluing PDE into /proc tree
Date: Tue, 29 Apr 2008 15:13:18 +0400
Message-Id: <1209467602-20001-8-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1209467538.29647.11.camel@iris.sw.ru>
References: <1209467538.29647.11.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply replace proc_create and further data assigned with proc_create_data.
No need to check for data!=NULL after that.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Paul Mackerras <paulus@au.ibm.com>
---
 arch/powerpc/platforms/pseries/scanlog.c |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/scanlog.c b/arch/powerpc/platforms/pseries/scanlog.c
index e5b0ea8..7a76f63 100644
--- a/arch/powerpc/platforms/pseries/scanlog.c
+++ b/arch/powerpc/platforms/pseries/scanlog.c
@@ -57,11 +57,6 @@ static ssize_t scanlog_read(struct file *file, char __user *buf,
         dp = PDE(inode);
  	data = (unsigned int *)dp->data;
 
-	if (!data) {
-		printk(KERN_ERR "scanlog: read failed no data\n");
-		return -EIO;
-	}
-
 	if (count > RTAS_DATA_BUF_SIZE)
 		count = RTAS_DATA_BUF_SIZE;
 
@@ -153,11 +148,6 @@ static int scanlog_open(struct inode * inode, struct file * file)
 	struct proc_dir_entry *dp = PDE(inode);
 	unsigned int *data = (unsigned int *)dp->data;
 
-	if (!data) {
-		printk(KERN_ERR "scanlog: open failed no data\n");
-		return -EIO;
-	}
-
 	if (data[0] != 0) {
 		/* This imperfect test stops a second copy of the
 		 * data (or a reset while data is being copied)
@@ -175,10 +165,6 @@ static int scanlog_release(struct inode * inode, struct file * file)
 	struct proc_dir_entry *dp = PDE(inode);
 	unsigned int *data = (unsigned int *)dp->data;
 
-	if (!data) {
-		printk(KERN_ERR "scanlog: release failed no data\n");
-		return -EIO;
-	}
 	data[0] = 0;
 
 	return 0;
@@ -207,12 +193,11 @@ static int __init scanlog_init(void)
 	if (!data)
 		goto err;
 
-	ent = proc_create("ppc64/rtas/scan-log-dump", S_IRUSR, NULL,
-			  &scanlog_fops);
+	ent = proc_create_data("ppc64/rtas/scan-log-dump", S_IRUSR, NULL,
+			       &scanlog_fops, data);
 	if (!ent)
 		goto err;
 
-	ent->data = data;
 	proc_ppc64_scan_log_dump = ent;
 
 	return 0;
-- 
1.5.3.rc5


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762771AbYBNS1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762771AbYBNS1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbYBNS1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:27:04 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:42079 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbYBNS1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:27:01 -0500
Message-ID: <47B487F4.7000003@ct.jp.nec.com>
Date: Thu, 14 Feb 2008 10:27:00 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] latencytop: fix memory leak on latency proc file
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

At lstats_open(), calling get_proc_task() gets task struct, but it never put.
put_task_struct() should be called when releasing.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 fs/proc/base.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1710b03..dc651a9 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -360,6 +360,15 @@ static int lstats_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
+static int lstats_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = file->private_data;
+	struct task_struct *task = m->private;
+
+	put_task_struct(task);
+	return single_release(inode, file);
+}
+
 static ssize_t lstats_write(struct file *file, const char __user *buf,
 			    size_t count, loff_t *offs)
 {
@@ -378,7 +387,7 @@ static const struct file_operations proc_lstats_operations = {
 	.read		= seq_read,
 	.write		= lstats_write,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= lstats_release,
 };
 
 #endif
-- 
1.5.3.8


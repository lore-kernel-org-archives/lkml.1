Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZHFXnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZHFXnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 19:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbZHFXnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 19:43:19 -0400
Received: from vena.lwn.net ([206.168.112.25]:50326 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586AbZHFXnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 19:43:18 -0400
Date: Thu, 6 Aug 2009 14:01:18 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mark Gross <mgross@linux.intel.com>
Subject: [PATCH 2/2] pm_qos: clean up racy "name" variable
Message-ID: <20090806140118.17286d0e@bike.lwn.net>
In-Reply-To: <20090806135841.46682114@bike.lwn.net>
References: <20090806135841.46682114@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"name" is an awful name for a file-global variable.  It was used in three
different functions, with no mutual exclusion.  But it's just a tiny,
temporary string; let's just move it onto the stack in the functions that
need it.  Also use snprintf() just in case.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 kernel/pm_qos_params.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index d96b83e..3db49b9 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -343,18 +343,18 @@ int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier)
 }
 EXPORT_SYMBOL_GPL(pm_qos_remove_notifier);
 
-#define PID_NAME_LEN sizeof("process_1234567890")
-static char name[PID_NAME_LEN];
+#define PID_NAME_LEN 32
 
 static int pm_qos_power_open(struct inode *inode, struct file *filp)
 {
 	int ret;
 	long pm_qos_class;
+	char name[PID_NAME_LEN];
 
 	pm_qos_class = find_pm_qos_object_by_minor(iminor(inode));
 	if (pm_qos_class >= 0) {
 		filp->private_data = (void *)pm_qos_class;
-		sprintf(name, "process_%d", current->pid);
+		snprintf(name, PID_NAME_LEN, "process_%d", current->pid);
 		ret = pm_qos_add_requirement(pm_qos_class, name,
 					PM_QOS_DEFAULT_VALUE);
 		if (ret >= 0)
@@ -366,9 +366,10 @@ static int pm_qos_power_open(struct inode *inode, struct file *filp)
 static int pm_qos_power_release(struct inode *inode, struct file *filp)
 {
 	int pm_qos_class;
+	char name[PID_NAME_LEN];
 
 	pm_qos_class = (long)filp->private_data;
-	sprintf(name, "process_%d", current->pid);
+	snprintf(name, PID_NAME_LEN, "process_%d", current->pid);
 	pm_qos_remove_requirement(pm_qos_class, name);
 
 	return 0;
@@ -379,13 +380,14 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
 {
 	s32 value;
 	int pm_qos_class;
+	char name[PID_NAME_LEN];
 
 	pm_qos_class = (long)filp->private_data;
 	if (count != sizeof(s32))
 		return -EINVAL;
 	if (copy_from_user(&value, buf, sizeof(s32)))
 		return -EFAULT;
-	sprintf(name, "process_%d", current->pid);
+	snprintf(name, PID_NAME_LEN, "process_%d", current->pid);
 	pm_qos_update_requirement(pm_qos_class, name, value);
 
 	return  sizeof(s32);
-- 
1.6.2.5


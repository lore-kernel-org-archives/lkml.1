Return-Path: <linux-kernel-owner+w=401wt.eu-S934582AbZJNPpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934582AbZJNPpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934566AbZJNPp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:45:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:33867 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934565AbZJNPp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:45:28 -0400
Date: Wed, 14 Oct 2009 15:44:31 GMT
From: tip-bot for Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, corbet@lwn.net, tglx@linutronix.de,
       mgross@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, corbet@lwn.net,
       mgross@linux.intel.com
In-Reply-To: <20091010153349.113570550@linutronix.de>
References: <20091010153349.113570550@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/core] pm_qos: clean up racy global "name" variable
Message-ID: <tip-1a6deaea3584fd7af1cad492b1fe0867060b45db@git.kernel.org>
Git-Commit-ID: 1a6deaea3584fd7af1cad492b1fe0867060b45db
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:44:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a6deaea3584fd7af1cad492b1fe0867060b45db
Gitweb:     http://git.kernel.org/tip/1a6deaea3584fd7af1cad492b1fe0867060b45db
Author:     Jonathan Corbet <corbet@lwn.net>
AuthorDate: Thu, 6 Aug 2009 13:35:44 -0600
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 15:31:10 +0200

pm_qos: clean up racy global "name" variable

"name" is a poor name for a file-global variable.  It was used in three
different functions, with no mutual exclusion.  But it's just a tiny,
temporary string; let's just move it onto the stack in the functions that
need it.  Also use snprintf() just in case.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
LKML-Reference: <20091010153349.113570550@linutronix.de>
Acked-by: Mark Gross <mgross@linux.intel.com>
Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

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

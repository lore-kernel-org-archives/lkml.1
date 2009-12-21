Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZLUBWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZLUBWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbZLUBWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:22:01 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37728 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbZLUBUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:20:33 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20091221220.243954235@firstfloor.org>
In-Reply-To: <20091221220.243954235@firstfloor.org>
To: joel.becker@oracle.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, ebiederm@xmission.com
Subject: [PATCH] [10/11] SYSCTL: Use RCU protected sysctl for ocfs group add helper
Message-Id: <20091221012031.B4593B158A@basil.firstfloor.org>
Date: Mon, 21 Dec 2009 02:20:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This avoids races with unlocked sysctl() 

Cc: joel.becker@oracle.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ocfs2/stackglue.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

Index: linux-2.6.33-rc1-ak/fs/ocfs2/stackglue.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/fs/ocfs2/stackglue.c
+++ linux-2.6.33-rc1-ak/fs/ocfs2/stackglue.c
@@ -27,6 +27,7 @@
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
 #include <linux/sysctl.h>
+#include <linux/rcustring.h>
 
 #include "ocfs2_fs.h"
 
@@ -40,7 +41,7 @@ static struct ocfs2_locking_protocol *lp
 static DEFINE_SPINLOCK(ocfs2_stack_lock);
 static LIST_HEAD(ocfs2_stack_list);
 static char cluster_stack_name[OCFS2_STACK_LABEL_LEN + 1];
-static char ocfs2_hb_ctl_path[OCFS2_MAX_HB_CTL_PATH] = "/sbin/ocfs2_hb_ctl";
+static char *ocfs2_hb_ctl_path = "/sbin/ocfs2_hb_ctl";
 
 /*
  * The stack currently in use.  If not null, active_stack->sp_count > 0,
@@ -395,8 +396,15 @@ static void ocfs2_leave_group(const char
 {
 	int ret;
 	char *argv[5], *envp[3];
+	char *helper;
 
-	argv[0] = ocfs2_hb_ctl_path;
+	helper = access_rcu_string(ocfs2_hb_ctl_path, OCFS2_MAX_HB_CTL_PATH, GFP_KERNEL);
+	if (!helper) {
+		printk(KERN_ERR "ocfs2_leave_group: no memory\n");
+		return;
+	}
+
+	argv[0] = helper;
 	argv[1] = "-K";
 	argv[2] = "-u";
 	argv[3] = (char *)group;
@@ -414,6 +422,7 @@ static void ocfs2_leave_group(const char
 		       "\"%s %s %s %s\"\n",
 		       ret, argv[0], argv[1], argv[2], argv[3]);
 	}
+	kfree(helper);
 }
 
 /*
@@ -621,10 +630,10 @@ error:
 static ctl_table ocfs2_nm_table[] = {
 	{
 		.procname	= "hb_ctl_path",
-		.data		= ocfs2_hb_ctl_path,
+		.data		= &ocfs2_hb_ctl_path,
 		.maxlen		= OCFS2_MAX_HB_CTL_PATH,
 		.mode		= 0644,
-		.proc_handler	= proc_dostring,
+		.proc_handler	= proc_rcu_string,
 	},
 	{ }
 };

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517Ab0AECQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0AECQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472Ab0AECQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:16:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43086 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0AECPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:15:35 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20100105315.789846878@firstfloor.org>
In-Reply-To: <20100105315.789846878@firstfloor.org>
To: joel.becker@oracle.com, ebiederm@xmission.com, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/9] SYSCTL: Use RCU protected sysctl for ocfs group add helper
Message-Id: <20100105021534.41436B17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 03:15:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This avoids races with unlocked sysctl() 

Also saves ~220 bytes in the data segment.

Cc: joel.becker@oracle.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ocfs2/stackglue.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

Index: linux-2.6.33-rc2-ak/fs/ocfs2/stackglue.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/fs/ocfs2/stackglue.c
+++ linux-2.6.33-rc2-ak/fs/ocfs2/stackglue.c
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
+	helper = access_rcu_string(&ocfs2_hb_ctl_path, OCFS2_MAX_HB_CTL_PATH, GFP_KERNEL);
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

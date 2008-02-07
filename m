Return-Path: <linux-kernel-owner+w=401wt.eu-S935830AbYBGVVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935830AbYBGVVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762892AbYBGVNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:13:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934271AbYBGVM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:12:58 -0500
Date: Thu, 7 Feb 2008 16:12:29 -0500
From: Jason Baron <jbaron@redhat.com>
To: mathieu.desnoyers@polymtl.ca
Cc: akpm@linux-foundation.org, mingo@elte.hu, fche@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [patch 3/4] make pr_debug() dynamic - sysctl support
Message-ID: <20080207211229.GE14732@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-add /proc/sys/debug/pr_debug, to toggle pr_debug() on/off

Signed-off-by: Jason Baron <jbaron@redhat.com>
---

 kernel/sysctl.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)


diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 7cb1ac3..73508d7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -155,6 +155,11 @@ static int proc_do_cad_pid(struct ctl_table *table, int write, struct file *filp
 static int proc_dointvec_taint(struct ctl_table *table, int write, struct file *filp,
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
+#ifdef CONFIG_PR_DEBUG_DYNAMIC
+static int proc_pr_debug_handler(struct ctl_table *table, int write,
+				 struct file *filp, void __user *buffer,
+				 size_t *lenp, loff_t *ppos);
+#endif
 
 static struct ctl_table root_table[];
 static struct ctl_table_root sysctl_table_root;
@@ -1312,6 +1317,16 @@ static struct ctl_table debug_table[] = {
 		.proc_handler	= proc_dointvec
 	},
 #endif
+#ifdef CONFIG_PR_DEBUG_DYNAMIC
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "pr_debug",
+		.data           = NULL,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_pr_debug_handler
+	},
+#endif
 	{ .ctl_name = 0 }
 };
 
@@ -2499,6 +2514,32 @@ static int proc_do_cad_pid(struct ctl_table *table, int write, struct file *filp
 	return 0;
 }
 
+#ifdef CONFIG_PR_DEBUG_DYNAMIC
+
+static int proc_pr_debug_handler(struct ctl_table *table, int write,
+				 struct file *filp, void __user *buffer,
+				 size_t *lenp, loff_t *ppos)
+{
+	int tmp, r;
+
+	if (!write)
+		tmp = imv_read(pr_debug_on);
+	r = __do_proc_dointvec(&tmp, table, write, filp, buffer,
+				lenp, ppos, NULL, NULL);
+	if (r)
+		return r;
+
+	if (write) {
+		if (tmp)
+			imv_set(pr_debug_on, 1);
+		else
+			imv_set(pr_debug_on, 0);
+	}
+	return 0;
+}
+
+#endif
+
 #else /* CONFIG_PROC_FS */
 
 int proc_dostring(struct ctl_table *table, int write, struct file *filp,

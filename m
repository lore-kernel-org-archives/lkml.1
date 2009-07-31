Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494AbZGaBmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbZGaBmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 21:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZGaBmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 21:42:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:47348 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbZGaBly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 21:41:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,298,1246863600"; 
   d="scan'208";a="170795506"
From: Huang Ying <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
       linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v5 3/4] x86: MCE: Move debugfs mce dir creating to mce.c
Date: Fri, 31 Jul 2009 09:41:42 +0800
Message-Id: <1249004503-17254-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249004503-17254-3-git-send-email-ying.huang@intel.com>
References: <1249004503-17254-1-git-send-email-ying.huang@intel.com>
 <1249004503-17254-2-git-send-email-ying.huang@intel.com>
 <1249004503-17254-3-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because more debugfs files under mce dir will be create in mce.c.

Signed-off-by: Huang Ying <ying.huang@intel.com>


ChangeLog:

v5:

- Rebased on x86-tip.git/mce
---
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    1 +
 arch/x86/kernel/cpu/mcheck/mce-severity.c |    4 +---
 arch/x86/kernel/cpu/mcheck/mce.c          |   13 +++++++++++++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 6bd51e7..32996f9 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -22,6 +22,7 @@ struct mce_bank {
 };
 
 int mce_severity(struct mce *a, int tolerant, char **msg);
+struct dentry *mce_get_debugfs_dir(void);
 
 extern int mce_ser;
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 51f7c72..bc35a07 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -197,7 +197,7 @@ static int __init severities_debugfs_init(void)
 {
 	struct dentry *dmce = NULL, *fseverities_coverage = NULL;
 
-	dmce = debugfs_create_dir("mce", NULL);
+	dmce = mce_get_debugfs_dir();
 	if (dmce == NULL)
 		goto err_out;
 	fseverities_coverage = debugfs_create_file("severities-coverage",
@@ -209,8 +209,6 @@ static int __init severities_debugfs_init(void)
 	return 0;
 
 err_out:
-	if (dmce)
-		debugfs_remove(dmce);
 	return -ENOMEM;
 }
 late_initcall(severities_debugfs_init);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 1ce6db1..9c7419e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -34,6 +34,7 @@
 #include <linux/smp.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/debugfs.h>
 
 #include <asm/processor.h>
 #include <asm/hw_irq.h>
@@ -2003,3 +2004,15 @@ static int __init mcheck_disable(char *str)
 	return 1;
 }
 __setup("nomce", mcheck_disable);
+
+#ifdef CONFIG_DEBUG_FS
+struct dentry *mce_get_debugfs_dir(void)
+{
+	static struct dentry *dmce;
+
+	if (!dmce)
+		dmce = debugfs_create_dir("mce", NULL);
+
+	return dmce;
+}
+#endif
-- 
1.6.3.3


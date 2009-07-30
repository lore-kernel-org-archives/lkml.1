Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbZG3IxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbZG3IxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 04:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZG3IxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 04:53:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:47187 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbZG3IxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 04:53:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,294,1246863600"; 
   d="scan'208";a="479226481"
From: Huang Ying <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
       linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v4 3/4] x86: MCE: Move debugfs mce dir creating to mce.c
Date: Thu, 30 Jul 2009 16:52:32 +0800
Message-Id: <1248943953-26100-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248943953-26100-3-git-send-email-ying.huang@intel.com>
References: <1248943953-26100-1-git-send-email-ying.huang@intel.com>
 <1248943953-26100-2-git-send-email-ying.huang@intel.com>
 <1248943953-26100-3-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because more debugfs files under mce dir will be create in mce.c.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    1 +
 arch/x86/kernel/cpu/mcheck/mce-severity.c |    6 +++---
 arch/x86/kernel/cpu/mcheck/mce.c          |   13 +++++++++++++
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 54dcb8f..2179f87 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -11,5 +11,6 @@ enum severity_level {
 };
 
 int mce_severity(struct mce *a, int tolerant, char **msg);
+struct dentry *mce_get_debugfs_dir(void);
 
 extern int mce_ser;
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index ff0807f..1392c96 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -139,6 +139,7 @@ int mce_severity(struct mce *a, int tolerant, char **msg)
 	}
 }
 
+#ifdef CONFIG_DEBUG_FS
 static void *s_start(struct seq_file *f, loff_t *pos)
 {
 	if (*pos >= ARRAY_SIZE(severities))
@@ -197,7 +198,7 @@ static int __init severities_debugfs_init(void)
 {
 	struct dentry *dmce = NULL, *fseverities_coverage = NULL;
 
-	dmce = debugfs_create_dir("mce", NULL);
+	dmce = mce_get_debugfs_dir();
 	if (dmce == NULL)
 		goto err_out;
 	fseverities_coverage = debugfs_create_file("severities-coverage",
@@ -211,8 +212,7 @@ static int __init severities_debugfs_init(void)
 err_out:
 	if (fseverities_coverage)
 		debugfs_remove(fseverities_coverage);
-	if (dmce)
-		debugfs_remove(dmce);
 	return -ENOMEM;
 }
 late_initcall(severities_debugfs_init);
+#endif
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 484c1e5..b57b6aa 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -34,6 +34,7 @@
 #include <linux/smp.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/debugfs.h>
 
 #include <asm/processor.h>
 #include <asm/hw_irq.h>
@@ -2047,3 +2048,15 @@ static int __init mcheck_disable(char *str)
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


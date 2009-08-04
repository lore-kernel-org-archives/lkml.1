Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbZHDGBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbZHDGBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 02:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932360AbZHDGBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 02:01:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37748 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbZHDGBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 02:01:17 -0400
Message-ID: <4A77CEAB.4030909@np.css.fujitsu.com>
Date: Tue, 04 Aug 2009 15:01:15 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "H.Peter Anvin" <hpa@zytor.com>
Cc: LKLM <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>, Huang Ying <ying.huang@intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH] x86, mce: cleanup initcall of debugfs for mce
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Send this patch again because I posted the patch as an attachment.

This patch is made based on the v5 patches of Huangying for mce.
Before using this patch, please apply the patches of Huangying.
The patches' URLs of Huangying are listed as following:
1.x86: MCE: Support specifying context for software mce injection
  URL: http://marc.info/?l=linux-kernel&m=124900459100786&w=2
2.x86: MCE: Support specifying raise mode for software MCE injection
  URL: http://marc.info/?l=linux-kernel&m=124900459100795&w=2
3.x86: MCE: Move debugfs mce dir creating to mce.c
  URL: http://marc.info/?l=linux-kernel&m=124900459100790&w=2
4.x86: MCE: Fake panic support for MCE testing
  URL: http://marc.info/?l=linux-kernel&m=124900453800724&w=2

There are two initcall functions in the patches of Huangying,
mce_debugfs_init() used in mce.c and severities_debugfs_init() used
in mce-severity.c. I think an initcall function is enough for mce
debug. So we make them into one initcall function.

This version is based x86-tip/mce.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    2 +-
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   13 +++----------
 arch/x86/kernel/cpu/mcheck/mce.c          |   24 +++++++++++-------------
 3 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h
b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 32996f9..ca8421d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -22,7 +22,7 @@ struct mce_bank {
 };

 int mce_severity(struct mce *a, int tolerant, char **msg);
-struct dentry *mce_get_debugfs_dir(void);
+int __init severities_debugfs_init(struct dentry *dmce);

 extern int mce_ser;

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c
b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index bc35a07..49e57ab 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -193,22 +193,15 @@ static const struct file_operations
severities_coverage_fops = {
 	.write		= severities_coverage_write,
 };

-static int __init severities_debugfs_init(void)
+int __init severities_debugfs_init(struct dentry *dmce)
 {
-	struct dentry *dmce = NULL, *fseverities_coverage = NULL;
+	struct dentry *fseverities_coverage = NULL;

-	dmce = mce_get_debugfs_dir();
-	if (dmce == NULL)
-		goto err_out;
 	fseverities_coverage = debugfs_create_file("severities-coverage",
 						   0444, dmce, NULL,
 						   &severities_coverage_fops);
 	if (fseverities_coverage == NULL)
-		goto err_out;
+		return -ENOMEM;

 	return 0;
-
-err_out:
-	return -ENOMEM;
 }
-late_initcall(severities_debugfs_init);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 54bd1b2..37b6526 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2018,16 +2018,6 @@ static int __init mcheck_disable(char *str)
 __setup("nomce", mcheck_disable);

 #ifdef CONFIG_DEBUG_FS
-struct dentry *mce_get_debugfs_dir(void)
-{
-	static struct dentry *dmce;
-
-	if (!dmce)
-		dmce = debugfs_create_dir("mce", NULL);
-
-	return dmce;
-}
-
 static void mce_reset(void)
 {
 	cpu_missing = 0;
@@ -2055,17 +2045,25 @@ DEFINE_SIMPLE_ATTRIBUTE(fake_panic_fops, fake_panic_get,

 static int __init mce_debugfs_init(void)
 {
-	struct dentry *dmce, *ffake_panic;
+	struct dentry *dmce = NULL, *ffake_panic = NULL;

-	dmce = mce_get_debugfs_dir();
+	dmce = debugfs_create_dir("mce", NULL);
 	if (!dmce)
 		return -ENOMEM;
 	ffake_panic = debugfs_create_file("fake_panic", 0444, dmce, NULL,
 					  &fake_panic_fops);
 	if (!ffake_panic)
-		return -ENOMEM;
+		goto err_out;
+
+	if (severities_debugfs_init(dmce))
+		goto err_out;

 	return 0;
+
+err_out:
+	debugfs_remove_recursive(dmce);
+
+	return -ENOMEM;
 }
 late_initcall(mce_debugfs_init);
 #endif
-- 
1.6.2.2

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbYJQL0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbYJQL0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYJQL02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:26:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57095 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbYJQL00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:26:26 -0400
Message-ID: <48F87615.60302@cn.fujitsu.com>
Date: Fri, 17 Oct 2008 19:25:09 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: lethal@linux-sh.org
CC: linux-sh@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix debugfs_create_file's error checking method for arch/sh/mm/
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

debugfs_create_file() returns NULL if an error occurs, returns -ENODEV
when debugfs is not enabled in the kernel.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 arch/sh/mm/cache-debugfs.c |    6 ++++++
 arch/sh/mm/pmb.c           |    2 ++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/sh/mm/cache-debugfs.c b/arch/sh/mm/cache-debugfs.c
index 0e189cc..5ba067b 100644
--- a/arch/sh/mm/cache-debugfs.c
+++ b/arch/sh/mm/cache-debugfs.c
@@ -130,12 +130,18 @@ static int __init cache_debugfs_init(void)
 	dcache_dentry = debugfs_create_file("dcache", S_IRUSR, sh_debugfs_root,
 					    (unsigned int *)CACHE_TYPE_DCACHE,
 					    &cache_debugfs_fops);
+	if (!dcache_dentry)
+		return -ENOMEM;
 	if (IS_ERR(dcache_dentry))
 		return PTR_ERR(dcache_dentry);
 
 	icache_dentry = debugfs_create_file("icache", S_IRUSR, sh_debugfs_root,
 					    (unsigned int *)CACHE_TYPE_ICACHE,
 					    &cache_debugfs_fops);
+	if (!icache_dentry) {
+		debugfs_remove(dcache_dentry);
+		return -ENOMEM;
+	}
 	if (IS_ERR(icache_dentry)) {
 		debugfs_remove(dcache_dentry);
 		return PTR_ERR(icache_dentry);
diff --git a/arch/sh/mm/pmb.c b/arch/sh/mm/pmb.c
index cef7276..8424167 100644
--- a/arch/sh/mm/pmb.c
+++ b/arch/sh/mm/pmb.c
@@ -394,6 +394,8 @@ static int __init pmb_debugfs_init(void)
 
 	dentry = debugfs_create_file("pmb", S_IFREG | S_IRUGO,
 				     sh_debugfs_root, NULL, &pmb_debugfs_fops);
+	if (!dentry)
+		return -ENOMEM;
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-- 
1.5.5.3



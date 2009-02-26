Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZBZWFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZBZWFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZBZWF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:05:29 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:49711 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbZBZWF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:05:28 -0500
Date: Thu, 26 Feb 2009 16:05:26 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -mm] namespaces: get_sb_ns does not require CONFIG_BLOCK
Message-ID: <20090226220525.GA25317@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So move it outside of the CONFIG_BLOCK ifdef in fs/super.c.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 fs/super.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 1a37b58..5182044 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -761,19 +761,6 @@ void kill_litter_super(struct super_block *sb)
 
 EXPORT_SYMBOL(kill_litter_super);
 
-#ifdef CONFIG_BLOCK
-static int set_bdev_super(struct super_block *s, void *data)
-{
-	s->s_bdev = data;
-	s->s_dev = s->s_bdev->bd_dev;
-	return 0;
-}
-
-static int test_bdev_super(struct super_block *s, void *data)
-{
-	return (void *)s->s_bdev == data;
-}
-
 static int ns_test_super(struct super_block *sb, void *data)
 {
 	return sb->s_fs_info == data;
@@ -812,6 +799,21 @@ int get_sb_ns(struct file_system_type *fs_type, int flags, void *data,
 	return 0;
 }
 
+EXPORT_SYMBOL(get_sb_ns);
+
+#ifdef CONFIG_BLOCK
+static int set_bdev_super(struct super_block *s, void *data)
+{
+	s->s_bdev = data;
+	s->s_dev = s->s_bdev->bd_dev;
+	return 0;
+}
+
+static int test_bdev_super(struct super_block *s, void *data)
+{
+	return (void *)s->s_bdev == data;
+}
+
 int get_sb_bdev(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data,
 	int (*fill_super)(struct super_block *, void *, int),
-- 
1.5.4.3


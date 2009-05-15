Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbZEOFXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbZEOFXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 01:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbZEOFXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 01:23:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59212 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbZEOFXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 01:23:36 -0400
Message-ID: <4A0CFB90.3060109@cn.fujitsu.com>
Date: Fri, 15 May 2009 13:20:16 +0800
From: Wei Yongjun <yjwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] devpts: fix to set default values of mount options
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If devpts is mounted with no option specified, the default
values of mount options will no be set. This happend in my
Fedora11Beta box when CONFIG_DEVPTS_MULTIPLE_INSTANCES is
configured in .config.

  $ mkdir /dev/pts2

  $ mount -t devpts devpts /dev/pts2
  $ cat /proc/mounts
  devpts /dev/pts2 devpts rw,relatime,mode=000,ptmxmode=000 0 0

  # umount /dev/pts2
  $ mount -t devpts -o gid=0 devpts /dev/pts2
  $ cat /proc/mounts
  devpts /dev/pts2 devpts rw,relatime,gid=0,mode=600,ptmxmode=000 0 0

This patch fixed the problem.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 fs/devpts/inode.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 21165cf..738ffdc 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -105,6 +105,9 @@ static int parse_mount_options(char *data, int op, struct pts_mount_opts *opts)
 	if (op == PARSE_MOUNT)
 		opts->newinstance = 0;
 
+	if (!data)
+		return 0;
+
 	while ((p = strsep(&data, ",")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
 		int token;
@@ -356,11 +359,10 @@ static int devpts_get_sb(struct file_system_type *fs_type,
 	struct super_block *s;
 
 	memset(&opts, 0, sizeof(opts));
-	if (data) {
-		error = parse_mount_options(data, PARSE_MOUNT, &opts);
-		if (error)
+
+	error = parse_mount_options(data, PARSE_MOUNT, &opts);
+	if (error)
 			return error;
-	}
 
 	if (opts.newinstance)
 		s = sget(fs_type, NULL, set_anon_super, NULL);
-- 
1.5.3.8




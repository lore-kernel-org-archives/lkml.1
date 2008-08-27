Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbYH0NwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbYH0NwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756472AbYH0NsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:48:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944AbYH0NsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:48:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/59] CRED: Wrap task credential accesses in the FAT
	filesystem
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 27 Aug 2008 14:47:56 +0100
Message-ID: <20080827134756.19980.73543.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/file.c  |    2 +-
 fs/fat/inode.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/fat/file.c b/fs/fat/file.c
index ddde370..81e2032 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -302,7 +302,7 @@ static int fat_allow_set_time(struct msdos_sb_info *sbi, struct inode *inode)
 {
 	mode_t allow_utime = sbi->options.allow_utime;
 
-	if (current->fsuid != inode->i_uid) {
+	if (current_fsuid() != inode->i_uid) {
 		if (in_group_p(inode->i_gid))
 			allow_utime >>= 3;
 		if (allow_utime & MAY_WRITE)
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 0fbf173..489a80b 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -921,8 +921,8 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 
 	opts->isvfat = is_vfat;
 
-	opts->fs_uid = current->uid;
-	opts->fs_gid = current->gid;
+	opts->fs_uid = current_uid();
+	opts->fs_gid = current_gid();
 	opts->fs_fmask = opts->fs_dmask = current->fs->umask;
 	opts->allow_utime = -1;
 	opts->codepage = fat_default_codepage;


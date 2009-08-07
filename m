Return-Path: <linux-kernel-owner+w=401wt.eu-S932987AbZHGS6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbZHGS6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932507AbZHGS6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:58:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56761 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932954AbZHGS6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:58:38 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@infradead.org, rlove@google.com,
       msb@google.com, viro@zeniv.linux.org.uk, hannes@cmpxchg.org
Subject: [PATCH 3/4] vfs: change sb->s_maxbytes to a loff_t
Date: Fri,  7 Aug 2009 14:57:40 -0400
Message-Id: <1249671461-9071-4-git-send-email-jlayton@redhat.com>
In-Reply-To: <1249671461-9071-1-git-send-email-jlayton@redhat.com>
References: <1249671461-9071-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sb->s_maxbytes is supposed to indicate the maximum size of a file that
can exist on the filesystem. It's declared as an unsigned long long.

Even if a filesystem has no inherent limit that prevents it from using
every bit in that unsigned long long, it's still problematic to set it
to anything larger than MAX_LFS_FILESIZE. A lot of places implicitly
cast s_maxbytes to a signed value when doing comparisons against it
(usually using loff_t on the other side of the comparison). If it's
set too large then this cast makes it a negative number and generally
breaks the comparison.

Change s_maxbytes to be loff_t instead. That should help eliminate the
temptation to set it too large by making it a signed value.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/super.c         |   10 ++++++++++
 include/linux/fs.h |    2 +-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 2761d3e..929d55d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -889,6 +889,16 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
  	if (error)
  		goto out_sb;
 
+	/*
+	 * filesystems should never set s_maxbytes larger than MAX_LFS_FILESIZE
+	 * but s_maxbytes was an unsigned long long for many releases. Throw
+	 * this warning for a little while to try and catch filesystems that
+	 * violate this rule. This warning can be removed in 2.6.34.
+	 */
+	WARN(((unsigned long long) mnt->mnt_sb->s_maxbytes > MAX_LFS_FILESIZE),
+		"WARNING: %s sets sb->s_maxbytes too large (%llu)", type->name,
+		(unsigned long long) mnt->mnt_sb->s_maxbytes);
+
 	mnt->mnt_mountpoint = mnt->mnt_root;
 	mnt->mnt_parent = mnt;
 	up_write(&mnt->mnt_sb->s_umount);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a36ffa5..25d9743 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1316,7 +1316,7 @@ struct super_block {
 	unsigned long		s_blocksize;
 	unsigned char		s_blocksize_bits;
 	unsigned char		s_dirt;
-	unsigned long long	s_maxbytes;	/* Max file size */
+	loff_t			s_maxbytes;	/* Max file size */
 	struct file_system_type	*s_type;
 	const struct super_operations	*s_op;
 	struct dquot_operations	*dq_op;
-- 
1.6.0.6


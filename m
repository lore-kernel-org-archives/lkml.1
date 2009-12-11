Return-Path: <linux-kernel-owner+w=401wt.eu-S1762450AbZLKEi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762450AbZLKEi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762387AbZLKEh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:37:29 -0500
Received: from kroah.org ([198.145.64.141]:37113 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762280AbZLKEgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:44 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:17 2009
Message-Id: <20091211042816.881920653@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Josef Bacik <josef@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [79/90] ext4: wait for log to commit when umounting
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0079-ext4-wait-for-log-to-commit-when-umounting.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit d4edac314e9ad0b21ba20ba8bc61b61f186f79e1)

There is a potential race when a transaction is committing right when
the file system is being umounting.  This could reduce in a race
because EXT4_SB(sb)->s_group_info could be freed in ext4_put_super
before the commit code calls a callback so the mballoc code can
release freed blocks in the transaction, resulting in a panic trying
to access the freed s_group_info.

The fix is to wait for the transaction to finish committing before we
shutdown the multiblock allocator.

Signed-off-by: Josef Bacik <josef@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/super.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -610,10 +610,6 @@ static void ext4_put_super(struct super_
 	if (sb->s_dirt)
 		ext4_commit_super(sb, 1);
 
-	ext4_release_system_zone(sb);
-	ext4_mb_release(sb);
-	ext4_ext_release(sb);
-	ext4_xattr_put_super(sb);
 	if (sbi->s_journal) {
 		err = jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
@@ -621,6 +617,12 @@ static void ext4_put_super(struct super_
 			ext4_abort(sb, __func__,
 				   "Couldn't clean up the journal");
 	}
+
+	ext4_release_system_zone(sb);
+	ext4_mb_release(sb);
+	ext4_ext_release(sb);
+	ext4_xattr_put_super(sb);
+
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);



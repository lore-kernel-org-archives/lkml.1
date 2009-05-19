Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZESEXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZESEXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 00:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbZESEXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 00:23:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56718 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZESEXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 00:23:08 -0400
Date: Tue, 19 May 2009 14:23:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the vfs tree with the ext4 tree
Message-Id: <20090519142306.8476809a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al, Ted,

Today's linux-next merge of the vfs tree got a conflict in
fs/ext4/super.c between commit cb0765fe4c3db8c9c22f1ed1017cbced2dd68150
("ext4: Add a comprehensive block validity check to ext4_get_blocks()")
from the ext4 tree and various commits from the vfs tree.

Just context changes.  I fixed it up (see below - please check as I am
not sure of the ordering constraints in the first hunk) and can carry the
fixup as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/super.c
index eca6c05,d789833..0000000
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@@ -568,7 -564,11 +569,12 @@@ static void ext4_put_super(struct super
  	struct ext4_super_block *es = sbi->s_es;
  	int i, err;
  
+ 	lock_super(sb);
+ 	lock_kernel();
+ 	if (sb->s_dirt)
+ 		ext4_write_super_locked(sb);
+ 
 +	ext4_release_system_zone(sb);
  	ext4_mb_release(sb);
  	ext4_ext_release(sb);
  	ext4_xattr_put_super(sb);
@@@ -3322,11 -3268,30 +3325,18 @@@ int ext4_force_commit(struct super_bloc
  	return ret;
  }
  
- static void ext4_write_super(struct super_block *sb)
 -/*
 - * Ext4 always journals updates to the superblock itself, so we don't
 - * have to propagate any other updates to the superblock on disk at this
 - * point.  (We can probably nuke this function altogether, and remove
 - * any mention to sb->s_dirt in all of fs/ext4; eventual cleanup...)
 - */
+ static void ext4_write_super_locked(struct super_block *sb)
  {
 -	if (EXT4_SB(sb)->s_journal) {
 -		if (mutex_trylock(&sb->s_lock) != 0)
 -			BUG();
 -		sb->s_dirt = 0;
 -	} else {
 -		ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);
 -	}
 +	ext4_commit_super(sb, 1);
  }
  
+ static void ext4_write_super(struct super_block *sb)
+ {
+ 	lock_super(sb);
+ 	ext4_write_super_locked(sb);
+ 	unlock_super(sb);
+ }
+ 
  static int ext4_sync_fs(struct super_block *sb, int wait)
  {
  	int ret = 0;

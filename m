Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbZAWBbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbZAWBbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760083AbZAWBPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:50 -0500
Received: from kroah.org ([198.145.64.141]:50953 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760294AbZAWBPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:15:24 -0500
Date: Thu, 22 Jan 2009 17:13:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Nick Piggin <npiggin@suse.de>
Subject: [patch 46/46] fs: sys_sync fix
Message-ID: <20090123011316.GU19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fs-sys_sync-fix.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit 856bf4d717feb8c55d4e2f817b71ebb70cfbc67b upstream.

s_syncing livelock avoidance was breaking data integrity guarantee of
sys_sync, by allowing sys_sync to skip writing or waiting for superblocks
if there is a concurrent sys_sync happening.

This livelock avoidance is much less important now that we don't have the
get_super_to_sync() call after every sb that we sync.  This was replaced
by __put_super_and_need_restart.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fs-writeback.c  |   20 +-------------------
 include/linux/fs.h |    1 -
 2 files changed, 1 insertion(+), 20 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -652,18 +652,6 @@ void sync_inodes_sb(struct super_block *
 	sync_sb_inodes(sb, &wbc);
 }
 
-/*
- * Rather lame livelock avoidance.
- */
-static void set_sb_syncing(int val)
-{
-	struct super_block *sb;
-	spin_lock(&sb_lock);
-	list_for_each_entry_reverse(sb, &super_blocks, s_list)
-		sb->s_syncing = val;
-	spin_unlock(&sb_lock);
-}
-
 /**
  * sync_inodes - writes all inodes to disk
  * @wait: wait for completion
@@ -690,9 +678,6 @@ static void __sync_inodes(int wait)
 	spin_lock(&sb_lock);
 restart:
 	list_for_each_entry(sb, &super_blocks, s_list) {
-		if (sb->s_syncing)
-			continue;
-		sb->s_syncing = 1;
 		sb->s_count++;
 		spin_unlock(&sb_lock);
 		down_read(&sb->s_umount);
@@ -710,13 +695,10 @@ restart:
 
 void sync_inodes(int wait)
 {
-	set_sb_syncing(0);
 	__sync_inodes(0);
 
-	if (wait) {
-		set_sb_syncing(0);
+	if (wait)
 		__sync_inodes(1);
-	}
 }
 
 /**
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1124,7 +1124,6 @@ struct super_block {
 	struct rw_semaphore	s_umount;
 	struct mutex		s_lock;
 	int			s_count;
-	int			s_syncing;
 	int			s_need_sync_fs;
 	atomic_t		s_active;
 #ifdef CONFIG_SECURITY


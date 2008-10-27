Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbYJ0Luh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbYJ0Luh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYJ0Lu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:50:27 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49702 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbYJ0Lu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:50:26 -0400
X-AuditID: 0ac90650-ac8ccba000006fc9-29-4905ab0010a3
Message-ID: <4905AAF2.8020302@hitachi.com>
Date: Mon, 27 Oct 2008 20:50:10 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Jan Kara <jack@ucw.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: [PATCH 2/2 take 2] ext4: fix a bug accessing freed memory in
    ext4_abort
References: <19f34abd0810250422t17990222x78fcf0fad2e6f04b@mail.gmail.com> 
    <49056D29.2010700@hitachi.com> <49056FA5.7070202@hitachi.com> 
    <20081027104325.GA13641@elte.hu> <4905A99F.8000605@hitachi.com>
In-Reply-To: <4905A99F.8000605@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum reported a bug which accesses freed memory (found via
kmemcheck).  When journal has been aborted, ext4_put_super() calls
ext4_abort() after freeing the journal_t object, and then ext4_abort()
accesses it.  This patch fix it.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6.28-rc2/fs/ext4/super.c
===================================================================
--- linux-2.6.28-rc2.orig/fs/ext4/super.c
+++ linux-2.6.28-rc2/fs/ext4/super.c
@@ -333,7 +333,8 @@ void ext4_abort(struct super_block *sb, 
 	EXT4_SB(sb)->s_mount_state |= EXT4_ERROR_FS;
 	sb->s_flags |= MS_RDONLY;
 	EXT4_SB(sb)->s_mount_opt |= EXT4_MOUNT_ABORT;
-	jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
+	if (EXT4_SB(sb)->s_journal)
+		jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
 }
 
 void ext4_warning(struct super_block *sb, const char *function,
@@ -442,14 +443,16 @@ static void ext4_put_super(struct super_
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
-	int i;
+	int i, err;
 
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
 	ext4_xattr_put_super(sb);
-	if (jbd2_journal_destroy(sbi->s_journal) < 0)
-		ext4_abort(sb, __func__, "Couldn't clean up the journal");
+	err = jbd2_journal_destroy(sbi->s_journal);
 	sbi->s_journal = NULL;
+	if (err < 0)
+		ext4_abort(sb, __func__, "Couldn't clean up the journal");
+
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);



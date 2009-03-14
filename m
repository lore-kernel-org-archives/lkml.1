Return-Path: <linux-kernel-owner+w=401wt.eu-S1762589AbZCNAtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762589AbZCNAtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbZCNAUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:20:12 -0400
Received: from kroah.org ([198.145.64.141]:35068 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753364AbZCNATs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:52 2009
Message-Id: <20090314000752.379159554@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:35 -0700
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
       alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
       Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>
Subject: [patch 87/96] Revert "ext4: wait on all pending commits in ext4_sync_fs()"
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=revert-ext4-wait-on-all-pending-commits-in-ext4_sync_fs.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

(cherry picked from commit 9eddacf9e9c03578ef2c07c9534423e823d677f8)

This undoes commit 14ce0cb411c88681ab8f3a4c9caa7f42e97a3184.

Since jbd2_journal_start_commit() is now fixed to return 1 when we
started a transaction commit, there's some transaction waiting to be
committed or there's a transaction already committing, we don't
need to call ext4_force_commit() in ext4_sync_fs(). Furthermore
ext4_force_commit() can unnecessarily create sync transaction which is
expensive so it's worthwhile to remove it when we can.

http://bugzilla.kernel.org/show_bug.cgi?id=12224

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2950,14 +2950,14 @@ static void ext4_write_super(struct supe
 
 static int ext4_sync_fs(struct super_block *sb, int wait)
 {
-	int ret = 0;
+	tid_t target;
 
 	sb->s_dirt = 0;
-	if (wait)
-		ret = ext4_force_commit(sb);
-	else
-		jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, NULL);
-	return ret;
+	if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target)) {
+		if (wait)
+			jbd2_log_wait_commit(EXT4_SB(sb)->s_journal, target);
+	}
+	return 0;
 }
 
 /*



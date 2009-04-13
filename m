Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZDMWKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZDMWKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbZDMWKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:10:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:37189 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZDMWKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=reDqWc48OXMd3cZaAN/nd1Tc1U/7DGCPEAssMpyXWSWs5qiH0wAYkf+/puyQJTzL/6
         Cw1tJuYgenOu1hMMIb5vXnSz+dNDe1NiM/XTGR5CrcWFi4jZXy+AvMaDKhb+FQ5d955k
         DPwM1GwQY6abFQPw5hoBGYkZaovHWSl0jZUNQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [PATCH] kill-the-BKL: fix unsafe j_flush_mutex lock
Date: Tue, 14 Apr 2009 00:10:35 +0200
Message-Id: <1239660635-12940-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix a deadlock

The j_flush_mutex is acquired safely in journal.c:
if we can't take it, we free the reiserfs per superblock lock
and wait a bit.

But we have a remaining place in kupdate_transactions() where
j_flush_mutex is still acquired traditionnaly. Thus the following
scenario (warned by lockdep) can happen:

A						B

mutex_lock(&write_lock)			mutex_lock(&write_lock)
	mutex_lock(&j_flush_mutex)	mutex_lock(&j_flush_mutex) //block
	mutex_unlock(&write_lock)
	sleep...
	mutex_lock(&write_lock) //deadlock

Fix this by using reiserfs_mutex_lock_safe() in kupdate_transactions().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/journal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 64dcabd..7976d7d 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -1826,7 +1826,7 @@ static int kupdate_transactions(struct super_block *s,
 	struct reiserfs_journal *journal = SB_JOURNAL(s);
 	chunk.nr = 0;
 
-	mutex_lock(&journal->j_flush_mutex);
+	reiserfs_mutex_lock_safe(&journal->j_flush_mutex, s);
 	if (!journal_list_still_alive(s, orig_trans_id)) {
 		goto done;
 	}
-- 
1.6.1


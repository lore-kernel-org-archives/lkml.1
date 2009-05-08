Return-Path: <linux-kernel-owner+w=401wt.eu-S1763880AbZEHSiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763880AbZEHSiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932108AbZEHSfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:35:40 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61221 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166AbZEHSfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=piHN3bX+2oU7SZDR5fDQS3jUT1hWXdRMem/Tf2g0dsXchnLE2IsNgonuG6xCNqm8b5
         +p7xPZaPfRE7phvHsKrXvwtnhardeQvgFhrBQhU7/WqJKKp+uE64UibPu2DjFv3HXGaW
         p7E5CL2dHZTQnnkcFj6S+vMAMhxFyEjxci//0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 7/7] kill-the-bkl/reiserfs: use mutex_lock in reiserfs_mutex_lock_safe
Date: Fri,  8 May 2009 20:35:24 +0200
Message-Id: <1241807725-6263-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241807725-6263-1-git-send-email-fweisbec@gmail.com>
References: <1241807725-6263-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reiserfs_mutex_lock_safe() is a hack to avoid any dependency between
an internal reiserfs mutex and the write lock, it has been proposed
to follow the old bkl logic.

The code does the following:

while (!mutex_trylock(m)) {
	reiserfs_write_unlock(s);
	schedule();
	reiserfs_write_lock(s);
}

It then imitate the implicit behaviour of the lock when it was
a Bkl and hadn't such dependency:

mutex_lock(m) {
	if (fastpath)
		let's go
	else {
		wait_for_mutex() {
			schedule() {
				unlock_kernel()
				reacquire_lock_kernel()
			}
		}
	}
}

The problem is that by using such explicit schedule(), we don't
benefit of the adaptive mutex spinning on owner.

The logic in use now is:

reiserfs_write_unlock(s);
mutex_lock(m); // -> possible adaptive spinning
reiserfs_write_lock(s);

[ Impact: restore the use of adaptive spinning mutexes in reiserfs ]

Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 fs/reiserfs/journal.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index b1ebd5a..3c3e00d 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -566,11 +566,9 @@ static inline void insert_journal_hash(struct reiserfs_journal_cnode **table,
 static inline void reiserfs_mutex_lock_safe(struct mutex *m,
 			       struct super_block *s)
 {
-	while (!mutex_trylock(m)) {
-		reiserfs_write_unlock(s);
-		schedule();
-		reiserfs_write_lock(s);
-	}
+	reiserfs_write_unlock(s);
+	mutex_lock(m);
+	reiserfs_write_lock(s);
 }
 
 /* lock the current transaction */
-- 
1.6.2.3


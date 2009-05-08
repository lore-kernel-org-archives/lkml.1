Return-Path: <linux-kernel-owner+w=401wt.eu-S1763498AbZEHSf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763498AbZEHSf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbZEHSfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:35:32 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61221 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbZEHSfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:35:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tgvEEWdAiPxCmO/vDExov7QyB4GbxMBmKQ4KtROLRQR3gmDN/BTGVjwEHTnPR5okmE
         PMTBOKZBkF0ELhrjlgce0HFb+uZXQ7AEYfeoFwM+AThRLoHzOj9qgvhK+9c4c+7+JDEg
         3mQTIo3M0bgsfVJwjpRa28xPMqKf6rbkJTyKI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 1/7] kill-the-BKL/reiserfs: add reiserfs_cond_resched()
Date: Fri,  8 May 2009 20:35:18 +0200
Message-Id: <1241807725-6263-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241807725-6263-1-git-send-email-fweisbec@gmail.com>
References: <1241807725-6263-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually, when we call cond_resched(), we want the write lock
to be released and then reacquired once we return from scheduling.
Not only does it follow the previous bkl based locking scheme, but
it also let other waiters to get the lock.

But if we aren't going to reschedule(), such as in !TIF_NEED_RESCHED
case, it's useless to release the lock. Worse, if we release and reacquire
the lock whereas it is not needed, we create useless contentions. Also
if someone takes the lock while we are modifying or reading the tree,
there are good chances we'll have to retry our operation, eg if the
block we were seeeking has moved.

So this patch introduces a helper which only unlock the write lock
if we are going to schedule.

[ Impact: prepare to inject less lock contention and less tree operation attempts ]

Reported-by: Andi Kleen <andi@firstfloor.org>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/reiserfs_fs.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 397d281..995bdf9 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -62,6 +62,19 @@ void reiserfs_write_unlock(struct super_block *s);
 int reiserfs_write_lock_once(struct super_block *s);
 void reiserfs_write_unlock_once(struct super_block *s, int lock_depth);
 
+/*
+ * When we schedule, we usually want to also release the write lock,
+ * according to the previous bkl based locking scheme of reiserfs.
+ */
+static inline void reiserfs_cond_resched(struct super_block *s)
+{
+	if (need_resched()) {
+		reiserfs_write_unlock(s);
+		schedule();
+		reiserfs_write_lock(s);
+	}
+}
+
 struct fid;
 
 /* in reading the #defines, it may help to understand that they employ
-- 
1.6.2.3


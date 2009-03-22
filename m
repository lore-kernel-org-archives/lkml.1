Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbZCVT1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbZCVT1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbZCVT0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:26:14 -0400
Received: from brick.kernel.dk ([93.163.65.50]:52576 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbZCVT0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:26:07 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de,
       hch@infradead.org, akpm@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 03/12] Get rid of pdflush_operation() in emergency sync and remount
Date: Sun, 22 Mar 2009 20:25:55 +0100
Message-Id: <1237749964-8343-4-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.12.g83676
In-Reply-To: <1237749964-8343-1-git-send-email-jens.axboe@oracle.com>
References: <1237749964-8343-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Opencode a cheasy approach with kevent. The idea here is that we'll
add some generic delayed work infrastructure, which probably wont be
based on pdflush (or maybe it will, in which case we can just add it
back).

This is in preparation for getting rid of pdflush completely.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/super.c |   11 +++++++++--
 fs/sync.c  |   14 +++++++++++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 6ce5014..dd4acb1 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -674,7 +674,7 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	return 0;
 }
 
-static void do_emergency_remount(unsigned long foo)
+static void do_emergency_remount(struct work_struct *work)
 {
 	struct super_block *sb;
 
@@ -697,12 +697,19 @@ static void do_emergency_remount(unsigned long foo)
 		spin_lock(&sb_lock);
 	}
 	spin_unlock(&sb_lock);
+	kfree(work);
 	printk("Emergency Remount complete\n");
 }
 
 void emergency_remount(void)
 {
-	pdflush_operation(do_emergency_remount, 0);
+	struct work_struct *work;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (work) {
+		INIT_WORK(work, do_emergency_remount);
+		schedule_work(work);
+	}
 }
 
 /*
diff --git a/fs/sync.c b/fs/sync.c
index a16d53e..ec95a69 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -42,9 +42,21 @@ SYSCALL_DEFINE0(sync)
 	return 0;
 }
 
+static void do_sync_work(struct work_struct *work)
+{
+	do_sync(0);
+	kfree(work);
+}
+
 void emergency_sync(void)
 {
-	pdflush_operation(do_sync, 0);
+	struct work_struct *work;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (work) {
+		INIT_WORK(work, do_sync_work);
+		schedule_work(work);
+	}
 }
 
 /*
-- 
1.6.2.12.g83676


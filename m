Return-Path: <linux-kernel-owner+w=401wt.eu-S933549AbZDHMGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbZDHMGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933403AbZDHMAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:00:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48890 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933390AbZDHMAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:00:19 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 01/13] buffer: switch do_emergency_thaw() away from pdflush_operation()
Date: Wed,  8 Apr 2009 14:00:04 +0200
Message-Id: <1239192016-19857-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.2.446.gfbdc0
In-Reply-To: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is (again) a preparatory patch similar to commit
a2a9537ac0b37a5da6fbe7e1e9cb06c524d2a9c4. It open codes a simple
async way of executing do_thaw_all() out of context, so we can get
rid of pdflush.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/buffer.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 6e35762..6a18802 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -547,7 +547,7 @@ repeat:
 	return err;
 }
 
-void do_thaw_all(unsigned long unused)
+void do_thaw_all(struct work_struct *work)
 {
 	struct super_block *sb;
 	char b[BDEVNAME_SIZE];
@@ -567,6 +567,7 @@ restart:
 			goto restart;
 	}
 	spin_unlock(&sb_lock);
+	kfree(work);
 	printk(KERN_WARNING "Emergency Thaw complete\n");
 }
 
@@ -577,7 +578,13 @@ restart:
  */
 void emergency_thaw_all(void)
 {
-	pdflush_operation(do_thaw_all, 0);
+	struct work_struct *work;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (work) {
+		INIT_WORK(work, do_thaw_all);
+		schedule_work(work);
+	}
 }
 
 /**
-- 
1.6.2.2.446.gfbdc0


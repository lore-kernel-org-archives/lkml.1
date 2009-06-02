Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZFBMLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZFBMLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 08:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbZFBMLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 08:11:39 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:48226 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZFBMLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:11:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Igg3e+zZYx48K/+Bpp3xsEZczp4ODeW/PH/MSimFT8uz2Wz1Enz2ALpK0EcYgsKjxB
         xBed9REQ2+OQtQkdKpCwkt65Y7/aY9/qpRzBnp3l7OQzu+YRqwqXpTnXxHG6Vr6ELdiX
         hm4pNy4dcBkMNwd/RJIVhpsp2hepSeRdbj6C0=
From: Gerard Lledo <gerard.lledo@gmail.com>
To: akpm@linux-foundation.org
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Gerard Lledo <gerard.lledo@gmail.com>
Subject: [PATCH] [JFFS2] jffs2_start_garbage_collect_thread() return value cleanup
Date: Tue,  2 Jun 2009 15:11:26 +0300
Message-Id: <1243944686-7039-2-git-send-email-gerard.lledo@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1243944686-7039-1-git-send-email-gerard.lledo@gmail.com>
References: <20090602113216.GA3513@tank>
 <1243944686-7039-1-git-send-email-gerard.lledo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no user of this return value in the kernel.  Change it to return void
instead.
---
 fs/jffs2/background.c |    7 +------
 fs/jffs2/os-linux.h   |    2 +-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/jffs2/background.c b/fs/jffs2/background.c
index 3ff50da..3ae7e5c 100644
--- a/fs/jffs2/background.c
+++ b/fs/jffs2/background.c
@@ -30,10 +30,9 @@ void jffs2_garbage_collect_trigger(struct jffs2_sb_info *c)
 }
 
 /* This must only ever be called when no GC thread is currently running */
-int jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c)
+void jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c)
 {
 	struct task_struct *tsk;
-	int ret = 0;
 
 	BUG_ON(c->gc_task);
 
@@ -44,15 +43,11 @@ int jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c)
 	if (IS_ERR(tsk)) {
 		printk(KERN_WARNING "fork failed for JFFS2 garbage collect thread: %ld\n", -PTR_ERR(tsk));
 		complete(&c->gc_thread_exit);
-		ret = PTR_ERR(tsk);
 	} else {
 		/* Wait for it... */
 		D1(printk(KERN_DEBUG "JFFS2: Garbage collect thread is pid %d\n", tsk->pid));
 		wait_for_completion(&c->gc_thread_start);
-		ret = tsk->pid;
 	}
-
-	return ret;
 }
 
 void jffs2_stop_garbage_collect_thread(struct jffs2_sb_info *c)
diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
index 2228380..f3184ac 100644
--- a/fs/jffs2/os-linux.h
+++ b/fs/jffs2/os-linux.h
@@ -151,7 +151,7 @@ static inline void jffs2_erase_pending_trigger(struct jffs2_sb_info *c)
 }
 
 /* background.c */
-int jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c);
+void jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c);
 void jffs2_stop_garbage_collect_thread(struct jffs2_sb_info *c);
 void jffs2_garbage_collect_trigger(struct jffs2_sb_info *c);
 
-- 
1.5.6.5


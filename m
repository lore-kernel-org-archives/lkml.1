Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZICBlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZICBlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 21:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZICBlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 21:41:10 -0400
Received: from mail.atheros.com ([12.36.123.2]:53914 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbZICBlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 21:41:00 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <catalin.marinas@arm.com>
CC: <linux-kernel@vger.kernel.org>, <penberg@cs.helsinki.fi>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/5] kmemleak: add clear command support
Date: Wed, 2 Sep 2009 18:40:56 -0700
Message-ID: <1251942059-21448-3-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251942059-21448-1-git-send-email-lrodriguez@atheros.com>
References: <1251942059-21448-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In an ideal world your kmemleak output will be small,
when its not you can use the clear command to ingore previously
annotated kmemleak objects. We do this by painting them black.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 mm/kmemleak.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index c6e71bb..4840212 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1294,6 +1294,26 @@ static int kmemleak_release(struct inode *inode, struct file *file)
 	return seq_release(inode, file);
 }
 
+static void kmemleak_clear(void)
+{
+	struct kmemleak_object *object;
+	unsigned long flags;
+
+	mutex_lock(&scan_mutex);
+	stop_scan_thread();
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(object, &object_list, object_list) {
+		spin_lock_irqsave(&object->lock, flags);
+		object->min_count = -1;
+		spin_unlock_irqrestore(&object->lock, flags);
+	}
+	rcu_read_unlock();
+	mutex_unlock(&scan_mutex);
+
+	start_scan_thread();
+}
+
 /*
  * File write operation to configure kmemleak at run-time. The following
  * commands can be written to the /sys/kernel/debug/kmemleak file:
@@ -1324,6 +1344,8 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
 
 	if (strncmp(buf, "off", 3) == 0)
 		kmemleak_disable();
+	else if (strncmp(buf, "clear", 8) == 0)
+		kmemleak_clear();
 	else if (strncmp(buf, "stack=on", 8) == 0)
 		kmemleak_stack_scan = 1;
 	else if (strncmp(buf, "stack=off", 9) == 0)
-- 
1.6.3.3


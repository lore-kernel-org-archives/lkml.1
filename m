Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbYHDWsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbYHDWsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYHDWsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:48:05 -0400
Received: from mail.atheros.com ([12.36.123.2]:45853 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbYHDWsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:48:04 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linville@tuxdriver.com>,
       <torvalds@linux-foundation.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       <linux-wireless@vger.kernel.org>, <ath9k-devel@venema.h4ckr.net>
Subject: [PATCH 1/4] list.h: Add list_splice_tail() and list_splice_tail_init()
Date: Mon, 4 Aug 2008 15:48:00 -0700
Message-ID: <1217890080-12073-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.5.6.rc2.15.g457bb.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you are using linked lists for queues list_splice() will not do what
you would expect even if you use the elements passed reversed. We need
to handle these differently. We add list_splice_tail() and
list_splice_tail_init()

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/list.h |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 453916b..594f67c 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -229,7 +229,7 @@ static inline void __list_splice(const struct list_head *list,
 }
 
 /**
- * list_splice - join two lists
+ * list_splice - join two lists, this is designed for stacks
  * @list: the new list to add.
  * @head: the place to add it in the first list.
  */
@@ -256,6 +256,49 @@ static inline void list_splice_init(struct list_head *list,
 	}
 }
 
+static inline void __list_splice_tail(const struct list_head *list,
+				 struct list_head *head)
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+	struct list_head *current_tail = head->prev;
+
+	current_tail->next = first;
+	last->next = head;
+	head->prev = last;
+	first->prev = current_tail;
+}
+
+/**
+ * list_splice_tail - join two lists, each list being a queue
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ */
+static inline void list_splice_tail(const struct list_head *list,
+				struct list_head *head)
+{
+	if (!list_empty(list))
+		__list_splice_tail(list, head);
+}
+
+/**
+ * list_splice_tail_init - join two lists, each list being a queue, and
+ * 	reinitialise the emptied list.
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ *
+ * The list at @list is reinitialised
+ */
+static inline void list_splice_tail_init(struct list_head *list,
+				    struct list_head *head)
+{
+	if (!list_empty(list)) {
+		__list_splice_tail(list, head);
+		INIT_LIST_HEAD(list);
+	}
+}
+
+
 /**
  * list_entry - get the struct for this entry
  * @ptr:	the &struct list_head pointer.
-- 
1.5.6.rc2.15.g457bb.dirty


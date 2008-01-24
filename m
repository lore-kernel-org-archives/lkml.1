Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYAXEU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYAXEU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 23:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYAXEUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 23:20:48 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35039 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbYAXEUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 23:20:47 -0500
Date: Thu, 24 Jan 2008 13:20:12 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 2/8] mem_notify v5: introduce wake_up_locked_nr() new API
Cc: kosaki.motohiro@jp.fujitsu.com, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080124130348.1760.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080124130348.1760.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080124131927.1766.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


introduce new API wake_up_locked_nr() and wake_up_locked_all().
it it similar as wake_up_nr() and wake_up_all(), but it doesn't lock.

Signed-off-by: Marcelo Tosatti <marcelo@kvack.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 include/linux/wait.h |    7 +++++--
 kernel/sched.c       |    5 +++--
 2 files changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6.24-rc6-mm1-memnotify/include/linux/wait.h
===================================================================
--- linux-2.6.24-rc6-mm1-memnotify.orig/include/linux/wait.h	2008-01-17 18:28:33.000000000 +0900
+++ linux-2.6.24-rc6-mm1-memnotify/include/linux/wait.h	2008-01-17 18:56:16.000000000 +0900
@@ -142,7 +142,7 @@ static inline void __remove_wait_queue(w
 }
 
 void FASTCALL(__wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key));
-extern void FASTCALL(__wake_up_locked(wait_queue_head_t *q, unsigned int mode));
+void FASTCALL(__wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr, void *key));
 extern void FASTCALL(__wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr));
 void FASTCALL(__wake_up_bit(wait_queue_head_t *, void *, int));
 int FASTCALL(__wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned));
@@ -155,7 +155,10 @@ wait_queue_head_t *FASTCALL(bit_waitqueu
 #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
 #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
 #define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
-#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL)
+
+#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL, 1, NULL)
+#define wake_up_locked_nr(x, nr)	__wake_up_locked((x), TASK_NORMAL, nr, NULL)
+#define wake_up_locked_all(x)		__wake_up_locked((x), TASK_NORMAL, 0, NULL)
 
 #define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
 #define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
Index: linux-2.6.24-rc6-mm1-memnotify/kernel/sched.c
===================================================================
--- linux-2.6.24-rc6-mm1-memnotify.orig/kernel/sched.c	2008-01-17 18:31:12.000000000 +0900
+++ linux-2.6.24-rc6-mm1-memnotify/kernel/sched.c	2008-01-17 18:56:16.000000000 +0900
@@ -3837,9 +3837,10 @@ EXPORT_SYMBOL(__wake_up);
 /*
  * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
  */
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode,
+		      int nr_exclusive, void *key)
 {
-	__wake_up_common(q, mode, 1, 0, NULL);
+	__wake_up_common(q, mode, nr_exclusive, 0, key);
 }
 
 /**



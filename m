Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbYBIPWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbYBIPWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYBIPV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:21:59 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:35240 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYBIPV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:21:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=EZs4/+BD9YzXZALkN9MmryWunVxO8EFvvsgxvG9kHq8xSY6SFTQAkeJM2P3cr05TvIbgvuLWEHjTQ6RpNJihFGra45mjFvbLLt4ejr29k428AkXY/jWzTfu2+6isxMi+/FUT4itQGXr2H6aBYBjAf+0XG5wDI5cvYTXzbDVBgb0=
Message-ID: <2f11576a0802090721l5cd8c89bx7814b2848b419057@mail.gmail.com>
Date: Sun, 10 Feb 2008 00:21:56 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8][for -mm] mem_notify v6: introduce wake_up_locked_nr() new API
Cc: kosaki.motohiro@jp.fujitsu.com, "Marcelo Tosatti" <marcelo@kvack.org>,
       "Daniel Spang" <daniel.spang@gmail.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-fsdevel@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>, "Al Boldi" <a1426z@gawab.com>,
       "Jon Masters" <jonathan@jonmasters.org>, "Zan Lynx" <zlynx@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 8f147955073ebcb8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

introduce new API wake_up_locked_nr() and wake_up_locked_all().
it it similar as wake_up_nr() and wake_up_all(), but it doesn't lock.

Signed-off-by: Marcelo Tosatti <marcelo@kvack.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 include/linux/wait.h |   12 ++++++++----
 kernel/sched.c       |    5 +++--
 2 files changed, 11 insertions(+), 6 deletions(-)

Index: b/include/linux/wait.h
===================================================================
--- a/include/linux/wait.h	2008-02-03 20:27:54.000000000 +0900
+++ b/include/linux/wait.h	2008-02-03 20:32:12.000000000 +0900
@@ -142,7 +142,8 @@ static inline void __remove_wait_queue(w
 }

 void FASTCALL(__wake_up(wait_queue_head_t *q, unsigned int mode, int
nr, void *key));
-extern void FASTCALL(__wake_up_locked(wait_queue_head_t *q, unsigned
int mode));
+void FASTCALL(__wake_up_locked(wait_queue_head_t *q, unsigned int mode,
+			       int nr, void *key));
 extern void FASTCALL(__wake_up_sync(wait_queue_head_t *q, unsigned
int mode, int nr));
 void FASTCALL(__wake_up_bit(wait_queue_head_t *, void *, int));
 int FASTCALL(__wait_on_bit(wait_queue_head_t *, struct wait_bit_queue
*, int (*)(void *), unsigned));
@@ -155,10 +156,13 @@ wait_queue_head_t *FASTCALL(bit_waitqueu
 #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
 #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
 #define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
-#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL)

-#define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
-#define wake_up_interruptible_nr(x, nr)	__wake_up(x,
TASK_INTERRUPTIBLE, nr, NULL)
+#define wake_up_locked(x)	        __wake_up_locked((x), TASK_NORMAL, 1, NULL)
+#define wake_up_locked_nr(x, nr)        __wake_up_locked((x),
TASK_NORMAL, nr, NULL)
+#define wake_up_locked_all(x)	        __wake_up_locked((x),
TASK_NORMAL, 0, NULL)
+
+#define wake_up_interruptible(x) 	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
+#define wake_up_interruptible_nr(x, nr) __wake_up(x,
TASK_INTERRUPTIBLE, nr, NULL)
 #define wake_up_interruptible_all(x)	__wake_up(x, TASK_INTERRUPTIBLE, 0, NULL)
 #define wake_up_interruptible_sync(x)	__wake_up_sync((x),
TASK_INTERRUPTIBLE, 1)

Index: b/kernel/sched.c
===================================================================
--- a/kernel/sched.c	2008-02-03 20:27:54.000000000 +0900
+++ b/kernel/sched.c	2008-02-03 20:29:09.000000000 +0900
@@ -4115,9 +4115,10 @@ EXPORT_SYMBOL(__wake_up);
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

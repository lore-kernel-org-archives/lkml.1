Return-Path: <linux-kernel-owner+w=401wt.eu-S1758989AbYDUDhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbYDUDhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 23:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYDUDhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 23:37:31 -0400
Received: from ozlabs.org ([203.10.76.45]:57588 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbYDUDha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 23:37:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] typesafe: TIMER_INITIALIZER and setup_timer
Date: Mon, 21 Apr 2008 09:10:10 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200804210859.00080.rusty@rustcorp.com.au> <200804210907.44606.rusty@rustcorp.com.au> <200804210909.23232.rusty@rustcorp.com.au>
In-Reply-To: <200804210909.23232.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804210910.10512.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lets timer callback functions have their natural type
(ie. exactly match the data pointer type); it allows the old "unsigned
long data" type as well.

Downside: if you use the old "unsigned long" callback type, you won't
get a warning if your data is not an unsigned long, due to the cast.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/timer.h |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -r 1a72bd2d9ea6 include/linux/timer.h
--- a/include/linux/timer.h	Mon Apr 21 07:04:32 2008 +1000
+++ b/include/linux/timer.h	Mon Apr 21 07:28:46 2008 +1000
@@ -24,11 +24,21 @@ struct timer_list {
 
 extern struct tvec_base boot_tvec_bases;
 
-#define TIMER_INITIALIZER(_function, _expires, _data) {		\
-		.function = (_function),			\
-		.expires = (_expires),				\
-		.data = (_data),				\
-		.base = &boot_tvec_bases,			\
+/*
+ * For historic reasons the timer function takes an unsigned long, so
+ * we use this variant of typesafe_cb.  data is converted to an unsigned long
+ * if it is another integer type, by adding 0UL.
+ */
+#define typesafe_timerfn(fn, data)				\
+	__typesafe_cb(void (*)(unsigned long), (fn),		\
+		      void (*)(const typeof((data)+0UL)),	\
+		      void (*)(typeof((data)+0UL)))
+
+#define TIMER_INITIALIZER(_function, _expires, _data) {			\
+		.function = typesafe_timerfn((_function), (_data)),	\
+		.expires = (_expires),					\
+		.data = (unsigned long)(_data),				\
+		.base = &boot_tvec_bases,				\
 	}
 
 #define DEFINE_TIMER(_name, _function, _expires, _data)		\
@@ -38,9 +48,13 @@ void init_timer(struct timer_list *timer
 void init_timer(struct timer_list *timer);
 void init_timer_deferrable(struct timer_list *timer);
 
-static inline void setup_timer(struct timer_list * timer,
-				void (*function)(unsigned long),
-				unsigned long data)
+#define setup_timer(timer, function, data)				\
+	__setup_timer((timer), typesafe_timerfn((function), (data)),	\
+		      (unsigned long)(data))
+
+static inline void __setup_timer(struct timer_list * timer,
+				 void (*function)(unsigned long),
+				 unsigned long data)
 {
 	timer->function = function;
 	timer->data = data;

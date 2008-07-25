Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbYGYCTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbYGYCTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 22:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYGYCTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 22:19:04 -0400
Received: from ozlabs.org ([203.10.76.45]:41768 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbYGYCTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 22:19:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/4] typesafe: TIMER_INITIALIZER and setup_timer
Date: Fri, 25 Jul 2008 12:19:01 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Harvey Harrison <harvey.harrison@gmail.com>
References: <200807251213.17773.rusty@rustcorp.com.au> <200807251216.12139.rusty@rustcorp.com.au> <200807251217.41875.rusty@rustcorp.com.au>
In-Reply-To: <200807251217.41875.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807251219.01448.rusty@rustcorp.com.au>
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
 include/linux/timer.h |   32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff -r 138795de70da include/linux/timer.h
--- a/include/linux/timer.h	Thu May 01 21:03:51 2008 +1000
+++ b/include/linux/timer.h	Thu May 01 21:05:13 2008 +1000
@@ -25,12 +25,22 @@ struct timer_list {
 
 extern struct tvec_base boot_tvec_bases;
 
-#define TIMER_INITIALIZER(_function, _expires, _data) {		\
-		.entry = { .prev = TIMER_ENTRY_STATIC },	\
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
+		.entry = { .prev = TIMER_ENTRY_STATIC },		\
+		.function = typesafe_timerfn((_function), (_data)),	\
+		.expires = (_expires),					\
+		.data = (unsigned long)(_data),				\
+		.base = &boot_tvec_bases,				\
 	}
 
 #define DEFINE_TIMER(_name, _function, _expires, _data)		\
@@ -51,9 +61,13 @@ static inline void init_timer_on_stack(s
 }
 #endif
 
-static inline void setup_timer(struct timer_list * timer,
-				void (*function)(unsigned long),
-				unsigned long data)
+#define setup_timer(timer, function, data)				\
+	__setup_timer((timer), typesafe_timerfn((function), (data)),	\
+		      (unsigned long)(data))
+
+static inline void __setup_timer(struct timer_list *timer,
+				 void (*function)(unsigned long),
+				 unsigned long data)
 {
 	timer->function = function;
 	timer->data = data;

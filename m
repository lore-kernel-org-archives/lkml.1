Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYBDMUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYBDMUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYBDMUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:20:01 -0500
Received: from ozlabs.org ([203.10.76.45]:53330 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbYBDMUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:20:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5/5] typesafe: TIMER_INITIALIZER and setup_timer
Date: Mon, 4 Feb 2008 23:19:44 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
References: <200802042311.18762.rusty@rustcorp.com.au> <200802042317.29130.rusty@rustcorp.com.au> <200802042318.33503.rusty@rustcorp.com.au>
In-Reply-To: <200802042318.33503.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802042319.44929.rusty@rustcorp.com.au>
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

diff -r c53eb02af893 include/linux/timer.h
--- a/include/linux/timer.h	Thu Jan 31 17:27:22 2008 +1100
+++ b/include/linux/timer.h	Thu Jan 31 17:27:39 2008 +1100
@@ -24,11 +24,13 @@ struct timer_list {
 
 extern struct tvec_base boot_tvec_bases;
 
-#define TIMER_INITIALIZER(_function, _expires, _data) {		\
-		.function = (_function),			\
-		.expires = (_expires),				\
-		.data = (_data),				\
-		.base = &boot_tvec_bases,			\
+
+#define TIMER_INITIALIZER(_function, _expires, _data) {			\
+		.function = cast_if_type(_function, void (*)(typeof(_data)), \
+					 void (*)(unsigned long)),	\
+		.expires = (_expires),					\
+		.data = (unsigned long)(_data),				\
+		.base = &boot_tvec_bases,				\
 	}
 
 #define DEFINE_TIMER(_name, _function, _expires, _data)		\
@@ -38,9 +40,15 @@ void fastcall init_timer(struct timer_li
 void fastcall init_timer(struct timer_list * timer);
 void fastcall init_timer_deferrable(struct timer_list *timer);
 
-static inline void setup_timer(struct timer_list * timer,
-				void (*function)(unsigned long),
-				unsigned long data)
+#define setup_timer(timer, function, data)				\
+	__setup_timer((timer),						\
+		      cast_if_type(function, void (*)(typeof(data)),	\
+				   void (*)(unsigned long)),		\
+		      (unsigned long)(data))
+
+static inline void __setup_timer(struct timer_list * timer,
+				 void (*function)(unsigned long),
+				 unsigned long data)
 {
 	timer->function = function;
 	timer->data = data;

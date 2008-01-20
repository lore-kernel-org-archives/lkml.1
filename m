Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbYATJ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbYATJ6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 04:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYATJ6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 04:58:31 -0500
Received: from ozlabs.org ([203.10.76.45]:35299 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbYATJ6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 04:58:30 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6/6] typesafe: timers
Date: Sun, 20 Jan 2008 20:57:53 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
References: <200801202046.14746.rusty@rustcorp.com.au> <200801202051.42958.rusty@rustcorp.com.au> <200801202054.03484.rusty@rustcorp.com.au>
In-Reply-To: <200801202054.03484.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801202057.53304.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lets timer callback functions have their natural type
(ie. exactly match the data pointer type); it allows the old "unsigned
long data" type as well.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 142a2cf4a8dc include/linux/timer.h
--- a/include/linux/timer.h	Sun Jan 20 19:01:56 2008 +1100
+++ b/include/linux/timer.h	Sun Jan 20 19:36:33 2008 +1100
@@ -24,11 +24,13 @@ struct timer_list {
 
 extern struct tvec_t_base_s boot_tvec_bases;
 
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

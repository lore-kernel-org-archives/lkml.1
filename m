Return-Path: <linux-kernel-owner+w=401wt.eu-S932097AbXBKTWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbXBKTWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932099AbXBKTWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:22:54 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:64196 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097AbXBKTWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:22:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH 03/10] atomic.h : i386 type safety fix
Date: Sun, 11 Feb 2007 14:17:41 -0500
Message-Id: <11712214681364-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

atomic.h : i386 type safety fix

This patch removes an explicit cast to an integer type for the result returned
by cmpxchg. It is not per se a problem on the i386 architecture, because
sizeof(int) == sizeof(long), but whenever this code is cut'n'pasted to a
different architecture (which happened at least for x86_64), it would simply
accept passing an atomic64_t value as parameter to cmpxchg, xchg and
add_unless, having 64 bits inputs casted to 32 bits.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-i386/atomic.h
+++ b/include/asm-i386/atomic.h
@@ -207,8 +207,8 @@ static __inline__ int atomic_sub_return(int i, atomic_t *v)
 	return atomic_add_return(-i,v);
 }
 
-#define atomic_cmpxchg(v, old, new) ((int)cmpxchg(&((v)->counter), old, new))
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+#define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), (old), (new)))
+#define atomic_xchg(v, new) (xchg(&((v)->counter), (new)))
 
 /**
  * atomic_add_unless - add unless the number is a given value
@@ -221,7 +221,7 @@ static __inline__ int atomic_sub_return(int i, atomic_t *v)
  */
 #define atomic_add_unless(v, a, u)				\
 ({								\
-	int c, old;						\
+	__typeof__((v)->counter) c, old;			\
 	c = atomic_read(v);					\
 	for (;;) {						\
 		if (unlikely(c == (u)))				\

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYHPHji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYHPHji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 03:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYHPHj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 03:39:29 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:40745 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751592AbYHPHj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 03:39:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEANsapkhMRKxB/2dsb2JhbACBYrEggVg
Date: Sat, 16 Aug 2008 03:39:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64 : support atomic ops with 64 bits integer values
Message-ID: <20080816073926.GA19546@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 03:33:59 up 72 days, 12:14,  5 users,  load average: 0.60, 0.43,
	0.28
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 add/sub atomic ops does not seems to accept integer values bigger
than 32 bits as immediates. Intel's add/sub documentation specifies they
have to be passed as registers.

http://gcc.gnu.org/onlinedocs/gcc-4.3.0/gcc/Machine-Constraints.html#Machine-Constraints

states :

e
    32-bit signed integer constant, or a symbolic reference known to fit that range (for immediate operands in sign-extending x86-64 instructions).
Z
    32-bit unsigned integer constant, or a symbolic reference known to fit that range (for immediate operands in zero-extending x86-64 instructions). 

Since add/sub does sign extension, using the "e" constraint seems appropriate.

It applies to 2.6.27-rc, 2.6.26, 2.6.25...

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Joe Perches <joe@perches.com>
---
 include/asm-x86/atomic_64.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/include/asm-x86/atomic_64.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/atomic_64.h	2008-08-16 03:19:35.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86/atomic_64.h	2008-08-16 03:21:18.000000000 -0400
@@ -228,7 +228,7 @@ static inline void atomic64_add(long i, 
 {
 	asm volatile(LOCK_PREFIX "addq %1,%0"
 		     : "=m" (v->counter)
-		     : "ir" (i), "m" (v->counter));
+		     : "er" (i), "m" (v->counter));
 }
 
 /**
@@ -242,7 +242,7 @@ static inline void atomic64_sub(long i, 
 {
 	asm volatile(LOCK_PREFIX "subq %1,%0"
 		     : "=m" (v->counter)
-		     : "ir" (i), "m" (v->counter));
+		     : "er" (i), "m" (v->counter));
 }
 
 /**
@@ -260,7 +260,7 @@ static inline int atomic64_sub_and_test(
 
 	asm volatile(LOCK_PREFIX "subq %2,%0; sete %1"
 		     : "=m" (v->counter), "=qm" (c)
-		     : "ir" (i), "m" (v->counter) : "memory");
+	  	     : "er" (i), "m" (v->counter) : "memory");
 	return c;
 }
 
@@ -341,7 +341,7 @@ static inline int atomic64_add_negative(
 
 	asm volatile(LOCK_PREFIX "addq %2,%0; sets %1"
 		     : "=m" (v->counter), "=qm" (c)
-		     : "ir" (i), "m" (v->counter) : "memory");
+		     : "er" (i), "m" (v->counter) : "memory");
 	return c;
 }
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

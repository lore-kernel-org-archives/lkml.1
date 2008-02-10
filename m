Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbYBJP2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbYBJP2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 10:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYBJP2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 10:28:43 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:36074 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751368AbYBJP2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 10:28:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswMABinrkdMQWYq/2dsb2JhbACBWY9DlR2BdA
Date: Sun, 10 Feb 2008 10:28:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org
Subject: [PATCH] Cast cmpxchg and cmpxchg_local result for 386 and 486
Message-ID: <20080210152839.GA15138@Krystal>
References: <19f34abd0802090913w64773c44qb44a1d338cc10b4f@mail.gmail.com> <Pine.LNX.4.64.0802091620440.13328@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802091620440.13328@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:25:00 up 98 days, 20:30,  3 users,  load average: 1.13, 0.81,
	0.96
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum <vegard.nossum@gmail.com> :
> Hi,
>
> I get these warnings when compiling mm/slub.c in linux-2.6.git:
>
> mm/slub.c: In function 'slab_alloc':
> mm/slub.c:1637: warning: assignment makes pointer from integer without a cast
> mm/slub.c:1637: warning: assignment makes pointer from integer without a cast
> mm/slub.c: In function 'slab_free':
> mm/slub.c:1796: warning: assignment makes pointer from integer without a cast
> mm/slub.c:1796: warning: assignment makes pointer from integer without a cast
>
> The actual lines are calls to cmpxchg_local(). This is probably
> because I'm compiling with M386. I'm guessing the source of the
> warnings is in include/asm-x86/cmpxchg_32.h, lines 283 and 286. Config
> attached.

Christoph Lameter <clameter@sgi.com>
Hmmm.. That cmpxchg local needs to be fixed? Mathieu?

Yes, a cast is needed in the 386 and 486 code because the type is a pointer. In
every other integer case the original cmpxchg code (and the cmpxchg_local which
has been copied from it) worked fine, but since we touch a pointer, the type
needs to be casted in the cmpxchg_local and cmpxchg macros.

The more recent code (586+) does not have this problem (the cast is already
there).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Lameter <clameter@sgi.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org
---
 include/asm-x86/cmpxchg_32.h |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

Index: linux-2.6-lttng/include/asm-x86/cmpxchg_32.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86/cmpxchg_32.h	2008-02-10 06:26:50.000000000 -0500
+++ linux-2.6-lttng/include/asm-x86/cmpxchg_32.h	2008-02-10 06:41:43.000000000 -0500
@@ -269,22 +269,26 @@
 ({									\
 	__typeof__(*(ptr)) __ret;					\
 	if (likely(boot_cpu_data.x86 > 3))				\
-		__ret = __cmpxchg((ptr), (unsigned long)(o),		\
-					(unsigned long)(n), sizeof(*(ptr))); \
+		__ret = (__typeof__(*(ptr)))__cmpxchg((ptr),		\
+				(unsigned long)(o), (unsigned long)(n),	\
+				sizeof(*(ptr)));			\
 	else								\
-		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
-					(unsigned long)(n), sizeof(*(ptr))); \
+		__ret = (__typeof__(*(ptr)))cmpxchg_386((ptr),		\
+				(unsigned long)(o), (unsigned long)(n),	\
+				sizeof(*(ptr)));			\
 	__ret;								\
 })
 #define cmpxchg_local(ptr, o, n)					\
 ({									\
 	__typeof__(*(ptr)) __ret;					\
 	if (likely(boot_cpu_data.x86 > 3))				\
-		__ret = __cmpxchg_local((ptr), (unsigned long)(o),	\
-					(unsigned long)(n), sizeof(*(ptr))); \
+		__ret = (__typeof__(*(ptr)))__cmpxchg_local((ptr),	\
+				(unsigned long)(o), (unsigned long)(n),	\
+				sizeof(*(ptr)));			\
 	else								\
-		__ret = cmpxchg_386((ptr), (unsigned long)(o),		\
-					(unsigned long)(n), sizeof(*(ptr))); \
+		__ret = (__typeof__(*(ptr)))cmpxchg_386((ptr),		\
+				(unsigned long)(o), (unsigned long)(n),	\
+				sizeof(*(ptr)));			\
 	__ret;								\
 })
 #endif
@@ -301,10 +305,12 @@
 ({									\
 	__typeof__(*(ptr)) __ret;					\
 	if (likely(boot_cpu_data.x86 > 4))				\
-		__ret = __cmpxchg64((ptr), (unsigned long long)(o),	\
+		__ret = __typeof__(*(ptr))__cmpxchg64((ptr),		\
+				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	else								\
-		__ret = cmpxchg_486_u64((ptr), (unsigned long long)(o),	\
+		__ret = __typeof__(*(ptr))cmpxchg_486_u64((ptr),	\
+				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	__ret;								\
 })
@@ -312,10 +318,12 @@
 ({									\
 	__typeof__(*(ptr)) __ret;					\
 	if (likely(boot_cpu_data.x86 > 4))				\
-		__ret = __cmpxchg64_local((ptr), (unsigned long long)(o), \
+		__ret = __typeof__(*(ptr))__cmpxchg64_local((ptr),	\
+				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	else								\
-		__ret = cmpxchg_486_u64((ptr), (unsigned long long)(o),	\
+		__ret = __typeof__(*(ptr))cmpxchg_486_u64((ptr),	\
+				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	__ret;								\
 })
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

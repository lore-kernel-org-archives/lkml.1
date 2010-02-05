Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab0BEOi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:38:26 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:37588 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589Ab0BEOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:37:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QgzRXMZ1iwL9siL9CKgtRH6SE1HHZ4GonI3T7qkUqD1PrNhqOGkVghZfp7S8VRgLNw
         o69Xo8F8NY3ej7gmf3OuOO4zPz8OReJyUvi5Jb6JDc3+O9MqgMOQ56qR5vlmfByOkLOO
         tkfKk8mkEY9Fb+qhQ644akHDKoV4IU33gVjBo=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] x86-64: Use BUILDIO in io_64.h
Date: Fri,  5 Feb 2010 09:37:06 -0500
Message-Id: <1265380629-3212-5-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265380629-3212-1-git-send-email-brgerst@gmail.com>
References: <1265380629-3212-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copied from io_32.h.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/io_64.h |  112 ++++++++++++++----------------------------
 1 files changed, 37 insertions(+), 75 deletions(-)

diff --git a/arch/x86/include/asm/io_64.h b/arch/x86/include/asm/io_64.h
index 040bf74..4a94aef 100644
--- a/arch/x86/include/asm/io_64.h
+++ b/arch/x86/include/asm/io_64.h
@@ -104,86 +104,48 @@ static inline void slow_down_io(void)
 
 #endif
 
-/*
- * Talk about misusing macros..
- */
-#define __OUT1(s, x)							\
-static inline void out##s(unsigned x value, unsigned short port) {
-
-#define __OUT2(s, s1, s2)				\
-asm volatile ("out" #s " %" s1 "0,%" s2 "1"
-
-#ifndef REALLY_SLOW_IO
-#define REALLY_SLOW_IO
-#define UNSET_REALLY_SLOW_IO
-#endif
-
-#define __OUT(s, s1, x)							\
-	__OUT1(s, x) __OUT2(s, s1, "w") : : "a" (value), "Nd" (port));	\
-	}								\
-	__OUT1(s##_p, x) __OUT2(s, s1, "w") : : "a" (value), "Nd" (port)); \
+#define BUILDIO(bwl, bw, type)						\
+static inline void out##bwl(unsigned type value, int port)		\
+{									\
+	asm volatile("out" #bwl " %" #bw "0, %w1"			\
+		     : : "a"(value), "Nd"(port));			\
+}									\
+									\
+static inline unsigned type in##bwl(int port)				\
+{									\
+	unsigned type value;						\
+	asm volatile("in" #bwl " %w1, %" #bw "0"			\
+		     : "=a"(value) : "Nd"(port));			\
+	return value;							\
+}									\
+									\
+static inline void out##bwl##_p(unsigned type value, int port)		\
+{									\
+	out##bwl(value, port);						\
 	slow_down_io();							\
-}
-
-#define __IN1(s)							\
-static inline RETURN_TYPE in##s(unsigned short port)			\
+}									\
+									\
+static inline unsigned type in##bwl##_p(int port)			\
 {									\
-	RETURN_TYPE _v;
-
-#define __IN2(s, s1, s2)						\
-	asm volatile ("in" #s " %" s2 "1,%" s1 "0"
-
-#define __IN(s, s1, i...)						\
-	__IN1(s) __IN2(s, s1, "w") : "=a" (_v) : "Nd" (port), ##i);	\
-	return _v;							\
-	}								\
-	__IN1(s##_p) __IN2(s, s1, "w") : "=a" (_v) : "Nd" (port), ##i);	\
-	slow_down_io(); \
-	return _v; }
-
-#ifdef UNSET_REALLY_SLOW_IO
-#undef REALLY_SLOW_IO
-#endif
-
-#define __INS(s)							\
-static inline void ins##s(unsigned short port, void *addr,		\
-			  unsigned long count)				\
+	unsigned type value = in##bwl(port);				\
+	slow_down_io();							\
+	return value;							\
+}									\
+									\
+static inline void outs##bwl(int port, const void *addr, unsigned long count) \
 {									\
-	asm volatile ("rep ; ins" #s					\
-		      : "=D" (addr), "=c" (count)			\
-		      : "d" (port), "0" (addr), "1" (count));		\
-}
-
-#define __OUTS(s)							\
-static inline void outs##s(unsigned short port, const void *addr,	\
-			   unsigned long count)				\
+	asm volatile("rep; outs" #bwl					\
+		     : "+S"(addr), "+c"(count) : "d"(port));		\
+}									\
+									\
+static inline void ins##bwl(int port, void *addr, unsigned long count)	\
 {									\
-	asm volatile ("rep ; outs" #s					\
-		      : "=S" (addr), "=c" (count)			\
-		      : "d" (port), "0" (addr), "1" (count));		\
+	asm volatile("rep; ins" #bwl					\
+		     : "+D"(addr), "+c"(count) : "d"(port));		\
 }
 
-#define RETURN_TYPE unsigned char
-__IN(b, "")
-#undef RETURN_TYPE
-#define RETURN_TYPE unsigned short
-__IN(w, "")
-#undef RETURN_TYPE
-#define RETURN_TYPE unsigned int
-__IN(l, "")
-#undef RETURN_TYPE
-
-__OUT(b, "b", char)
-__OUT(w, "w", short)
-__OUT(l, , int)
-
-__INS(b)
-__INS(w)
-__INS(l)
-
-__OUTS(b)
-__OUTS(w)
-__OUTS(l)
-
+BUILDIO(b, b, char)
+BUILDIO(w, w, short)
+BUILDIO(l, , int)
 
 #endif /* _ASM_X86_IO_64_H */
-- 
1.6.6


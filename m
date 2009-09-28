Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZI1JeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZI1JeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 05:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZI1JeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 05:34:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:35410 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZI1JeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 05:34:10 -0400
Date: Mon, 28 Sep 2009 11:34:33 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@tglx.de, hpa@zytor.com, torvalds@linux-foundation.org
Subject: [PATCH] x86: Use __builtin_memset and __builtin_memcpy for
 memset/memcpy
Message-ID: <20090928113433.5e9b8ea7@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From ebb81aab0c3df19771ebc0eec1261ae314ddc0af Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 28 Sep 2009 11:21:32 +0200
Subject: [PATCH] x86: Use __builtin_memset and __builtin_memcpy for memset/memcpy

GCC provides reasonable memset/memcpy functions itself, with __builtin_memset
and __builtin_memcpy. For the "unknown" cases, it'll fall back to our
current existing functions, but for fixed size versions it'll inline
something smart. Quite often that will be the same as we have now,
but sometimes it can do something smarter (for example, if the code
then sets the first member of a struct, it can do a shorter memset).

In addition, and this is more important, gcc knows which registers and
such are not clobbered (while for our asm version it pretty much
acts like a compiler barrier), so for various cases it can avoid reloading
values.

The effect on codesize is shown below on my typical laptop .config:

   text	   data	    bss	    dec	    hex	filename
5605675	2041100	6525148	14171923	 d83f13	vmlinux.before
5595849	2041668	6525148	14162665	 d81ae9	vmlinux.after

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/include/asm/string_32.h |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index ae907e6..23a0bc2 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -177,10 +177,7 @@ static inline void *__memcpy3d(void *to, const void *from, size_t len)
  */
 
 #ifndef CONFIG_KMEMCHECK
-#define memcpy(t, f, n)				\
-	(__builtin_constant_p((n))		\
-	 ? __constant_memcpy((t), (f), (n))	\
-	 : __memcpy((t), (f), (n)))
+#define memcpy(t, f, n)	__builtin_memcpy(t, f, n)
 #else
 /*
  * kmemcheck becomes very happy if we use the REP instructions unconditionally,
@@ -316,11 +313,7 @@ void *__constant_c_and_count_memset(void *s, unsigned long pattern,
 	 : __memset_generic((s), (c), (count)))
 
 #define __HAVE_ARCH_MEMSET
-#define memset(s, c, count)						\
-	(__builtin_constant_p(c)					\
-	 ? __constant_c_x_memset((s), (0x01010101UL * (unsigned char)(c)), \
-				 (count))				\
-	 : __memset((s), (c), (count)))
+#define memset(s, c, count) __builtin_memset(s, c, count)
 
 /*
  * find the first occurrence of byte 'c', or 1 past the area if none
-- 
1.6.2.5


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

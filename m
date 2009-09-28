Return-Path: <linux-kernel-owner+w=401wt.eu-S1752370AbZI1MVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbZI1MVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 08:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZI1MU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 08:20:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:37169 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbZI1MU7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 08:20:59 -0400
Date: Mon, 28 Sep 2009 14:21:22 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de, hpa@zytor.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] x86: Use __builtin_memset and __builtin_memcpy for
 memset/memcpy
Message-ID: <20090928142122.6fc57e9c@infradead.org>
In-Reply-To: <20090928113433.5e9b8ea7@infradead.org>
References: <20090928113433.5e9b8ea7@infradead.org>
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

On Mon, 28 Sep 2009 11:34:33 +0200

turns out doing this unconditional is not a good idea due to gcc 3.x;
the updated patch below only does the change for gcc 4.x

>From e86cf2618a2e489cafcafb4361569c4d0853156e Mon Sep 17 00:00:00 2001
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

Due to some not-so-good behavior in the gcc 3.x series, this change
is only done for GCC 4.x and above.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/include/asm/string_32.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index ae907e6..3d3e835 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -177,10 +177,15 @@ static inline void *__memcpy3d(void *to, const void *from, size_t len)
  */
 
 #ifndef CONFIG_KMEMCHECK
+
+#if (__GNUC__ >= 4)
+#define memcpy(t, f, n) __builtin_memcpy(t, f, n)
+#else
 #define memcpy(t, f, n)				\
 	(__builtin_constant_p((n))		\
 	 ? __constant_memcpy((t), (f), (n))	\
 	 : __memcpy((t), (f), (n)))
+#endif
 #else
 /*
  * kmemcheck becomes very happy if we use the REP instructions unconditionally,
@@ -316,11 +321,15 @@ void *__constant_c_and_count_memset(void *s, unsigned long pattern,
 	 : __memset_generic((s), (c), (count)))
 
 #define __HAVE_ARCH_MEMSET
+#if (__GNUC__ >= 4)
+#define memset(s, c, count) __builtin_memset(s, c, count)
+#else
 #define memset(s, c, count)						\
 	(__builtin_constant_p(c)					\
 	 ? __constant_c_x_memset((s), (0x01010101UL * (unsigned char)(c)), \
 				 (count))				\
 	 : __memset((s), (c), (count)))
+#endif
 
 /*
  * find the first occurrence of byte 'c', or 1 past the area if none
-- 
1.6.2.5



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

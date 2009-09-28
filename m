Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbZI1XsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbZI1XsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 19:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZI1XsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 19:48:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:34754 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435AbZI1XsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 19:48:01 -0400
Date: Mon, 28 Sep 2009 23:47:39 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org, hpa@zytor.com,
       mingo@redhat.com, arjan@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, tglx@linutronix.de
In-Reply-To: <20090928142122.6fc57e9c@infradead.org>
References: <20090928142122.6fc57e9c@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Use __builtin_memset and __builtin_memcpy for memset/memcpy
Message-ID: <tip-ff60fab71bb3b4fdbf8caf57ff3739ffd0887396@git.kernel.org>
Git-Commit-ID: ff60fab71bb3b4fdbf8caf57ff3739ffd0887396
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 28 Sep 2009 23:47:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff60fab71bb3b4fdbf8caf57ff3739ffd0887396
Gitweb:     http://git.kernel.org/tip/ff60fab71bb3b4fdbf8caf57ff3739ffd0887396
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Mon, 28 Sep 2009 14:21:22 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 28 Sep 2009 16:43:15 -0700

x86: Use __builtin_memset and __builtin_memcpy for memset/memcpy

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
LKML-Reference: <20090928142122.6fc57e9c@infradead.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


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

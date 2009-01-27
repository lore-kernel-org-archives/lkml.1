Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbZA0Ipo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbZA0Ipo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbZA0IpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:45:09 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:45874 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914AbZA0IpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:45:08 -0500
Date: Tue, 27 Jan 2009 11:45:13 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: fix the BUG() macro
Message-ID: <20090127084513.GC15452@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit "alpha: teach the compiler that BUG doesn't return"
(ed6b9b97f42c091630335bfb71a2931e6f86388b) moved the asm code into
inline function which takes __FILE__ and __LINE__ as arguments.
This violates asm constrains there ("i" - an immediate operand
with constant value), so that compile may result in warning
or error, depending on compiler version.

Just adding an infinite loop to the BUG() is sufficient.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/include/asm/bug.h |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/alpha/include/asm/bug.h b/arch/alpha/include/asm/bug.h
index 695a5ee..7b85b7c 100644
--- a/arch/alpha/include/asm/bug.h
+++ b/arch/alpha/include/asm/bug.h
@@ -8,17 +8,12 @@
 
 /* ??? Would be nice to use .gprel32 here, but we can't be sure that the
    function loaded the GP, so this could fail in modules.  */
-static inline void ATTRIB_NORET __BUG(const char *file, int line)
-{
-	__asm__ __volatile__(
-		"call_pal %0  # bugchk\n\t"
-		".long %1\n\t.8byte %2"
-		       : : "i" (PAL_bugchk), "i"(line), "i"(file));
-	for ( ; ; )
-		;
-}
-
-#define BUG() __BUG(__FILE__, __LINE__)
+#define BUG()	{							\
+	__asm__ __volatile__(						\
+		"call_pal %0  # bugchk\n\t"				\
+		".long %1\n\t.8byte %2"					\
+		: : "i"(PAL_bugchk), "i"(__LINE__), "i"(__FILE__));	\
+	for ( ; ; ); }
 
 #define HAVE_ARCH_BUG
 #endif

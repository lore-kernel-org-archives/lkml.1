Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZIWAOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZIWAOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 20:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbZIWAOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 20:14:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbZIWAOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 20:14:19 -0400
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Subject: [PATCH] kmemcheck: clean up kmemcheck_annotate_bitfield
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090923001301.3ED5922@magilla.sf.frob.com>
Date: Tue, 22 Sep 2009 17:13:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 181f7c5dd3832763bdf2756b6d2d8a49bdf12791 change traded a
style warning from sparse for a syntax warning from the real compiler
(and perhaps an error with compilers old enough).  The use of a local
variable inside BUILD_BUG_ON() is pretty questionable too, though it
works with the compiler's constant-folding in practice.

This change cleans it all up a little more sanely.
The details are self-explanatory.

Signed-off-by: Roland McGrath <roland@redhat.com>
CC: Johannes Berg <johannes@sipsolutions.net>
CC: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/linux/kmemcheck.h |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
index c800660..9e2c5f4 100644
--- a/include/linux/kmemcheck.h
+++ b/include/linux/kmemcheck.h
@@ -143,16 +143,14 @@ static inline bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
 #define kmemcheck_bitfield_end(name)	\
 	int name##_end[0];
 
+#define kmemcheck_bitfield_stretch(ptr, name)	\
+	((long) &(ptr)->name##_end - (long) &(ptr)->name##_begin)
+
 #define kmemcheck_annotate_bitfield(ptr, name)				\
 	do {								\
-		if (!ptr)						\
-			break;						\
-									\
-		int _n = (long) &((ptr)->name##_end)			\
-			- (long) &((ptr)->name##_begin);		\
-		BUILD_BUG_ON(_n < 0);					\
-									\
-		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
+		BUILD_BUG_ON(kmemcheck_bitfield_stretch(ptr, name) < 0);\
+		kmemcheck_mark_initialized(&(ptr)->name##_begin,	\
+			kmemcheck_bitfield_stretch(ptr, name));		\
 	} while (0)
 
 #define kmemcheck_annotate_variable(var)				\

Return-Path: <linux-kernel-owner+w=401wt.eu-S934107AbXCVQKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107AbXCVQKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933789AbXCVQKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:10:18 -0400
Received: from [198.99.130.12] ([198.99.130.12]:53369 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934004AbXCVQJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:09:39 -0400
Date: Thu, 22 Mar 2007 12:06:41 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [ PATCH 1/7 ] UML - Update UML definition of ARRAY_SIZE
Message-ID: <20070322160641.GA6997@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the minimal change needed to keep UML building with the new
definition of ARRAY_SIZE.  It is defined in user_util.h so that
userspace files, which can't include kernel.h, can still use
ARRAY_SIZE.  However, since user_util.h is included everywhere,
including kernel files, the token sequence of the expansion has to
match.

This patch copies enough from the kernel headers to make that happen.

However, this is too gross to survive, and so is the entire header.
Future patches will make this header disappear, but this is a quick
and simple fix for the problem in case there is a noticable lag
between this patch and the more extensive patches which tidy this mess.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/user_util.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: linux-2.6.21-mm/arch/um/include/user_util.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/user_util.h	2007-03-21 10:58:05.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/user_util.h	2007-03-21 11:05:44.000000000 -0400
@@ -8,8 +8,19 @@
 
 #include "sysdep/ptrace.h"
 
-/* Copied from kernel.h */
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+/* Copied from kernel.h and compiler-gcc.h */
+
+/* Force a compilation error if condition is true, but also produce a
+   result (of value 0 and type size_t), so the expression can be used
+   e.g. in a structure initializer (or where-ever else comma expressions
+   aren't permitted). */
+#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
+
+/* &a[0] degrades to a pointer: a different type from an array */
+#define __must_be_array(a) \
+  BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
+
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
 #define CATCH_EINTR(expr) while ((errno = 0, ((expr) < 0)) && (errno == EINTR))
 

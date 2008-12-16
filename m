Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbYLPLkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbYLPLkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbYLPLkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:40:10 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:39546 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbYLPLkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:40:08 -0500
Message-Id: <4947A1BB.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 16 Dec 2008 11:40:27 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Cc: <linux-arch@vger.kernel.org>
Subject: [PATCH] allow bug table entries to use relative pointers (and
	 use it on x86-64)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows reducing the bug table size by half. Perhaps there are
other 64-bit architectures that could also make use of this.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/Kconfig           |    4 ++++
 arch/x86/include/asm/bug.h |    2 +-
 include/asm-generic/bug.h  |    8 ++++++++
 lib/bug.c                  |   19 +++++++++++++++++--
 4 files changed, 30 insertions(+), 3 deletions(-)

--- linux-2.6.28-rc8/arch/x86/Kconfig	2008-12-11 14:45:37.000000000 +0100
+++ 2.6.28-rc8-x86_64-bug-rel-addr/arch/x86/Kconfig	2008-12-01 14:10:32.000000000 +0100
@@ -87,6 +87,10 @@ config GENERIC_IOMAP
 config GENERIC_BUG
 	def_bool y
 	depends on BUG
+	select GENERIC_BUG_RELATIVE_POINTERS if X86_64
+
+config GENERIC_BUG_RELATIVE_POINTERS
+	bool
 
 config GENERIC_HWEIGHT
 	def_bool y
--- linux-2.6.28-rc8/arch/x86/include/asm/bug.h	2008-12-11 14:45:37.000000000 +0100
+++ 2.6.28-rc8-x86_64-bug-rel-addr/arch/x86/include/asm/bug.h	2008-12-01 14:12:17.000000000 +0100
@@ -9,7 +9,7 @@
 #ifdef CONFIG_X86_32
 # define __BUG_C0	"2:\t.long 1b, %c0\n"
 #else
-# define __BUG_C0	"2:\t.quad 1b, %c0\n"
+# define __BUG_C0	"2:\t.long 1b - 2b, %c0 - 2b\n"
 #endif
 
 #define BUG()							\
--- linux-2.6.28-rc8/include/asm-generic/bug.h	2008-12-11 14:46:04.000000000 +0100
+++ 2.6.28-rc8-x86_64-bug-rel-addr/include/asm-generic/bug.h	2008-12-01 14:13:35.000000000 +0100
@@ -8,9 +8,17 @@
 #ifdef CONFIG_GENERIC_BUG
 #ifndef __ASSEMBLY__
 struct bug_entry {
+#ifndef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
 	unsigned long	bug_addr;
+#else
+	signed int	bug_addr_disp;
+#endif
 #ifdef CONFIG_DEBUG_BUGVERBOSE
+#ifndef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
 	const char	*file;
+#else
+	signed int	file_disp;
+#endif
 	unsigned short	line;
 #endif
 	unsigned short	flags;
--- linux-2.6.28-rc8/lib/bug.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.28-rc8-x86_64-bug-rel-addr/lib/bug.c	2008-12-01 14:18:37.000000000 +0100
@@ -5,6 +5,8 @@
 
   CONFIG_BUG - emit BUG traps.  Nothing happens without this.
   CONFIG_GENERIC_BUG - enable this code.
+  CONFIG_GENERIC_BUG_RELATIVE_POINTERS - use 32-bit pointers relative to
+	the containing struct bug_entry for bug_addr and file.
   CONFIG_DEBUG_BUGVERBOSE - emit full file+line information for each BUG
 
   CONFIG_BUG and CONFIG_DEBUG_BUGVERBOSE are potentially user-settable
@@ -43,6 +45,15 @@
 
 extern const struct bug_entry __start___bug_table[], __stop___bug_table[];
 
+static inline unsigned long bug_addr(const struct bug_entry *bug)
+{
+#ifndef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
+	return bug->bug_addr;
+#else
+	return (unsigned long)bug + bug->bug_addr_disp;
+#endif
+}
+
 #ifdef CONFIG_MODULES
 static LIST_HEAD(module_bug_list);
 
@@ -55,7 +66,7 @@ static const struct bug_entry *module_fi
 		unsigned i;
 
 		for (i = 0; i < mod->num_bugs; ++i, ++bug)
-			if (bugaddr == bug->bug_addr)
+			if (bugaddr == bug_addr(bug))
 				return bug;
 	}
 	return NULL;
@@ -108,7 +119,7 @@ const struct bug_entry *find_bug(unsigne
 	const struct bug_entry *bug;
 
 	for (bug = __start___bug_table; bug < __stop___bug_table; ++bug)
-		if (bugaddr == bug->bug_addr)
+		if (bugaddr == bug_addr(bug))
 			return bug;
 
 	return module_find_bug(bugaddr);
@@ -133,7 +144,11 @@ enum bug_trap_type report_bug(unsigned l
 
 	if (bug) {
 #ifdef CONFIG_DEBUG_BUGVERBOSE
+#ifndef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
 		file = bug->file;
+#else
+		file = (const char *)bug + bug->file_disp;
+#endif
 		line = bug->line;
 #endif
 		warning = (bug->flags & BUGFLAG_WARNING) != 0;




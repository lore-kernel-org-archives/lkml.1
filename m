Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbZDZCSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbZDZCSk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 22:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZDZCR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 22:17:59 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54204 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137AbZDZCR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 22:17:58 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?utf-8?q?Am=C3=A9rico=20Wang?= <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 01/15] Add new HEAD_TEXT_SECTION macro.
Date: Sat, 25 Apr 2009 22:10:56 -0400
Message-Id: <1240711870-30505-1-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is preparation for replacing all uses of ".head.text" or
".text.head" in the kernel with macros, so that the section name can
later be changed without having to touch a lot of the kernel.

Since some linker scripts do more complex things than referencing
HEAD_TEXT, we add a HEAD_TEXT_SECTION macro that just contains the
actual name.

I've defined HEAD_TEXT_SECTION in a new header,
include/linux/section-names.h, so that this section name only needs to
appear in one place.  I anticipate creating similar macro structures
for a number of other section names.

The long-term goal here is to be able to change the kernel's magic
section names to those that are compatible with -ffunction-sections
-fdata-sections.  This requires renaming all magic sections with names
of the form ".text.foo".

Signed-off-by: Tim Abbott <tabbott@mit.edu>
---
 include/asm-generic/vmlinux.lds.h |    4 +++-
 include/linux/init.h              |    4 +++-
 include/linux/section-names.h     |    6 ++++++
 3 files changed, 12 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/section-names.h

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 7fa660f..eaa06ef 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -1,3 +1,5 @@
+#include <linux/section-names.h>
+
 #ifndef LOAD_OFFSET
 #define LOAD_OFFSET 0
 #endif
@@ -331,7 +333,7 @@
 #endif
 
 /* Section used for early init (in .S files) */
-#define HEAD_TEXT  *(.head.text)
+#define HEAD_TEXT  *(HEAD_TEXT_SECTION)
 
 /* init and exit section handling */
 #define INIT_DATA							\
diff --git a/include/linux/init.h b/include/linux/init.h
index f121a7a..20a1334 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -2,6 +2,8 @@
 #define _LINUX_INIT_H
 
 #include <linux/compiler.h>
+#include <linux/section-names.h>
+#include <linux/stringify.h>
 
 /* These macros are used to mark some functions or 
  * initialized data (doesn't apply to uninitialized data)
@@ -107,7 +109,7 @@
 #define __memexitconst   __section(.memexit.rodata)
 
 /* For assembly routines */
-#define __HEAD		.section	".head.text","ax"
+#define __HEAD		.section	__stringify(HEAD_TEXT_SECTION),"ax"
 #define __INIT		.section	".init.text","ax"
 #define __FINIT		.previous
 
diff --git a/include/linux/section-names.h b/include/linux/section-names.h
new file mode 100644
index 0000000..c956f4e
--- /dev/null
+++ b/include/linux/section-names.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_SECTION_NAMES_H
+#define __LINUX_SECTION_NAMES_H
+
+#define HEAD_TEXT_SECTION .head.text
+
+#endif /* !__LINUX_SECTION_NAMES_H */
-- 
1.6.2.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S932769AbZD1RBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769AbZD1RBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761318AbZD1RBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:01:18 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54132 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760906AbZD1RBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:01:16 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@MIT.EDU>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH v2 01/15] Add new macros for page-aligned data and bss sections.
Date: Tue, 28 Apr 2009 13:00:48 -0400
Message-Id: <1240938062-3264-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240938062-3264-1-git-send-email-tabbott@mit.edu>
References: <1240938062-3264-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is preparation for replacing most uses of
".bss.page_aligned" and ".data.page_aligned" in the kernel with
macros, so that the section name can later be changed without having
to touch a lot of the kernel.

The long-term goal here is to be able to change the kernel's magic
section names to those that are compatible with -ffunction-sections
-fdata-sections.  This requires renaming all magic sections with names
of the form ".data.foo".

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 include/asm-generic/vmlinux.lds.h |    8 ++++++++
 include/linux/linkage.h           |    9 +++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 89853bc..3d88c87 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -116,6 +116,14 @@
 	FTRACE_EVENTS()							\
 	TRACE_SYSCALLS()
 
+#define PAGE_ALIGNED_DATA						\
+	. = ALIGN(PAGE_SIZE);						\
+	*(.data.page_aligned)
+
+#define PAGE_ALIGNED_BSS						\
+	. = ALIGN(PAGE_SIZE);						\
+	*(.bss.page_aligned)
+
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index fee9e59..af051fc 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -22,6 +22,15 @@
 #define __page_aligned_bss	__section(.bss.page_aligned) __aligned(PAGE_SIZE)
 
 /*
+ * For assembly routines.
+ *
+ * Note when using these that you must specify the appropriate
+ * alignment directives yourself
+ */
+#define __PAGE_ALIGNED_DATA	.section ".data.page_aligned", "aw", @progbits
+#define __PAGE_ALIGNED_BSS	.section ".bss.page_aligned", "aw", @nobits
+
+/*
  * This is used by architectures to keep arguments on the stack
  * untouched by the compiler by keeping them live until the end.
  * The argument stack may be owned by the assembly-language
-- 
1.6.2.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYERPi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYERPi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 11:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbYERPiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 11:38:17 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58408
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYERPiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 11:38:17 -0400
From: Avi Kivity <avi@qumranet.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] Make LIST_POISON less deadly
Date: Sun, 18 May 2008 18:38:14 +0300
Message-Id: <1211125094-32167-1-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The list macros use LIST_POISON1 and LIST_POISON2 as undereferencable
pointers in order to trap erronous use of freed list_heads.  Unfortunately
userspace can arrange for those pointers to actually be dereferencable,
potentially turning an oops to an expolit.

To avoid this allow architectures (currently x86_64 only) to override
the default values for these pointers with truly-undereferncable values.
This is easy on x86_64 as the virtual address space is smaller than
the range spanned by pointer values.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/Kconfig         |    1 +
 include/asm-x86/poison.h |   14 ++++++++++++++
 include/linux/poison.h   |    4 ++++
 lib/Kconfig              |    3 +++
 4 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-x86/poison.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fe361ae..0eb34a9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -25,6 +25,7 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
+	select HAVE_ARCH_POISON
 
 config DEFCONFIG_LIST
 	string
diff --git a/include/asm-x86/poison.h b/include/asm-x86/poison.h
new file mode 100644
index 0000000..26b95dd
--- /dev/null
+++ b/include/asm-x86/poison.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_X86_POISON_H
+#define _ASM_X86_POISON_H
+
+/*
+ * Define LIST_POISON[12] as pointers that cannot be dereferenced.
+ */
+#ifdef CONFIG_X86_84
+#  undef LIST_POISON1
+#  undef LIST_POISON2
+#  define LIST_POISON1 ((void *)0x8001000100010001L)
+#  define LIST_POISON2 ((void *)0x8002000200020002L)
+#endif
+
+#endif
diff --git a/include/linux/poison.h b/include/linux/poison.h
index 9f31683..8bb6ad9 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -68,4 +68,8 @@
 /********** sound/oss/ **********/
 #define OSS_POISON_FREE		0xAB
 
+#ifdef CONFIG_HAVE_ARCH_POISON
+#include <asm/poison.h>
+#endif
+
 #endif
diff --git a/lib/Kconfig b/lib/Kconfig
index 8cc8e87..31b9457 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -150,4 +150,7 @@ config CHECK_SIGNATURE
 config HAVE_LMB
 	boolean
 
+config HAVE_ARCH_POISON
+	boolean
+
 endmenu
-- 
1.5.5.1


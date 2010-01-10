Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494Ab0AJO2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab0AJO2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316Ab0AJO2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:28:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab0AJO2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:28:14 -0500
From: Avi Kivity <avi@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH][RESEND] core, x86: make LIST_POISON less deadly
Date: Sun, 10 Jan 2010 16:28:09 +0200
Message-Id: <1263133689-13123-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

The list macros use LIST_POISON1 and LIST_POISON2 as undereferencable
pointers in order to trap erronous use of freed list_heads.  Unfortunately
userspace can arrange for those pointers to actually be dereferencable,
potentially turning an oops to an expolit.

To avoid this allow architectures (currently x86_64 only) to override
the default values for these pointers with truly-undereferencable values.
This is easy on x86_64 as the virtual address space is large and contains
areas that cannot be mapped.

Other 64-bit architectures will likely find similar unmapped ranges.

[ingo: switch to 0xdead000000000000 as the unmapped area]
[ingo: add comments, cleanup]
[jaswinder: eliminate sparse warnings]

Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Avi Kivity <avi@redhat.com>
---

Linus, Ingo won't push this for some reason, but he has no objection to
me submitting the patch and AFAICT no objections to the patch itself.

 arch/x86/Kconfig       |    5 +++++
 include/linux/poison.h |   16 ++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3b2a5ac..098f0d3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1244,6 +1244,11 @@ config ARCH_MEMORY_PROBE
 	def_bool X86_64
 	depends on MEMORY_HOTPLUG
 
+config ILLEGAL_POINTER_VALUE
+       hex
+       default 0 if X86_32
+       default 0xdead000000000000 if X86_64
+
 source "mm/Kconfig"
 
 config HIGHPTE
diff --git a/include/linux/poison.h b/include/linux/poison.h
index 7fc194a..2110a81 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -2,13 +2,25 @@
 #define _LINUX_POISON_H
 
 /********** include/linux/list.h **********/
+
+/*
+ * Architectures might want to move the poison pointer offset
+ * into some well-recognized area such as 0xdead000000000000,
+ * that is also not mappable by user-space exploits:
+ */
+#ifdef CONFIG_ILLEGAL_POINTER_VALUE
+# define POISON_POINTER_DELTA _AC(CONFIG_ILLEGAL_POINTER_VALUE, UL)
+#else
+# define POISON_POINTER_DELTA 0
+#endif
+
 /*
  * These are non-NULL pointers that will result in page faults
  * under normal circumstances, used to verify that nobody uses
  * non-initialized list entries.
  */
-#define LIST_POISON1  ((void *) 0x00100100)
-#define LIST_POISON2  ((void *) 0x00200200)
+#define LIST_POISON1  ((void *) 0x00100100 + POISON_POINTER_DELTA)
+#define LIST_POISON2  ((void *) 0x00200200 + POISON_POINTER_DELTA)
 
 /********** include/linux/timer.h **********/
 /*
-- 
1.6.5.3


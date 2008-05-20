Return-Path: <linux-kernel-owner+w=401wt.eu-S1764531AbYETLjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764531AbYETLjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYETLj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:39:28 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:56014
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbYETLj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:39:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] Make LIST_POISON less deadly (v3)
Date: Tue, 20 May 2008 14:39:25 +0300
Message-Id: <1211283565-30671-1-git-send-email-avi@qumranet.com>
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
This is easy on x86_64 as the virtual address space is large and contains
unmapped ranges.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---

Changes since v1:
- add CONFIG_ILLEGAL_POINTER_VALUE instead of new header <asm/poison.h>

Changes since v2:
- switched the range from an uncanonical address to a canonical unmapped
  address, since uncannonical addresses generate #GP instead of #PF, losing
  the faulting address.

 arch/x86/Kconfig       |    5 +++++
 include/linux/poison.h |   10 ++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fe361ae..54d4e36 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1021,6 +1021,11 @@ config ARCH_MEMORY_PROBE
 	def_bool X86_64
 	depends on MEMORY_HOTPLUG
 
+config ILLEGAL_POINTER_VALUE
+       hex
+       default 0 if X86_32
+       default 0xffffc10000000000 if X86_64
+
 source "mm/Kconfig"
 
 config HIGHPTE
diff --git a/include/linux/poison.h b/include/linux/poison.h
index 9f31683..0d105a5 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -1,14 +1,20 @@
 #ifndef _LINUX_POISON_H
 #define _LINUX_POISON_H
 
+#ifdef CONFIG_ILLEGAL_POINTER_VALUE
+#define POISON_POINTER_DELTA CONFIG_ILLEGAL_POINTER_VALUE
+#else
+#define POISON_POINTER_DELTA 0L
+#endif
+
 /********** include/linux/list.h **********/
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
1.5.5.1


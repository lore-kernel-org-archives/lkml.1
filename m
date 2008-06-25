Return-Path: <linux-kernel-owner+w=401wt.eu-S1759405AbYFYEsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405AbYFYEsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbYFYEht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:49 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37479 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756015AbYFYEh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:29 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 18 of 36] x86/paravirt: add debugging for missing operations
X-Mercurial-Node: 3cc92aa2d8e419b4754913209ec4e30106b67140
Message-Id: <3cc92aa2d8e419b47549.1214367554@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:14 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than just jumping to 0 when there's a missing operation, raise a BUG.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/Kconfig           |    7 +++++++
 include/asm-x86/paravirt.h |    8 ++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -433,6 +433,13 @@
 	  the kernel is theoretically slower and slightly larger.
 
 endif
+
+config PARAVIRT_DEBUG
+       bool "paravirt-ops debugging"
+       depends on PARAVIRT && DEBUG_KERNEL
+       help
+         Enable to debug paravirt_ops internals.  Specifically, BUG if
+	 a paravirt_op is missing when it is called.
 
 config MEMTEST
 	bool "Memtest"
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -460,10 +460,17 @@
 #define VEXTRA_CLOBBERS	 , "rax", "r8", "r9", "r10", "r11"
 #endif
 
+#ifdef CONFIG_PARAVIRT_DEBUG
+#define PVOP_TEST_NULL(op)	BUG_ON(op == NULL)
+#else
+#define PVOP_TEST_NULL(op)	((void)op)
+#endif
+
 #define __PVOP_CALL(rettype, op, pre, post, ...)			\
 	({								\
 		rettype __ret;						\
 		PVOP_CALL_ARGS;					\
+		PVOP_TEST_NULL(op);					\
 		/* This is 32-bit specific, but is okay in 64-bit */	\
 		/* since this condition will never hold */		\
 		if (sizeof(rettype) > sizeof(unsigned long)) {		\
@@ -492,6 +499,7 @@
 #define __PVOP_VCALL(op, pre, post, ...)				\
 	({								\
 		PVOP_VCALL_ARGS;					\
+		PVOP_TEST_NULL(op);					\
 		asm volatile(pre					\
 			     paravirt_alt(PARAVIRT_CALL)		\
 			     post					\



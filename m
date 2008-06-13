Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbYFMNKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbYFMNKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 09:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760261AbYFMNKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 09:10:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759950AbYFMNKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 09:10:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] MN10300: Provide __ucmpdi2() for MN10300
To: torvalds@osdl.org, akpm@linux-foundation.org, bunk@kernel.org
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Date: Fri, 13 Jun 2008 14:09:58 +0100
Message-ID: <20080613130958.26794.23426.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080613130952.26794.26092.stgit@warthog.procyon.org.uk>
References: <20080613130952.26794.26092.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide __ucmpdi2() for MN10300 so that allmodconfig can be built.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/mn10300_ksyms.c |    2 ++
 arch/mn10300/lib/Makefile           |    2 +-
 arch/mn10300/lib/__ucmpdi2.S        |   43 +++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 1 deletions(-)
 create mode 100644 arch/mn10300/lib/__ucmpdi2.S


diff --git a/arch/mn10300/kernel/mn10300_ksyms.c b/arch/mn10300/kernel/mn10300_ksyms.c
index 544ee1a..f9eb975 100644
--- a/arch/mn10300/kernel/mn10300_ksyms.c
+++ b/arch/mn10300/kernel/mn10300_ksyms.c
@@ -34,7 +34,9 @@ extern u64 __ashrdi3(u64, unsigned);
 extern u64 __ashldi3(u64, unsigned);
 extern u64 __lshrdi3(u64, unsigned);
 extern s64 __negdi2(s64);
+extern int __ucmpdi2(u64, u64);
 EXPORT_SYMBOL(__ashrdi3);
 EXPORT_SYMBOL(__ashldi3);
 EXPORT_SYMBOL(__lshrdi3);
 EXPORT_SYMBOL(__negdi2);
+EXPORT_SYMBOL(__ucmpdi2);
diff --git a/arch/mn10300/lib/Makefile b/arch/mn10300/lib/Makefile
index fdfa9ec..0cd2346 100644
--- a/arch/mn10300/lib/Makefile
+++ b/arch/mn10300/lib/Makefile
@@ -4,4 +4,4 @@
 
 lib-y = delay.o usercopy.o checksum.o bitops.o memcpy.o memmove.o memset.o
 lib-y += do_csum.o
-lib-y += __ashldi3.o __ashrdi3.o __lshrdi3.o negdi2.o
+lib-y += __ashldi3.o __ashrdi3.o __lshrdi3.o negdi2.o __ucmpdi2.o
diff --git a/arch/mn10300/lib/__ucmpdi2.S b/arch/mn10300/lib/__ucmpdi2.S
new file mode 100644
index 0000000..29633fd
--- /dev/null
+++ b/arch/mn10300/lib/__ucmpdi2.S
@@ -0,0 +1,43 @@
+/* __ucmpdi2.S: 64-bit unsigned compare
+ *
+ * Copyright (C) 2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+
+        .text
+        .p2align	4
+
+###############################################################################
+#
+# int __ucmpdi2(unsigned long long a [D0:D1],
+#		unsigned long long b [(SP,12),(SP,16)])
+#
+# - returns 0, 1, or 2 as a <, =, > b respectively.
+#
+###############################################################################
+        .globl		__ucmpdi2
+        .type		__ucmpdi2,@function
+__ucmpdi2:
+	mov		(12,sp),a0		# b.lsw
+	mov		(16,sp),a1		# b.msw
+
+	sub		a0,d0
+	subc		a1,d1			# may clear Z, never sets it
+	bne		__ucmpdi2_differ	# a.msw != b.msw
+	mov		+1,d0
+	rets
+
+__ucmpdi2_differ:
+	# C flag is set if LE, clear if GE
+	subc		d0,d0			# -1 if LE, 0 if GE
+	add		+1,d0			#  0 if LE, 1 if GE 
+	add		d0,d0			#  0 if LE, 2 if GE
+	rets
+
+	.size		__ucmpdi2, .-__ucmpdi2


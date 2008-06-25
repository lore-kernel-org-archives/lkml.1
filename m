Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbYFYEkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbYFYEkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYFYEhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:17 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37448 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753628AbYFYEhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:13 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 14 of 36] x86_64: add sync_cmpxchg
X-Mercurial-Node: 80d35cf20be0e0dc26e81af3f92ee2c7727c1aae
Message-Id: <80d35cf20be0e0dc26e8.1214367550@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:10 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sync_cmpxchg to match 32-bit's sync_cmpxchg.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/cmpxchg_64.h |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/include/asm-x86/cmpxchg_64.h b/include/asm-x86/cmpxchg_64.h
--- a/include/asm-x86/cmpxchg_64.h
+++ b/include/asm-x86/cmpxchg_64.h
@@ -93,6 +93,39 @@
 	return old;
 }
 
+/*
+ * Always use locked operations when touching memory shared with a
+ * hypervisor, since the system may be SMP even if the guest kernel
+ * isn't.
+ */
+static inline unsigned long __sync_cmpxchg(volatile void *ptr,
+					   unsigned long old,
+					   unsigned long new, int size)
+{
+	unsigned long prev;
+	switch (size) {
+	case 1:
+		asm volatile("lock; cmpxchgb %b1,%2"
+			     : "=a"(prev)
+			     : "q"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
+		return prev;
+	case 2:
+		asm volatile("lock; cmpxchgw %w1,%2"
+			     : "=a"(prev)
+			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
+		return prev;
+	case 4:
+		asm volatile("lock; cmpxchgl %1,%2"
+			     : "=a"(prev)
+			     : "r"(new), "m"(*__xg(ptr)), "0"(old)
+			     : "memory");
+		return prev;
+	}
+	return old;
+}
+
 static inline unsigned long __cmpxchg_local(volatile void *ptr,
 					    unsigned long old,
 					    unsigned long new, int size)
@@ -139,6 +172,10 @@
 	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
 					     (unsigned long)(n),	\
 					     sizeof(*(ptr))))
+#define sync_cmpxchg(ptr, o, n)						\
+	((__typeof__(*(ptr)))__sync_cmpxchg((ptr), (unsigned long)(o),	\
+					    (unsigned long)(n),		\
+					    sizeof(*(ptr))))
 #define cmpxchg64_local(ptr, o, n)					\
 ({									\
 	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\



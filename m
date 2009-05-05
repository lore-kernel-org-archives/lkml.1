Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbZEENZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbZEENZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbZEENYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:24:46 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:44245 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbZEENYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:24:43 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RFC PATCH 1/3] add generic hypercall support
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com
Date: Tue, 05 May 2009 09:24:37 -0400
Message-ID: <20090505132437.19891.42922.stgit@dev.haskins.net>
In-Reply-To: <20090505132005.19891.78436.stgit@dev.haskins.net>
References: <20090505132005.19891.78436.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We add a generic hypercall() mechanism for use by IO code which is
compatible with a variety of hypervisors, but which prefers to use
hypercalls over other types of hypervisor traps for performance and/or
feature reasons.

For instance, consider an emulated PCI device in KVM.  Today we can chose
to do IO over MMIO or PIO infrastructure, but they each have their own
distinct disadvantages:

*) MMIO causes a page-fault, which must be decoded by the hypervisor and is
   therefore fairly expensive.

*) PIO is more direct than MMIO, but it poses other problems such as:
      a) can have a small limited address space (x86 is 2^16)
      b) is a narrow-band interface (one 8, 16, 32, 64 bit word at a time)
      c) not available on all archs (PCI mentions ppc as problematic) and
         is therefore recommended to avoid.

Hypercalls, on the other hand, offer a direct access path like PIOs, yet
do not suffer the same drawbacks such as a limited address space or a
narrow-band interface.  Hypercalls are much more friendly to software
to software interaction since we can pack multiple registers in a way
that is natural and simple for software to utilize.

The problem with hypercalls today is that there is no generic support.
There is various support for hypervisor specific implementations (for
instance, see  kvm_hypercall0() in arch/x86/include/asm/kvm_para.h).  This
makes it difficult to implement a device that is hypervisor agnostic since
it would not only need to know the hypercall ABI, but also which platform
specific function call it should make.

If we can convey a dynamic binding to a specific hypercall vector in a
generic way (out of the scope of this patch series), then an IO driver
could utilize that dynamic binding to communicate without requiring
hypervisor specific knowledge.  Therefore, we implement a system wide
hypercall() interface based on a variable length list of unsigned longs
(representing registers to pack) and expect that various arch/hypervisor
implementations can fill in the details, if supported.  This is expected
to be done as part of the pv_ops infrastructure, which is the natural
hook-point for hypervisor specific code.  Note, however, that the
generic hypercall() interface does not require the implementation to use
pv_ops if so desired.

Example use case:
------------------

Consider a PCI device "X".  It can already advertise MMIO/PIO regions via
its BAR infrastructure.  With this new model it could also advertise a
hypercall vector in its device-specific upper configuration space.  (The
allocation and assignment of this vector on the backend is beyond the scope
of this series).  The guest-side driver for device "X" would sense (via
something like a feature-bit) if the hypercall was available and valid,
read the value with a configuration cycle, and proceed to ignore the BARs
in favor of using the hypercall() interface.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/hypercall.h |   83 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 83 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/hypercall.h

diff --git a/include/linux/hypercall.h b/include/linux/hypercall.h
new file mode 100644
index 0000000..c8a1492
--- /dev/null
+++ b/include/linux/hypercall.h
@@ -0,0 +1,83 @@
+/*
+ * Copyright 2009 Novell.  All Rights Reserved.
+ *
+ * Author:
+ *      Gregory Haskins <ghaskins@novell.com>
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
+ */
+
+#ifndef _LINUX_HYPERCALL_H
+#define _LINUX_HYPERCALL_H
+
+#ifdef CONFIG_HAVE_HYPERCALL
+
+long hypercall(unsigned long nr, unsigned long *args, size_t count);
+
+#else
+
+static inline long
+hypercall(unsigned long nr, unsigned long *args, size_t count)
+{
+	return -EINVAL;
+}
+
+#endif /* CONFIG_HAVE_HYPERCALL */
+
+#define hypercall0(nr) hypercall(nr, NULL, 0)
+#define hypercall1(nr, a1)                                              \
+	({						                \
+		unsigned long __args[] = { a1, };	                \
+		long __ret;				                \
+		__ret = hypercall(nr, __args, ARRAY_SIZE(__args));      \
+		__ret;                                                  \
+	})
+#define hypercall2(nr, a1, a2)						\
+	({						                \
+		unsigned long __args[] = { a1, a2, };	                \
+		long __ret;				                \
+		__ret = hypercall(nr, __args, ARRAY_SIZE(__args));      \
+		__ret;                                                  \
+	})
+#define hypercall3(nr, a1, a2, a3)			       		\
+	({						                \
+		unsigned long __args[] = { a1, a2, a3, };		\
+		long __ret;				                \
+		__ret = hypercall(nr, __args, ARRAY_SIZE(__args));      \
+		__ret;                                                  \
+	})
+#define hypercall4(nr, a1, a2, a3, a4)					\
+	({						                \
+		unsigned long __args[] = { a1, a2, a3, a4, };		\
+		long __ret;				                \
+		__ret = hypercall(nr, __args, ARRAY_SIZE(__args));      \
+		__ret;                                                  \
+	})
+#define hypercall5(nr, a1, a2, a3, a4, a5)				\
+	({						                \
+		unsigned long __args[] = { a1, a2, a3, a4, a5, };	\
+		long __ret;				                \
+		__ret = hypercall(nr, __args, ARRAY_SIZE(__args));      \
+		__ret;                                                  \
+	})
+#define hypercall6(nr, a1, a2, a3, a4, a5, a6)				\
+	({						                \
+		unsigned long __args[] = { a1, a2, a3, a4, a5, a6, };	\
+		long __ret;				                \
+		__ret = hypercall(nr, __args, ARRAY_SIZE(__args));      \
+		__ret;                                                  \
+	})
+
+
+#endif /* _LINUX_HYPERCALL_H */


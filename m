Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbYCRFe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbYCRFe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYCRFYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:35 -0400
Received: from gw.goop.org ([64.81.55.164]:37847 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbYCRFYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:07 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 24 of 31] xen: add support for callbackops hypercall
X-Mercurial-Node: e0520177f1a12cbc3598b7d7c55440b005308359
Message-Id: <e0520177f1a12cbc3598.1205797035@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 include/asm-x86/xen/hypercall.h  |    6 ++
 include/asm-x86/xen/interface.h  |    4 +
 include/xen/interface/callback.h |  102 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 112 insertions(+)

diff --git a/include/asm-x86/xen/hypercall.h b/include/asm-x86/xen/hypercall.h
--- a/include/asm-x86/xen/hypercall.h
+++ b/include/asm-x86/xen/hypercall.h
@@ -161,6 +161,12 @@
 	return _hypercall4(int, set_callbacks,
 			   event_selector, event_address,
 			   failsafe_selector, failsafe_address);
+}
+
+static inline int
+HYPERVISOR_callback_op(int cmd, void *arg)
+{
+	return _hypercall2(int, callback_op, cmd, arg);
 }
 
 static inline int
diff --git a/include/asm-x86/xen/interface.h b/include/asm-x86/xen/interface.h
--- a/include/asm-x86/xen/interface.h
+++ b/include/asm-x86/xen/interface.h
@@ -171,6 +171,10 @@
     unsigned long pad[5]; /* sizeof(struct vcpu_info) == 64 */
 };
 
+struct xen_callback {
+	unsigned long cs;
+	unsigned long eip;
+};
 #endif /* !__ASSEMBLY__ */
 
 /*
diff --git a/include/xen/interface/callback.h b/include/xen/interface/callback.h
new file mode 100644
--- /dev/null
+++ b/include/xen/interface/callback.h
@@ -0,0 +1,102 @@
+/******************************************************************************
+ * callback.h
+ *
+ * Register guest OS callbacks with Xen.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Copyright (c) 2006, Ian Campbell
+ */
+
+#ifndef __XEN_PUBLIC_CALLBACK_H__
+#define __XEN_PUBLIC_CALLBACK_H__
+
+#include "xen.h"
+
+/*
+ * Prototype for this hypercall is:
+ *   long callback_op(int cmd, void *extra_args)
+ * @cmd        == CALLBACKOP_??? (callback operation).
+ * @extra_args == Operation-specific extra arguments (NULL if none).
+ */
+
+/* ia64, x86: Callback for event delivery. */
+#define CALLBACKTYPE_event                 0
+
+/* x86: Failsafe callback when guest state cannot be restored by Xen. */
+#define CALLBACKTYPE_failsafe              1
+
+/* x86/64 hypervisor: Syscall by 64-bit guest app ('64-on-64-on-64'). */
+#define CALLBACKTYPE_syscall               2
+
+/*
+ * x86/32 hypervisor: Only available on x86/32 when supervisor_mode_kernel
+ *     feature is enabled. Do not use this callback type in new code.
+ */
+#define CALLBACKTYPE_sysenter_deprecated   3
+
+/* x86: Callback for NMI delivery. */
+#define CALLBACKTYPE_nmi                   4
+
+/*
+ * x86: sysenter is only available as follows:
+ * - 32-bit hypervisor: with the supervisor_mode_kernel feature enabled
+ * - 64-bit hypervisor: 32-bit guest applications on Intel CPUs
+ *                      ('32-on-32-on-64', '32-on-64-on-64')
+ *                      [nb. also 64-bit guest applications on Intel CPUs
+ *                           ('64-on-64-on-64'), but syscall is preferred]
+ */
+#define CALLBACKTYPE_sysenter              5
+
+/*
+ * x86/64 hypervisor: Syscall by 32-bit guest app on AMD CPUs
+ *                    ('32-on-32-on-64', '32-on-64-on-64')
+ */
+#define CALLBACKTYPE_syscall32             7
+
+/*
+ * Disable event deliver during callback? This flag is ignored for event and
+ * NMI callbacks: event delivery is unconditionally disabled.
+ */
+#define _CALLBACKF_mask_events             0
+#define CALLBACKF_mask_events              (1U << _CALLBACKF_mask_events)
+
+/*
+ * Register a callback.
+ */
+#define CALLBACKOP_register                0
+struct callback_register {
+    uint16_t type;
+    uint16_t flags;
+    struct xen_callback address;
+};
+
+/*
+ * Unregister a callback.
+ *
+ * Not all callbacks can be unregistered. -EINVAL will be returned if
+ * you attempt to unregister such a callback.
+ */
+#define CALLBACKOP_unregister              1
+struct callback_unregister {
+    uint16_t type;
+    uint16_t _unused;
+};
+
+#endif /* __XEN_PUBLIC_CALLBACK_H__ */



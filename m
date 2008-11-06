Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYKFVVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYKFVVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbYKFVUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:20:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63798 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbYKFVUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:20:43 -0500
Message-Id: <20081106212041.790862958@goodmis.org>
References: <20081106211949.320119144@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 06 Nov 2008 16:19:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/1] ftrace: split out hardirq ftrace code into own header
Content-Disposition: inline; filename=0001-ftrace-split-out-hardirq-ftrace-code-into-own-heade.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: moving of function prototypes into own header file

ftrace.h is too big of a file for hardirq.h, and some archs will fail
to build because of the include dependencies not being met.

This patch pulls out the required prototypes for hardirq.h into a smaller
and safer ftrace_irq.h file.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h     |    5 -----
 include/linux/ftrace_irq.h |   13 +++++++++++++
 include/linux/hardirq.h    |    2 +-
 3 files changed, 14 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/ftrace_irq.h

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 41054a3..1f5608c 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -134,9 +134,6 @@ extern void ftrace_release(void *start, unsigned long size);
 
 extern void ftrace_disable_daemon(void);
 extern void ftrace_enable_daemon(void);
-extern void ftrace_nmi_enter(void);
-extern void ftrace_nmi_exit(void);
-
 #else
 # define skip_trace(ip)				({ 0; })
 # define ftrace_force_update()			({ 0; })
@@ -144,8 +141,6 @@ extern void ftrace_nmi_exit(void);
 # define ftrace_disable_daemon()		do { } while (0)
 # define ftrace_enable_daemon()			do { } while (0)
 static inline void ftrace_release(void *start, unsigned long size) { }
-static inline void ftrace_nmi_enter(void) { }
-static inline void ftrace_nmi_exit(void) { }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 /* totally disable ftrace - can not re-enable after this */
diff --git a/include/linux/ftrace_irq.h b/include/linux/ftrace_irq.h
new file mode 100644
index 0000000..b1299d6
--- /dev/null
+++ b/include/linux/ftrace_irq.h
@@ -0,0 +1,13 @@
+#ifndef _LINUX_FTRACE_IRQ_H
+#define _LINUX_FTRACE_IRQ_H
+
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+extern void ftrace_nmi_enter(void);
+extern void ftrace_nmi_exit(void);
+#else
+static inline void ftrace_nmi_enter(void) { }
+static inline void ftrace_nmi_exit(void) { }
+#endif
+
+#endif /* _LINUX_FTRACE_IRQ_H */
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index ffc16ab..89a56d7 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -4,7 +4,7 @@
 #include <linux/preempt.h>
 #include <linux/smp_lock.h>
 #include <linux/lockdep.h>
-#include <linux/ftrace.h>
+#include <linux/ftrace_irq.h>
 #include <asm/hardirq.h>
 #include <asm/system.h>
 
-- 
1.5.6.5

-- 

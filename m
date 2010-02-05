Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934023Ab0BEWtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 17:49:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:37614 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934046Ab0BEWtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:49:24 -0500
Date: Fri, 5 Feb 2010 22:49:17 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1265380629-3212-4-git-send-email-brgerst@gmail.com>
References: <1265380629-3212-4-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/io] x86-64: Reorganize io_64.h
Message-ID: <tip-2e16fc7728a77755b5b2dc6b27dde62cd97b9ea5@git.kernel.org>
Git-Commit-ID: 2e16fc7728a77755b5b2dc6b27dde62cd97b9ea5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Feb 2010 22:49:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e16fc7728a77755b5b2dc6b27dde62cd97b9ea5
Gitweb:     http://git.kernel.org/tip/2e16fc7728a77755b5b2dc6b27dde62cd97b9ea5
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 5 Feb 2010 09:37:05 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 5 Feb 2010 13:57:22 -0800

x86-64: Reorganize io_64.h

Make it more similar to io_32.h.  No real code changes.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1265380629-3212-4-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/io_64.h |   90 +++++++++++++++++++++++-------------------
 1 files changed, 49 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/io_64.h b/arch/x86/include/asm/io_64.h
index 2440678..040bf74 100644
--- a/arch/x86/include/asm/io_64.h
+++ b/arch/x86/include/asm/io_64.h
@@ -35,6 +35,54 @@
   *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
   */
 
+#ifdef __KERNEL__
+
+#include <asm-generic/iomap.h>
+
+#include <linux/vmalloc.h>
+
+/*
+ * Convert a virtual cached pointer to an uncached pointer
+ */
+#define xlate_dev_kmem_ptr(p)	p
+
+void memset_io(volatile void __iomem *a, int b, size_t c);
+
+void __memcpy_fromio(void *, unsigned long, unsigned);
+static inline void memcpy_fromio(void *to, const volatile void __iomem *from,
+				 unsigned len)
+{
+	__memcpy_fromio(to, (unsigned long)from, len);
+}
+
+void __memcpy_toio(unsigned long, const void *, unsigned);
+static inline void memcpy_toio(volatile void __iomem *to, const void *from,
+			       unsigned len)
+{
+	__memcpy_toio((unsigned long)to, from, len);
+}
+
+/*
+ * ISA space is 'always mapped' on a typical x86 system, no need to
+ * explicitly ioremap() it. The fact that the ISA IO space is mapped
+ * to PAGE_OFFSET is pure coincidence - it does not mean ISA values
+ * are physical addresses. The following constant pointer can be
+ * used as the IO-area pointer (it can be iounmapped as well, so the
+ * analogy with PCI is quite large):
+ */
+#define __ISA_IO_base ((char __iomem *)(PAGE_OFFSET))
+
+/*
+ *	Cache management
+ *
+ *	This needed for two cases
+ *	1. Out of order aware processors
+ *	2. Accidentally out of order processors (PPro errata #51)
+ */
+#define flush_write_buffers() do { } while (0)
+
+#endif /* __KERNEL__ */
+
 extern void native_io_delay(void);
 
 extern int io_delay_type;
@@ -53,6 +101,7 @@ static inline void slow_down_io(void)
 	native_io_delay();
 #endif
 }
+
 #endif
 
 /*
@@ -136,46 +185,5 @@ __OUTS(b)
 __OUTS(w)
 __OUTS(l)
 
-#if defined(__KERNEL__) && defined(__x86_64__)
-
-#include <linux/vmalloc.h>
-
-#include <asm-generic/iomap.h>
-
-void __memcpy_fromio(void *, unsigned long, unsigned);
-void __memcpy_toio(unsigned long, const void *, unsigned);
-
-static inline void memcpy_fromio(void *to, const volatile void __iomem *from,
-				 unsigned len)
-{
-	__memcpy_fromio(to, (unsigned long)from, len);
-}
-
-static inline void memcpy_toio(volatile void __iomem *to, const void *from,
-			       unsigned len)
-{
-	__memcpy_toio((unsigned long)to, from, len);
-}
-
-void memset_io(volatile void __iomem *a, int b, size_t c);
-
-/*
- * ISA space is 'always mapped' on a typical x86 system, no need to
- * explicitly ioremap() it. The fact that the ISA IO space is mapped
- * to PAGE_OFFSET is pure coincidence - it does not mean ISA values
- * are physical addresses. The following constant pointer can be
- * used as the IO-area pointer (it can be iounmapped as well, so the
- * analogy with PCI is quite large):
- */
-#define __ISA_IO_base ((char __iomem *)(PAGE_OFFSET))
-
-#define flush_write_buffers()
-
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
-#endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_IO_64_H */

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbYHAJi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbYHAJi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbYHAJib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:38:31 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:14084 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbYHAJi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:38:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u9ClGtQtWSacW3khwfkWFCo6BZ69J1xRV1ikPCsmeZY/MThaEPhJSl17A4usffbL7r
         JywZ4yc7KJF5eAbNoZPz8KGzM18OnnEq83Kgq8b5+loJD+fYMQ45I6jA+bKAkkqdmKGH
         isT+vLxYGa8InkFUyyCYjxistKBN9wjrU7xiE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 01/16] x86: 64bit support more than 256 irq
Date: Fri,  1 Aug 2008 02:37:29 -0700
Message-Id: <1217583464-28494-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani got:
kernel BUG at arch/x86/kernel/io_apic_64.c:357!
invalid opcode: 0000 [1] SMP
CPU 24
...

his system (x3950) has 8 ioapic, irq > 256

caused by
        commit 9b7dc567d03d74a1fbae84e88949b6a60d922d82
        Author: Thomas Gleixner <tglx@linutronix.de>
        Date:   Fri May 2 20:10:09 2008 +0200

           x86: unify interrupt vector defines

           The interrupt vector defines are copied 4 times around with minimal
           differences. Move them all into asm-x86/irq_vectors.h

because 64bit allow same vector for different cpu to serve different irq

need to create that array dynamically later

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

---
 include/asm-x86/irq_vectors.h |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)
Index: linux-2.6/include/asm-x86/irq_vectors.h
===================================================================
--- linux-2.6.orig/include/asm-x86/irq_vectors.h
+++ linux-2.6/include/asm-x86/irq_vectors.h
@@ -113,28 +113,26 @@
 
 # if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS)
 
+#ifdef CONFIG_X86_64
+#  define NR_IRQS		(32 * NR_CPUS + 224)
+#else
 #  define NR_IRQS		224
-
-#  if (224 >= 32 * NR_CPUS)
-#   define NR_IRQ_VECTORS	NR_IRQS
-#  else
-#   define NR_IRQ_VECTORS	(32 * NR_CPUS)
-#  endif
+#endif
 
 # else /* IO_APIC || PARAVIRT */
 
 #  define NR_IRQS		16
-#  define NR_IRQ_VECTORS	NR_IRQS
 
 # endif
 
 #else /* !VISWS && !VOYAGER */
 
 # define NR_IRQS		224
-# define NR_IRQ_VECTORS		NR_IRQS
 
 #endif /* VISWS */
 
+#define NR_IRQ_VECTORS		NR_IRQS
+
 /* Voyager specific defines */
 /* These define the CPIs we use in linux */
 #define VIC_CPI_LEVEL0			0

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbZFBLGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbZFBLGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760629AbZFBLGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:06:07 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:63602 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760441AbZFBLGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:06:06 -0400
Message-Id: <20090602110512.002655198@de.ibm.com>
References: <20090602105311.591592481@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 12:53:13 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC 2/4] arch specific probe_kernel_write() implementation
Content-Disposition: inline; filename=201-probe_kernel_write-s390.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Add an s390 specific probe_kernel_write() function which allows to
write to the kernel text segment even if write protection is enabled.
This is implemented using the lra (load real address) and stura (store
using real address) instructions.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 arch/s390/mm/Makefile  |    2 -
 arch/s390/mm/maccess.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/arch/s390/mm/maccess.c linux-2.6-patched/arch/s390/mm/maccess.c
--- linux-2.6/arch/s390/mm/maccess.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/arch/s390/mm/maccess.c	2009-06-02 10:40:04.000000000 +0200
@@ -0,0 +1,61 @@
+/*
+ * Access kernel memory without faulting -- s390 specific implementation.
+ *
+ * Copyright IBM Corp. 2009
+ *
+ *   Author(s): Heiko Carstens <heiko.carstens@de.ibm.com>,
+ *
+ */
+
+#include <linux/uaccess.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <asm/system.h>
+
+/*
+ * This function writes to kernel memory bypassing DAT and possible
+ * write protection. It copies one to four bytes from src to dst
+ * using the stura instruction.
+ * Returns the number of bytes copied or -EFAULT.
+ */
+static long probe_kernel_write_odd(void *dst, void *src, size_t size)
+{
+	unsigned long count, aligned;
+	int offset, mask;
+	int rc = -EFAULT;
+
+	aligned = (unsigned long) dst & ~3UL;
+	offset = (unsigned long) dst & 3;
+	count = min_t(unsigned long, 4 - offset, size);
+	mask = (0xf << (4 - count)) & 0xf;
+	mask >>= offset;
+	asm volatile(
+		"	bras	1,0f\n"
+		"	icm	0,0,0(%3)\n"
+		"0:	l	0,0(%1)\n"
+		"	lra	%1,0(%1)\n"
+		"1:	ex	%2,0(1)\n"
+		"2:	stura	0,%1\n"
+		"	la	%0,0\n"
+		"3:\n"
+		EX_TABLE(0b,3b) EX_TABLE(1b,3b) EX_TABLE(2b,3b)
+		: "+d" (rc), "+a" (aligned)
+		: "a" (mask), "a" (src) : "cc", "memory", "0", "1");
+	return rc ? rc : count;
+}
+
+long probe_kernel_write(void *dst, void *src, size_t size)
+{
+	long copied = 0;
+
+	while (size) {
+		copied = probe_kernel_write_odd(dst, src, size);
+		if (copied < 0)
+			break;
+		dst += copied;
+		src += copied;
+		size -= copied;
+	}
+	return copied < 0 ? -EFAULT : 0;
+}
diff -urpN linux-2.6/arch/s390/mm/Makefile linux-2.6-patched/arch/s390/mm/Makefile
--- linux-2.6/arch/s390/mm/Makefile	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6-patched/arch/s390/mm/Makefile	2009-06-02 10:40:04.000000000 +0200
@@ -2,7 +2,7 @@
 # Makefile for the linux s390-specific parts of the memory manager.
 #
 
-obj-y	 := init.o fault.o extmem.o mmap.o vmem.o pgtable.o
+obj-y	 := init.o fault.o extmem.o mmap.o vmem.o pgtable.o maccess.o
 obj-$(CONFIG_CMM) += cmm.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_PAGE_STATES) += page-states.o

-- 

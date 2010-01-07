Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566Ab0AGTB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0AGTB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208Ab0AGTBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:01:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:60150 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0AGTBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:01:08 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>,
       Sonic Zhang <sonic.adi@gmail.com>, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 2/4] blackfin,kgdb,probe_kernel: Cleanup probe_kernel_read/write
Date: Thu,  7 Jan 2010 12:59:54 -0600
Message-Id: <1262890796-25053-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1262890796-25053-1-git-send-email-jason.wessel@windriver.com>
References: <1262890796-25053-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 07 Jan 2010 19:00:41.0095 (UTC) FILETIME=[B4FAD170:01CA8FCB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Blackfin needs it own arch specific probe_kernel_read() and
probe_kernel_write().

This was moved out of the kgdb code and into the
arch/blackfin/maccess.c, because it is a generic kernel api.

The arch specific kgdb.c for blackfin was cleaned of all functions
which exist in the kgdb core that do the same thing after resolving
the probe_kernel_read() and probe_kernel_write().  This also
eliminated the need for most of the #include's.

CC: Sonic Zhang <sonic.adi@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/kgdb.c |  205 -------------------------------------------
 arch/blackfin/mm/Makefile   |    2 +-
 arch/blackfin/mm/maccess.c  |   97 ++++++++++++++++++++
 3 files changed, 98 insertions(+), 206 deletions(-)
 create mode 100644 arch/blackfin/mm/maccess.c

diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
index f1036b6..da03848 100644
--- a/arch/blackfin/kernel/kgdb.c
+++ b/arch/blackfin/kernel/kgdb.c
@@ -6,23 +6,9 @@
  * Licensed under the GPL-2 or later.
  */
 
-#include <linux/string.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/smp.h>
-#include <linux/spinlock.h>
-#include <linux/delay.h>
 #include <linux/ptrace.h>		/* for linux pt_regs struct */
 #include <linux/kgdb.h>
-#include <linux/console.h>
-#include <linux/init.h>
-#include <linux/errno.h>
-#include <linux/irq.h>
 #include <linux/uaccess.h>
-#include <asm/system.h>
-#include <asm/traps.h>
-#include <asm/blackfin.h>
-#include <asm/dma.h>
 
 void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 {
@@ -424,182 +410,6 @@ struct kgdb_arch arch_kgdb_ops = {
 	.correct_hw_break = bfin_correct_hw_break,
 };
 
-static int hex(char ch)
-{
-	if ((ch >= 'a') && (ch <= 'f'))
-		return ch - 'a' + 10;
-	if ((ch >= '0') && (ch <= '9'))
-		return ch - '0';
-	if ((ch >= 'A') && (ch <= 'F'))
-		return ch - 'A' + 10;
-	return -1;
-}
-
-static int validate_memory_access_address(unsigned long addr, int size)
-{
-	if (size < 0 || addr == 0)
-		return -EFAULT;
-	return bfin_mem_access_type(addr, size);
-}
-
-static int bfin_probe_kernel_read(char *dst, char *src, int size)
-{
-	unsigned long lsrc = (unsigned long)src;
-	int mem_type;
-
-	mem_type = validate_memory_access_address(lsrc, size);
-	if (mem_type < 0)
-		return mem_type;
-
-	if (lsrc >= SYSMMR_BASE) {
-		if (size == 2 && lsrc % 2 == 0) {
-			u16 mmr = bfin_read16(src);
-			memcpy(dst, &mmr, sizeof(mmr));
-			return 0;
-		} else if (size == 4 && lsrc % 4 == 0) {
-			u32 mmr = bfin_read32(src);
-			memcpy(dst, &mmr, sizeof(mmr));
-			return 0;
-		}
-	} else {
-		switch (mem_type) {
-			case BFIN_MEM_ACCESS_CORE:
-			case BFIN_MEM_ACCESS_CORE_ONLY:
-				return probe_kernel_read(dst, src, size);
-			/* XXX: should support IDMA here with SMP */
-			case BFIN_MEM_ACCESS_DMA:
-				if (dma_memcpy(dst, src, size))
-					return 0;
-				break;
-			case BFIN_MEM_ACCESS_ITEST:
-				if (isram_memcpy(dst, src, size))
-					return 0;
-				break;
-		}
-	}
-
-	return -EFAULT;
-}
-
-static int bfin_probe_kernel_write(char *dst, char *src, int size)
-{
-	unsigned long ldst = (unsigned long)dst;
-	int mem_type;
-
-	mem_type = validate_memory_access_address(ldst, size);
-	if (mem_type < 0)
-		return mem_type;
-
-	if (ldst >= SYSMMR_BASE) {
-		if (size == 2 && ldst % 2 == 0) {
-			u16 mmr;
-			memcpy(&mmr, src, sizeof(mmr));
-			bfin_write16(dst, mmr);
-			return 0;
-		} else if (size == 4 && ldst % 4 == 0) {
-			u32 mmr;
-			memcpy(&mmr, src, sizeof(mmr));
-			bfin_write32(dst, mmr);
-			return 0;
-		}
-	} else {
-		switch (mem_type) {
-			case BFIN_MEM_ACCESS_CORE:
-			case BFIN_MEM_ACCESS_CORE_ONLY:
-				return probe_kernel_write(dst, src, size);
-			/* XXX: should support IDMA here with SMP */
-			case BFIN_MEM_ACCESS_DMA:
-				if (dma_memcpy(dst, src, size))
-					return 0;
-				break;
-			case BFIN_MEM_ACCESS_ITEST:
-				if (isram_memcpy(dst, src, size))
-					return 0;
-				break;
-		}
-	}
-
-	return -EFAULT;
-}
-
-/*
- * Convert the memory pointed to by mem into hex, placing result in buf.
- * Return a pointer to the last char put in buf (null). May return an error.
- */
-int kgdb_mem2hex(char *mem, char *buf, int count)
-{
-	char *tmp;
-	int err;
-
-	/*
-	 * We use the upper half of buf as an intermediate buffer for the
-	 * raw memory copy.  Hex conversion will work against this one.
-	 */
-	tmp = buf + count;
-
-	err = bfin_probe_kernel_read(tmp, mem, count);
-	if (!err) {
-		while (count > 0) {
-			buf = pack_hex_byte(buf, *tmp);
-			tmp++;
-			count--;
-		}
-
-		*buf = 0;
-	}
-
-	return err;
-}
-
-/*
- * Copy the binary array pointed to by buf into mem.  Fix $, #, and
- * 0x7d escaped with 0x7d.  Return a pointer to the character after
- * the last byte written.
- */
-int kgdb_ebin2mem(char *buf, char *mem, int count)
-{
-	char *tmp_old, *tmp_new;
-	int size;
-
-	tmp_old = tmp_new = buf;
-
-	for (size = 0; size < count; ++size) {
-		if (*tmp_old == 0x7d)
-			*tmp_new = *(++tmp_old) ^ 0x20;
-		else
-			*tmp_new = *tmp_old;
-		tmp_new++;
-		tmp_old++;
-	}
-
-	return bfin_probe_kernel_write(mem, buf, count);
-}
-
-/*
- * Convert the hex array pointed to by buf into binary to be placed in mem.
- * Return a pointer to the character AFTER the last byte written.
- * May return an error.
- */
-int kgdb_hex2mem(char *buf, char *mem, int count)
-{
-	char *tmp_raw, *tmp_hex;
-
-	/*
-	 * We use the upper half of buf as an intermediate buffer for the
-	 * raw memory that is converted from hex.
-	 */
-	tmp_raw = buf + count * 2;
-
-	tmp_hex = tmp_raw - 1;
-	while (tmp_hex >= buf) {
-		tmp_raw--;
-		*tmp_raw = hex(*tmp_hex--);
-		*tmp_raw |= hex(*tmp_hex--) << 4;
-	}
-
-	return bfin_probe_kernel_write(mem, tmp_raw, count);
-}
-
 #define IN_MEM(addr, size, l1_addr, l1_size) \
 ({ \
 	unsigned long __addr = (unsigned long)(addr); \
@@ -629,21 +439,6 @@ int kgdb_validate_break_address(unsigned long addr)
 	return -EFAULT;
 }
 
-int kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr)
-{
-	int err = bfin_probe_kernel_read(saved_instr, (char *)addr,
-	                                 BREAK_INSTR_SIZE);
-	if (err)
-		return err;
-	return bfin_probe_kernel_write((char *)addr, arch_kgdb_ops.gdb_bpt_instr,
-	                               BREAK_INSTR_SIZE);
-}
-
-int kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle)
-{
-	return bfin_probe_kernel_write((char *)addr, bundle, BREAK_INSTR_SIZE);
-}
-
 int kgdb_arch_init(void)
 {
 	kgdb_single_step = 0;
diff --git a/arch/blackfin/mm/Makefile b/arch/blackfin/mm/Makefile
index d489f89..4c011b1 100644
--- a/arch/blackfin/mm/Makefile
+++ b/arch/blackfin/mm/Makefile
@@ -2,4 +2,4 @@
 # arch/blackfin/mm/Makefile
 #
 
-obj-y := sram-alloc.o isram-driver.o init.o
+obj-y := sram-alloc.o isram-driver.o init.o maccess.o
diff --git a/arch/blackfin/mm/maccess.c b/arch/blackfin/mm/maccess.c
new file mode 100644
index 0000000..b71cebc
--- /dev/null
+++ b/arch/blackfin/mm/maccess.c
@@ -0,0 +1,97 @@
+/*
+ * safe read and write memory routines callable while atomic
+ *
+ * Copyright 2005-2008 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/uaccess.h>
+#include <asm/dma.h>
+
+static int validate_memory_access_address(unsigned long addr, int size)
+{
+	if (size < 0 || addr == 0)
+		return -EFAULT;
+	return bfin_mem_access_type(addr, size);
+}
+
+long probe_kernel_read(void *dst, void *src, size_t size)
+{
+	unsigned long lsrc = (unsigned long)src;
+	int mem_type;
+
+	mem_type = validate_memory_access_address(lsrc, size);
+	if (mem_type < 0)
+		return mem_type;
+
+	if (lsrc >= SYSMMR_BASE) {
+		if (size == 2 && lsrc % 2 == 0) {
+			u16 mmr = bfin_read16(src);
+			memcpy(dst, &mmr, sizeof(mmr));
+			return 0;
+		} else if (size == 4 && lsrc % 4 == 0) {
+			u32 mmr = bfin_read32(src);
+			memcpy(dst, &mmr, sizeof(mmr));
+			return 0;
+		}
+	} else {
+		switch (mem_type) {
+		case BFIN_MEM_ACCESS_CORE:
+		case BFIN_MEM_ACCESS_CORE_ONLY:
+			return __probe_kernel_read(dst, src, size);
+			/* XXX: should support IDMA here with SMP */
+		case BFIN_MEM_ACCESS_DMA:
+			if (dma_memcpy(dst, src, size))
+				return 0;
+			break;
+		case BFIN_MEM_ACCESS_ITEST:
+			if (isram_memcpy(dst, src, size))
+				return 0;
+			break;
+		}
+	}
+
+	return -EFAULT;
+}
+
+long probe_kernel_write(void *dst, void *src, size_t size)
+{
+	unsigned long ldst = (unsigned long)dst;
+	int mem_type;
+
+	mem_type = validate_memory_access_address(ldst, size);
+	if (mem_type < 0)
+		return mem_type;
+
+	if (ldst >= SYSMMR_BASE) {
+		if (size == 2 && ldst % 2 == 0) {
+			u16 mmr;
+			memcpy(&mmr, src, sizeof(mmr));
+			bfin_write16(dst, mmr);
+			return 0;
+		} else if (size == 4 && ldst % 4 == 0) {
+			u32 mmr;
+			memcpy(&mmr, src, sizeof(mmr));
+			bfin_write32(dst, mmr);
+			return 0;
+		}
+	} else {
+		switch (mem_type) {
+		case BFIN_MEM_ACCESS_CORE:
+		case BFIN_MEM_ACCESS_CORE_ONLY:
+			return __probe_kernel_write(dst, src, size);
+			/* XXX: should support IDMA here with SMP */
+		case BFIN_MEM_ACCESS_DMA:
+			if (dma_memcpy(dst, src, size))
+				return 0;
+			break;
+		case BFIN_MEM_ACCESS_ITEST:
+			if (isram_memcpy(dst, src, size))
+				return 0;
+			break;
+		}
+	}
+
+	return -EFAULT;
+}
-- 
1.6.3.1.9.g95405b


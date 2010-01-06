Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183Ab0AFTny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0AFTny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150Ab0AFTny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:43:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:45692 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab0AFTnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:43:53 -0500
Message-ID: <4B44E7E3.10305@windriver.com>
Date: Wed, 06 Jan 2010 13:43:31 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sonic Zhang <sonic.adi@gmail.com>
CC: "Zhang, Sonic" <Sonic.Zhang@analog.com>,
       Mike Frysinger <vapier.adi@gmail.com>,
       kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [Kgdb-bugreport] [PATCH 09/37] kgdb,blackfin: Add in kgdb_arch_set_pc
 for blackfin
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com><1261603190-5036-4-git-send-email-jason.wessel@windriver.com><1261603190-5036-5-git-send-email-jason.wessel@windriver.com><1261603190-5036-6-git-send-email-jason.wessel@windriver.com><1261603190-5036-7-git-send-email-jason.wessel@windriver.com><1261603190-5036-8-git-send-email-jason.wessel@windriver.com><1261603190-5036-9-git-send-email-jason.wessel@windriver.com><1261603190-5036-10-git-send-email-jason.wessel@windriver.com><8bd0f97a0912261312x4b7c7df6s14ac0137b702044e@mail.gmail.com><0F1B54C89D5F954D8535DB252AF412FA0553E3A0@chinexm1.ad.analog.com> <4e5ebad50912301845p35b1ea98l2f91c2a209ee863a@mail.gmail.com>
In-Reply-To: <4e5ebad50912301845p35b1ea98l2f91c2a209ee863a@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070508080802070709070809"
X-OriginalArrivalTime: 06 Jan 2010 19:43:30.0801 (UTC) FILETIME=[863B1610:01CA8F08]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070508080802070709070809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Sonic Zhang wrote:
> I have to recall my last wrong patch.
>
> In blackfin, kgdb is running in delayed exception IRQ5 other than in
> exception IRQ3 directly.  Register reti other than retx in pt_regs is
> the kgdb return address. So, don't put PC in gdb_regs into retx.
>
> Sonic Zhang
>
> Index: arch/blackfin/kernel/kgdb.c
> ============================
> --- arch/blackfin/kernel/kgdb.c	(revision 8105)
> +++ arch/blackfin/kernel/kgdb.c	(revision 8106)
> @@ -147,7 +147,7 @@
>  	regs->lb1 = gdb_regs[BFIN_LB1];
>  	regs->usp = gdb_regs[BFIN_USP];
>  	regs->syscfg = gdb_regs[BFIN_SYSCFG];
> -	regs->retx = gdb_regs[BFIN_PC];
> +	regs->retx = gdb_regs[BFIN_RETX];
>  	regs->retn = gdb_regs[BFIN_RETN];
>  	regs->rete = gdb_regs[BFIN_RETE];
>  	regs->pc = gdb_regs[BFIN_PC];
>
>   

Sonic,

I pulled in this patch, and made the changes the Mike talked about with
respect to cleaning up the arch specific kgdb.c for blackfin.  See the
attached patch.

Your patch and the one here will go into kgdb-next and onto linux-next.

At some point you sent a patch for cpu switching that was blackfin
specific.  There is new generic code in the debug core for doing this
without exiting the debug context.  At some point you should test this
and figure out if something further needs to be done that is blackfin
specific.

Thanks,
Jason.

--------------070508080802070709070809
Content-Type: text/x-diff;
 name="blackfin_kgdb_cleanup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="blackfin_kgdb_cleanup.patch"

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] maccess,blackfin,kgdb: Cleanup probe_kernel_read/write

Blackfin needs it own arch specific probe_kernel_read() and
probe_kernel_write().

This was moved out of the kgdb code and into the
arch/blackfin/maccess.c, because it is a generic kernel api.

The arch specific kgdb.c for blackfin was cleaned of all functions
which exist in the kgdb core that do the same thing after resolving
the probe_kernel_read() and probe_kernel_write().  This also
eliminated the need for most of the #include's.

CC: Mike Frysinger <vapier@gentoo.org>
CC: Sonic Zhang <sonic.adi@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 arch/blackfin/kernel/kgdb.c |  205 --------------------------------------------
 arch/blackfin/mm/Makefile   |    2 
 arch/blackfin/mm/maccess.c  |   97 ++++++++++++++++++++
 mm/maccess.c                |    2 
 4 files changed, 99 insertions(+), 207 deletions(-)

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
@@ -629,21 +439,6 @@ int kgdb_validate_break_address(unsigned
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
 void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 {
 	regs->retx = ip;
--- a/arch/blackfin/mm/Makefile
+++ b/arch/blackfin/mm/Makefile
@@ -2,4 +2,4 @@
 # arch/blackfin/mm/Makefile
 #
 
-obj-y := sram-alloc.o isram-driver.o init.o
+obj-y := sram-alloc.o isram-driver.o init.o maccess.o
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
+			case BFIN_MEM_ACCESS_CORE:
+			case BFIN_MEM_ACCESS_CORE_ONLY:
+				return probe_kernel_read(dst, src, size);
+			/* XXX: should support IDMA here with SMP */
+			case BFIN_MEM_ACCESS_DMA:
+				if (dma_memcpy(dst, src, size))
+					return 0;
+				break;
+			case BFIN_MEM_ACCESS_ITEST:
+				if (isram_memcpy(dst, src, size))
+					return 0;
+				break;
+		}
+	}
+
+	return -EFAULT;
+}
+
+long notrace probe_kernel_write(void *dst, void *src, size_t size)
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
+			case BFIN_MEM_ACCESS_CORE:
+			case BFIN_MEM_ACCESS_CORE_ONLY:
+				return probe_kernel_write(dst, src, size);
+			/* XXX: should support IDMA here with SMP */
+			case BFIN_MEM_ACCESS_DMA:
+				if (dma_memcpy(dst, src, size))
+					return 0;
+				break;
+			case BFIN_MEM_ACCESS_ITEST:
+				if (isram_memcpy(dst, src, size))
+					return 0;
+				break;
+		}
+	}
+
+	return -EFAULT;
+}
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -14,7 +14,7 @@
  * Safely read from address @src to the buffer at @dst.  If a kernel fault
  * happens, handle that and return -EFAULT.
  */
-long probe_kernel_read(void *dst, void *src, size_t size)
+long __weak probe_kernel_read(void *dst, void *src, size_t size)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();

--------------070508080802070709070809--

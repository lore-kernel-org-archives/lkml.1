Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbZFTSpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbZFTSpn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbZFTSpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:45:23 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47997 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456AbZFTSpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:45:18 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 01/25] Blackfin: unify memory region checks between kgdb and traps
Date: Sat, 20 Jun 2009 14:44:24 -0400
Message-Id: <1245523488-26536-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kgdb (in multiple places) and traps code developed pretty much
identical checks for how to access different regions of the Blackfin
memory map, but each wasn't 100%, so unify them to avoid duplication,
bitrot, and bugs with edge cases.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/uaccess.h |   22 +++
 arch/blackfin/kernel/kgdb.c         |  297 +++++++++++-----------------------
 arch/blackfin/kernel/process.c      |  151 ++++++++++++++----
 arch/blackfin/kernel/traps.c        |   60 ++-----
 4 files changed, 255 insertions(+), 275 deletions(-)

diff --git a/arch/blackfin/include/asm/uaccess.h b/arch/blackfin/include/asm/uaccess.h
index 8894e9f..2f469a1 100644
--- a/arch/blackfin/include/asm/uaccess.h
+++ b/arch/blackfin/include/asm/uaccess.h
@@ -265,4 +265,26 @@ __clear_user(void *to, unsigned long n)
 
 #define clear_user(to, n) __clear_user(to, n)
 
+/* How to interpret these return values:
+ *	CORE:      can be accessed by core load or dma memcpy
+ *	CORE_ONLY: can only be accessed by core load
+ *	DMA:       can only be accessed by dma memcpy
+ *	IDMA:      can only be accessed by interprocessor dma memcpy (BF561)
+ *	ITEST:     can be accessed by isram memcpy or dma memcpy
+ */
+enum {
+	BFIN_MEM_ACCESS_CORE = 0,
+	BFIN_MEM_ACCESS_CORE_ONLY,
+	BFIN_MEM_ACCESS_DMA,
+	BFIN_MEM_ACCESS_IDMA,
+	BFIN_MEM_ACCESS_ITEST,
+};
+/**
+ *	bfin_mem_access_type() - what kind of memory access is required
+ *	@addr:   the address to check
+ *	@size:   number of bytes needed
+ *	@return: <0 is error, >=0 is BFIN_MEM_ACCESS_xxx enum (see above)
+ */
+int bfin_mem_access_type(unsigned long addr, unsigned long size);
+
 #endif				/* _BLACKFIN_UACCESS_H */
diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
index da28f79..cce79d0 100644
--- a/arch/blackfin/kernel/kgdb.c
+++ b/arch/blackfin/kernel/kgdb.c
@@ -34,15 +34,6 @@ int gdb_bfin_vector = -1;
 #error change the definition of slavecpulocks
 #endif
 
-#define IN_MEM(addr, size, l1_addr, l1_size) \
-({ \
-	unsigned long __addr = (unsigned long)(addr); \
-	(l1_size && __addr >= l1_addr && __addr + (size) <= l1_addr + l1_size); \
-})
-#define ASYNC_BANK_SIZE \
-	(ASYNC_BANK0_SIZE + ASYNC_BANK1_SIZE + \
-	 ASYNC_BANK2_SIZE + ASYNC_BANK3_SIZE)
-
 void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
 {
 	gdb_regs[BFIN_R0] = regs->r0;
@@ -463,41 +454,88 @@ static int hex(char ch)
 
 static int validate_memory_access_address(unsigned long addr, int size)
 {
-	int cpu = raw_smp_processor_id();
-
-	if (size < 0)
+	if (size < 0 || addr == 0)
 		return -EFAULT;
-	if (addr >= 0x1000 && (addr + size) <= physical_mem_end)
-		return 0;
-	if (addr >= SYSMMR_BASE)
-		return 0;
-	if (IN_MEM(addr, size, ASYNC_BANK0_BASE, ASYNC_BANK_SIZE))
-		return 0;
-	if (cpu == 0) {
-		if (IN_MEM(addr, size, L1_SCRATCH_START, L1_SCRATCH_LENGTH))
-			return 0;
-		if (IN_MEM(addr, size, L1_CODE_START, L1_CODE_LENGTH))
-			return 0;
-		if (IN_MEM(addr, size, L1_DATA_A_START, L1_DATA_A_LENGTH))
-			return 0;
-		if (IN_MEM(addr, size, L1_DATA_B_START, L1_DATA_B_LENGTH))
-			return 0;
-#ifdef CONFIG_SMP
-	} else if (cpu == 1) {
-		if (IN_MEM(addr, size, COREB_L1_SCRATCH_START, L1_SCRATCH_LENGTH))
+	return bfin_mem_access_type(addr, size);
+}
+
+static int bfin_probe_kernel_read(char *dst, char *src, int size)
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
 			return 0;
-		if (IN_MEM(addr, size, COREB_L1_CODE_START, L1_CODE_LENGTH))
+		} else if (size == 4 && lsrc % 4 == 0) {
+			u32 mmr = bfin_read32(src);
+			memcpy(dst, &mmr, sizeof(mmr));
 			return 0;
-		if (IN_MEM(addr, size, COREB_L1_DATA_A_START, L1_DATA_A_LENGTH))
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
+static int bfin_probe_kernel_write(char *dst, char *src, int size)
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
 			return 0;
-		if (IN_MEM(addr, size, COREB_L1_DATA_B_START, L1_DATA_B_LENGTH))
+		} else if (size == 4 && ldst % 4 == 0) {
+			u32 mmr;
+			memcpy(&mmr, src, sizeof(mmr));
+			bfin_write32(dst, mmr);
 			return 0;
-#endif
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
 	}
 
-	if (IN_MEM(addr, size, L2_START, L2_LENGTH))
-		return 0;
-
 	return -EFAULT;
 }
 
@@ -509,14 +547,6 @@ int kgdb_mem2hex(char *mem, char *buf, int count)
 {
 	char *tmp;
 	int err;
-	unsigned char *pch;
-	unsigned short mmr16;
-	unsigned long mmr32;
-	int cpu = raw_smp_processor_id();
-
-	err = validate_memory_access_address((unsigned long)mem, count);
-	if (err)
-		return err;
 
 	/*
 	 * We use the upper half of buf as an intermediate buffer for the
@@ -524,44 +554,7 @@ int kgdb_mem2hex(char *mem, char *buf, int count)
 	 */
 	tmp = buf + count;
 
-	if ((unsigned int)mem >= SYSMMR_BASE) { /*access MMR registers*/
-		switch (count) {
-		case 2:
-			if ((unsigned int)mem % 2 == 0) {
-				mmr16 = *(unsigned short *)mem;
-				pch = (unsigned char *)&mmr16;
-				*tmp++ = *pch++;
-				*tmp++ = *pch++;
-				tmp -= 2;
-			} else
-				err = -EFAULT;
-			break;
-		case 4:
-			if ((unsigned int)mem % 4 == 0) {
-				mmr32 = *(unsigned long *)mem;
-				pch = (unsigned char *)&mmr32;
-				*tmp++ = *pch++;
-				*tmp++ = *pch++;
-				*tmp++ = *pch++;
-				*tmp++ = *pch++;
-				tmp -= 4;
-			} else
-				err = -EFAULT;
-			break;
-		default:
-			err = -EFAULT;
-		}
-	} else if ((cpu == 0 && IN_MEM(mem, count, L1_CODE_START, L1_CODE_LENGTH))
-#ifdef CONFIG_SMP
-		|| (cpu == 1 && IN_MEM(mem, count, COREB_L1_CODE_START, L1_CODE_LENGTH))
-#endif
-		) {
-		/* access L1 instruction SRAM*/
-		if (dma_memcpy(tmp, mem, count) == NULL)
-			err = -EFAULT;
-	} else
-		err = probe_kernel_read(tmp, mem, count);
-
+	err = bfin_probe_kernel_read(tmp, mem, count);
 	if (!err) {
 		while (count > 0) {
 			buf = pack_hex_byte(buf, *tmp);
@@ -582,13 +575,8 @@ int kgdb_mem2hex(char *mem, char *buf, int count)
  */
 int kgdb_ebin2mem(char *buf, char *mem, int count)
 {
-	char *tmp_old;
-	char *tmp_new;
-	unsigned short *mmr16;
-	unsigned long *mmr32;
-	int err;
+	char *tmp_old, *tmp_new;
 	int size;
-	int cpu = raw_smp_processor_id();
 
 	tmp_old = tmp_new = buf;
 
@@ -601,41 +589,7 @@ int kgdb_ebin2mem(char *buf, char *mem, int count)
 		tmp_old++;
 	}
 
-	err = validate_memory_access_address((unsigned long)mem, size);
-	if (err)
-		return err;
-
-	if ((unsigned int)mem >= SYSMMR_BASE) { /*access MMR registers*/
-		switch (size) {
-		case 2:
-			if ((unsigned int)mem % 2 == 0) {
-				mmr16 = (unsigned short *)buf;
-				*(unsigned short *)mem = *mmr16;
-			} else
-				err = -EFAULT;
-			break;
-		case 4:
-			if ((unsigned int)mem % 4 == 0) {
-				mmr32 = (unsigned long *)buf;
-				*(unsigned long *)mem = *mmr32;
-			} else
-				err = -EFAULT;
-			break;
-		default:
-			err = -EFAULT;
-		}
-	} else if ((cpu == 0 && IN_MEM(mem, count, L1_CODE_START, L1_CODE_LENGTH))
-#ifdef CONFIG_SMP
-		|| (cpu == 1 && IN_MEM(mem, count, COREB_L1_CODE_START, L1_CODE_LENGTH))
-#endif
-		) {
-		/* access L1 instruction SRAM */
-		if (dma_memcpy(mem, buf, size) == NULL)
-			err = -EFAULT;
-	} else
-		err = probe_kernel_write(mem, buf, size);
-
-	return err;
+	return bfin_probe_kernel_write(mem, buf, count);
 }
 
 /*
@@ -645,16 +599,7 @@ int kgdb_ebin2mem(char *buf, char *mem, int count)
  */
 int kgdb_hex2mem(char *buf, char *mem, int count)
 {
-	char *tmp_raw;
-	char *tmp_hex;
-	unsigned short *mmr16;
-	unsigned long *mmr32;
-	int err;
-	int cpu = raw_smp_processor_id();
-
-	err = validate_memory_access_address((unsigned long)mem, count);
-	if (err)
-		return err;
+	char *tmp_raw, *tmp_hex;
 
 	/*
 	 * We use the upper half of buf as an intermediate buffer for the
@@ -669,39 +614,18 @@ int kgdb_hex2mem(char *buf, char *mem, int count)
 		*tmp_raw |= hex(*tmp_hex--) << 4;
 	}
 
-	if ((unsigned int)mem >= SYSMMR_BASE) { /*access MMR registers*/
-		switch (count) {
-		case 2:
-			if ((unsigned int)mem % 2 == 0) {
-				mmr16 = (unsigned short *)tmp_raw;
-				*(unsigned short *)mem = *mmr16;
-			} else
-				err = -EFAULT;
-			break;
-		case 4:
-			if ((unsigned int)mem % 4 == 0) {
-				mmr32 = (unsigned long *)tmp_raw;
-				*(unsigned long *)mem = *mmr32;
-			} else
-				err = -EFAULT;
-			break;
-		default:
-			err = -EFAULT;
-		}
-	} else if ((cpu == 0 && IN_MEM(mem, count, L1_CODE_START, L1_CODE_LENGTH))
-#ifdef CONFIG_SMP
-		|| (cpu == 1 && IN_MEM(mem, count, COREB_L1_CODE_START, L1_CODE_LENGTH))
-#endif
-		) {
-		/* access L1 instruction SRAM */
-		if (dma_memcpy(mem, tmp_raw, count) == NULL)
-			err = -EFAULT;
-	} else
-		err = probe_kernel_write(mem, tmp_raw, count);
-
-	return err;
+	return bfin_probe_kernel_write(mem, tmp_raw, count);
 }
 
+#define IN_MEM(addr, size, l1_addr, l1_size) \
+({ \
+	unsigned long __addr = (unsigned long)(addr); \
+	(l1_size && __addr >= l1_addr && __addr + (size) <= l1_addr + l1_size); \
+})
+#define ASYNC_BANK_SIZE \
+	(ASYNC_BANK0_SIZE + ASYNC_BANK1_SIZE + \
+	 ASYNC_BANK2_SIZE + ASYNC_BANK3_SIZE)
+
 int kgdb_validate_break_address(unsigned long addr)
 {
 	int cpu = raw_smp_processor_id();
@@ -724,46 +648,17 @@ int kgdb_validate_break_address(unsigned long addr)
 
 int kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr)
 {
-	int err;
-	int cpu = raw_smp_processor_id();
-
-	if ((cpu == 0 && IN_MEM(addr, BREAK_INSTR_SIZE, L1_CODE_START, L1_CODE_LENGTH))
-#ifdef CONFIG_SMP
-		|| (cpu == 1 && IN_MEM(addr, BREAK_INSTR_SIZE, COREB_L1_CODE_START, L1_CODE_LENGTH))
-#endif
-		) {
-		/* access L1 instruction SRAM */
-		if (dma_memcpy(saved_instr, (void *)addr, BREAK_INSTR_SIZE)
-			== NULL)
-			return -EFAULT;
-
-		if (dma_memcpy((void *)addr, arch_kgdb_ops.gdb_bpt_instr,
-			BREAK_INSTR_SIZE) == NULL)
-			return -EFAULT;
-
-		return 0;
-	} else {
-		err = probe_kernel_read(saved_instr, (char *)addr,
-			BREAK_INSTR_SIZE);
-		if (err)
-			return err;
-
-		return probe_kernel_write((char *)addr,
-			arch_kgdb_ops.gdb_bpt_instr, BREAK_INSTR_SIZE);
-	}
+	int err = bfin_probe_kernel_read(saved_instr, (char *)addr,
+	                                 BREAK_INSTR_SIZE);
+	if (err)
+		return err;
+	return bfin_probe_kernel_write((char *)addr, arch_kgdb_ops.gdb_bpt_instr,
+	                               BREAK_INSTR_SIZE);
 }
 
 int kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle)
 {
-	if (IN_MEM(addr, BREAK_INSTR_SIZE, L1_CODE_START, L1_CODE_LENGTH)) {
-		/* access L1 instruction SRAM */
-		if (dma_memcpy((void *)addr, bundle, BREAK_INSTR_SIZE) == NULL)
-			return -EFAULT;
-
-		return 0;
-	} else
-		return probe_kernel_write((char *)addr,
-				(char *)bundle, BREAK_INSTR_SIZE);
+	return bfin_probe_kernel_write((char *)addr, bundle, BREAK_INSTR_SIZE);
 }
 
 int kgdb_arch_init(void)
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 3e1d86e..32ed8d3 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -344,6 +344,87 @@ void finish_atomic_sections (struct pt_regs *regs)
 	}
 }
 
+static inline
+int in_mem(unsigned long addr, unsigned long size,
+           unsigned long start, unsigned long end)
+{
+	return addr >= start && addr + size <= end;
+}
+static inline
+int in_mem_const_off(unsigned long addr, unsigned long size, unsigned long off,
+                     unsigned long const_addr, unsigned long const_size)
+{
+	return const_size &&
+	       in_mem(addr, size, const_addr + off, const_addr + const_size);
+}
+static inline
+int in_mem_const(unsigned long addr, unsigned long size,
+                 unsigned long const_addr, unsigned long const_size)
+{
+	return in_mem_const_off(addr, 0, size, const_addr, const_size);
+}
+#define IN_ASYNC(bnum, bctlnum) \
+({ \
+	(bfin_read_EBIU_AMGCTL() & 0xe) < ((bnum + 1) << 1) ? -EFAULT : \
+	bfin_read_EBIU_AMBCTL##bctlnum() & B##bnum##RDYEN ? -EFAULT : \
+	BFIN_MEM_ACCESS_CORE; \
+})
+
+int bfin_mem_access_type(unsigned long addr, unsigned long size)
+{
+	int cpu = raw_smp_processor_id();
+
+	/* Check that things do not wrap around */
+	if (addr > ULONG_MAX - size)
+		return -EFAULT;
+
+	if (in_mem(addr, size, FIXED_CODE_START, physical_mem_end))
+		return BFIN_MEM_ACCESS_CORE;
+
+	if (in_mem_const(addr, size, L1_CODE_START, L1_CODE_LENGTH))
+		return cpu == 0 ? BFIN_MEM_ACCESS_ITEST : BFIN_MEM_ACCESS_IDMA;
+	if (in_mem_const(addr, size, L1_SCRATCH_START, L1_SCRATCH_LENGTH))
+		return cpu == 0 ? BFIN_MEM_ACCESS_CORE_ONLY : -EFAULT;
+	if (in_mem_const(addr, size, L1_DATA_A_START, L1_DATA_A_LENGTH))
+		return cpu == 0 ? BFIN_MEM_ACCESS_CORE : BFIN_MEM_ACCESS_IDMA;
+	if (in_mem_const(addr, size, L1_DATA_B_START, L1_DATA_B_LENGTH))
+		return cpu == 0 ? BFIN_MEM_ACCESS_CORE : BFIN_MEM_ACCESS_IDMA;
+#ifdef COREB_L1_CODE_START
+	if (in_mem_const(addr, size, COREB_L1_CODE_START, L1_CODE_LENGTH))
+		return cpu == 1 ? BFIN_MEM_ACCESS_ITEST : BFIN_MEM_ACCESS_IDMA;
+	if (in_mem_const(addr, size, COREB_L1_SCRATCH_START, L1_SCRATCH_LENGTH))
+		return cpu == 1 ? BFIN_MEM_ACCESS_CORE_ONLY : -EFAULT;
+	if (in_mem_const(addr, size, COREB_L1_DATA_A_START, L1_DATA_A_LENGTH))
+		return cpu == 1 ? BFIN_MEM_ACCESS_CORE : BFIN_MEM_ACCESS_IDMA;
+	if (in_mem_const(addr, size, COREB_L1_DATA_B_START, L1_DATA_B_LENGTH))
+		return cpu == 1 ? BFIN_MEM_ACCESS_CORE : BFIN_MEM_ACCESS_IDMA;
+#endif
+	if (in_mem_const(addr, size, L2_START, L2_LENGTH))
+		return BFIN_MEM_ACCESS_CORE;
+
+	if (addr >= SYSMMR_BASE)
+		return BFIN_MEM_ACCESS_CORE_ONLY;
+
+	/* We can't read EBIU banks that aren't enabled or we end up hanging
+	 * on the access to the async space.
+	 */
+	if (in_mem_const(addr, size, ASYNC_BANK0_BASE, ASYNC_BANK0_SIZE))
+		return IN_ASYNC(0, 0);
+	if (in_mem_const(addr, size, ASYNC_BANK1_BASE, ASYNC_BANK1_SIZE))
+		return IN_ASYNC(1, 0);
+	if (in_mem_const(addr, size, ASYNC_BANK2_BASE, ASYNC_BANK2_SIZE))
+		return IN_ASYNC(2, 1);
+	if (in_mem_const(addr, size, ASYNC_BANK3_BASE, ASYNC_BANK3_SIZE))
+		return IN_ASYNC(3, 1);
+
+	if (in_mem_const(addr, size, BOOT_ROM_START, BOOT_ROM_LENGTH))
+		return BFIN_MEM_ACCESS_CORE;
+	if (in_mem_const(addr, size, L1_ROM_START, L1_ROM_LENGTH))
+		return BFIN_MEM_ACCESS_DMA;
+
+	return -EFAULT;
+}
+
 #if defined(CONFIG_ACCESS_CHECK)
 #ifdef CONFIG_ACCESS_OK_L1
 __attribute__((l1_text))
@@ -353,51 +434,59 @@ int _access_ok(unsigned long addr, unsigned long size)
 {
 	if (size == 0)
 		return 1;
-	if (addr > (addr + size))
+	/* Check that things do not wrap around */
+	if (addr > ULONG_MAX - size)
 		return 0;
 	if (segment_eq(get_fs(), KERNEL_DS))
 		return 1;
-#ifdef CONFIG_MTD_UCLINUX
-	if (addr >= memory_start && (addr + size) <= memory_end)
-		return 1;
-	if (addr >= memory_mtd_end && (addr + size) <= physical_mem_end)
+#ifndef CONFIG_MTD_UCLINUX
+	if (0)
+#endif
+	{
+		if (in_mem(addr, size, memory_start, memory_end))
+			return 1;
+		if (in_mem(addr, size, memory_mtd_end, physical_mem_end))
+			return 1;
+# ifndef CONFIG_ROMFS_ON_MTD
+		if (0)
+# endif
+			/* For XIP, allow user space to use pointers within the ROMFS.  */
+			if (in_mem(addr, size, memory_mtd_start, memory_mtd_end))
+				return 1;
+	} else {
+		if (in_mem(addr, size, memory_start, physical_mem_end))
+			return 1;
+	}
+
+	if (in_mem(addr, size, (unsigned long)__init_begin, (unsigned long)__init_end))
 		return 1;
 
-#ifdef CONFIG_ROMFS_ON_MTD
-	/* For XIP, allow user space to use pointers within the ROMFS.  */
-	if (addr >= memory_mtd_start && (addr + size) <= memory_mtd_end)
+	if (in_mem_const(addr, size, L1_CODE_START, L1_CODE_LENGTH))
 		return 1;
-#endif
-#else
-	if (addr >= memory_start && (addr + size) <= physical_mem_end)
+	if (in_mem_const_off(addr, size, _etext_l1 - _stext_l1, L1_CODE_START, L1_CODE_LENGTH))
 		return 1;
-#endif
-	if (addr >= (unsigned long)__init_begin &&
-	    addr + size <= (unsigned long)__init_end)
+	if (in_mem_const_off(addr, size, _ebss_l1 - _sdata_l1, L1_DATA_A_START, L1_DATA_A_LENGTH))
 		return 1;
-	if (addr >= get_l1_scratch_start()
-	    && addr + size <= get_l1_scratch_start() + L1_SCRATCH_LENGTH)
+	if (in_mem_const_off(addr, size, _ebss_b_l1 - _sdata_b_l1, L1_DATA_B_START, L1_DATA_B_LENGTH))
 		return 1;
-#if L1_CODE_LENGTH != 0
-	if (addr >= get_l1_code_start() + (_etext_l1 - _stext_l1)
-	    && addr + size <= get_l1_code_start() + L1_CODE_LENGTH)
+#ifdef COREB_L1_CODE_START
+	if (in_mem_const(addr, size, COREB_L1_CODE_START, L1_CODE_LENGTH))
 		return 1;
-#endif
-#if L1_DATA_A_LENGTH != 0
-	if (addr >= get_l1_data_a_start() + (_ebss_l1 - _sdata_l1)
-	    && addr + size <= get_l1_data_a_start() + L1_DATA_A_LENGTH)
+	if (in_mem_const(addr, size, COREB_L1_SCRATCH_START, L1_SCRATCH_LENGTH))
 		return 1;
-#endif
-#if L1_DATA_B_LENGTH != 0
-	if (addr >= get_l1_data_b_start() + (_ebss_b_l1 - _sdata_b_l1)
-	    && addr + size <= get_l1_data_b_start() + L1_DATA_B_LENGTH)
+	if (in_mem_const(addr, size, COREB_L1_DATA_A_START, L1_DATA_A_LENGTH))
 		return 1;
-#endif
-#if L2_LENGTH != 0
-	if (addr >= L2_START + (_ebss_l2 - _stext_l2)
-	    && addr + size <= L2_START + L2_LENGTH)
+	if (in_mem_const(addr, size, COREB_L1_DATA_B_START, L1_DATA_B_LENGTH))
 		return 1;
 #endif
+	if (in_mem_const_off(addr, size, _ebss_l2 - _stext_l2, L2_START, L2_LENGTH))
+		return 1;
+
+	if (in_mem_const(addr, size, BOOT_ROM_START, BOOT_ROM_LENGTH))
+		return 1;
+	if (in_mem_const(addr, size, L1_ROM_START, L1_ROM_LENGTH))
+		return 1;
+
 	return 0;
 }
 EXPORT_SYMBOL(_access_ok);
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index d279552..8eeb457 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -37,6 +37,7 @@
 #include <asm/traps.h>
 #include <asm/cacheflush.h>
 #include <asm/cplb.h>
+#include <asm/dma.h>
 #include <asm/blackfin.h>
 #include <asm/irq_handler.h>
 #include <linux/irq.h>
@@ -636,57 +637,30 @@ asmlinkage void trap_c(struct pt_regs *fp)
  */
 static bool get_instruction(unsigned short *val, unsigned short *address)
 {
-
-	unsigned long addr;
-
-	addr = (unsigned long)address;
+	unsigned long addr = (unsigned long)address;
 
 	/* Check for odd addresses */
 	if (addr & 0x1)
 		return false;
 
-	/* Check that things do not wrap around */
-	if (addr > (addr + 2))
+	/* MMR region will never have instructions */
+	if (addr >= SYSMMR_BASE)
 		return false;
 
-	/*
-	 * Since we are in exception context, we need to do a little address checking
-	 * We need to make sure we are only accessing valid memory, and
-	 * we don't read something in the async space that can hang forever
-	 */
-	if ((addr >= FIXED_CODE_START && (addr + 2) <= physical_mem_end) ||
-#if L2_LENGTH != 0
-	    (addr >= L2_START && (addr + 2) <= (L2_START + L2_LENGTH)) ||
-#endif
-	    (addr >= BOOT_ROM_START && (addr + 2) <= (BOOT_ROM_START + BOOT_ROM_LENGTH)) ||
-#if L1_DATA_A_LENGTH != 0
-	    (addr >= L1_DATA_A_START && (addr + 2) <= (L1_DATA_A_START + L1_DATA_A_LENGTH)) ||
-#endif
-#if L1_DATA_B_LENGTH != 0
-	    (addr >= L1_DATA_B_START && (addr + 2) <= (L1_DATA_B_START + L1_DATA_B_LENGTH)) ||
-#endif
-	    (addr >= L1_SCRATCH_START && (addr + 2) <= (L1_SCRATCH_START + L1_SCRATCH_LENGTH)) ||
-	    (!(bfin_read_EBIU_AMBCTL0() & B0RDYEN) &&
-	       addr >= ASYNC_BANK0_BASE && (addr + 2) <= (ASYNC_BANK0_BASE + ASYNC_BANK0_SIZE)) ||
-	    (!(bfin_read_EBIU_AMBCTL0() & B1RDYEN) &&
-	       addr >= ASYNC_BANK1_BASE && (addr + 2) <= (ASYNC_BANK1_BASE + ASYNC_BANK1_SIZE)) ||
-	    (!(bfin_read_EBIU_AMBCTL1() & B2RDYEN) &&
-	       addr >= ASYNC_BANK2_BASE && (addr + 2) <= (ASYNC_BANK2_BASE + ASYNC_BANK1_SIZE)) ||
-	    (!(bfin_read_EBIU_AMBCTL1() & B3RDYEN) &&
-	      addr >= ASYNC_BANK3_BASE && (addr + 2) <= (ASYNC_BANK3_BASE + ASYNC_BANK1_SIZE))) {
-		*val = *address;
-		return true;
+	switch (bfin_mem_access_type(addr, 2)) {
+		case BFIN_MEM_ACCESS_CORE:
+		case BFIN_MEM_ACCESS_CORE_ONLY:
+			*val = *address;
+			return true;
+		case BFIN_MEM_ACCESS_DMA:
+			dma_memcpy(val, address, 2);
+			return true;
+		case BFIN_MEM_ACCESS_ITEST:
+			isram_memcpy(val, address, 2);
+			return true;
+		default: /* invalid access */
+			return false;
 	}
-
-#if L1_CODE_LENGTH != 0
-	if (addr >= L1_CODE_START && (addr + 2) <= (L1_CODE_START + L1_CODE_LENGTH)) {
-		isram_memcpy(val, address, 2);
-		return true;
-	}
-#endif
-
-
-	return false;
 }
 
 /*
-- 
1.6.3.1


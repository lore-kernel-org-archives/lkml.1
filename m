Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbZFEIZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbZFEIZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbZFEIHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:07:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37594 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755669AbZFEIGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:12 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 58/62] Blackfin: kgdb: fix up error return values
Date: Fri,  5 Jun 2009 04:05:07 -0400
Message-Id: <1244189111-19639-59-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Blackfin kgdb code was all passing back positive errno values when it
really should have been using negative errno values.

Reported-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/kgdb.c |   55 +++++++++++++++++++++++-------------------
 1 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
index b163f6d..c5362b2 100644
--- a/arch/blackfin/kernel/kgdb.c
+++ b/arch/blackfin/kernel/kgdb.c
@@ -466,7 +466,7 @@ static int validate_memory_access_address(unsigned long addr, int size)
 	int cpu = raw_smp_processor_id();
 
 	if (size < 0)
-		return EFAULT;
+		return -EFAULT;
 	if (addr >= 0x1000 && (addr + size) <= physical_mem_end)
 		return 0;
 	if (addr >= SYSMMR_BASE)
@@ -498,7 +498,7 @@ static int validate_memory_access_address(unsigned long addr, int size)
 	if (IN_MEM(addr, size, L2_START, L2_LENGTH))
 		return 0;
 
-	return EFAULT;
+	return -EFAULT;
 }
 
 /*
@@ -508,14 +508,15 @@ static int validate_memory_access_address(unsigned long addr, int size)
 int kgdb_mem2hex(char *mem, char *buf, int count)
 {
 	char *tmp;
-	int err = 0;
+	int err;
 	unsigned char *pch;
 	unsigned short mmr16;
 	unsigned long mmr32;
 	int cpu = raw_smp_processor_id();
 
-	if (validate_memory_access_address((unsigned long)mem, count))
-		return EFAULT;
+	err = validate_memory_access_address((unsigned long)mem, count);
+	if (err)
+		return err;
 
 	/*
 	 * We use the upper half of buf as an intermediate buffer for the
@@ -533,7 +534,7 @@ int kgdb_mem2hex(char *mem, char *buf, int count)
 				*tmp++ = *pch++;
 				tmp -= 2;
 			} else
-				err = EFAULT;
+				err = -EFAULT;
 			break;
 		case 4:
 			if ((unsigned int)mem % 4 == 0) {
@@ -545,10 +546,10 @@ int kgdb_mem2hex(char *mem, char *buf, int count)
 				*tmp++ = *pch++;
 				tmp -= 4;
 			} else
-				err = EFAULT;
+				err = -EFAULT;
 			break;
 		default:
-			err = EFAULT;
+			err = -EFAULT;
 		}
 	} else if ((cpu == 0 && IN_MEM(mem, count, L1_CODE_START, L1_CODE_LENGTH))
 #ifdef CONFIG_SMP
@@ -557,7 +558,7 @@ int kgdb_mem2hex(char *mem, char *buf, int count)
 		) {
 		/* access L1 instruction SRAM*/
 		if (dma_memcpy(tmp, mem, count) == NULL)
-			err = EFAULT;
+			err = -EFAULT;
 	} else
 		err = probe_kernel_read(tmp, mem, count);
 
@@ -585,7 +586,7 @@ int kgdb_ebin2mem(char *buf, char *mem, int count)
 	char *tmp_new;
 	unsigned short *mmr16;
 	unsigned long *mmr32;
-	int err = 0;
+	int err;
 	int size = 0;
 	int cpu = raw_smp_processor_id();
 
@@ -601,8 +602,9 @@ int kgdb_ebin2mem(char *buf, char *mem, int count)
 		size++;
 	}
 
-	if (validate_memory_access_address((unsigned long)mem, size))
-		return EFAULT;
+	err = validate_memory_access_address((unsigned long)mem, size);
+	if (err)
+		return err;
 
 	if ((unsigned int)mem >= SYSMMR_BASE) { /*access MMR registers*/
 		switch (size) {
@@ -611,17 +613,17 @@ int kgdb_ebin2mem(char *buf, char *mem, int count)
 				mmr16 = (unsigned short *)buf;
 				*(unsigned short *)mem = *mmr16;
 			} else
-				return EFAULT;
+				err = -EFAULT;
 			break;
 		case 4:
 			if ((unsigned int)mem % 4 == 0) {
 				mmr32 = (unsigned long *)buf;
 				*(unsigned long *)mem = *mmr32;
 			} else
-				return EFAULT;
+				err = -EFAULT;
 			break;
 		default:
-			return EFAULT;
+			err = -EFAULT;
 		}
 	} else if ((cpu == 0 && IN_MEM(mem, count, L1_CODE_START, L1_CODE_LENGTH))
 #ifdef CONFIG_SMP
@@ -630,7 +632,7 @@ int kgdb_ebin2mem(char *buf, char *mem, int count)
 		) {
 		/* access L1 instruction SRAM */
 		if (dma_memcpy(mem, buf, size) == NULL)
-			err = EFAULT;
+			err = -EFAULT;
 	} else
 		err = probe_kernel_write(mem, buf, size);
 
@@ -648,10 +650,12 @@ int kgdb_hex2mem(char *buf, char *mem, int count)
 	char *tmp_hex;
 	unsigned short *mmr16;
 	unsigned long *mmr32;
+	int err;
 	int cpu = raw_smp_processor_id();
 
-	if (validate_memory_access_address((unsigned long)mem, count))
-		return EFAULT;
+	err = validate_memory_access_address((unsigned long)mem, count);
+	if (err)
+		return err;
 
 	/*
 	 * We use the upper half of buf as an intermediate buffer for the
@@ -673,17 +677,17 @@ int kgdb_hex2mem(char *buf, char *mem, int count)
 				mmr16 = (unsigned short *)tmp_raw;
 				*(unsigned short *)mem = *mmr16;
 			} else
-				return EFAULT;
+				err = -EFAULT;
 			break;
 		case 4:
 			if ((unsigned int)mem % 4 == 0) {
 				mmr32 = (unsigned long *)tmp_raw;
 				*(unsigned long *)mem = *mmr32;
 			} else
-				return EFAULT;
+				err = -EFAULT;
 			break;
 		default:
-			return EFAULT;
+			err = -EFAULT;
 		}
 	} else if ((cpu == 0 && IN_MEM(mem, count, L1_CODE_START, L1_CODE_LENGTH))
 #ifdef CONFIG_SMP
@@ -692,10 +696,11 @@ int kgdb_hex2mem(char *buf, char *mem, int count)
 		) {
 		/* access L1 instruction SRAM */
 		if (dma_memcpy(mem, tmp_raw, count) == NULL)
-			return EFAULT;
+			err = -EFAULT;
 	} else
-		return probe_kernel_write(mem, tmp_raw, count);
-	return 0;
+		err = probe_kernel_write(mem, tmp_raw, count);
+
+	return err;
 }
 
 int kgdb_validate_break_address(unsigned long addr)
@@ -715,7 +720,7 @@ int kgdb_validate_break_address(unsigned long addr)
 	if (IN_MEM(addr, BREAK_INSTR_SIZE, L2_START, L2_LENGTH))
 		return 0;
 
-	return EFAULT;
+	return -EFAULT;
 }
 
 int kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr)
-- 
1.6.3.1


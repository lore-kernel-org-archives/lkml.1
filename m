Return-Path: <linux-kernel-owner+w=401wt.eu-S1759562AbZFTSt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbZFTSt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758085AbZFTSrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:47:10 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48175 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758126AbZFTSrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:47:07 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 19/25] Blackfin: unify memory map headers
Date: Sat, 20 Jun 2009 14:44:42 -0400
Message-Id: <1245523488-26536-20-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many aspects of the Blackfin memory map is exactly the same across all
variants.  Rather than copy and paste all of these duplicated values in
each header, unify all of these into the common Blackfin memory map header
file.  In the process, push down BF561 SMP specific stuff to the BF561
specific header to keep the noise down.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/blackfin.h             |    1 +
 arch/blackfin/include/asm/mem_map.h              |   97 +++++++++++-----------
 arch/blackfin/mach-bf518/include/mach/blackfin.h |    1 -
 arch/blackfin/mach-bf518/include/mach/mem_map.h  |   56 ++-----------
 arch/blackfin/mach-bf527/include/mach/blackfin.h |    1 -
 arch/blackfin/mach-bf527/include/mach/mem_map.h  |   56 ++-----------
 arch/blackfin/mach-bf533/include/mach/blackfin.h |    1 -
 arch/blackfin/mach-bf533/include/mach/mem_map.h  |   56 ++-----------
 arch/blackfin/mach-bf537/include/mach/blackfin.h |    1 -
 arch/blackfin/mach-bf537/include/mach/mem_map.h  |   56 ++-----------
 arch/blackfin/mach-bf538/include/mach/blackfin.h |    1 -
 arch/blackfin/mach-bf538/include/mach/mem_map.h  |   57 ++-----------
 arch/blackfin/mach-bf548/include/mach/blackfin.h |    1 -
 arch/blackfin/mach-bf548/include/mach/mem_map.h  |   51 ++---------
 arch/blackfin/mach-bf561/include/mach/blackfin.h |    1 -
 arch/blackfin/mach-bf561/include/mach/mem_map.h  |   58 ++++++++++----
 16 files changed, 145 insertions(+), 350 deletions(-)

diff --git a/arch/blackfin/include/asm/blackfin.h b/arch/blackfin/include/asm/blackfin.h
index 8bb2cb1..4d44395 100644
--- a/arch/blackfin/include/asm/blackfin.h
+++ b/arch/blackfin/include/asm/blackfin.h
@@ -86,6 +86,7 @@ static inline void CSYNC(void)
 
 #endif /* __ASSEMBLY__ */
 
+#include <asm/mem_map.h>
 #include <mach/blackfin.h>
 #include <asm/bfin-global.h>
 
diff --git a/arch/blackfin/include/asm/mem_map.h b/arch/blackfin/include/asm/mem_map.h
index e92b310..5e21627 100644
--- a/arch/blackfin/include/asm/mem_map.h
+++ b/arch/blackfin/include/asm/mem_map.h
@@ -1,87 +1,84 @@
 /*
- * mem_map.h
- * Common header file for blackfin family of processors.
+ * Common Blackfin memory map
  *
+ * Copyright 2004-2009 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
  */
 
-#ifndef _MEM_MAP_H_
-#define _MEM_MAP_H_
+#ifndef __BFIN_MEM_MAP_H__
+#define __BFIN_MEM_MAP_H__
 
 #include <mach/mem_map.h>
 
-#ifndef __ASSEMBLY__
+/* Every Blackfin so far has MMRs like this */
+#ifndef COREMMR_BASE
+# define COREMMR_BASE 0xFFE00000
+#endif
+#ifndef SYSMMR_BASE
+# define SYSMMR_BASE  0xFFC00000
+#endif
 
-#ifdef CONFIG_SMP
-static inline ulong get_l1_scratch_start_cpu(int cpu)
-{
-	return (cpu) ? COREB_L1_SCRATCH_START : COREA_L1_SCRATCH_START;
-}
-static inline ulong get_l1_code_start_cpu(int cpu)
-{
-	return (cpu) ? COREB_L1_CODE_START : COREA_L1_CODE_START;
-}
-static inline ulong get_l1_data_a_start_cpu(int cpu)
-{
-	return (cpu) ? COREB_L1_DATA_A_START : COREA_L1_DATA_A_START;
-}
-static inline ulong get_l1_data_b_start_cpu(int cpu)
-{
-	return (cpu) ? COREB_L1_DATA_B_START : COREA_L1_DATA_B_START;
-}
+/* Every Blackfin so far has on-chip Scratch Pad SRAM like this */
+#ifndef L1_SCRATCH_START
+# define L1_SCRATCH_START  0xFFB00000
+# define L1_SCRATCH_LENGTH 0x1000
+#endif
 
-static inline ulong get_l1_scratch_start(void)
-{
-	return get_l1_scratch_start_cpu(blackfin_core_id());
-}
-static inline ulong get_l1_code_start(void)
-{
-	return get_l1_code_start_cpu(blackfin_core_id());
-}
-static inline ulong get_l1_data_a_start(void)
-{
-	return get_l1_data_a_start_cpu(blackfin_core_id());
-}
-static inline ulong get_l1_data_b_start(void)
-{
-	return get_l1_data_b_start_cpu(blackfin_core_id());
-}
+/* Most parts lack on-chip L2 SRAM */
+#ifndef L2_START
+# define L2_START  0
+# define L2_LENGTH 0
+#endif
+
+/* Most parts lack on-chip L1 ROM */
+#ifndef L1_ROM_START
+# define L1_ROM_START  0
+# define L1_ROM_LENGTH 0
+#endif
+
+/* Allow wonky SMP ports to override this */
+#ifndef GET_PDA_SAFE
+# define GET_PDA_SAFE(preg) \
+	preg.l = _cpu_pda; \
+	preg.h = _cpu_pda;
+# define GET_PDA(preg, dreg) GET_PDA_SAFE(preg)
 
-#else /* !CONFIG_SMP */
+# ifndef __ASSEMBLY__
 
-static inline ulong get_l1_scratch_start_cpu(int cpu)
+static inline unsigned long get_l1_scratch_start_cpu(int cpu)
 {
 	return L1_SCRATCH_START;
 }
-static inline ulong get_l1_code_start_cpu(int cpu)
+static inline unsigned long get_l1_code_start_cpu(int cpu)
 {
 	return L1_CODE_START;
 }
-static inline ulong get_l1_data_a_start_cpu(int cpu)
+static inline unsigned long get_l1_data_a_start_cpu(int cpu)
 {
 	return L1_DATA_A_START;
 }
-static inline ulong get_l1_data_b_start_cpu(int cpu)
+static inline unsigned long get_l1_data_b_start_cpu(int cpu)
 {
 	return L1_DATA_B_START;
 }
-static inline ulong get_l1_scratch_start(void)
+static inline unsigned long get_l1_scratch_start(void)
 {
 	return get_l1_scratch_start_cpu(0);
 }
-static inline ulong get_l1_code_start(void)
+static inline unsigned long get_l1_code_start(void)
 {
 	return  get_l1_code_start_cpu(0);
 }
-static inline ulong get_l1_data_a_start(void)
+static inline unsigned long get_l1_data_a_start(void)
 {
 	return get_l1_data_a_start_cpu(0);
 }
-static inline ulong get_l1_data_b_start(void)
+static inline unsigned long get_l1_data_b_start(void)
 {
 	return get_l1_data_b_start_cpu(0);
 }
 
-#endif /* CONFIG_SMP */
-#endif /* __ASSEMBLY__ */
+# endif /* __ASSEMBLY__ */
+#endif /* !GET_PDA_SAFE */
 
-#endif				/* _MEM_MAP_H_ */
+#endif
diff --git a/arch/blackfin/mach-bf518/include/mach/blackfin.h b/arch/blackfin/mach-bf518/include/mach/blackfin.h
index 267bb7c..e8e14c2 100644
--- a/arch/blackfin/mach-bf518/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf518/include/mach/blackfin.h
@@ -33,7 +33,6 @@
 #define _MACH_BLACKFIN_H_
 
 #include "bf518.h"
-#include "mem_map.h"
 #include "defBF512.h"
 #include "anomaly.h"
 
diff --git a/arch/blackfin/mach-bf518/include/mach/mem_map.h b/arch/blackfin/mach-bf518/include/mach/mem_map.h
index 62bcc78..3c6777c 100644
--- a/arch/blackfin/mach-bf518/include/mach/mem_map.h
+++ b/arch/blackfin/mach-bf518/include/mach/mem_map.h
@@ -1,38 +1,16 @@
 /*
- * file:         include/asm-blackfin/mach-bf518/mem_map.h
- * based on:	include/asm-blackfin/mach-bf527/mem_map.h
- * author:	Bryan Wu <cooloney@kernel.org>
+ * BF51x memory map
  *
- * created:
- * description:
- *	Memory MAP Common header file for blackfin BF518/6/4/2 of processors.
- * rev:
- *
- * modified:
- *
- * bugs:         enter bugs at http://blackfin.uclinux.org/
- *
- * this program is free software; you can redistribute it and/or modify
- * it under the terms of the gnu general public license as published by
- * the free software foundation; either version 2, or (at your option)
- * any later version.
- *
- * this program is distributed in the hope that it will be useful,
- * but without any warranty; without even the implied warranty of
- * merchantability or fitness for a particular purpose.  see the
- * gnu general public license for more details.
- *
- * you should have received a copy of the gnu general public license
- * along with this program; see the file copying.
- * if not, write to the free software foundation,
- * 59 temple place - suite 330, boston, ma 02111-1307, usa.
+ * Copyright 2004-2009 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
  */
 
-#ifndef _MEM_MAP_518_H_
-#define _MEM_MAP_518_H_
+#ifndef __BFIN_MACH_MEM_MAP_H__
+#define __BFIN_MACH_MEM_MAP_H__
 
-#define COREMMR_BASE           0xFFE00000	/* Core MMRs */
-#define SYSMMR_BASE            0xFFC00000	/* System MMRs */
+#ifndef __BFIN_MEM_MAP_H__
+# error "do not include mach/mem_map.h directly -- use asm/mem_map.h"
+#endif
 
 /* Async Memory Banks */
 #define ASYNC_BANK3_BASE	0x20300000	/* Async Bank 3 */
@@ -89,20 +67,4 @@
 #define BFIN_DSUPBANKS		0
 #endif				/*CONFIG_BFIN_DCACHE */
 
-/* Level 2 Memory - none */
-
-#define L2_START	0
-#define L2_LENGTH	0
-
-/* Scratch Pad Memory */
-
-#define L1_SCRATCH_START	0xFFB00000
-#define L1_SCRATCH_LENGTH	0x1000
-
-#define GET_PDA_SAFE(preg)		\
-	preg.l = _cpu_pda;		\
-	preg.h = _cpu_pda;
-
-#define GET_PDA(preg, dreg)	GET_PDA_SAFE(preg)
-
-#endif				/* _MEM_MAP_518_H_ */
+#endif
diff --git a/arch/blackfin/mach-bf527/include/mach/blackfin.h b/arch/blackfin/mach-bf527/include/mach/blackfin.h
index 417abcd..03665a8 100644
--- a/arch/blackfin/mach-bf527/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf527/include/mach/blackfin.h
@@ -33,7 +33,6 @@
 #define _MACH_BLACKFIN_H_
 
 #include "bf527.h"
-#include "mem_map.h"
 #include "defBF522.h"
 #include "anomaly.h"
 
diff --git a/arch/blackfin/mach-bf527/include/mach/mem_map.h b/arch/blackfin/mach-bf527/include/mach/mem_map.h
index 019e001..d96e894 100644
--- a/arch/blackfin/mach-bf527/include/mach/mem_map.h
+++ b/arch/blackfin/mach-bf527/include/mach/mem_map.h
@@ -1,38 +1,16 @@
 /*
- * file:         include/asm-blackfin/mach-bf527/mem_map.h
- * based on:	include/asm-blackfin/mach-bf537/mem_map.h
- * author:	Michael Hennerich (michael.hennerich@analog.com)
+ * BF52x memory map
  *
- * created:
- * description:
- *	Memory MAP Common header file for blackfin BF527/5/2 of processors.
- * rev:
- *
- * modified:
- *
- * bugs:         enter bugs at http://blackfin.uclinux.org/
- *
- * this program is free software; you can redistribute it and/or modify
- * it under the terms of the gnu general public license as published by
- * the free software foundation; either version 2, or (at your option)
- * any later version.
- *
- * this program is distributed in the hope that it will be useful,
- * but without any warranty; without even the implied warranty of
- * merchantability or fitness for a particular purpose.  see the
- * gnu general public license for more details.
- *
- * you should have received a copy of the gnu general public license
- * along with this program; see the file copying.
- * if not, write to the free software foundation,
- * 59 temple place - suite 330, boston, ma 02111-1307, usa.
+ * Copyright 2004-2009 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
  */
 
-#ifndef _MEM_MAP_527_H_
-#define _MEM_MAP_527_H_
+#ifndef __BFIN_MACH_MEM_MAP_H__
+#define __BFIN_MACH_MEM_MAP_H__
 
-#define COREMMR_BASE           0xFFE00000	/* Core MMRs */
-#define SYSMMR_BASE            0xFFC00000	/* System MMRs */
+#ifndef __BFIN_MEM_MAP_H__
+# error "do not include mach/mem_map.h directly -- use asm/mem_map.h"
+#endif
 
 /* Async Memory Banks */
 #define ASYNC_BANK3_BASE	0x20300000	/* Async Bank 3 */
@@ -89,20 +67,4 @@
 #define BFIN_DSUPBANKS	0
 #endif				/*CONFIG_BFIN_DCACHE */
 
-/* Level 2 Memory - none */
-
-#define L2_START	0
-#define L2_LENGTH	0
-
-/* Scratch Pad Memory */
-
-#define L1_SCRATCH_START	0xFFB00000
-#define L1_SCRATCH_LENGTH	0x1000
-
-#define GET_PDA_SAFE(preg)		\
-	preg.l = _cpu_pda;		\
-	preg.h = _cpu_pda;
-
-#define GET_PDA(preg, dreg)	GET_PDA_SAFE(preg)
-
-#endif				/* _MEM_MAP_527_H_ */
+#endif
diff --git a/arch/blackfin/mach-bf533/include/mach/blackfin.h b/arch/blackfin/mach-bf533/include/mach/blackfin.h
index 045184f..39aa175 100644
--- a/arch/blackfin/mach-bf533/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf533/include/mach/blackfin.h
@@ -34,7 +34,6 @@
 #define BF533_FAMILY
 
 #include "bf533.h"
-#include "mem_map.h"
 #include "defBF532.h"
 #include "anomaly.h"
 
diff --git a/arch/blackfin/mach-bf533/include/mach/mem_map.h b/arch/blackfin/mach-bf533/include/mach/mem_map.h
index fc33b7c..197af1a 100644
--- a/arch/blackfin/mach-bf533/include/mach/mem_map.h
+++ b/arch/blackfin/mach-bf533/include/mach/mem_map.h
@@ -1,38 +1,16 @@
 /*
- * File:         include/asm-blackfin/mach-bf533/mem_map.h
- * Based on:
- * Author:
+ * BF533 memory map
  *
- * Created:
- * Description:
- *
- * Rev:
- *
- * Modified:
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Copyright 2004-2009 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
  */
 
-#ifndef _MEM_MAP_533_H_
-#define _MEM_MAP_533_H_
+#ifndef __BFIN_MACH_MEM_MAP_H__
+#define __BFIN_MACH_MEM_MAP_H__
 
-#define COREMMR_BASE           0xFFE00000	 /* Core MMRs */
-#define SYSMMR_BASE            0xFFC00000	 /* System MMRs */
+#ifndef __BFIN_MEM_MAP_H__
+# error "do not include mach/mem_map.h directly -- use asm/mem_map.h"
+#endif
 
 /* Async Memory Banks */
 #define ASYNC_BANK3_BASE	0x20300000	 /* Async Bank 3 */
@@ -158,20 +136,4 @@
 
 #endif
 
-/* Level 2 Memory - none */
-
-#define L2_START	0
-#define L2_LENGTH	0
-
-/* Scratch Pad Memory */
-
-#define L1_SCRATCH_START	0xFFB00000
-#define L1_SCRATCH_LENGTH	0x1000
-
-#define GET_PDA_SAFE(preg)		\
-	preg.l = _cpu_pda;		\
-	preg.h = _cpu_pda;
-
-#define GET_PDA(preg, dreg)	GET_PDA_SAFE(preg)
-
-#endif				/* _MEM_MAP_533_H_ */
+#endif
diff --git a/arch/blackfin/mach-bf537/include/mach/blackfin.h b/arch/blackfin/mach-bf537/include/mach/blackfin.h
index 7d6069c..f5e5015 100644
--- a/arch/blackfin/mach-bf537/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf537/include/mach/blackfin.h
@@ -35,7 +35,6 @@
 #define BF537_FAMILY
 
 #include "bf537.h"
-#include "mem_map.h"
 #include "defBF534.h"
 #include "anomaly.h"
 
diff --git a/arch/blackfin/mach-bf537/include/mach/mem_map.h b/arch/blackfin/mach-bf537/include/mach/mem_map.h
index f9010c4..942f08d 100644
--- a/arch/blackfin/mach-bf537/include/mach/mem_map.h
+++ b/arch/blackfin/mach-bf537/include/mach/mem_map.h
@@ -1,38 +1,16 @@
 /*
- * file:         include/asm-blackfin/mach-bf537/mem_map.h
- * based on:
- * author:
+ * BF537 memory map
  *
- * created:
- * description:
- *	Memory MAP Common header file for blackfin BF537/6/4 of processors.
- * rev:
- *
- * modified:
- *
- * bugs:         enter bugs at http://blackfin.uclinux.org/
- *
- * this program is free software; you can redistribute it and/or modify
- * it under the terms of the gnu general public license as published by
- * the free software foundation; either version 2, or (at your option)
- * any later version.
- *
- * this program is distributed in the hope that it will be useful,
- * but without any warranty; without even the implied warranty of
- * merchantability or fitness for a particular purpose.  see the
- * gnu general public license for more details.
- *
- * you should have received a copy of the gnu general public license
- * along with this program; see the file copying.
- * if not, write to the free software foundation,
- * 59 temple place - suite 330, boston, ma 02111-1307, usa.
+ * Copyright 2004-2009 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
  */
 
-#ifndef _MEM_MAP_537_H_
-#define _MEM_MAP_537_H_
+#ifndef __BFIN_MACH_MEM_MAP_H__
+#define __BFIN_MACH_MEM_MAP_H__
 
-#define COREMMR_BASE           0xFFE00000	 /* Core MMRs */
-#define SYSMMR_BASE            0xFFC00000	 /* System MMRs */
+#ifndef __BFIN_MEM_MAP_H__
+# error "do not include mach/mem_map.h directly -- use asm/mem_map.h"
+#endif
 
 /* Async Memory Banks */
 #define ASYNC_BANK3_BASE	0x20300000	 /* Async Bank 3 */
@@ -166,20 +144,4 @@
 
 #endif
 
-/* Level 2 Memory - none */
-
-#define L2_START	0
-#define L2_LENGTH	0
-
-/* Scratch Pad Memory */
-
-#define L1_SCRATCH_START	0xFFB00000
-#define L1_SCRATCH_LENGTH	0x1000
-
-#define GET_PDA_SAFE(preg)		\
-	preg.l = _cpu_pda;		\
-	preg.h = _cpu_pda;
-
-#define GET_PDA(preg, dreg)	GET_PDA_SAFE(preg)
-
-#endif				/* _MEM_MAP_537_H_ */
+#endif
diff --git a/arch/blackfin/mach-bf538/include/mach/blackfin.h b/arch/blackfin/mach-bf538/include/mach/blackfin.h
index 6f62835..9496196 100644
--- a/arch/blackfin/mach-bf538/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf538/include/mach/blackfin.h
@@ -35,7 +35,6 @@
 #define BF538_FAMILY
 
 #include "bf538.h"
-#include "mem_map.h"
 #include "defBF539.h"
 #include "anomaly.h"
 
diff --git a/arch/blackfin/mach-bf538/include/mach/mem_map.h b/arch/blackfin/mach-bf538/include/mach/mem_map.h
index 7681196..aff00f4 100644
--- a/arch/blackfin/mach-bf538/include/mach/mem_map.h
+++ b/arch/blackfin/mach-bf538/include/mach/mem_map.h
@@ -1,38 +1,16 @@
 /*
- * File:         include/asm-blackfin/mach-bf538/mem_map.h
- * Based on:
- * Author:
+ * BF538 memory map
  *
- * Created:
- * Description:
- *
- * Rev:
- *
- * Modified:
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.
- * If not, write to the Free Software Foundation,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * Copyright 2004-2009 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
  */
 
-#ifndef _MEM_MAP_538_H_
-#define _MEM_MAP_538_H_
+#ifndef __BFIN_MACH_MEM_MAP_H__
+#define __BFIN_MACH_MEM_MAP_H__
 
-#define COREMMR_BASE           0xFFE00000	 /* Core MMRs */
-#define SYSMMR_BASE            0xFFC00000	 /* System MMRs */
+#ifndef __BFIN_MEM_MAP_H__
+# error "do not include mach/mem_map.h directly -- use asm/mem_map.h"
+#endif
 
 /* Async Memory Banks */
 #define ASYNC_BANK3_BASE	0x20300000	 /* Async Bank 3 */
@@ -93,21 +71,4 @@
 #define BFIN_DSUPBANKS	0
 #endif /*CONFIG_BFIN_DCACHE*/
 
-
-/* Level 2 Memory - none */
-
-#define L2_START	0
-#define L2_LENGTH	0
-
-/* Scratch Pad Memory */
-
-#define L1_SCRATCH_START	0xFFB00000
-#define L1_SCRATCH_LENGTH	0x1000
-
-#define GET_PDA_SAFE(preg)		\
-	preg.l = _cpu_pda;		\
-	preg.h = _cpu_pda;
-
-#define GET_PDA(preg, dreg)	GET_PDA_SAFE(preg)
-
-#endif				/* _MEM_MAP_538_H_ */
+#endif
diff --git a/arch/blackfin/mach-bf548/include/mach/blackfin.h b/arch/blackfin/mach-bf548/include/mach/blackfin.h
index cf6c150..6b97396 100644
--- a/arch/blackfin/mach-bf548/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf548/include/mach/blackfin.h
@@ -33,7 +33,6 @@
 #define _MACH_BLACKFIN_H_
 
 #include "bf548.h"
-#include "mem_map.h"
 #include "anomaly.h"
 
 #ifdef CONFIG_BF542
diff --git a/arch/blackfin/mach-bf548/include/mach/mem_map.h b/arch/blackfin/mach-bf548/include/mach/mem_map.h
index 70b9c11..caac2df 100644
--- a/arch/blackfin/mach-bf548/include/mach/mem_map.h
+++ b/arch/blackfin/mach-bf548/include/mach/mem_map.h
@@ -1,38 +1,16 @@
 /*
- * file:         include/asm-blackfin/mach-bf548/mem_map.h
- * based on:
- * author:
+ * BF548 memory map
  *
- * created:
- * description:
- *	Memory MAP Common header file for blackfin BF537/6/4 of processors.
- * rev:
- *
- * modified:
- *
- * bugs:         enter bugs at http://blackfin.uclinux.org/
- *
- * this program is free software; you can redistribute it and/or modify
- * it under the terms of the gnu general public license as published by
- * the free software foundation; either version 2, or (at your option)
- * any later version.
- *
- * this program is distributed in the hope that it will be useful,
- * but without any warranty; without even the implied warranty of
- * merchantability or fitness for a particular purpose.  see the
- * gnu general public license for more details.
- *
- * you should have received a copy of the gnu general public license
- * along with this program; see the file copying.
- * if not, write to the free software foundation,
- * 59 temple place - suite 330, boston, ma 02111-1307, usa.
+ * Copyright 2004-2009 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
  */
 
-#ifndef _MEM_MAP_548_H_
-#define _MEM_MAP_548_H_
+#ifndef __BFIN_MACH_MEM_MAP_H__
+#define __BFIN_MACH_MEM_MAP_H__
 
-#define COREMMR_BASE           0xFFE00000	 /* Core MMRs */
-#define SYSMMR_BASE            0xFFC00000	 /* System MMRs */
+#ifndef __BFIN_MEM_MAP_H__
+# error "do not include mach/mem_map.h directly -- use asm/mem_map.h"
+#endif
 
 /* Async Memory Banks */
 #define ASYNC_BANK3_BASE	0x2C000000	 /* Async Bank 3 */
@@ -103,15 +81,4 @@
 # define L2_LENGTH          0x20000
 #endif
 
-/* Scratch Pad Memory */
-
-#define L1_SCRATCH_START	0xFFB00000
-#define L1_SCRATCH_LENGTH	0x1000
-
-#define GET_PDA_SAFE(preg)		\
-	preg.l = _cpu_pda;		\
-	preg.h = _cpu_pda;
-
-#define GET_PDA(preg, dreg)	GET_PDA_SAFE(preg)
-
-#endif/* _MEM_MAP_548_H_ */
+#endif
diff --git a/arch/blackfin/mach-bf561/include/mach/blackfin.h b/arch/blackfin/mach-bf561/include/mach/blackfin.h
index f79f662..8be3135 100644
--- a/arch/blackfin/mach-bf561/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf561/include/mach/blackfin.h
@@ -34,7 +34,6 @@
 #define BF561_FAMILY
 
 #include "bf561.h"
-#include "mem_map.h"
 #include "defBF561.h"
 #include "anomaly.h"
 
diff --git a/arch/blackfin/mach-bf561/include/mach/mem_map.h b/arch/blackfin/mach-bf561/include/mach/mem_map.h
index 419dffd..a63e15c 100644
--- a/arch/blackfin/mach-bf561/include/mach/mem_map.h
+++ b/arch/blackfin/mach-bf561/include/mach/mem_map.h
@@ -1,13 +1,16 @@
 /*
- * Memory MAP
- * Common header file for blackfin BF561 of processors.
+ * BF561 memory map
+ *
+ * Copyright 2004-2009 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
  */
 
-#ifndef _MEM_MAP_561_H_
-#define _MEM_MAP_561_H_
+#ifndef __BFIN_MACH_MEM_MAP_H__
+#define __BFIN_MACH_MEM_MAP_H__
 
-#define COREMMR_BASE           0xFFE00000	 /* Core MMRs */
-#define SYSMMR_BASE            0xFFC00000	 /* System MMRs */
+#ifndef __BFIN_MEM_MAP_H__
+# error "do not include mach/mem_map.h directly -- use asm/mem_map.h"
+#endif
 
 /* Async Memory Banks */
 #define ASYNC_BANK3_BASE	0x2C000000	 /* Async Bank 3 */
@@ -82,9 +85,6 @@
 #define COREA_L1_SCRATCH_START	0xFFB00000
 #define COREB_L1_SCRATCH_START	0xFF700000
 
-#define L1_SCRATCH_START	COREA_L1_SCRATCH_START
-#define L1_SCRATCH_LENGTH	0x1000
-
 #ifdef __ASSEMBLY__
 
 /*
@@ -155,14 +155,42 @@
 	dreg = ROT dreg BY -1;		\
 	dreg = CC;
 
-#else
-#define GET_PDA_SAFE(preg)		\
-	preg.l = _cpu_pda;		\
-	preg.h = _cpu_pda;
+static inline unsigned long get_l1_scratch_start_cpu(int cpu)
+{
+	return cpu ? COREB_L1_SCRATCH_START : COREA_L1_SCRATCH_START;
+}
+static inline unsigned long get_l1_code_start_cpu(int cpu)
+{
+	return cpu ? COREB_L1_CODE_START : COREA_L1_CODE_START;
+}
+static inline unsigned long get_l1_data_a_start_cpu(int cpu)
+{
+	return cpu ? COREB_L1_DATA_A_START : COREA_L1_DATA_A_START;
+}
+static inline unsigned long get_l1_data_b_start_cpu(int cpu)
+{
+	return cpu ? COREB_L1_DATA_B_START : COREA_L1_DATA_B_START;
+}
+
+static inline unsigned long get_l1_scratch_start(void)
+{
+	return get_l1_scratch_start_cpu(blackfin_core_id());
+}
+static inline unsigned long get_l1_code_start(void)
+{
+	return get_l1_code_start_cpu(blackfin_core_id());
+}
+static inline unsigned long get_l1_data_a_start(void)
+{
+	return get_l1_data_a_start_cpu(blackfin_core_id());
+}
+static inline unsigned long get_l1_data_b_start(void)
+{
+	return get_l1_data_b_start_cpu(blackfin_core_id());
+}
 
-#define GET_PDA(preg, dreg)	GET_PDA_SAFE(preg)
 #endif /* CONFIG_SMP */
 
 #endif /* __ASSEMBLY__ */
 
-#endif				/* _MEM_MAP_533_H_ */
+#endif
-- 
1.6.3.1


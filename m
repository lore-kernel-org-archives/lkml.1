Return-Path: <linux-kernel-owner+w=401wt.eu-S1759059AbZFTSsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059AbZFTSsp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbZFTSqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:46:31 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48111 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757916AbZFTSqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:46:30 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Philippe Gerum <rpm@xenomai.org>
Subject: [PATCH 14/25] Blackfin: remove obsolete mcount support from I-pipe code
Date: Sat, 20 Jun 2009 14:44:37 -0400
Message-Id: <1245523488-26536-15-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/Makefile |    1 -
 arch/blackfin/kernel/ipipe.c  |    5 ---
 arch/blackfin/kernel/mcount.S |   70 -----------------------------------------
 3 files changed, 0 insertions(+), 76 deletions(-)
 delete mode 100644 arch/blackfin/kernel/mcount.S

diff --git a/arch/blackfin/kernel/Makefile b/arch/blackfin/kernel/Makefile
index 3731088..141d928 100644
--- a/arch/blackfin/kernel/Makefile
+++ b/arch/blackfin/kernel/Makefile
@@ -20,7 +20,6 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER)  += ftrace.o
 CFLAGS_REMOVE_ftrace.o = -pg
 
 obj-$(CONFIG_IPIPE)                  += ipipe.o
-obj-$(CONFIG_IPIPE_TRACE_MCOUNT)     += mcount.o
 obj-$(CONFIG_BFIN_GPTIMERS)          += gptimers.o
 obj-$(CONFIG_CPLB_INFO)              += cplbinfo.o
 obj-$(CONFIG_MODULES)                += module.o
diff --git a/arch/blackfin/kernel/ipipe.c b/arch/blackfin/kernel/ipipe.c
index 2b979ed..b8d2203 100644
--- a/arch/blackfin/kernel/ipipe.c
+++ b/arch/blackfin/kernel/ipipe.c
@@ -342,8 +342,3 @@ void ___ipipe_sync_pipeline(unsigned long syncmask)
 }
 
 EXPORT_SYMBOL(show_stack);
-
-#ifdef CONFIG_IPIPE_TRACE_MCOUNT
-void notrace _mcount(void);
-EXPORT_SYMBOL(_mcount);
-#endif /* CONFIG_IPIPE_TRACE_MCOUNT */
diff --git a/arch/blackfin/kernel/mcount.S b/arch/blackfin/kernel/mcount.S
deleted file mode 100644
index edcfb38..0000000
--- a/arch/blackfin/kernel/mcount.S
+++ /dev/null
@@ -1,70 +0,0 @@
-/*
- * linux/arch/blackfin/mcount.S
- *
- * Copyright (C) 2006 Analog Devices Inc.
- *
- * 2007/04/12 Save index, length, modify and base registers. --rpm
- */
-
-#include <linux/linkage.h>
-#include <asm/blackfin.h>
-
-.text
-
-.align 4 	/* just in case */
-
-ENTRY(__mcount)
-	[--sp] = i0;
-	[--sp] = i1;
-	[--sp] = i2;
-	[--sp] = i3;
-	[--sp] = l0;
-	[--sp] = l1;
-	[--sp] = l2;
-	[--sp] = l3;
-	[--sp] = m0;
-	[--sp] = m1;
-	[--sp] = m2;
-	[--sp] = m3;
-	[--sp] = b0;
-	[--sp] = b1;
-	[--sp] = b2;
-	[--sp] = b3;
-	[--sp] = ( r7:0, p5:0 );
-	[--sp] = ASTAT;
-
-	p1.L = _ipipe_trace_enable;
-	p1.H = _ipipe_trace_enable;
-	r7 = [p1];
-	CC = r7 == 0;
-	if CC jump out;
-	link 0x10;
-	r0 = 0x0;
-	[sp + 0xc] = r0; /* v */
-	r0 = 0x0;	/* type: IPIPE_TRACE_FN */
-	r1 = rets;
-	p0 = [fp];	/* p0: Prior FP */
-	r2 = [p0 + 4];	/* r2: Prior RETS */
-	call ___ipipe_trace;
-	unlink;
-out:
-	ASTAT = [sp++];
-	( r7:0, p5:0 ) = [sp++];
-	b3 = [sp++];
-	b2 = [sp++];
-	b1 = [sp++];
-	b0 = [sp++];
-	m3 = [sp++];
-	m2 = [sp++];
-	m1 = [sp++];
-	m0 = [sp++];
-	l3 = [sp++];
-	l2 = [sp++];
-	l1 = [sp++];
-	l0 = [sp++];
-	i3 = [sp++];
-	i2 = [sp++];
-	i1 = [sp++];
-	i0 = [sp++];
-	rts;
-ENDPROC(__mcount)
-- 
1.6.3.1


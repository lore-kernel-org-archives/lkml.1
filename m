Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbZIMDGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbZIMDGR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 23:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZIMDGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 23:06:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56076 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbZIMDGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 23:06:14 -0400
Message-Id: <20090913030616.682560932@goodmis.org>
References: <20090913030543.204871396@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 23:05:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, John Reiser <jreiser@BitWagon.com>
Subject: [PATCH 1/4] ftrace: __start_mcount_loc should be .init.rodata
Content-Disposition: inline; filename=0001-ftrace-__start_mcount_loc-should-be-.init.rodata.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Reiser <jreiser@bitwagon.com>

__start_mcount_loc[] is unused after init, yet occupies RAM forever
as part of .rodata.  152kiB is typical on a 64-bit architecture.  Instead,
__start_mcount_loc should be in the interval [__init_begin, __init_end)
so that the space is reclaimed after init.

__start_mcount_loc[] is generated during the load portion
of kernel build, and is used only by ftrace_init().  ftrace_init is declared
'__init' and is in .init.text, which is freed after init.
__start_mcount_loc is placed into .rodata by a call to MCOUNT_REC inside
the RO_DATA macro of include/asm-generic/vmlinux.lds.h.  The array *is*
read-only, but more importantly it is not used after init.  So the call to
MCOUNT_REC should be moved from RO_DATA to INIT_DATA.

This patch has been tested on x86_64 with CONFIG_DEBUG_PAGEALLOC=y
which verifies that the address range never is accessed after init.

Signed-off-by: John Reiser <jreiser@BitWagon.com>
LKML-Reference: <4A6DF0B6.7080402@bitwagon.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/vmlinux.lds.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 6ad76bf..98b37cf 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -91,7 +91,8 @@
 #endif
 
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
-#define MCOUNT_REC()	VMLINUX_SYMBOL(__start_mcount_loc) = .; \
+#define MCOUNT_REC()	. = ALIGN(8);				\
+			VMLINUX_SYMBOL(__start_mcount_loc) = .; \
 			*(__mcount_loc)				\
 			VMLINUX_SYMBOL(__stop_mcount_loc) = .;
 #else
@@ -331,7 +332,6 @@
 	/* __*init sections */						\
 	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
 		*(.ref.rodata)						\
-		MCOUNT_REC()						\
 		DEV_KEEP(init.rodata)					\
 		DEV_KEEP(exit.rodata)					\
 		CPU_KEEP(init.rodata)					\
@@ -455,6 +455,7 @@
 	MEM_DISCARD(init.data)						\
 	KERNEL_CTORS()							\
 	*(.init.rodata)							\
+	MCOUNT_REC()							\
 	DEV_DISCARD(init.rodata)					\
 	CPU_DISCARD(init.rodata)					\
 	MEM_DISCARD(init.rodata)
-- 
1.6.3.3

-- 

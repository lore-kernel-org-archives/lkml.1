Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZIMPDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZIMPDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 11:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZIMPDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 11:03:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:32866 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbZIMPDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 11:03:13 -0400
Date: Sun, 13 Sep 2009 15:02:23 GMT
From: tip-bot for John Reiser <jreiser@bitwagon.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, jreiser@bitwagon.com, jreiser@bitwagon.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, jreiser@bitwagon.com, tglx@linutronix.de,
       jreiser@bitwagon.com
In-Reply-To: <4A6DF0B6.7080402@bitwagon.com>
References: <4A6DF0B6.7080402@bitwagon.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] ftrace: __start_mcount_loc should be .init.rodata
Message-ID: <tip-4b3b4c5e64ce26612646867ee354373620063534@git.kernel.org>
Git-Commit-ID: 4b3b4c5e64ce26612646867ee354373620063534
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 13 Sep 2009 15:02:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b3b4c5e64ce26612646867ee354373620063534
Gitweb:     http://git.kernel.org/tip/4b3b4c5e64ce26612646867ee354373620063534
Author:     John Reiser <jreiser@bitwagon.com>
AuthorDate: Mon, 27 Jul 2009 11:23:50 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Sat, 12 Sep 2009 21:57:29 -0400

ftrace: __start_mcount_loc should be .init.rodata

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

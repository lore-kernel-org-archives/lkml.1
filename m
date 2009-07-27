Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbZG0SeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbZG0SeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbZG0SeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:34:05 -0400
Received: from bitwagon.com ([74.82.39.175]:57289 "HELO bitwagon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751634AbZG0SeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:34:04 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2009 14:34:04 EDT
Message-ID: <4A6DF0B6.7080402@bitwagon.com>
Date: Mon, 27 Jul 2009 11:23:50 -0700
From: John Reiser <jreiser@bitwagon.com>
Organization: -
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ftrace: __start_mcount_loc should be .init.rodata
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

[Please cc: me if replying only to the linux-kernel list.]

Signed off by: John Reiser <jreiser@BitWagon.com>

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


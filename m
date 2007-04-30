Return-Path: <linux-kernel-owner+w=401wt.eu-S1946367AbXD3Qdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946367AbXD3Qdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946362AbXD3Qdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:33:32 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60714 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946365AbXD3Qd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:33:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/12] i386: Introduce head32.c
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com>
	<m18xc96eyq.fsf@ebiederm.dsl.xmission.com>
	<m14pmx6ewk.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm4p509a.fsf_-_@ebiederm.dsl.xmission.com>
	<m1vefd4zyj.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com>
	<m1mz0p4zfc.fsf_-_@ebiederm.dsl.xmission.com>
	<m1irbd4zcm.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ejm14z5f.fsf_-_@ebiederm.dsl.xmission.com>
	<m1abwp4yd9.fsf_-_@ebiederm.dsl.xmission.com>
Date: Mon, 30 Apr 2007 10:32:56 -0600
In-Reply-To: <m1abwp4yd9.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Mon, 30 Apr 2007 10:32:02 -0600")
Message-ID: <m1647d4ybr.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Copy x86_64 and add a head32.c so we can start moving early
architecture initialization out of  assembly.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/i386/Makefile        |    2 +-
 arch/i386/kernel/Makefile |    2 +-
 arch/i386/kernel/head.S   |    2 +-
 arch/i386/kernel/head32.c |   14 ++++++++++++++
 4 files changed, 17 insertions(+), 3 deletions(-)
 create mode 100644 arch/i386/kernel/head32.c

diff --git a/arch/i386/Makefile b/arch/i386/Makefile
index 6dc5e5d..89e6f6f 100644
--- a/arch/i386/Makefile
+++ b/arch/i386/Makefile
@@ -96,7 +96,7 @@ core-$(CONFIG_X86_ES7000)	:= arch/i386/mach-es7000/
 # default subarch .h files
 mflags-y += -Iinclude/asm-i386/mach-default
 
-head-y := arch/i386/kernel/head.o arch/i386/kernel/init_task.o
+head-y := arch/i386/kernel/head.o arch/i386/kernel/head32.o arch/i386/kernel/init_task.o
 
 libs-y 					+= arch/i386/lib/
 core-y					+= arch/i386/kernel/ \
diff --git a/arch/i386/kernel/Makefile b/arch/i386/kernel/Makefile
index 4c96141..530ccaa 100644
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-extra-y := head.o init_task.o vmlinux.lds
+extra-y := head.o head32.o init_task.o vmlinux.lds
 
 obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_i386.o \
diff --git a/arch/i386/kernel/head.S b/arch/i386/kernel/head.S
index de65f45..22ddb3f 100644
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -300,7 +300,7 @@ is386:	movl $2,%ecx		# set MP
 	jmp initialize_secondary # all other CPUs call initialize_secondary
 1:
 #endif /* CONFIG_SMP */
-	jmp start_kernel
+	jmp i386_start_kernel
 
 /*
  * We depend on ET to be correct. This checks for 287/387.
diff --git a/arch/i386/kernel/head32.c b/arch/i386/kernel/head32.c
new file mode 100644
index 0000000..3db0590
--- /dev/null
+++ b/arch/i386/kernel/head32.c
@@ -0,0 +1,14 @@
+/*
+ *  linux/arch/i386/kernel/head32.c -- prepare to run common code
+ *
+ *  Copyright (C) 2000 Andrea Arcangeli <andrea@suse.de> SuSE
+ *  Copyright (C) 2007 Eric Biederman <ebiederm@xmission.com>
+ */
+
+#include <linux/init.h>
+#include <linux/start_kernel.h>
+
+void __init i386_start_kernel(void)
+{
+	start_kernel();
+}
-- 
1.5.1.1.181.g2de0


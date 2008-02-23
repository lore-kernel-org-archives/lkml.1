Return-Path: <linux-kernel-owner+w=401wt.eu-S934075AbYBWJGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbYBWJGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 04:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYBWJFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 04:05:32 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:45844 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765049AbYBWJFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 04:05:23 -0500
Date: Sat, 23 Feb 2008 10:05:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: introduce kernel/head32.c
Message-ID: <20080223090534.GA12161@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7143f15993be4709e59c43fb65b086a8402e589b Mon Sep 17 00:00:00 2001
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 23 Feb 2008 09:58:20 +0100
Subject: [PATCH] x86: introduce kernel/head32.c

Copy x86_64 and add a head32.c so we can start moving early
architecture initialization out of assembly.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
---

Based on original submission from Eric:
http://lkml.org/lkml/2007/4/30/337

I just updated it to x86
Only build tested on 64bit x86 but looks trivially correct.

	Sam


 arch/x86/Makefile         |    6 +++---
 arch/x86/kernel/Makefile  |    3 +--
 arch/x86/kernel/head32.c  |   14 ++++++++++++++
 arch/x86/kernel/head_32.S |    2 +-
 4 files changed, 19 insertions(+), 6 deletions(-)
 create mode 100644 arch/x86/kernel/head32.c

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index f1e739a..03131ce 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -159,9 +159,9 @@ KBUILD_AFLAGS += $(mflags-y)
 ###
 # Kernel objects
 
-head-y                := arch/x86/kernel/head_$(BITS).o
-head-$(CONFIG_X86_64) += arch/x86/kernel/head64.o
-head-y                += arch/x86/kernel/init_task.o
+head-y := arch/x86/kernel/head_$(BITS).o
+head-y += arch/x86/kernel/head$(BITS).o
+head-y += arch/x86/kernel/init_task.o
 
 libs-y  += arch/x86/lib/
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4eb5ce8..8f2371d 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -2,8 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-extra-y                := head_$(BITS).o init_task.o vmlinux.lds
-extra-$(CONFIG_X86_64) += head64.o
+extra-y                := head_$(BITS).o head$(BITS).o init_task.o vmlinux.lds
 
 CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
 
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
new file mode 100644
index 0000000..3db0590
--- /dev/null
+++ b/arch/x86/kernel/head32.c
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
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 25eb985..d4247c0 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -450,7 +450,7 @@ is386:	movl $2,%ecx		# set MP
 	jmp initialize_secondary # all other CPUs call initialize_secondary
 1:
 #endif /* CONFIG_SMP */
-	jmp start_kernel
+	jmp i386_start_kernel
 
 /*
  * We depend on ET to be correct. This checks for 287/387.
-- 
1.5.4.rc3.14.g44397


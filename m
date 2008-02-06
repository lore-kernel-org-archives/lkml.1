Return-Path: <linux-kernel-owner+w=401wt.eu-S1762836AbYBFNqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762836AbYBFNqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 08:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbYBFNpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 08:45:33 -0500
Received: from styx.suse.cz ([82.119.242.94]:44717 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763493AbYBFNp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:45:28 -0500
Date: Wed, 6 Feb 2008 14:45:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ASLR: add possibility for more fine-grained tweaking
In-Reply-To: <Pine.LNX.4.64.0802061438150.30955@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0802061442300.30955@jikos.suse.cz>
References: <Pine.LNX.4.64.0802061438150.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

ASLR: add possibility for more fine-grained tweaking

Some prehistoric binaries don't like when start of brk area is located
anywhere else than just after code+bss.

This patch adds possibility to configure the default behavior of address
space randomization. In addition to that, randomize_va_space now can have
value of '2', which means full randomization including brk space.

Also, documentation of randomize_va_space is added.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 8984a53..91ab40d 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -41,6 +41,7 @@ show up in /proc/sys/kernel:
 - pid_max
 - powersave-nap               [ PPC only ]
 - printk
+- randomize_va_space
 - real-root-dev               ==> Documentation/initrd.txt
 - reboot-cmd                  [ SPARC only ]
 - rtsig-max
@@ -280,6 +281,37 @@ send before ratelimiting kicks in.
 
 ==============================================================
 
+randomize-va-space:
+
+This option can be used to select the type of process address
+space randomization that is used in the system, for architectures
+that support this feature.
+
+One of the following numeric values is possible:
+
+0 - [none]
+	Turn the process address space randomization off by default.
+
+1 - [conservative]
+	Conservative address space randomization makes the addresses of
+	mmap base and VDSO page randomized. This, among other things,
+	implies that shared libraries will be loaded to random addresses.
+	Also for PIE binaries, the location of code start is randomized.
+
+2 - [full]
+
+	This includes all the features that Conservative randomization
+	provides. In addition to that, also start of the brk area is
+	randomized.
+	There a few legacy applications out there (such as some ancient
+	versions of libc.so.5 from 1996) that assume that brk area starts
+	just after the end of the code+bss. These applications break when
+	start of the brk area is randomized. There are however no known
+	non-legacy applications that would be broken this way, so for most
+	systems it is safe to choose Full randomization.
+
+==============================================================
+
 reboot-cmd: (Sparc only)
 
 ??? This seems to be a way to give an argument to the Sparc
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 4628c42..d9f23d5 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1077,7 +1077,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	current->mm->start_stack = bprm->p;
 
 #ifdef arch_randomize_brk
-	if (current->flags & PF_RANDOMIZE)
+	if (current->flags & PF_RANDOMIZE && randomize_va_space == 2)
 		current->mm->brk = current->mm->start_brk =
 			arch_randomize_brk(current->mm);
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index 87f50df..aeb38b2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -662,6 +662,46 @@ config SLOB
 
 endchoice
 
+choice
+	prompt "Address space randomization type"
+	default RANDOMIZATION_CONSERVATIVE
+	help
+	   This option allows to select the type of process address space
+	   randomization that will be used by default (for those architectures
+	   that support address space randomization). This option can be
+	   overriden in runtime through kernel.randomize_va_space sysctl.
+
+config RANDOMIZATION_NONE
+	bool "NONE"
+	help
+	   Turn the process address space randomization off by default.
+	   Equivalent to sysctl kernel.randomize_va_space = 0.
+
+config RANDOMIZATION_CONSERVATIVE
+	bool "CONSERVATIVE"
+	help
+	   Conservative address space randomization makes the addresses of
+	   mmap base and VDSO page randomized. This, among other things,
+	   implies that shared libraries will be loaded to random addresses.
+	   Also for PIE binaries, the location of code start is randomized.
+	   Equivalent to sysctl kernel.randomize_va_space = 1.
+
+config RANDOMIZATION_FULL
+	bool "FULL"
+	help
+	   This includes all the features that Conservative randomization
+	   provides. In addition to that, also start of the brk area is
+	   randomized.
+	   There a few legacy applications out there (such as some ancient
+	   versions of libc.so.5 from 1996) that assume that the brk area
+	   starts just after the end of the code+bss. These applications
+	   break when start of the brk area is randomized. There are however
+	   no known non-legacy applications that would be broken this way,
+	   so for most systems it is safe to choose Full randomization.
+	   Equivalent to sysctl kernel.randomize_va_space = 2.
+
+endchoice
+
 config PROFILING
 	bool "Profiling support (EXPERIMENTAL)"
 	help
diff --git a/mm/memory.c b/mm/memory.c
index 7bb7072..e84f69a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -82,7 +82,15 @@ void * high_memory;
 EXPORT_SYMBOL(num_physpages);
 EXPORT_SYMBOL(high_memory);
 
+#ifdef CONFIG_RANDOMIZATION_CONSERVATIVE
 int randomize_va_space __read_mostly = 1;
+#else
+#ifdef CONFIG_RANDOMIZATION_FULL
+int randomize_va_space __read_mostly = 2;
+#else
+int randomize_va_space __read_mostly = 0;
+#endif
+#endif
 
 static int __init disable_randmaps(char *s)
 {

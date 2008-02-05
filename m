Return-Path: <linux-kernel-owner+w=401wt.eu-S1762072AbYBEWfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762072AbYBEWfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760259AbYBEWfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:35:30 -0500
Received: from styx.suse.cz ([82.119.242.94]:52757 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759634AbYBEWf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:35:29 -0500
Date: Tue, 5 Feb 2008 23:35:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@ucw.cz>
cc: Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Abel Bernabeu <abel.bernabeu@gmail.com>
Subject: Re: brk randomization breaks columns
In-Reply-To: <20080205085841.51713a5d@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0802052328390.30955@jikos.suse.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz>
 <Pine.LNX.4.64.0802051243240.542@blonde.site> <20080205070001.7bc8058f@laptopd505.fenrus.org>
 <20080205154648.GA24331@elf.ucw.cz> <20080205085841.51713a5d@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Arjan van de Ven wrote:

> the combo of a config option + sysctl sounds the right way forward then 
> ;(

OK, so I propose the one below (unested yet, but should be trivial). Does 
anyone have any objections?



From: Jiri Kosina <jkosina@suse.cz>

ASLR: add possibility for more fine-grained tweaking

Some prehistoric binaries don't like when start of brk area is located 
anywhere else than just after code+bss.

This patch adds possibility to configure the default behavior of address 
space randomization. In addition to that, randomize_va_space now can have 
value of '2', which means full randomization including brk space.

Also, documentation of randomize_va_space is added.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 8984a53..0373bbe 100644
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
+space randomization is used in the system, for architectures
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
+	versions of libc.so.5 from 1996), that assume that brk area starts
+	just after the end of the code+bss. These applications break when
+	start of the brk area is randomized. There are however no known
+	non-legacy applications that would be broken this way, so for most
+	systems it is safe to chose Full randomization.
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
index 87f50df..804a3a6 100644
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
+	   versions of libc.so.5 from 1996), that assume that brk area starts
+	   just after the end of the code+bss. These applications break when
+	   start of the brk area is randomized. There are however no known
+	   non-legacy applications that would be broken this way, so for most
+	   systems it is safe to chose Full randomization.
+	   Equivalent to sysctl kernel.randomize_va_space = 2.
+
+endchoice
+
 config PROFILING
 	bool "Profiling support (EXPERIMENTAL)"
 	help
diff --git a/mm/memory.c b/mm/memory.c
index 7bb7072..5765567 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -82,7 +82,15 @@ void * high_memory;
 EXPORT_SYMBOL(num_physpages);
 EXPORT_SYMBOL(high_memory);
 
+#ifdef CONFIG_RANDOMIZE_CONSERVATIVE
 int randomize_va_space __read_mostly = 1;
+#else
+#ifdef CONFIG_RANDOMIZE_FULL
+int randomize_va_space __read_mostly = 2;
+#else
+int randomize_va_space __read_mostly = 0;
+#endif
+#endif
 
 static int __init disable_randmaps(char *s)
 {


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbYBFNvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbYBFNvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 08:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYBFNvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 08:51:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43668 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbYBFNvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:51:12 -0500
Date: Wed, 6 Feb 2008 14:49:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ASLR: add possibility for more fine-grained
	tweaking
Message-ID: <20080206134959.GA25689@elte.hu>
References: <Pine.LNX.4.64.0802061438150.30955@jikos.suse.cz> <Pine.LNX.4.64.0802061442300.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802061442300.30955@jikos.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> ASLR: add possibility for more fine-grained tweaking
> 
> Some prehistoric binaries don't like when start of brk area is located 
> anywhere else than just after code+bss.
> 
> This patch adds possibility to configure the default behavior of 
> address space randomization. In addition to that, randomize_va_space 
> now can have value of '2', which means full randomization including 
> brk space.

i've already added the patch below to x86.git.

	Ingo

-------------------->
Subject: brk randomization: introduce CONFIG_COMPAT_BRK
From: Ingo Molnar <mingo@elte.hu>

based on similar patch from: Pavel Machek <pavel@ucw.cz>

Introduce CONFIG_COMPAT_BRK. If disabled then the kernel is free
(but not obliged to) randomize the brk area.

Heap randomization breaks ancient binaries, so we keep COMPAT_BRK
enabled by default.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/binfmt_elf.c |    2 +-
 init/Kconfig    |   12 ++++++++++++
 mm/memory.c     |   13 ++++++++++++-
 3 files changed, 25 insertions(+), 2 deletions(-)

Index: linux-x86.q/fs/binfmt_elf.c
===================================================================
--- linux-x86.q.orig/fs/binfmt_elf.c
+++ linux-x86.q/fs/binfmt_elf.c
@@ -1077,7 +1077,7 @@ static int load_elf_binary(struct linux_
 	current->mm->start_stack = bprm->p;
 
 #ifdef arch_randomize_brk
-	if (current->flags & PF_RANDOMIZE)
+	if ((current->flags & PF_RANDOMIZE) && (randomize_va_space > 1))
 		current->mm->brk = current->mm->start_brk =
 			arch_randomize_brk(current->mm);
 #endif
Index: linux-x86.q/init/Kconfig
===================================================================
--- linux-x86.q.orig/init/Kconfig
+++ linux-x86.q/init/Kconfig
@@ -541,6 +541,18 @@ config ELF_CORE
 	help
 	  Enable support for generating core dumps. Disabling saves about 4k.
 
+config COMPAT_BRK
+	bool "Disable heap randomization"
+	default y
+	help
+	  Randomizing heap placement makes heap exploits harder, but it
+	  also breaks ancient binaries (including anything libc5 based).
+	  This option changes the bootup default to heap randomization
+	  disabled, and can be overriden runtime by setting
+	  /proc/sys/kernel/randomize_va_space to 2.
+
+	  On non-ancient distros (post-2000 ones) Y is usually a safe choice.
+
 config BASE_FULL
 	default y
 	bool "Enable full-sized data structures for core" if EMBEDDED
Index: linux-x86.q/mm/memory.c
===================================================================
--- linux-x86.q.orig/mm/memory.c
+++ linux-x86.q/mm/memory.c
@@ -82,7 +82,18 @@ void * high_memory;
 EXPORT_SYMBOL(num_physpages);
 EXPORT_SYMBOL(high_memory);
 
-int randomize_va_space __read_mostly = 1;
+/*
+ * Randomize the address space (stacks, mmaps, brk, etc.).
+ *
+ * ( When CONFIG_COMPAT_BRK=y we exclude brk from randomization,
+ *   as ancient (libc5 based) binaries can segfault. )
+ */
+int randomize_va_space __read_mostly =
+#ifdef CONFIG_COMPAT_BRK
+					1;
+#else
+					2;
+#endif
 
 static int __init disable_randmaps(char *s)
 {

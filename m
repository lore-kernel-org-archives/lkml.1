Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbZLBNpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbZLBNpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbZLBNpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:45:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbZLBNpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:45:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1259421863-12777-1-git-send-email-vapier@gentoo.org>
References: <1259421863-12777-1-git-send-email-vapier@gentoo.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FDPIC: respect PT_GNU_STACK exec markings when creating NOMMU stack
Date: Wed, 02 Dec 2009 13:44:12 +0000
Message-ID: <7946.1259761452@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> that tends to be 128kB of waste.

While your patch is reasonable, at least in concept, I don't see where you get
this bit of the description from.

> +					 (executable_stack & EXSTACK_ENABLE_X ? PROT_EXEC : 0),

executable_stack might be EXSTACK_DEFAULT, but the default might be to enable
stack exec - in which case, this is wrong.

I also don't think that the EXSTACK_xxx constants are a bitmask; I think
they're an enumeration - in which case you shouldn't be using '&' to test
them.  setup_arg_pages() uses '=='.

As far as I can see only powerpc currently defines the behaviour for
EXSTACK_DEFAULT.  Mostly it seems to depend on VM_STACK_DEFAULT_FLAGS.

Further, I think it only matters for MMU and MPU modes, not for NOMMU mode.

There is one further consequence of your patch that you don't mention: the brk
area _also_ becomes non-executable.  In NOMMU, I suspect this is irrelevant,
as I'm not sure brk is used at all (should we make sys_brk() return ENOSYS?).

How about the attached instead?  Probably VM_DATA_DEFAULT_FLAGS should not
include VM_EXEC for either Blackfin or FRV, but it may be required for SH.
The if-statement that calls elf_read_implies_exec() will be optimised away
unless the arch specifically sets it (which none of FRV, Blackfin or SH do).

David
---
From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] FDPIC: Respect PT_GNU_STACK exec protection markings when creating NOMMU stack

The current code will load the stack size and protection markings, but then
only use the markings in the MMU code path.  The NOMMU code path always passes
PROT_EXEC to the mmap() call.  While this doesn't matter to most people whilst
the code is running, it will cause a pointless icache flush when starting every
FDPIC application.  Typically this icache flush will be of a region on the
order of 128KB in size, or may be the entire icache, depending on the
facilities available on the CPU.

In the case where the arch default behaviour seems to be desired
(EXSTACK_DEFAULT), we probe VM_STACK_FLAGS for VM_EXEC to determine whether we
should be setting PROT_EXEC or not.

For arches that support an MPU (Memory Protection Unit - an MMU without the
virtual mapping capability), setting PROT_EXEC or not will make an important
difference.

It should be noted that this change also affects the executability of the brk
region, since ELF-FDPIC has that share with the stack.  However, this is
probably irrelevant as NOMMU programs aren't likely to use the brk region,
preferring instead allocation via mmap().

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/blackfin/include/asm/page.h |    5 +++++
 arch/frv/include/asm/page.h      |    2 --
 fs/binfmt_elf_fdpic.c            |   13 +++++++++++--
 3 files changed, 16 insertions(+), 4 deletions(-)


diff --git a/arch/blackfin/include/asm/page.h b/arch/blackfin/include/asm/page.h
index 944a07c..1d04e40 100644
--- a/arch/blackfin/include/asm/page.h
+++ b/arch/blackfin/include/asm/page.h
@@ -10,4 +10,9 @@
 #include <asm-generic/page.h>
 #define MAP_NR(addr) (((unsigned long)(addr)-PAGE_OFFSET) >> PAGE_SHIFT)
 
+#define VM_DATA_DEFAULT_FLAGS \
+	(VM_READ | VM_WRITE | \
+	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
+		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
 #endif
diff --git a/arch/frv/include/asm/page.h b/arch/frv/include/asm/page.h
index 25c6a50..8c97068 100644
--- a/arch/frv/include/asm/page.h
+++ b/arch/frv/include/asm/page.h
@@ -63,12 +63,10 @@ extern unsigned long max_pfn;
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 
 
-#ifdef CONFIG_MMU
 #define VM_DATA_DEFAULT_FLAGS \
 	(VM_READ | VM_WRITE | \
 	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
 		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-#endif
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 56f159b..4bd0a27 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -171,6 +171,9 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 #ifdef ELF_FDPIC_PLAT_INIT
 	unsigned long dynaddr;
 #endif
+#ifndef CONFIG_MMU
+	unsigned long stack_prot;
+#endif
 	struct file *interpreter = NULL; /* to shut gcc up */
 	char *interpreter_name = NULL;
 	int executable_stack;
@@ -316,6 +319,8 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	 * defunct, deceased, etc. after this point we have to exit via
 	 * error_kill */
 	set_personality(PER_LINUX_FDPIC);
+	if (elf_read_implies_exec(&exec_params.hdr, executable_stack))
+		current->personality |= READ_IMPLIES_EXEC;
 	set_binfmt(&elf_fdpic_format);
 
 	current->mm->start_code = 0;
@@ -377,9 +382,13 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	if (stack_size < PAGE_SIZE * 2)
 		stack_size = PAGE_SIZE * 2;
 
+	stack_prot = PROT_READ | PROT_WRITE;
+	if (executable_stack == EXSTACK_ENABLE_X ||
+	    (executable_stack == EXSTACK_DEFAULT && VM_STACK_FLAGS & VM_EXEC))
+		stack_prot |= PROT_EXEC;
+
 	down_write(&current->mm->mmap_sem);
-	current->mm->start_brk = do_mmap(NULL, 0, stack_size,
-					 PROT_READ | PROT_WRITE | PROT_EXEC,
+	current->mm->start_brk = do_mmap(NULL, 0, stack_size, stack_prot,
 					 MAP_PRIVATE | MAP_ANONYMOUS |
 					 MAP_UNINITIALIZED | MAP_GROWSDOWN,
 					 0);

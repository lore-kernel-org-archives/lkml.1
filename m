Return-Path: <linux-kernel-owner+w=401wt.eu-S932422Ab0AFRYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab0AFRYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932405Ab0AFRYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:24:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab0AFRYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:24:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/4] FDPIC: Respect PT_GNU_STACK exec protection markings when
	creating NOMMU stack
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
       Mike Frysinger <vapier@gentoo.org>, David Howells <dhowells@redhat.com>
Date: Wed, 06 Jan 2010 17:23:17 +0000
Message-ID: <20100106172317.25862.64950.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

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
index 7dc8599..c57d9ce 100644
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


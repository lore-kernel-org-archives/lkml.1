Return-Path: <linux-kernel-owner+w=401wt.eu-S1761234AbYGQWnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761234AbYGQWnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbYGQWnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:43:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbYGQWnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:43:42 -0400
Date: Thu, 17 Jul 2008 15:42:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Lynch <ntl@pobox.com>
Cc: benh@kernel.crashing.org, torvalds@linux-foundation.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       roland@redhat.com, John Reiser <jreiser@BitWagon.com>
Subject: Re: [PATCH v3] elf loader support for auxvec base platform string
Message-Id: <20080717154218.8981035c.akpm@linux-foundation.org>
In-Reply-To: <20080717221932.GL9594@localdomain>
References: <1216166331-14810-1-git-send-email-ntl@pobox.com>
	<1216166331-14810-2-git-send-email-ntl@pobox.com>
	<1216276539.7740.309.camel@pasglop>
	<20080717000951.5f8cab37.akpm@linux-foundation.org>
	<20080717221932.GL9594@localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 17:19:32 -0500
Nathan Lynch <ntl@pobox.com> wrote:

> Some IBM POWER-based platforms have the ability to run in a
> mode which mostly appears to the OS as a different processor from the
> actual hardware.  For example, a Power6 system may appear to be a
> Power5+, which makes the AT_PLATFORM value "power5+".  This means that
> programs are restricted to the ISA supported by Power5+;
> Power6-specific instructions are treated as illegal.
> 
> However, some applications (virtual machines, optimized libraries) can
> benefit from knowledge of the underlying CPU model.  A new aux vector
> entry, AT_BASE_PLATFORM, will denote the actual hardware.  For
> example, on a Power6 system in Power5+ compatibility mode, AT_PLATFORM
> will be "power5+" and AT_BASE_PLATFORM will be "power6".  The idea is
> that AT_PLATFORM indicates the instruction set supported, while
> AT_BASE_PLATFORM indicates the underlying microarchitecture.
> 
> If the architecture has defined ELF_BASE_PLATFORM, copy that value to
> the user stack in the same manner as ELF_PLATFORM.
> 
> Signed-off-by: Nathan Lynch <ntl@pobox.com>
> 
> ---
> 
> Added comment explaining ELF_BASE_PLATFORM.
> 
>  fs/binfmt_elf.c        |   28 ++++++++++++++++++++++++++++
>  include/linux/auxvec.h |    5 ++++-
>  2 files changed, 32 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index d48ff5f..d8a7cc0 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -131,6 +131,15 @@ static int padzero(unsigned long elf_bss)
>  #define STACK_ALLOC(sp, len) ({ sp -= len ; sp; })
>  #endif
>  
> +#ifndef ELF_BASE_PLATFORM
> +/*
> + * AT_BASE_PLATFORM indicates the "real" hardware/microarchitecture.
> + * If the arch defines ELF_BASE_PLATFORM (in asm/elf.h), the value
> + * will be copied to the user stack in the same manner as AT_PLATFORM.
> + */
> +#define ELF_BASE_PLATFORM NULL
> +#endif
> +
>  static int
>  create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>  		unsigned long load_addr, unsigned long interp_load_addr)
> @@ -142,7 +151,9 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>  	elf_addr_t __user *envp;
>  	elf_addr_t __user *sp;
>  	elf_addr_t __user *u_platform;
> +	elf_addr_t __user *u_base_platform;
>  	const char *k_platform = ELF_PLATFORM;
> +	const char *k_base_platform = ELF_BASE_PLATFORM;
>  	int items;
>  	elf_addr_t *elf_info;
>  	int ei_index = 0;
> @@ -172,6 +183,19 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>  			return -EFAULT;
>  	}
>  
> +	/*
> +	 * If this architecture has a "base" platform capability
> +	 * string, copy it to userspace.
> +	 */
> +	u_base_platform = NULL;
> +	if (k_base_platform) {
> +		size_t len = strlen(k_base_platform) + 1;
> +
> +		u_base_platform = (elf_addr_t __user *)STACK_ALLOC(p, len);
> +		if (__copy_to_user(u_base_platform, k_base_platform, len))
> +			return -EFAULT;
> +	}
> +
>  	/* Create the ELF interpreter info */
>  	elf_info = (elf_addr_t *)current->mm->saved_auxv;
>  	/* update AT_VECTOR_SIZE_BASE if the number of NEW_AUX_ENT() changes */
> @@ -208,6 +232,10 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>  		NEW_AUX_ENT(AT_PLATFORM,
>  			    (elf_addr_t)(unsigned long)u_platform);
>  	}
> +	if (k_base_platform) {
> +		NEW_AUX_ENT(AT_BASE_PLATFORM,
> +			    (elf_addr_t)(unsigned long)u_base_platform);
> +	}
>  	if (bprm->interp_flags & BINPRM_FLAGS_EXECFD) {
>  		NEW_AUX_ENT(AT_EXECFD, bprm->interp_data);
>  	}
> diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
> index ad89545..1adc61d 100644
> --- a/include/linux/auxvec.h
> +++ b/include/linux/auxvec.h
> @@ -26,8 +26,11 @@
>  
>  #define AT_SECURE 23   /* secure mode boolean */
>  
> +#define AT_BASE_PLATFORM 38	/* string identifying real platform, may
> +				 * differ from AT_PLATFORM. */
> +
>  #ifdef __KERNEL__
> -#define AT_VECTOR_SIZE_BASE (14 + 2) /* NEW_AUX_ENT entries in auxiliary table */
> +#define AT_VECTOR_SIZE_BASE (14 + 3) /* NEW_AUX_ENT entries in auxiliary table */
>  #endif
>  
>  #endif /* _LINUX_AUXVEC_H */

OK.

But it conflicts directly with the already-queued
execve-filename-document-and-export-via-auxiliary-vector.patch (which
various potential reviewers blithely deleted - don't come complaining
to me!):


From: John Reiser <jreiser@BitWagon.com>

The Linux kernel puts the filename argument of execve() into the
new address space.  Many developers are surprised to learn this.
Those who know and could use it, object "But it's not documented."
Those who want to use it dislike the expression
  (char *)(1+ strlen(env[-1+ n_env]) + env[-1+ n_env])
because it requires locating the last original environment variable,
and assumes that the filename follows the characters.

This patch documents the insertion of the filename, and makes it easier to
find by adding a new tag AT_EXECFN in the ElfXX_auxv_t; see <elf.h>.

In many cases readlink("/proc/self/exe",) gives the same answer.  But if all
the original pages get unmapped, then the kernel erases the symlink for
/proc/self/exe.  This can happen when a program decompressor does a good job
of cleaning up after uncompressing directly to memory, so that the address
space of the target program looks the same as if compression had never
happened.  One example is http://upx.sourceforge.net .

One notable use of the underlying concept (what path containED the executable)
is glibc expanding $ORIGIN in DT_RUNPATH.  In practice for the near term, it
may be a good idea for user-mode code to use both /proc/self/exe and AT_EXECFN
as fall-back methods for each other.  /proc/self/exe can fail due to
unmapping, AT_EXECFN can fail because it won't be present on non-new systems. 
The auxvec or {AT_EXECFN}.d_val also can get overwritten, although in nearly
all cases this would be the result of a bug.

The runtime cost is one NEW_AUX_ENT using two words of stack space.  The
underlying value is maintained already as bprm->exec; setup_arg_pages() in
fs/exec.c slides it for stack_shift, etc.

Signed-off-by: John Reiser <jreiser@BitWagon.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c        |    1 +
 include/linux/auxvec.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~execve-filename-document-and-export-via-auxiliary-vector fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~execve-filename-document-and-export-via-auxiliary-vector
+++ a/fs/binfmt_elf.c
@@ -204,6 +204,7 @@ create_elf_tables(struct linux_binprm *b
 	NEW_AUX_ENT(AT_GID, tsk->gid);
 	NEW_AUX_ENT(AT_EGID, tsk->egid);
  	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
+	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
 	if (k_platform) {
 		NEW_AUX_ENT(AT_PLATFORM,
 			    (elf_addr_t)(unsigned long)u_platform);
diff -puN include/linux/auxvec.h~execve-filename-document-and-export-via-auxiliary-vector include/linux/auxvec.h
--- a/include/linux/auxvec.h~execve-filename-document-and-export-via-auxiliary-vector
+++ a/include/linux/auxvec.h
@@ -26,8 +26,10 @@
 
 #define AT_SECURE 23   /* secure mode boolean */
 
+#define AT_EXECFN  31	/* filename of program */
 #ifdef __KERNEL__
-#define AT_VECTOR_SIZE_BASE (14 + 2) /* NEW_AUX_ENT entries in auxiliary table */
+#define AT_VECTOR_SIZE_BASE 17 /* NEW_AUX_ENT entries in auxiliary table */
+  /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
 #endif
 
 #endif /* _LINUX_AUXVEC_H */
_


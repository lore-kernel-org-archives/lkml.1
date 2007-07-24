Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbXGXPSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbXGXPSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbXGXPSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:18:16 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4206 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbXGXPSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:18:15 -0400
Date: Tue, 24 Jul 2007 11:17:38 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, wwoods@redhat.com
Subject: Re: [PATCH]: allow individual core dump methods to be unlimited when sending to a pipe
Message-ID: <20070724151738.GB23976@hmsreliant.homelinux.net>
References: <20070722153947.GA11941@hmsreliant.homelinux.net> <20070724020939.7644f18c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724020939.7644f18c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 02:09:39AM -0700, Andrew Morton wrote:
> On Sun, 22 Jul 2007 11:39:47 -0400 Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > 	This is a follow on to the patch entitled:
> > update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
> > It allows individual core dump methods to have the core dump size limit passed
> > into them.  Its more efficient than each method having to retrieve it on their
> > own, and it allows for do_coredump to specify a infinite limit in the event that
> > a pipe is configured in /proc/sys/kernel/core_pattern, in which case ulimit -c
> > should not apply.
> 
> Needed this warning fix:
> 
> fs/exec.c: In function 'do_coredump':
> fs/exec.c:1761: warning: large integer implicitly truncated to unsigned type
> 
> diff -puN fs/exec.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix fs/exec.c
> --- a/fs/exec.c~allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix
> +++ a/fs/exec.c
> @@ -1703,7 +1703,7 @@ int do_coredump(long signr, int exit_cod
>  	int fsuid = current->fsuid;
>  	int flag = 0;
>  	int ispipe = 0;
> -	u32 core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
> +	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
>  
>  	audit_core_dumps(signr);
>  
> _
> 
> which makes me worry about how much care was taken here on 32/64 issues,
> and crsos-arch issues (the underlying type for compat_ulong_t, for one).
> 
> Could you please go over it with a toothcomb, see if there are any other
> slipups there?
> 
> 
> Thanks.

Heres the subsequent patch that I promised you.  It changes all the limit
passing to be unsigned longs.  I've built it on x86, x86_64 and ia64 and it
seems to be good to go.  It leaves off the bit that you have above, since you've
already included that.

Thanks & Regards
Neil


Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 arch/x86_64/ia32/ia32_aout.c |    2 +-
 fs/binfmt_aout.c             |    2 +-
 fs/binfmt_elf.c              |    4 ++--
 fs/binfmt_elf_fdpic.c        |    2 +-
 fs/binfmt_flat.c             |    2 +-
 fs/binfmt_som.c              |    2 +-
 fs/exec.c                    |    2 +-
 include/linux/binfmts.h      |    2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)



diff --git a/arch/x86_64/ia32/ia32_aout.c b/arch/x86_64/ia32/ia32_aout.c
index 5967cc5..61acc5c 100644
--- a/arch/x86_64/ia32/ia32_aout.c
+++ b/arch/x86_64/ia32/ia32_aout.c
@@ -148,7 +148,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit)
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index e247d80..e914b82 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -88,7 +88,7 @@ if (file->f_op->llseek) { \
  * dumping of the process results in another error..
  */
 
-static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit)
+static int aout_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit)
 {
 	mm_segment_t fs;
 	int has_dumped = 0;
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index cd81def..cbda09b 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -52,7 +52,7 @@ static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, i
  * don't even try.
  */
 #if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
-static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, u32 limit);
+static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit);
 #else
 #define elf_core_dump	NULL
 #endif
@@ -1488,7 +1488,7 @@ static struct vm_area_struct *next_vma(struct vm_area_struct *this_vma,
  * and then they are actually written out.  If we run out of core limit
  * we just truncate.
  */
-static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, u32 limit)
+static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, unsigned long limit)
 {
 #define	NUM_NOTES	6
 	int has_dumped = 0;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index fb4ad53..f2871e5 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1552,7 +1552,7 @@ static int elf_fdpic_dump_segments(struct file *file, size_t *size,
  * we just truncate.
  */
 static int elf_fdpic_core_dump(long signr, struct pt_regs *regs,
-			       struct file *file, u32 limit)
+			       struct file *file, unsigned long limit)
 {
 #define	NUM_NOTES	6
 	int has_dumped = 0;
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 1a17556..e8f8198 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -90,7 +90,7 @@ static struct linux_binfmt flat_format = {
  * Currently only a stub-function.
  */
 
-static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, u32 limit)
+static int flat_core_dump(long signr, struct pt_regs * regs, struct file *file, unsigned long limit)
 {
 	printk("Process %s:%d received signr %d and should have core dumped\n",
 			current->comm, current->pid, (int) signr);
diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
index 0da1fae..7474970 100644
--- a/fs/binfmt_som.c
+++ b/fs/binfmt_som.c
@@ -44,7 +44,7 @@ static int load_som_library(struct file *);
  * don't even try.
  */
 #if 0
-static int som_core_dump(long signr, struct pt_regs * regs, u32 limit);
+static int som_core_dump(long signr, struct pt_regs * regs, unsigned long limit);
 #else
 #define som_core_dump	NULL
 #endif
diff --git a/fs/exec.c b/fs/exec.c
index 3b2e1e7..c0b5def 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1726,7 +1726,7 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 	int fsuid = current->fsuid;
 	int flag = 0;
 	int ispipe = 0;
-	u32 core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
+	unsigned long core_limit = current->signal->rlim[RLIMIT_CORE].rlim_cur;
 
 	audit_core_dumps(signr);
 
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 3188627..fb62eda 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -67,7 +67,7 @@ struct linux_binfmt {
 	struct module *module;
 	int (*load_binary)(struct linux_binprm *, struct  pt_regs * regs);
 	int (*load_shlib)(struct file *);
-	int (*core_dump)(long signr, struct pt_regs * regs, struct file * file, u32 limit);
+	int (*core_dump)(long signr, struct pt_regs * regs, struct file * file, unsigned long limit);
 	unsigned long min_coredump;	/* minimal dump size */
 	int hasvdso;
 };
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/

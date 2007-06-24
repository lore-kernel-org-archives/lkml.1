Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbXFXRpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbXFXRpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 13:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXFXRpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 13:45:31 -0400
Received: from gateway-b.fh-trier.de ([143.93.54.182]:34015 "EHLO
	gateway-b.fh-trier.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbXFXRp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 13:45:29 -0400
Message-ID: <467EADA0.9020101@gentoo.org>
Date: Sun, 24 Jun 2007 19:45:04 +0200
From: Alexander Gabert <pappy@gentoo.org>
Organization: Hardened Gentoo Linux
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
CC: Matt Mackall <mpm@selenic.com>, Arjan van de Ven <arjan@infradead.org>,
       libc-alpha@sourceware.org, hardened@gentoo.org
Subject: Re: [PATCH] get_random_long() and AT_ENTROPY for auxv, kernel 2.6.21.5
References: <4675C678.3080807@gentoo.org> <1182128803.22999.9.camel@laptopd505.fenrus.org> <4675DFA8.606 <20070620203022.GO11166@waste.org>
In-Reply-To: <20070620203022.GO11166@waste.org>
Content-Type: multipart/mixed;
 boundary="------------070609000900040707070808"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070609000900040707070808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Linus,
hi LKML,

i would like to thank LKML and especially Eric (thanks for the per_cpu 
macro tips and design guidelines!) and the other contributors to this idea.

This time the patch is rather big because it also removes 
get_random_int() and introduces get_random_long() throughout the kernel.
The function get_random_int was primarily used for setting up the 
randomization of memory used for process stacks and initializing a stack 
canary in a tsk.
However, using get_random_long works exactly the same way to generate 
randomization deltas for this purpose and i have applied it to all 
locations where get_random_int was previously used.

Now to explain the reasoning for replacing get_random_int...
My findings with get_random_int was that when i called it two times very 
fast after another because of setting up two SSP randomized guard values 
for the same process, it returned the same, yet randomized, integer number.

I learned that get_random_int uses the current process pid and the 
current jiffies for feeding the half_md4_transform function that's 
following deeper in the code.  However, when called in a relatively 
short timeframe (lesser than a jiffie can increase it's count), this 
information given to the underlying "randomization" generation is not 
changing, which means when you call get_random_int two or more times in 
short time, it will use the same data for generating the randomized 
data, which is the pid of the process and current jiffies.  The returned 
randomized integer numbers are the same because the pid and the jiffies 
used as the input for the randomization function did not change in such 
a short time.  Sorry that i cannot explain it more detailed or in better 
english, you should be able to see it from the code looking at 
get_random_int and how it's working by calling the other function and 
looking at the input to the function.
Also remember that the comment in the function is probably a bit 
outdated because rekeying is happening not every 1 second any more.

This is the url for the patch:
http://dev.gentoo.org/~pappy/kernel/linux-2.6.21.5-get_random_long-AT_ENTROPY.patch

Thanks for the attention and thanks again to all posters for your help!


-Alex

This is the inlined patch, i changed my vimrc and really hope i'm not 
making a whitespace error again:

diff -Nru linux-2.6.21.5.ORIG/arch/i386/kernel/process.c linux-2.6.21.5/arch/i386/kernel/process.c
--- linux-2.6.21.5.ORIG/arch/i386/kernel/process.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/i386/kernel/process.c	2007-06-24 19:00:15.000000000 +0200
@@ -924,6 +924,6 @@
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() % 8192;
+		sp -= get_random_long() % 8192;
 	return sp & ~0xf;
 }
diff -Nru linux-2.6.21.5.ORIG/arch/i386/mm/mmap.c linux-2.6.21.5/arch/i386/mm/mmap.c
--- linux-2.6.21.5.ORIG/arch/i386/mm/mmap.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/i386/mm/mmap.c	2007-06-24 19:00:53.000000000 +0200
@@ -42,7 +42,7 @@
 	unsigned long random_factor = 0;
 
 	if (current->flags & PF_RANDOMIZE)
-		random_factor = get_random_int() % (1024*1024);
+		random_factor = get_random_long() % (1024*1024);
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
diff -Nru linux-2.6.21.5.ORIG/arch/sparc64/kernel/sys_sparc.c linux-2.6.21.5/arch/sparc64/kernel/sys_sparc.c
--- linux-2.6.21.5.ORIG/arch/sparc64/kernel/sys_sparc.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/sparc64/kernel/sys_sparc.c	2007-06-24 19:01:44.000000000 +0200
@@ -362,7 +362,7 @@
 	unsigned long random_factor = 0UL;
 
 	if (current->flags & PF_RANDOMIZE) {
-		random_factor = get_random_int();
+		random_factor = get_random_long();
 		if (test_thread_flag(TIF_32BIT))
 			random_factor &= ((1 * 1024 * 1024) - 1);
 		else
diff -Nru linux-2.6.21.5.ORIG/arch/um/kernel/process.c linux-2.6.21.5/arch/um/kernel/process.c
--- linux-2.6.21.5.ORIG/arch/um/kernel/process.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/um/kernel/process.c	2007-06-24 19:02:08.000000000 +0200
@@ -478,7 +478,7 @@
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() % 8192;
+		sp -= get_random_long() % 8192;
 	return sp & ~0xf;
 }
 #endif
diff -Nru linux-2.6.21.5.ORIG/arch/x86_64/ia32/mmap32.c linux-2.6.21.5/arch/x86_64/ia32/mmap32.c
--- linux-2.6.21.5.ORIG/arch/x86_64/ia32/mmap32.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/x86_64/ia32/mmap32.c	2007-06-24 19:02:34.000000000 +0200
@@ -44,7 +44,7 @@
 	unsigned long random_factor = 0;
 
 	if (current->flags & PF_RANDOMIZE)
-		random_factor = get_random_int() % (1024*1024);
+		random_factor = get_random_long() % (1024*1024);
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
diff -Nru linux-2.6.21.5.ORIG/arch/x86_64/kernel/functionlist linux-2.6.21.5/arch/x86_64/kernel/functionlist
--- linux-2.6.21.5.ORIG/arch/x86_64/kernel/functionlist	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/x86_64/kernel/functionlist	2007-06-24 19:02:48.000000000 +0200
@@ -862,7 +862,7 @@
 *(.text.__ide_dma_end)
 *(.text.hrtimer_get_remaining)
 *(.text.get_task_mm)
-*(.text.get_random_int)
+*(.text.get_random_long)
 *(.text.free_pipe_info)
 *(.text.filemap_write_and_wait_range)
 *(.text.exit_thread)
diff -Nru linux-2.6.21.5.ORIG/arch/x86_64/kernel/process.c linux-2.6.21.5/arch/x86_64/kernel/process.c
--- linux-2.6.21.5.ORIG/arch/x86_64/kernel/process.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/x86_64/kernel/process.c	2007-06-24 19:03:02.000000000 +0200
@@ -885,6 +885,6 @@
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() % 8192;
+		sp -= get_random_long() % 8192;
 	return sp & ~0xf;
 }
diff -Nru linux-2.6.21.5.ORIG/arch/x86_64/mm/mmap.c linux-2.6.21.5/arch/x86_64/mm/mmap.c
--- linux-2.6.21.5.ORIG/arch/x86_64/mm/mmap.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/x86_64/mm/mmap.c	2007-06-24 19:03:47.000000000 +0200
@@ -18,9 +18,9 @@
 	if (current->flags & PF_RANDOMIZE) {
 		/* Add 28bit randomness which is about 40bits of address space
 		   because mmap base has to be page aligned.
- 		   or ~1/128 of the total user VM
-	   	   (total user address space is 47bits) */
-		unsigned rnd = get_random_int() & 0xfffffff;
+		   or ~1/128 of the total user VM
+		   (total user address space is 47bits) */
+		unsigned rnd = get_random_long() & 0xfffffff;
 		mm->mmap_base += ((unsigned long)rnd) << PAGE_SHIFT;
 	}
 	mm->get_unmapped_area = arch_get_unmapped_area;
diff -Nru linux-2.6.21.5.ORIG/drivers/char/random.c linux-2.6.21.5/drivers/char/random.c
--- linux-2.6.21.5.ORIG/drivers/char/random.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/drivers/char/random.c	2007-06-24 19:04:03.000000000 +0200
@@ -437,6 +437,9 @@
 	.pool = nonblocking_pool_data
 };
 
+static u32 entropycache_shared[8] __read_mostly;
+static DEFINE_PER_CPU(unsigned long , entropycache_pcpu)[16 / sizeof(unsigned long)];
+
 /*
  * This function adds a byte into the entropy "pool".  It does not
  * update the entropy estimate.  The caller should call
@@ -1455,6 +1458,10 @@
 	keyptr->count = (ip_cnt & COUNT_MASK) << HASH_BITS;
 	smp_wmb();
 	ip_cnt++;
+
+	/* initialize the shared part of the entropy cache */
+	get_random_bytes(entropycache_shared, sizeof(entropycache_shared));
+
 	schedule_delayed_work(&rekey_work, REKEY_INTERVAL);
 }
 
@@ -1637,20 +1644,17 @@
 
 
 /*
- * Get a random word for internal kernel use only. Similar to urandom but
- * with the goal of minimal entropy pool depletion. As a result, the random
- * value is not cryptographically secure but for several uses the cost of
- * depleting entropy is too high
+ * get_random_long() returns a randomized unsigned long word.
+ * The entropy cache is refreshed periodically in rekey_seq_generator.
+ * This function uses half_md4_transform to generate a unique return value
+ * and is not intended for strong cryptographic routines.
  */
-unsigned int get_random_int(void)
+unsigned long get_random_long(void)
 {
-	/*
-	 * Use IP's RNG. It suits our purpose perfectly: it re-keys itself
-	 * every second, from the entropy pool (and thus creates a limited
-	 * drain on it), and uses halfMD4Transform within the second. We
-	 * also mix it with jiffies and the PID:
-	 */
-	return secure_ip_id((__force __be32)(current->pid + jiffies));
+	half_md4_transform((u32 *)__get_cpu_var(entropycache_pcpu),
+				entropycache_shared);
+
+	return __get_cpu_var(entropycache_pcpu)[0];
 }
 
 /*
@@ -1669,5 +1673,5 @@
 
 	if (end <= start + len)
 		return 0;
-	return PAGE_ALIGN(get_random_int() % range + start);
+	return PAGE_ALIGN(get_random_long() % range + start);
 }
diff -Nru linux-2.6.21.5.ORIG/fs/binfmt_elf.c linux-2.6.21.5/fs/binfmt_elf.c
--- linux-2.6.21.5.ORIG/fs/binfmt_elf.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/fs/binfmt_elf.c	2007-06-24 19:04:24.000000000 +0200
@@ -200,7 +200,8 @@
 	NEW_AUX_ENT(AT_EUID, tsk->euid);
 	NEW_AUX_ENT(AT_GID, tsk->gid);
 	NEW_AUX_ENT(AT_EGID, tsk->egid);
- 	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
+	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
+	NEW_AUX_ENT(AT_ENTROPY, get_random_long());
 	if (k_platform) {
 		NEW_AUX_ENT(AT_PLATFORM,
 			    (elf_addr_t)(unsigned long)u_platform);
@@ -516,7 +517,7 @@
 
 	if ((current->flags & PF_RANDOMIZE) &&
 		!(current->personality & ADDR_NO_RANDOMIZE)) {
-		random_variable = get_random_int() & STACK_RND_MASK;
+		random_variable = get_random_long() & STACK_RND_MASK;
 		random_variable <<= PAGE_SHIFT;
 	}
 #ifdef CONFIG_STACK_GROWSUP
diff -Nru linux-2.6.21.5.ORIG/include/linux/auxvec.h linux-2.6.21.5/include/linux/auxvec.h
--- linux-2.6.21.5.ORIG/include/linux/auxvec.h	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/include/linux/auxvec.h	2007-06-24 17:39:12.000000000 +0200
@@ -24,8 +24,9 @@
 #define AT_HWCAP  16    /* arch dependent hints at CPU capabilities */
 #define AT_CLKTCK 17	/* frequency at which times() increments */
 
-#define AT_SECURE 23   /* secure mode boolean */
+#define AT_SECURE 23	/* secure mode boolean */
+#define AT_ENTROPY 24	/* kernel entropy in auxv */
 
-#define AT_VECTOR_SIZE  44 /* Size of auxiliary table.  */
+#define AT_VECTOR_SIZE  45 /* Size of auxiliary table.  */
 
 #endif /* _LINUX_AUXVEC_H */
diff -Nru linux-2.6.21.5.ORIG/include/linux/random.h linux-2.6.21.5/include/linux/random.h
--- linux-2.6.21.5.ORIG/include/linux/random.h	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/include/linux/random.h	2007-06-24 18:19:54.000000000 +0200
@@ -66,7 +66,7 @@
 extern const struct file_operations random_fops, urandom_fops;
 #endif
 
-unsigned int get_random_int(void);
+unsigned long get_random_long(void);
 unsigned long randomize_range(unsigned long start, unsigned long end, unsigned long len);
 
 u32 random32(void);
diff -Nru linux-2.6.21.5.ORIG/kernel/fork.c linux-2.6.21.5/kernel/fork.c
--- linux-2.6.21.5.ORIG/kernel/fork.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/kernel/fork.c	2007-06-24 19:05:00.000000000 +0200
@@ -180,7 +180,7 @@
 	setup_thread_stack(tsk, orig);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
-	tsk->stack_canary = get_random_int();
+	tsk->stack_canary = get_random_long();
 #endif
 
 	/* One for us, one for whoever does the "release_task()" (usually parent) */


--------------070609000900040707070808
Content-Type: text/plain;
 name="linux-2.6.21.5-get_random_long-AT_ENTROPY.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.21.5-get_random_long-AT_ENTROPY.patch"

diff -Nru linux-2.6.21.5.ORIG/arch/i386/kernel/process.c linux-2.6.21.5/arch/i386/kernel/process.c
--- linux-2.6.21.5.ORIG/arch/i386/kernel/process.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/i386/kernel/process.c	2007-06-24 19:00:15.000000000 +0200
@@ -924,6 +924,6 @@
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() % 8192;
+		sp -= get_random_long() % 8192;
 	return sp & ~0xf;
 }
diff -Nru linux-2.6.21.5.ORIG/arch/i386/mm/mmap.c linux-2.6.21.5/arch/i386/mm/mmap.c
--- linux-2.6.21.5.ORIG/arch/i386/mm/mmap.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/i386/mm/mmap.c	2007-06-24 19:00:53.000000000 +0200
@@ -42,7 +42,7 @@
 	unsigned long random_factor = 0;
 
 	if (current->flags & PF_RANDOMIZE)
-		random_factor = get_random_int() % (1024*1024);
+		random_factor = get_random_long() % (1024*1024);
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
diff -Nru linux-2.6.21.5.ORIG/arch/sparc64/kernel/sys_sparc.c linux-2.6.21.5/arch/sparc64/kernel/sys_sparc.c
--- linux-2.6.21.5.ORIG/arch/sparc64/kernel/sys_sparc.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/sparc64/kernel/sys_sparc.c	2007-06-24 19:01:44.000000000 +0200
@@ -362,7 +362,7 @@
 	unsigned long random_factor = 0UL;
 
 	if (current->flags & PF_RANDOMIZE) {
-		random_factor = get_random_int();
+		random_factor = get_random_long();
 		if (test_thread_flag(TIF_32BIT))
 			random_factor &= ((1 * 1024 * 1024) - 1);
 		else
diff -Nru linux-2.6.21.5.ORIG/arch/um/kernel/process.c linux-2.6.21.5/arch/um/kernel/process.c
--- linux-2.6.21.5.ORIG/arch/um/kernel/process.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/um/kernel/process.c	2007-06-24 19:02:08.000000000 +0200
@@ -478,7 +478,7 @@
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() % 8192;
+		sp -= get_random_long() % 8192;
 	return sp & ~0xf;
 }
 #endif
diff -Nru linux-2.6.21.5.ORIG/arch/x86_64/ia32/mmap32.c linux-2.6.21.5/arch/x86_64/ia32/mmap32.c
--- linux-2.6.21.5.ORIG/arch/x86_64/ia32/mmap32.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/x86_64/ia32/mmap32.c	2007-06-24 19:02:34.000000000 +0200
@@ -44,7 +44,7 @@
 	unsigned long random_factor = 0;
 
 	if (current->flags & PF_RANDOMIZE)
-		random_factor = get_random_int() % (1024*1024);
+		random_factor = get_random_long() % (1024*1024);
 
 	if (gap < MIN_GAP)
 		gap = MIN_GAP;
diff -Nru linux-2.6.21.5.ORIG/arch/x86_64/kernel/functionlist linux-2.6.21.5/arch/x86_64/kernel/functionlist
--- linux-2.6.21.5.ORIG/arch/x86_64/kernel/functionlist	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/x86_64/kernel/functionlist	2007-06-24 19:02:48.000000000 +0200
@@ -862,7 +862,7 @@
 *(.text.__ide_dma_end)
 *(.text.hrtimer_get_remaining)
 *(.text.get_task_mm)
-*(.text.get_random_int)
+*(.text.get_random_long)
 *(.text.free_pipe_info)
 *(.text.filemap_write_and_wait_range)
 *(.text.exit_thread)
diff -Nru linux-2.6.21.5.ORIG/arch/x86_64/kernel/process.c linux-2.6.21.5/arch/x86_64/kernel/process.c
--- linux-2.6.21.5.ORIG/arch/x86_64/kernel/process.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/x86_64/kernel/process.c	2007-06-24 19:03:02.000000000 +0200
@@ -885,6 +885,6 @@
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() % 8192;
+		sp -= get_random_long() % 8192;
 	return sp & ~0xf;
 }
diff -Nru linux-2.6.21.5.ORIG/arch/x86_64/mm/mmap.c linux-2.6.21.5/arch/x86_64/mm/mmap.c
--- linux-2.6.21.5.ORIG/arch/x86_64/mm/mmap.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/arch/x86_64/mm/mmap.c	2007-06-24 19:03:47.000000000 +0200
@@ -18,9 +18,9 @@
 	if (current->flags & PF_RANDOMIZE) {
 		/* Add 28bit randomness which is about 40bits of address space
 		   because mmap base has to be page aligned.
- 		   or ~1/128 of the total user VM
-	   	   (total user address space is 47bits) */
-		unsigned rnd = get_random_int() & 0xfffffff;
+		   or ~1/128 of the total user VM
+		   (total user address space is 47bits) */
+		unsigned rnd = get_random_long() & 0xfffffff;
 		mm->mmap_base += ((unsigned long)rnd) << PAGE_SHIFT;
 	}
 	mm->get_unmapped_area = arch_get_unmapped_area;
diff -Nru linux-2.6.21.5.ORIG/drivers/char/random.c linux-2.6.21.5/drivers/char/random.c
--- linux-2.6.21.5.ORIG/drivers/char/random.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/drivers/char/random.c	2007-06-24 19:04:03.000000000 +0200
@@ -437,6 +437,9 @@
 	.pool = nonblocking_pool_data
 };
 
+static u32 entropycache_shared[8] __read_mostly;
+static DEFINE_PER_CPU(unsigned long , entropycache_pcpu)[16 / sizeof(unsigned long)];
+
 /*
  * This function adds a byte into the entropy "pool".  It does not
  * update the entropy estimate.  The caller should call
@@ -1455,6 +1458,10 @@
 	keyptr->count = (ip_cnt & COUNT_MASK) << HASH_BITS;
 	smp_wmb();
 	ip_cnt++;
+
+	/* initialize the shared part of the entropy cache */
+	get_random_bytes(entropycache_shared, sizeof(entropycache_shared));
+
 	schedule_delayed_work(&rekey_work, REKEY_INTERVAL);
 }
 
@@ -1637,20 +1644,17 @@
 
 
 /*
- * Get a random word for internal kernel use only. Similar to urandom but
- * with the goal of minimal entropy pool depletion. As a result, the random
- * value is not cryptographically secure but for several uses the cost of
- * depleting entropy is too high
+ * get_random_long() returns a randomized unsigned long word.
+ * The entropy cache is refreshed periodically in rekey_seq_generator.
+ * This function uses half_md4_transform to generate a unique return value
+ * and is not intended for strong cryptographic routines.
  */
-unsigned int get_random_int(void)
+unsigned long get_random_long(void)
 {
-	/*
-	 * Use IP's RNG. It suits our purpose perfectly: it re-keys itself
-	 * every second, from the entropy pool (and thus creates a limited
-	 * drain on it), and uses halfMD4Transform within the second. We
-	 * also mix it with jiffies and the PID:
-	 */
-	return secure_ip_id((__force __be32)(current->pid + jiffies));
+	half_md4_transform((u32 *)__get_cpu_var(entropycache_pcpu),
+				entropycache_shared);
+
+	return __get_cpu_var(entropycache_pcpu)[0];
 }
 
 /*
@@ -1669,5 +1673,5 @@
 
 	if (end <= start + len)
 		return 0;
-	return PAGE_ALIGN(get_random_int() % range + start);
+	return PAGE_ALIGN(get_random_long() % range + start);
 }
diff -Nru linux-2.6.21.5.ORIG/fs/binfmt_elf.c linux-2.6.21.5/fs/binfmt_elf.c
--- linux-2.6.21.5.ORIG/fs/binfmt_elf.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/fs/binfmt_elf.c	2007-06-24 19:04:24.000000000 +0200
@@ -200,7 +200,8 @@
 	NEW_AUX_ENT(AT_EUID, tsk->euid);
 	NEW_AUX_ENT(AT_GID, tsk->gid);
 	NEW_AUX_ENT(AT_EGID, tsk->egid);
- 	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
+	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
+	NEW_AUX_ENT(AT_ENTROPY, get_random_long());
 	if (k_platform) {
 		NEW_AUX_ENT(AT_PLATFORM,
 			    (elf_addr_t)(unsigned long)u_platform);
@@ -516,7 +517,7 @@
 
 	if ((current->flags & PF_RANDOMIZE) &&
 		!(current->personality & ADDR_NO_RANDOMIZE)) {
-		random_variable = get_random_int() & STACK_RND_MASK;
+		random_variable = get_random_long() & STACK_RND_MASK;
 		random_variable <<= PAGE_SHIFT;
 	}
 #ifdef CONFIG_STACK_GROWSUP
diff -Nru linux-2.6.21.5.ORIG/include/linux/auxvec.h linux-2.6.21.5/include/linux/auxvec.h
--- linux-2.6.21.5.ORIG/include/linux/auxvec.h	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/include/linux/auxvec.h	2007-06-24 17:39:12.000000000 +0200
@@ -24,8 +24,9 @@
 #define AT_HWCAP  16    /* arch dependent hints at CPU capabilities */
 #define AT_CLKTCK 17	/* frequency at which times() increments */
 
-#define AT_SECURE 23   /* secure mode boolean */
+#define AT_SECURE 23	/* secure mode boolean */
+#define AT_ENTROPY 24	/* kernel entropy in auxv */
 
-#define AT_VECTOR_SIZE  44 /* Size of auxiliary table.  */
+#define AT_VECTOR_SIZE  45 /* Size of auxiliary table.  */
 
 #endif /* _LINUX_AUXVEC_H */
diff -Nru linux-2.6.21.5.ORIG/include/linux/random.h linux-2.6.21.5/include/linux/random.h
--- linux-2.6.21.5.ORIG/include/linux/random.h	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/include/linux/random.h	2007-06-24 18:19:54.000000000 +0200
@@ -66,7 +66,7 @@
 extern const struct file_operations random_fops, urandom_fops;
 #endif
 
-unsigned int get_random_int(void);
+unsigned long get_random_long(void);
 unsigned long randomize_range(unsigned long start, unsigned long end, unsigned long len);
 
 u32 random32(void);
diff -Nru linux-2.6.21.5.ORIG/kernel/fork.c linux-2.6.21.5/kernel/fork.c
--- linux-2.6.21.5.ORIG/kernel/fork.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/kernel/fork.c	2007-06-24 19:05:00.000000000 +0200
@@ -180,7 +180,7 @@
 	setup_thread_stack(tsk, orig);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
-	tsk->stack_canary = get_random_int();
+	tsk->stack_canary = get_random_long();
 #endif
 
 	/* One for us, one for whoever does the "release_task()" (usually parent) */

--------------070609000900040707070808--

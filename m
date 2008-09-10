Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbYIJOse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbYIJOse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYIJOsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:48:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:33887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbYIJOsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:48:14 -0400
Date: Wed, 10 Sep 2008 16:48:12 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: some lock annotations for user copy paths
Message-ID: <20080910144812.GB18644@wotan.suse.de>
References: <20080910113717.GB16811@wotan.suse.de> <1221046892.30429.85.camel@twins.programming.kicks-ass.net> <20080910114755.GA9696@elte.hu> <20080910121217.GA16013@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910121217.GA16013@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 02:12:17PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > shouldn't some of that be conditional on pagefault_disable() 'n 
> > > such?
> > 
> > i dont think so - those have their own special __atomic user-copy 
> > primitives which Nick didnt touch.
> 
> hm, but the prefetch bits were touched, and -tip testing stumbled upon 
> this false positive:
> 
> [   66.187448] PM: Adding info for No Bus:vcsa12
> [   67.138685] evbug.c: Event. Dev: input0, Type: 20, Code: 0, Value: 500
> [   80.149087] BUG: sleeping function called from invalid context at arch/x86/mm/fault.c:122
> [   80.157344] in_atomic(): 1, irqs_disabled(): 0, pid: 6811, name: gam_server
> [   80.164315] no locks held by gam_server/6811.
> [   80.168685] Pid: 6811, comm: gam_server Not tainted 2.6.27-rc6-tip-00187-gbfd4ed7-dirty #2
> [   80.177013] Call Trace:
> [   80.179454]  [<ffffffff8026c1e8>] ? __debug_show_held_locks+0x22/0x24
> [   80.185876]  [<ffffffff80242c4d>] __might_sleep+0x104/0x109
> [   80.191430]  [<ffffffff8022fd25>] is_prefetch+0xe8/0x228
> [   80.196760]  [<ffffffff8023050b>] do_page_fault+0x5d8/0x9a9
> [   80.202361]  [<ffffffff802c8218>] ? sys_newstat+0x36/0x41
> [   80.207774]  [<ffffffff80c3b2fa>] error_exit+0x0/0xb9
> 
> so i've excluded these commits for now. (once there's a fix i can 
> continue testing it)

Right, the prefetch stuff does get_user inside preempt_disable. Possibly
other code too, although ideally we would have a get_user_atomic, I will
give an intermediate soluation which is just what Peter suggested.

I've also moved it out of line to avoid sched.h and bad include bloating
and possible breakage.

---

copy_to/from_user and all its variants (except the atomic ones) can take a
page fault and perform non-trivial work like taking mmap_sem and entering
the filesyste/pagecache.

Unfortunately, this often escapes lockdep because a common pattern is to
use it to read in some arguments just set up from userspace, or write data
back to a hot buffer. In those cases, it will be unlikely for page reclaim
to get a window in to cause copy_*_user to fault.

With the new might_lock primitives, add some annotations to x86. I don't
know if I caught all possible faulting points (it's a bit of a maze, and I
didn't really look at 32-bit). But this is a starting point.

Boots and runs OK so far.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---

Index: linux-2.6/include/asm-x86/uaccess_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/uaccess_64.h
+++ linux-2.6/include/asm-x86/uaccess_64.h
@@ -28,6 +28,8 @@ static __always_inline __must_check
 int __copy_from_user(void *dst, const void __user *src, unsigned size)
 {
 	int ret = 0;
+
+	might_fault();
 	if (!__builtin_constant_p(size))
 		return copy_user_generic(dst, (__force void *)src, size);
 	switch (size) {
@@ -70,6 +72,8 @@ static __always_inline __must_check
 int __copy_to_user(void __user *dst, const void *src, unsigned size)
 {
 	int ret = 0;
+
+	might_fault();
 	if (!__builtin_constant_p(size))
 		return copy_user_generic((__force void *)dst, src, size);
 	switch (size) {
@@ -112,6 +116,8 @@ static __always_inline __must_check
 int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
 {
 	int ret = 0;
+
+	might_fault();
 	if (!__builtin_constant_p(size))
 		return copy_user_generic((__force void *)dst,
 					 (__force void *)src, size);
Index: linux-2.6/include/asm-x86/uaccess.h
===================================================================
--- linux-2.6.orig/include/asm-x86/uaccess.h
+++ linux-2.6/include/asm-x86/uaccess.h
@@ -157,6 +157,7 @@ extern int __get_user_bad(void);
 	int __ret_gu;							\
 	unsigned long __val_gu;						\
 	__chk_user_ptr(ptr);						\
+	might_fault();							\
 	switch (sizeof(*(ptr))) {					\
 	case 1:								\
 		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
@@ -241,6 +242,7 @@ extern void __put_user_8(void);
 	int __ret_pu;						\
 	__typeof__(*(ptr)) __pu_val;				\
 	__chk_user_ptr(ptr);					\
+	might_fault();						\
 	__pu_val = x;						\
 	switch (sizeof(*(ptr))) {				\
 	case 1:							\
@@ -265,6 +267,7 @@ extern void __put_user_8(void);
 #define __put_user_size(x, ptr, size, retval, errret)			\
 do {									\
 	retval = 0;							\
+	might_fault();							\
 	__chk_user_ptr(ptr);						\
 	switch (size) {							\
 	case 1:								\
@@ -317,6 +320,7 @@ do {									\
 #define __get_user_size(x, ptr, size, retval, errret)			\
 do {									\
 	retval = 0;							\
+	might_fault();							\
 	__chk_user_ptr(ptr);						\
 	switch (size) {							\
 	case 1:								\
Index: linux-2.6/arch/x86/lib/usercopy_32.c
===================================================================
--- linux-2.6.orig/arch/x86/lib/usercopy_32.c
+++ linux-2.6/arch/x86/lib/usercopy_32.c
@@ -32,7 +32,7 @@ static inline int __movsl_is_ok(unsigned
 #define __do_strncpy_from_user(dst, src, count, res)			   \
 do {									   \
 	int __d0, __d1, __d2;						   \
-	might_sleep();							   \
+	might_fault();							   \
 	__asm__ __volatile__(						   \
 		"	testl %1,%1\n"					   \
 		"	jz 2f\n"					   \
@@ -119,7 +119,7 @@ EXPORT_SYMBOL(strncpy_from_user);
 #define __do_clear_user(addr,size)					\
 do {									\
 	int __d0;							\
-	might_sleep();							\
+	might_fault();							\
 	__asm__ __volatile__(						\
 		"0:	rep; stosl\n"					\
 		"	movl %2,%0\n"					\
@@ -148,7 +148,6 @@ do {									\
 unsigned long
 clear_user(void __user *to, unsigned long n)
 {
-	might_sleep();
 	if (access_ok(VERIFY_WRITE, to, n))
 		__do_clear_user(to, n);
 	return n;
@@ -190,7 +189,7 @@ long strnlen_user(const char __user *s, 
 	unsigned long mask = -__addr_ok(s);
 	unsigned long res, tmp;
 
-	might_sleep();
+	might_fault();
 
 	__asm__ __volatile__(
 		"	testl %0, %0\n"
Index: linux-2.6/arch/x86/lib/usercopy_64.c
===================================================================
--- linux-2.6.orig/arch/x86/lib/usercopy_64.c
+++ linux-2.6/arch/x86/lib/usercopy_64.c
@@ -15,7 +15,7 @@
 #define __do_strncpy_from_user(dst,src,count,res)			   \
 do {									   \
 	long __d0, __d1, __d2;						   \
-	might_sleep();							   \
+	might_fault();							   \
 	__asm__ __volatile__(						   \
 		"	testq %1,%1\n"					   \
 		"	jz 2f\n"					   \
@@ -64,7 +64,7 @@ EXPORT_SYMBOL(strncpy_from_user);
 unsigned long __clear_user(void __user *addr, unsigned long size)
 {
 	long __d0;
-	might_sleep();
+	might_fault();
 	/* no memory constraint because it doesn't change any memory gcc knows
 	   about */
 	asm volatile(
Index: linux-2.6/include/asm-x86/uaccess_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/uaccess_32.h
+++ linux-2.6/include/asm-x86/uaccess_32.h
@@ -82,8 +82,8 @@ __copy_to_user_inatomic(void __user *to,
 static __always_inline unsigned long __must_check
 __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
-       might_sleep();
-       return __copy_to_user_inatomic(to, from, n);
+	might_fault();
+	return __copy_to_user_inatomic(to, from, n);
 }
 
 static __always_inline unsigned long
@@ -137,7 +137,7 @@ __copy_from_user_inatomic(void *to, cons
 static __always_inline unsigned long
 __copy_from_user(void *to, const void __user *from, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (__builtin_constant_p(n)) {
 		unsigned long ret;
 
@@ -159,7 +159,7 @@ __copy_from_user(void *to, const void __
 static __always_inline unsigned long __copy_from_user_nocache(void *to,
 				const void __user *from, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (__builtin_constant_p(n)) {
 		unsigned long ret;
 
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -3016,3 +3016,18 @@ void print_vma_addr(char *prefix, unsign
 	}
 	up_read(&current->mm->mmap_sem);
 }
+
+void might_fault(void)
+{
+	/*
+	 * it would be nicer only to annotatea paths which are not under
+	 * pagefault_disable, however that requires a larger audit and
+	 * providing helpers like get_user_atomic.
+	 */
+	if (!in_atomic()) {
+		might_sleep();
+		if (current->mm)
+			might_lock_read(&current->mm->mmap_sem);
+	}
+}
+EXPORT_SYMBOL(might_fault);
Index: linux-2.6/include/linux/kernel.h
===================================================================
--- linux-2.6.orig/include/linux/kernel.h
+++ linux-2.6/include/linux/kernel.h
@@ -140,6 +140,15 @@ extern int _cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
+#ifdef CONFIG_LOCKDEP
+void might_fault(void);
+#else
+static inline void might_fault(void)
+{
+	might_sleep();
+}
+#endif
+
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)

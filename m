Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYIJOal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYIJOal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYIJOaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:30:20 -0400
Received: from mx1.suse.de ([195.135.220.2]:42061 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbYIJOaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:30:18 -0400
Date: Wed, 10 Sep 2008 16:30:16 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: some lock annotations for user copy paths
Message-ID: <20080910143016.GA18644@wotan.suse.de>
References: <20080910113717.GB16811@wotan.suse.de> <1221046892.30429.85.camel@twins.programming.kicks-ass.net> <20080910114755.GA9696@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910114755.GA9696@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 01:47:55PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Wed, 2008-09-10 at 13:37 +0200, Nick Piggin wrote:
> > > copy_to/from_user and all its variants (except the atomic ones) can take a
> > > page fault and perform non-trivial work like taking mmap_sem and entering
> > > the filesyste/pagecache.
> > > 
> > > Unfortunately, this often escapes lockdep because a common pattern is to
> > > use it to read in some arguments just set up from userspace, or write data
> > > back to a hot buffer. In those cases, it will be unlikely for page reclaim
> > > to get a window in to cause copy_*_user to fault.
> > > 
> > > With the new might_lock primitives, add some annotations to x86. I don't
> > > know if I caught all possible faulting points (it's a bit of a maze, and I
> > > didn't really look at 32-bit). But this is a starting point.
> > > 
> > > Boots and runs OK so far.
> > 
> > shouldn't some of that be conditional on pagefault_disable() 'n such?
> 
> i dont think so - those have their own special __atomic user-copy 
> primitives which Nick didnt touch.
 
Right, it's a bit of a maze there, but yes we are safe because except for
where I added some missing ones, they all had might_sleep() there too,
which would complain if called under pagefault_disable I think.


> but i think it should be a single primitive sprinkled around, 
> might_fault(), which would be something like:
> 
> > > +	might_sleep();
> > > +	if (current->mm)
> > > +		might_lock_read(&current->mm->mmap_sem);
> 
> that way it's a lot less visually intrusive as well.

That's really the right way to do it, it makes it easier for other archs
to pick up, and it means we can add other things to it easily if needed.

Thanks,
Nick
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
@@ -8,6 +8,8 @@
 #include <linux/thread_info.h>
 #include <linux/prefetch.h>
 #include <linux/string.h>
+#include <linux/lockdep.h>
+#include <linux/sched.h>
 #include <asm/asm.h>
 #include <asm/page.h>
 
@@ -157,6 +159,7 @@ extern int __get_user_bad(void);
 	int __ret_gu;							\
 	unsigned long __val_gu;						\
 	__chk_user_ptr(ptr);						\
+	might_fault();							\
 	switch (sizeof(*(ptr))) {					\
 	case 1:								\
 		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
@@ -241,6 +244,7 @@ extern void __put_user_8(void);
 	int __ret_pu;						\
 	__typeof__(*(ptr)) __pu_val;				\
 	__chk_user_ptr(ptr);					\
+	might_fault();						\
 	__pu_val = x;						\
 	switch (sizeof(*(ptr))) {				\
 	case 1:							\
@@ -265,6 +269,7 @@ extern void __put_user_8(void);
 #define __put_user_size(x, ptr, size, retval, errret)			\
 do {									\
 	retval = 0;							\
+	might_fault();							\
 	__chk_user_ptr(ptr);						\
 	switch (size) {							\
 	case 1:								\
@@ -317,6 +322,7 @@ do {									\
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
 
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -2219,6 +2219,16 @@ static inline void mm_init_owner(struct 
 
 #define TASK_STATE_TO_CHAR_STR "RSDTtZX"
 
+/*
+ * Run some checks for a path that must be able to cope with a page fault.
+ */
+static inline void might_fault(void)
+{
+	might_sleep();
+	if (current->mm)
+		might_lock_read(&current->mm->mmap_sem);
+}
+
 #endif /* __KERNEL__ */
 
 #endif

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbYIJLlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbYIJLlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 07:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYIJLlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 07:41:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:38607 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYIJLlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 07:41:35 -0400
Subject: Re: [patch] x86: some lock annotations for user copy paths
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080910113717.GB16811@wotan.suse.de>
References: <20080910113717.GB16811@wotan.suse.de>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 13:41:32 +0200
Message-Id: <1221046892.30429.85.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 13:37 +0200, Nick Piggin wrote:
> copy_to/from_user and all its variants (except the atomic ones) can take a
> page fault and perform non-trivial work like taking mmap_sem and entering
> the filesyste/pagecache.
> 
> Unfortunately, this often escapes lockdep because a common pattern is to
> use it to read in some arguments just set up from userspace, or write data
> back to a hot buffer. In those cases, it will be unlikely for page reclaim
> to get a window in to cause copy_*_user to fault.
> 
> With the new might_lock primitives, add some annotations to x86. I don't
> know if I caught all possible faulting points (it's a bit of a maze, and I
> didn't really look at 32-bit). But this is a starting point.
> 
> Boots and runs OK so far.

shouldn't some of that be conditional on pagefault_disable() 'n such?

> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
> 
> Index: linux-2.6/include/asm-x86/uaccess_64.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/uaccess_64.h
> +++ linux-2.6/include/asm-x86/uaccess_64.h
> @@ -28,6 +28,10 @@ static __always_inline __must_check
>  int __copy_from_user(void *dst, const void __user *src, unsigned size)
>  {
>  	int ret = 0;
> +
> +	might_sleep();
> +	if (current->mm)
> +		might_lock_read(&current->mm->mmap_sem);
>  	if (!__builtin_constant_p(size))
>  		return copy_user_generic(dst, (__force void *)src, size);
>  	switch (size) {
> @@ -70,6 +74,10 @@ static __always_inline __must_check
>  int __copy_to_user(void __user *dst, const void *src, unsigned size)
>  {
>  	int ret = 0;
> +
> +	might_sleep();
> +	if (current->mm)
> +		might_lock_read(&current->mm->mmap_sem);
>  	if (!__builtin_constant_p(size))
>  		return copy_user_generic((__force void *)dst, src, size);
>  	switch (size) {
> @@ -112,6 +120,10 @@ static __always_inline __must_check
>  int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
>  {
>  	int ret = 0;
> +
> +	might_sleep();
> +	if (current->mm)
> +		might_lock_read(&current->mm->mmap_sem);
>  	if (!__builtin_constant_p(size))
>  		return copy_user_generic((__force void *)dst,
>  					 (__force void *)src, size);
> Index: linux-2.6/include/asm-x86/uaccess.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/uaccess.h
> +++ linux-2.6/include/asm-x86/uaccess.h
> @@ -8,6 +8,8 @@
>  #include <linux/thread_info.h>
>  #include <linux/prefetch.h>
>  #include <linux/string.h>
> +#include <linux/lockdep.h>
> +#include <linux/sched.h>
>  #include <asm/asm.h>
>  #include <asm/page.h>
>  
> @@ -157,6 +159,9 @@ extern int __get_user_bad(void);
>  	int __ret_gu;							\
>  	unsigned long __val_gu;						\
>  	__chk_user_ptr(ptr);						\
> +	might_sleep();							\
> +	if (current->mm)						\
> +		might_lock_read(&current->mm->mmap_sem);		\
>  	switch (sizeof(*(ptr))) {					\
>  	case 1:								\
>  		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
> @@ -241,6 +246,9 @@ extern void __put_user_8(void);
>  	int __ret_pu;						\
>  	__typeof__(*(ptr)) __pu_val;				\
>  	__chk_user_ptr(ptr);					\
> +	might_sleep();						\
> +	if (current->mm)					\
> +		might_lock_read(&current->mm->mmap_sem);	\
>  	__pu_val = x;						\
>  	switch (sizeof(*(ptr))) {				\
>  	case 1:							\
> @@ -265,6 +273,9 @@ extern void __put_user_8(void);
>  #define __put_user_size(x, ptr, size, retval, errret)			\
>  do {									\
>  	retval = 0;							\
> +	might_sleep();							\
> +	if (current->mm)						\
> +		might_lock_read(&current->mm->mmap_sem);		\
>  	__chk_user_ptr(ptr);						\
>  	switch (size) {							\
>  	case 1:								\
> @@ -317,6 +328,9 @@ do {									\
>  #define __get_user_size(x, ptr, size, retval, errret)			\
>  do {									\
>  	retval = 0;							\
> +	might_sleep();							\
> +	if (current->mm)						\
> +		might_lock_read(&current->mm->mmap_sem);		\
>  	__chk_user_ptr(ptr);						\
>  	switch (size) {							\
>  	case 1:								\
> Index: linux-2.6/arch/x86/lib/usercopy_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/lib/usercopy_32.c
> +++ linux-2.6/arch/x86/lib/usercopy_32.c
> @@ -33,6 +33,8 @@ static inline int __movsl_is_ok(unsigned
>  do {									   \
>  	int __d0, __d1, __d2;						   \
>  	might_sleep();							   \
> +	if (current->mm)						   \
> +		might_lock_read(&current->mm->mmap_sem);		   \
>  	__asm__ __volatile__(						   \
>  		"	testl %1,%1\n"					   \
>  		"	jz 2f\n"					   \
> @@ -120,6 +122,8 @@ EXPORT_SYMBOL(strncpy_from_user);
>  do {									\
>  	int __d0;							\
>  	might_sleep();							\
> +	if (current->mm)						\
> +		might_lock_read(&current->mm->mmap_sem);		\
>  	__asm__ __volatile__(						\
>  		"0:	rep; stosl\n"					\
>  		"	movl %2,%0\n"					\
> @@ -148,7 +152,6 @@ do {									\
>  unsigned long
>  clear_user(void __user *to, unsigned long n)
>  {
> -	might_sleep();
>  	if (access_ok(VERIFY_WRITE, to, n))
>  		__do_clear_user(to, n);
>  	return n;
> @@ -191,6 +194,8 @@ long strnlen_user(const char __user *s, 
>  	unsigned long res, tmp;
>  
>  	might_sleep();
> +	if (current->mm)
> +		might_lock_read(&current->mm->mmap_sem);
>  
>  	__asm__ __volatile__(
>  		"	testl %0, %0\n"
> Index: linux-2.6/arch/x86/lib/usercopy_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/lib/usercopy_64.c
> +++ linux-2.6/arch/x86/lib/usercopy_64.c
> @@ -16,6 +16,8 @@
>  do {									   \
>  	long __d0, __d1, __d2;						   \
>  	might_sleep();							   \
> +	if (current->mm)						   \
> +		might_lock_read(&current->mm->mmap_sem);		   \
>  	__asm__ __volatile__(						   \
>  		"	testq %1,%1\n"					   \
>  		"	jz 2f\n"					   \
> @@ -65,6 +67,8 @@ unsigned long __clear_user(void __user *
>  {
>  	long __d0;
>  	might_sleep();
> +	if (current->mm)
> +		might_lock_read(&current->mm->mmap_sem);
>  	/* no memory constraint because it doesn't change any memory gcc knows
>  	   about */
>  	asm volatile(
> Index: linux-2.6/include/asm-x86/uaccess_32.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/uaccess_32.h
> +++ linux-2.6/include/asm-x86/uaccess_32.h
> @@ -82,8 +82,10 @@ __copy_to_user_inatomic(void __user *to,
>  static __always_inline unsigned long __must_check
>  __copy_to_user(void __user *to, const void *from, unsigned long n)
>  {
> -       might_sleep();
> -       return __copy_to_user_inatomic(to, from, n);
> +	might_sleep();
> +	if (current->mm)
> +		might_lock_read(&current->mm->mmap_sem);
> +	return __copy_to_user_inatomic(to, from, n);
>  }
>  
>  static __always_inline unsigned long
> @@ -138,6 +140,8 @@ static __always_inline unsigned long
>  __copy_from_user(void *to, const void __user *from, unsigned long n)
>  {
>  	might_sleep();
> +	if (current->mm)
> +		might_lock_read(&current->mm->mmap_sem);
>  	if (__builtin_constant_p(n)) {
>  		unsigned long ret;
>  
> @@ -160,6 +164,8 @@ static __always_inline unsigned long __c
>  				const void __user *from, unsigned long n)
>  {
>  	might_sleep();
> +	if (current->mm)
> +		might_lock_read(&current->mm->mmap_sem);
>  	if (__builtin_constant_p(n)) {
>  		unsigned long ret;
>  


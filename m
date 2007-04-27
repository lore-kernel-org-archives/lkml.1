Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbXD0U2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbXD0U2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbXD0U2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:28:09 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757202AbXD0U2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:28:07 -0400
Date: Fri, 27 Apr 2007 13:27:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: - maps2-add-proc-pid-pagemap-interface-fix.patch removed from
 -mm tree
Message-Id: <20070427132713.fc9d82c0.akpm@linux-foundation.org>
In-Reply-To: <20070427104533.GA6001@localhost.sw.ru>
References: <200704270814.l3R8EnFJ023047@shell0.pdx.osdl.net>
	<20070427104533.GA6001@localhost.sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 14:45:33 +0400
Alexey Dobriyan <adobriyan@sw.ru> wrote:

> > maps2-add-proc-pid-pagemap-interface.patch
> 
> Ohhh, you're repeating december mincore() bug
> 2f77d107050abc14bc393b34bdb7b91cf670c250
> 
> pagemap_read() takes ->mmap_sem for reading
> walk_page_range
> pagemap_pte_range
> add_to_pagemap
> flush_pagemap
> copy_to_user

argh.  I think it's always a bug to run uaccess functions while holding
mmap_sem, isn't it?

I'll see if I can get something like this working as a -mm-only thing:

diff -puN include/asm-i386/uaccess.h~i386-uaccess-debugging include/asm-i386/uaccess.h
--- a/include/asm-i386/uaccess.h~i386-uaccess-debugging
+++ a/include/asm-i386/uaccess.h
@@ -33,6 +33,8 @@
 
 #define segment_eq(a,b)	((a).seg == (b).seg)
 
+void no_mmap_sem(void);
+
 /*
  * movsl can be slow when source and dest are not both 8-byte aligned
  */
@@ -149,6 +151,7 @@ extern void __get_user_4(void);
 ({	int __ret_gu;							\
 	unsigned long __val_gu;						\
 	__chk_user_ptr(ptr);						\
+	no_mmap_sem();							\
 	switch(sizeof (*(ptr))) {					\
 	case 1:  __get_user_x(1,__ret_gu,__val_gu,ptr); break;		\
 	case 2:  __get_user_x(2,__ret_gu,__val_gu,ptr); break;		\
@@ -198,6 +201,7 @@ extern void __put_user_8(void);
 ({	int __ret_pu;						\
 	__typeof__(*(ptr)) __pu_val;				\
 	__chk_user_ptr(ptr);					\
+	no_mmap_sem();						\
 	__pu_val = x;						\
 	switch(sizeof(*(ptr))) {				\
 	case 1: __put_user_1(__pu_val, ptr); break;		\
@@ -215,6 +219,7 @@ extern void __put_user_8(void);
  	int __ret_pu;						\
 	__typeof__(*(ptr)) __pus_tmp = x;			\
 	__ret_pu=0;						\
+	no+_mmap_sem();						\
 	if(unlikely(__copy_to_user_ll(ptr, &__pus_tmp,		\
 				sizeof(*(ptr))) != 0))		\
  		__ret_pu=-EFAULT;				\
@@ -301,6 +306,7 @@ extern void __put_user_8(void);
 do {									\
 	retval = 0;							\
 	__chk_user_ptr(ptr);						\
+	no_mmap_sem();							\
 	switch (size) {							\
 	case 1: __put_user_asm(x,ptr,retval,"b","b","iq",errret);break;	\
 	case 2: __put_user_asm(x,ptr,retval,"w","w","ir",errret);break; \
@@ -316,6 +322,7 @@ do {									\
 do {									\
 	__typeof__(*(ptr)) __pus_tmp = x;				\
 	retval = 0;							\
+	no_mmap_sem();							\
 									\
 	if(unlikely(__copy_to_user_ll(ptr, &__pus_tmp, size) != 0))	\
 		retval = errret;					\
@@ -361,6 +368,7 @@ extern long __get_user_bad(void);
 do {									\
 	retval = 0;							\
 	__chk_user_ptr(ptr);						\
+	no_mmap_sem();							\
 	switch (size) {							\
 	case 1: __get_user_asm(x,ptr,retval,"b","b","=q",errret);break;	\
 	case 2: __get_user_asm(x,ptr,retval,"w","w","=r",errret);break;	\
@@ -407,6 +415,7 @@ unsigned long __must_check __copy_from_u
 static __always_inline unsigned long __must_check
 __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)
 {
+	no_mmap_sem();
 	if (__builtin_constant_p(n)) {
 		unsigned long ret;
 
@@ -454,6 +463,7 @@ __copy_from_user_inatomic(void *to, cons
 	 * but as the zeroing behaviour is only significant when n is not
 	 * constant, that shouldn't be a problem.
 	 */
+	no_mmap_sem();
 	if (__builtin_constant_p(n)) {
 		unsigned long ret;
 
diff -puN arch/i386/lib/usercopy.c~i386-uaccess-debugging arch/i386/lib/usercopy.c
--- a/arch/i386/lib/usercopy.c~i386-uaccess-debugging
+++ a/arch/i386/lib/usercopy.c
@@ -717,6 +717,7 @@ unsigned long __copy_to_user_ll(void __u
 				unsigned long n)
 {
 	BUG_ON((long) n < 0);
+	no_mmap_sem();
 #ifndef CONFIG_X86_WP_WORKS_OK
 	if (unlikely(boot_cpu_data.wp_works_ok == 0) &&
 			((unsigned long )to) < TASK_SIZE) {
@@ -786,6 +787,7 @@ unsigned long __copy_from_user_ll(void *
 					unsigned long n)
 {
 	BUG_ON((long)n < 0);
+	no_mmap_sem();
 	if (movsl_is_ok(to, from, n))
 		__copy_user_zeroing(to, from, n);
 	else
@@ -798,6 +800,7 @@ unsigned long __copy_from_user_ll_nozero
 					 unsigned long n)
 {
 	BUG_ON((long)n < 0);
+	no_mmap_sem();
 	if (movsl_is_ok(to, from, n))
 		__copy_user(to, from, n);
 	else
@@ -811,6 +814,7 @@ unsigned long __copy_from_user_ll_nocach
 					unsigned long n)
 {
 	BUG_ON((long)n < 0);
+	no_mmap_sem();
 #ifdef CONFIG_X86_INTEL_USERCOPY
 	if ( n > 64 && cpu_has_xmm2)
                 n = __copy_user_zeroing_intel_nocache(to, from, n);
@@ -826,6 +830,7 @@ unsigned long __copy_from_user_ll_nocach
 					unsigned long n)
 {
 	BUG_ON((long)n < 0);
+	no_mmap_sem();
 #ifdef CONFIG_X86_INTEL_USERCOPY
 	if ( n > 64 && cpu_has_xmm2)
                 n = __copy_user_intel_nocache(to, from, n);
@@ -887,3 +892,16 @@ copy_from_user(void *to, const void __us
 	return n;
 }
 EXPORT_SYMBOL(copy_from_user);
+
+void no_mmap_sem(void)
+{
+	struct mm_struct *mm;
+
+	if (in_atomic())
+		return;		/* We won't take pagefaults */
+	mm = current->mm;
+	if (!mm)
+		return;
+	WARN_ON(rwsem_is_locked(&mm->mmap_sem))
+}
+EXPORT_SYMBOL(no_mmap_sem);
_


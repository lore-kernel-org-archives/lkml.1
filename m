Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbZEDGHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbZEDGHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 02:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZEDGHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 02:07:31 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:35947 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZEDGHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 02:07:30 -0400
Message-ID: <49FE861D.5050808@monstr.eu>
Date: Mon, 04 May 2009 08:07:25 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org, Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH V3] asm-generic: add a generic uaccess.h
References: <cover.1241105648.git.arnd@arndb.de> <200905011436.05204.arnd@arndb.de> <49FAED34.5000701@monstr.eu> <200905011513.25344.arnd@arndb.de>
In-Reply-To: <200905011513.25344.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> This adds a new asm-generic/uaccess.h file that should be usable
> by both all NOMMU architectures out of the box. Architectures with
> an MMU should override the __access_ok(), __copy_from_user() and
> __copy_to_user definitions with their own functions to provide
> correct exception handling.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
> new file mode 100644
> index 0000000..deb1722
> --- /dev/null
> +++ b/include/asm-generic/uaccess.h
> @@ -0,0 +1,319 @@
> +#ifndef __ASM_GENERIC_UACCESS_H
> +#define __ASM_GENERIC_UACCESS_H
> +
> +/*
> + * User space memory access functions, these should work
> + * on a ny machine that has kernel and user data in the same
> + * address space, e.g. all NOMMU machines.
> + */
> +#include <linux/sched.h>
> +#include <linux/mm.h>
> +#include <linux/string.h>
> +
> +#include <asm/segment.h>
> +
> +#ifndef get_fs
> +#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
> +#define KERNEL_DS	MAKE_MM_SEG(~0UL)
> +#define USER_DS		MAKE_MM_SEG(TASK_SIZE - 1)
> +
> +#define get_ds() (KERNEL_DS)
> +#define get_fs() (current_thread_info()->addr_limit)
> +
> +static inline void set_fs(mm_segment_t fs)
> +{
> +	current_thread_info()->addr_limit = fs;
> +}
> +#endif

This part should be rewrite to this style.

#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })

#ifndef KERNEL_DS
#define KERNEL_DS	MAKE_MM_SEG(~0UL)
#endif

#ifndef USER_DS
#define USER_DS		MAKE_MM_SEG(TASK_SIZE - 1)
#endif


#ifndef get_fs
#define get_ds() (KERNEL_DS)
#define get_fs() (current_thread_info()->addr_limit)

static inline void set_fs(mm_segment_t fs)
{
	current_thread_info()->addr_limit = fs;
}
#endif

What do you think?


Michal






> +
> +#define segment_eq(a, b) ((a).seg == (b).seg)
> +
> +#define VERIFY_READ	0
> +#define VERIFY_WRITE	1
> +
> +#define access_ok(type, addr, size) __access_ok((unsigned long)(addr),(size))
> +
> +/*
> + * The architecture should really override this if possible, at least
> + * doing a check on the get_fs()
> + */
> +#ifndef __access_ok
> +static inline int __access_ok(unsigned long addr, unsigned long size)
> +{
> +	return 1;
> +}
> +#endif
> +
> +/*
> + * The exception table consists of pairs of addresses: the first is the
> + * address of an instruction that is allowed to fault, and the second is
> + * the address at which the program should continue.  No registers are
> + * modified, so it is entirely up to the continuation code to figure out
> + * what to do.
> + *
> + * All the routines below use bits of fixup code that are out of line
> + * with the main instruction path.  This means when everything is well,
> + * we don't even have to jump over them.  Further, they do not intrude
> + * on our cache or tlb entries.
> + */
> +
> +struct exception_table_entry
> +{
> +	unsigned long insn, fixup;
> +};
> +
> +/* Returns 0 if exception not found and fixup otherwise.  */
> +extern unsigned long search_exception_table(unsigned long);
> +
> +/*
> + * architectures with an MMU should override these two
> + */
> +#ifndef __copy_from_user
> +static inline __must_check long __copy_from_user(void *to,
> +		const void __user * from, unsigned long n)
> +{
> +	if (__builtin_constant_p(n)) {
> +		switch(n) {
> +		case 1:
> +			*(u8 *)to = *(u8 __force *)from;
> +			return 0;
> +		case 2:
> +			*(u16 *)to = *(u16 __force *)from;
> +			return 0;
> +		case 4:
> +			*(u32 *)to = *(u32 __force *)from;
> +			return 0;
> +#ifdef CONFIG_64BIT
> +		case 8:
> +			*(u64 *)to = *(u64 __force *)from;
> +			return 0;
> +#endif
> +		default:
> +			break;
> +		}
> +	}
> +
> +	memcpy(to, (const void __force *)from, n);
> +	return 0;
> +}
> +#endif
> +
> +#ifndef __copy_to_user
> +static inline __must_check long __copy_to_user(void __user *to,
> +		const void *from, unsigned long n)
> +{
> +	if (__builtin_constant_p(n)) {
> +		switch(n) {
> +		case 1:
> +			*(u8 __force *)to = *(u8 *)from;
> +			return 0;
> +		case 2:
> +			*(u16 __force *)to = *(u16 *)from;
> +			return 0;
> +		case 4:
> +			*(u32 __force *)to = *(u32 *)from;
> +			return 0;
> +#ifdef CONFIG_64BIT
> +		case 8:
> +			*(u64 __force *)to = *(u64 *)from;
> +			return 0;
> +#endif
> +		default:
> +			break;
> +		}
> +	}
> +
> +	memcpy((void __force *)to, from, n);
> +	return 0;
> +}
> +#endif
> +
> +/*
> + * These are the main single-value transfer routines.  They automatically
> + * use the right size if we just have the right pointer type.
> + * This version just falls back to copy_{from,to}_user, which should
> + * provide a fast-path for small values. 
> + */
> +#define __put_user(x, ptr) \
> +({								\
> +	__typeof__(*(ptr)) __x = (x);				\
> +	int __pu_err = -EFAULT;					\
> +        __chk_user_ptr(ptr);					\
> +	switch (sizeof (*(ptr))) {				\
> +	case 1:							\
> +	case 2:							\
> +	case 4:							\
> +	case 8:							\
> +		__pu_err = __put_user_fn(sizeof (*(ptr)),	\
> +					 ptr, &__x);		\
> +		break;						\
> +	default:						\
> +		__put_user_bad();				\
> +		break;						\
> +	 }							\
> +	__pu_err;						\
> +})
> +
> +#define put_user(x, ptr)					\
> +({								\
> +	might_sleep();						\
> +	__access_ok(ptr, sizeof (*ptr)) ?			\
> +		__put_user(x, ptr) :				\
> +		-EFAULT;					\
> +})
> +
> +static inline int __put_user_fn(size_t size, void __user *ptr, void *x)
> +{
> +	size = __copy_to_user(ptr, x, size);
> +	return size ? -EFAULT : size;
> +}
> +
> +extern int __put_user_bad(void) __attribute__((noreturn));
> +
> +#define __get_user(x, ptr)					\
> +({								\
> +	int __gu_err = -EFAULT;					\
> +	__chk_user_ptr(ptr);					\
> +	switch (sizeof(*(ptr))) {				\
> +	case 1: {						\
> +		unsigned char __x;				\
> +		__gu_err = __get_user_fn(sizeof (*(ptr)),	\
> +					 ptr, &__x);		\
> +		(x) = *(__force __typeof__(*(ptr)) *) &__x;	\
> +		break;						\
> +	};							\
> +	case 2: {						\
> +		unsigned short __x;				\
> +		__gu_err = __get_user_fn(sizeof (*(ptr)),	\
> +					 ptr, &__x);		\
> +		(x) = *(__force __typeof__(*(ptr)) *) &__x;	\
> +		break;						\
> +	};							\
> +	case 4: {						\
> +		unsigned int __x;				\
> +		__gu_err = __get_user_fn(sizeof (*(ptr)),	\
> +					 ptr, &__x);		\
> +		(x) = *(__force __typeof__(*(ptr)) *) &__x;	\
> +		break;						\
> +	};							\
> +	case 8: {						\
> +		unsigned long long __x;				\
> +		__gu_err = __get_user_fn(sizeof (*(ptr)),	\
> +					 ptr, &__x);		\
> +		(x) = *(__force __typeof__(*(ptr)) *) &__x;	\
> +		break;						\
> +	};							\
> +	default:						\
> +		__get_user_bad();				\
> +		break;						\
> +	}							\
> +	__gu_err;						\
> +})
> +
> +#define get_user(x, ptr)					\
> +({								\
> +	might_sleep();						\
> +	__access_ok(ptr, sizeof (*ptr)) ?			\
> +		__get_user(x, ptr) :				\
> +		-EFAULT;					\
> +})
> +
> +static inline int __get_user_fn(size_t size, const void __user *ptr, void *x)
> +{
> +	size = __copy_from_user(x, ptr, size);
> +	return size ? -EFAULT : size;
> +}
> +
> +extern int __get_user_bad(void) __attribute__((noreturn));
> +
> +#ifndef __copy_from_user_inatomic
> +#define __copy_from_user_inatomic __copy_from_user
> +#endif
> +
> +#ifndef __copy_to_user_inatomic
> +#define __copy_to_user_inatomic __copy_to_user
> +#endif
> +
> +static inline long copy_from_user(void *to,
> +		const void __user * from, unsigned long n)
> +{
> +	might_sleep();
> +	if (__access_ok(from, n))
> +		return __copy_from_user(to, from, n);
> +	else
> +		return n;
> +}
> +
> +static inline long copy_to_user(void __user *to,
> +		const void *from, unsigned long n)
> +{
> +	might_sleep();
> +	if (__access_ok(to, n))
> +		return __copy_to_user(to, from, n);
> +	else
> +		return n;
> +}
> +
> +/*
> + * Copy a null terminated string from userspace.
> + */
> +#ifndef __strncpy_from_user
> +static inline long
> +__strncpy_from_user(char *dst, const char __user *src, long count)
> +{
> +	char *tmp;
> +	strncpy(dst, (const char __force *)src, count);
> +	for (tmp = dst; *tmp && count > 0; tmp++, count--)
> +		;
> +	return (tmp - dst);
> +}
> +#endif
> +
> +static inline long
> +strncpy_from_user(char *dst, const char __user *src, long count)
> +{
> +	if (!__access_ok(src, 1))
> +		return -EFAULT;
> +	return __strncpy_from_user(dst, src, count);
> +}
> +
> +/*
> + * Return the size of a string (including the ending 0)
> + *
> + * Return 0 on exception, a value greater than N if too long
> + */
> +#ifndef strnlen_user
> +static inline long strnlen_user(const char __user *src, long n)
> +{
> +	return strlen((void * __force)src) + 1;
> +}
> +#endif
> +
> +static inline long strlen_user(const char __user *src)
> +{
> +	return strnlen_user(src, 32767);
> +}
> +
> +/*
> + * Zero Userspace
> + */
> +#ifndef __clear_user
> +static inline __must_check unsigned long
> +__clear_user(void __user *to, unsigned long n)
> +{
> +	memset((void __force *)to, 0, n);
> +	return 0;
> +}
> +#endif
> +
> +static inline __must_check unsigned long
> +clear_user(void __user *to, unsigned long n)
> +{
> +	might_sleep();
> +	if (!__access_ok(to, n))
> +		return n;
> +
> +	return __clear_user(to, n);
> +}
> +
> +#endif /* __ASM_GENERIC_UACCESS_H */


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZD2L1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZD2L1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbZD2L1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:27:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53289 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbZD2L1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:27:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 20/30] microblaze_mmu_v1: uaccess MMU update
Date: Wed, 29 Apr 2009 13:26:23 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu> <1240821139-7247-20-git-send-email-monstr@monstr.eu> <1240821139-7247-21-git-send-email-monstr@monstr.eu>
In-Reply-To: <1240821139-7247-21-git-send-email-monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904291326.23511.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/z0uwPLU+HCBeADCz9yQv+RsH4OEMjOF6gOQz
 xxVtIwMrCXtLurTiLOuuG9eQikjlp6Jbrr/6JTokSzeT6tSS+v
 k+fKJXt7AXhmOS9J9VVDw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following up on my earlier comment:

On Monday 27 April 2009, monstr@monstr.eu wrote:

> +#define __get_user(var, ptr)				\
> +({							\
> +	int __gu_err = 0;				\
> +	switch (sizeof(*(ptr))) {			\
> +	case 1:						\
> +	case 2:						\
> +	case 4:						\
> +		(var) = *(ptr);				\
> +		break;					\
> +	case 8:						\
> +		memcpy((void *) &(var), (ptr), 8);	\
> +		break;					\
> +	default:					\
> +		(var) = 0;				\
> +		__gu_err = __get_user_bad();		\
> +		break;					\
> +	}						\
> +	__gu_err;					\
> +})

This needs more __force to dereference the user pointers.
  
>  #define __get_user_bad()	(bad_user_access_length(), (-EFAULT))

You have actually defined bad_user_access_length(), which is not
how it __get_user_bad()	was meant as. The idea was to declare
an undefined function, which results in a link error in case
of funny length inputs to __get_user, a cheap way to do
BUILD_BUG_ON() in a switch() statement.

> +/* FIXME is not there defined __pu_val */
> +({								\
> +	int __pu_err = 0;					\
> +	switch (sizeof(*(ptr))) {				\
> +	case 1:							\
> +	case 2:							\
> +	case 4:							\
> +		*(ptr) = (var);					\
> +		break;						\
> +	case 8: {						\
> +		typeof(*(ptr)) __pu_val = (var);		\
> +		memcpy(ptr, &__pu_val, sizeof(__pu_val));	\
> +		}						\
> +		break;						\
> +	default:						\
> +		__pu_err = __put_user_bad();			\
> +		break;						\
> +	}							\
> +	__pu_err;						\
> +})
>  
>  #define __put_user_bad()	(bad_user_access_length(), (-EFAULT))

Same comments apply here.
  
> -#define put_user(x, ptr)	__put_user(x, ptr)
> -#define get_user(x, ptr)	__get_user(x, ptr)
> -
> -#define copy_to_user(to, from, n)		(memcpy(to, from, n), 0)
> -#define copy_from_user(to, from, n)		(memcpy(to, from, n), 0)
> +#define put_user(x, ptr)	__put_user((x), (ptr))
> +#define get_user(x, ptr)	__get_user((x), (ptr))

put_user and get_user should call access_ok() for the !MMU version I guess,
if you can easily detect kernel pointers based on the address.
It's also a good idea to add might_sleep() in there if access_ok()
doesn't have it already.

> -#define __copy_to_user(to, from, n)		(copy_to_user(to, from, n))
> -#define __copy_from_user(to, from, n)		(copy_from_user(to, from, n))
> -#define __copy_to_user_inatomic(to, from, n)	(__copy_to_user(to, from, n))
> -#define __copy_from_user_inatomic(to, from, n)	(__copy_from_user(to, from, n))
> +#define copy_to_user(to, from, n)	(memcpy((to), (from), (n)), 0)
> +#define copy_from_user(to, from, n)	(memcpy((to), (from), (n)), 0)

Same here, plus they can be shared between MMU and NOMMU.

> +#else /* CONFIG_MMU */
> +
> +/*
> + * Address is valid if:
> + *  - "addr", "addr + size" and "size" are all below the limit
> + */
> +#define access_ok(type, addr, size) \
> +	(get_fs().seg > (((unsigned long)(addr)) | \
> +		(size) | ((unsigned long)(addr) + (size))))
> +
> +/* || printk("access_ok failed for %s at 0x%08lx (size %d), seg 0x%08x\n",
> + type?"WRITE":"READ",addr,size,get_fs().seg)) */
> +
> +/*
> + * All the __XXX versions macros/functions below do not perform
> + * access checking. It is assumed that the necessary checks have been
> + * already performed before the finction (macro) is called.
> + */
> +
> +#define get_user(x, ptr)						\
> +({									\
> +	access_ok(VERIFY_READ, (ptr), sizeof(*(ptr)))			\
> +		? __get_user((x), (ptr)) : -EFAULT;			\
> +})
> +
> +#define put_user(x, ptr)						\
> +({									\
> +	access_ok(VERIFY_WRITE, (ptr), sizeof(*(ptr)))			\
> +		? __put_user((x), (ptr)) : -EFAULT;			\
> +})

Please add might_sleep() either here or in access_ok().

> +#define __get_user(x, ptr)						\
> +({									\
> +	unsigned long __gu_val;						\
> +	/*unsigned long __gu_ptr = (unsigned long)(ptr);*/		\
> +	long __gu_err;							\
> +	switch (sizeof(*(ptr))) {					\
> +	case 1:								\
> +		__get_user_asm("lbu", (ptr), __gu_val, __gu_err);	\
> +		break;							\
> +	case 2:								\
> +		__get_user_asm("lhu", (ptr), __gu_val, __gu_err);	\
> +		break;							\
> +	case 4:								\
> +		__get_user_asm("lw", (ptr), __gu_val, __gu_err);	\
> +		break;							\
> +	default:							\
> +		__gu_val = 0; __gu_err = -EINVAL;			\
> +	}								\
> +	x = (__typeof__(*(ptr))) __gu_val;				\
> +	__gu_err;							\
> +})

Again, the 'default:' case should give a link error, not a runtime
error. 

It seems inconsistent to have a 'case 8:' in !MMU as well as both
__put_user variants but not in the MMU __get_user.

> +#define __put_user(x, ptr)						\
> +({									\
> +	__typeof__(*(ptr)) __gu_val = x;				\
> +	long __gu_err = 0;						\
> +	switch (sizeof(__gu_val)) {					\
> +	case 1:								\
> +		__put_user_asm("sb", (ptr), __gu_val, __gu_err);	\
> +		break;							\
> +	case 2: 							\
> +		__put_user_asm("sh", (ptr), __gu_val, __gu_err);	\
> +		break;							\
> +	case 4:								\
> +		__put_user_asm("sw", (ptr), __gu_val, __gu_err);	\
> +		break;							\
> +	case 8:								\
> +		__put_user_asm_8((ptr), __gu_val, __gu_err);		\
> +		break;							\
> +	default:							\
> +		__gu_err = -EINVAL;					\
> +	}								\
> +	__gu_err;							\
> +})

> +/*
> + * Return: number of not copied bytes, i.e. 0 if OK or non-zero if fail.
> + */
> +static inline int clear_user(char *to, int size)
> +{
> +	if (size && access_ok(VERIFY_WRITE, to, size)) {
> +		__asm__ __volatile__ ("				\
> +				1:				\
> +					sb	r0, %2, r0;	\
> +					addik	%0, %0, -1;	\
> +					bneid	%0, 1b;		\
> +					addik	%2, %2, 1;	\
> +				2:				\
> +				.section __ex_table,\"a\";	\
> +				.word	1b,2b;			\
> +				.section .text;"		\
> +			: "=r"(size)				\
> +			: "0"(size), "r"(to)
> +		);
> +	}
> +	return size;
> +}

Please use the prototype I mentioned in the other mail.

While I don't remember the exact story, I think the preferred
way to write multi-line inline assembly is

	asm volatile("# clear_user		\n"
		"1:				\n"
		"	sb r0, %2, r0		\n"
		"	addik	%0, %0, -1	\n"
		"	bneid	%0, 1b		\n"
		"2:				\n"
		".section __ex_table,\"a\"	\n"
		".word	1b,2b;			\n"
		".section .text;		\n");

rather than a single multi-line string.

> +extern unsigned long __copy_tofrom_user(void __user *to,
> +		const void __user *from, unsigned long size);
> +
> +#define copy_to_user(to, from, n)					\
> +	(access_ok(VERIFY_WRITE, (to), (n)) ?				\
> +		__copy_tofrom_user((void __user *)(to),			\
> +			(__force const void __user *)(from), (n))	\
> +		: -EFAULT)

No, copy_to_user does *not* return an errno, but instead the number
of bytes not copied. Assuming your __copy_tofrom_user is correct,
this would be

static inline __must_check unsigned long
copy_to_user(void __user *to, void *from, size_t n)
{
	might_sleep();

	if (!access_ok(VERIFY_WRITE, to, n))
		return n;

	return __copy_tofrom_user(to, (const void __force __user *)from, n);
}

> +#define __copy_to_user(to, from, n)	copy_to_user((to), (from), (n))
> +#define __copy_to_user_inatomic(to, from, n)	copy_to_user((to), (from), (n))
> +
> +#define copy_from_user(to, from, n)					\
> +	(access_ok(VERIFY_READ, (from), (n)) ?				\
> +		__copy_tofrom_user((__force void __user *)(to),		\
> +			(void __user *)(from), (n))			\
> +		: -EFAULT)

same here

> +#define __copy_from_user(to, from, n)	copy_from_user((to), (from), (n))
> +#define __copy_from_user_inatomic(to, from, n) \
> +		copy_from_user((to), (from), (n))
> +
> +extern int __strncpy_user(char *to, const char __user *from, int len);
> +extern int __strnlen_user(const char __user *sstr, int len);
> +
> +#define strncpy_from_user(to, from, len)	\
> +		(access_ok(VERIFY_READ, from, 1) ?	\
> +			__strncpy_user(to, from, len) : -EFAULT)

and here.

	Arnd <><

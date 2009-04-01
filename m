Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbZDAOjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbZDAOjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761752AbZDAOjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:39:33 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53223 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbZDAOjb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:39:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l8wYs0AXAXtqftdki5Rx34mC4y3/SCWSF5TtZ5JOWaH64wFN7828TlE23BelICRd7b
         VLOnyI+/W5yAngT6jRau3yjvut6GFthz3GMx9Wk1BpG3jBHKI8jHx4dbs7Elaillxhz4
         Zq4MDe073f9HEpXM3KLoYIvyc9JmZVGAeVXdY=
MIME-Version: 1.0
In-Reply-To: <200904011611.53355.arnd@arndb.de>
References: <49D071A8.4010703@petalogix.com>
	 <10f740e80903300741h387e6342veba0ccceea6714e9@mail.gmail.com>
	 <200903301717.57184.arnd@arndb.de> <200904011611.53355.arnd@arndb.de>
Date: Wed, 1 Apr 2009 15:39:27 +0100
Message-ID: <87a5b0800904010739g3564eb1fhf32afcfee4936c4b@mail.gmail.com>
Subject: Re: [RFC] asm-generic/{unistd,types,posix_types}.h for new arch
From: Will Newton <will.newton@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>,
       michal.simek@petalogix.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
       Chen Liqin <liqin.chen@sunplusct.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 1, 2009 at 3:11 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> I've spent more time on my asm-generic patches and believe I now
> have an unistd.h implementation that can be used by the new
> architectures (score and microblaze) so they don't have to go
> through the error-prone process of coming up with their own lists.

I appreciate your work on this, it should make porting to a new arch
much less error-prone.

> It would be good if more people could in particular look over the
> system call lists. I have left the syscalls that I think should
> be dropped in #ifdef __ARCH_WANT_SYSCALL_{DEPRECATED,NO_AT,NO_FLAGS,OFF_T}
> so that it becomes easy to reenable them temporarily while porting
> the libc, and to easily see which ones get left out.
>
> I have also changed checksyscalls.sh to stop complaining when
> the old syscalls are not present.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/asm-generic/posix_types.h |  162 ++++++
>  include/asm-generic/types.h       |   63 ++
>  include/asm-generic/unistd.h      |  829 +++++++++++++++++++++++++++++
>  kernel/Makefile                   |    1 +
>  kernel/syscall_table.c            |   12 +
>  scripts/checksyscalls.sh          |   93 +++-
>  6 files changed, 1157 insertions(+), 3 deletions(-)
>
>
> diff --git a/include/asm-generic/posix_types.h b/include/asm-generic/posix_types.h
> new file mode 100644
> index 0000000..4772f74
> --- /dev/null
> +++ b/include/asm-generic/posix_types.h
> @@ -0,0 +1,162 @@
> +#ifndef __ASM_GENERIC_POSIX_TYPES_H
> +#define __ASM_GENERIC_POSIX_TYPES_H
> +
> +#include <asm/types.h>
> +
> +/*
> + * This file is generally used by user-level software, so you need to
> + * be a little careful about namespace pollution etc.
> + *
> + * First the types that are often defined in different ways across
> + * architectures, so that you can override them.
> + */
> +
> +#ifndef __kernel_ino_t
> +typedef unsigned long  __kernel_ino_t;
> +#endif
> +
> +#ifndef __kernel_mode_t
> +typedef unsigned int   __kernel_mode_t;
> +#endif
> +
> +#ifndef __kernel_nlink_t
> +typedef unsigned long  __kernel_nlink_t;
> +#endif
> +
> +#ifndef __kernel_pid_t
> +typedef int            __kernel_pid_t;
> +#endif
> +
> +#ifndef __kernel_ipc_pid_t
> +typedef int            __kernel_ipc_pid_t;
> +#endif
> +
> +#ifndef __kernel_uid_t
> +typedef unsigned int   __kernel_uid_t;
> +typedef unsigned int   __kernel_gid_t;
> +#endif
> +
> +#ifndef __kernel_suseconds_t
> +typedef long           __kernel_suseconds_t;
> +#endif
> +
> +#ifndef __kernel_daddr_t
> +typedef int            __kernel_daddr_t;
> +#endif
> +
> +#ifndef __kernel_uid32_t
> +typedef __kernel_uid_t __kernel_uid32_t;
> +typedef __kernel_gid_t __kernel_gid32_t;
> +#endif
> +
> +#ifndef __kernel_old_uid_t
> +typedef __kernel_uid_t __kernel_old_uid_t;
> +typedef __kernel_gid_t __kernel_old_gid_t;
> +#endif
> +
> +#ifndef __kernel_old_dev_t
> +typedef unsigned int   __kernel_old_dev_t;
> +#endif
> +
> +#ifndef __kernel_size_t
> +#if __BITS_PER_LONG != 64
> +typedef unsigned int   __kernel_size_t;
> +typedef int            __kernel_ssize_t;
> +typedef int            __kernel_ptrdiff_t;
> +#else
> +typedef unsigned long  __kernel_size_t;
> +typedef long           __kernel_ssize_t;
> +typedef long           __kernel_ptrdiff_t;
> +#endif
> +#endif
> +
> +/*
> + * anything below here should be completely generic
> + */
> +typedef long           __kernel_off_t;
> +typedef long long      __kernel_loff_t;
> +typedef long           __kernel_time_t;
> +typedef long           __kernel_clock_t;
> +typedef int            __kernel_timer_t;
> +typedef int            __kernel_clockid_t;
> +typedef char *         __kernel_caddr_t;
> +typedef unsigned short __kernel_uid16_t;
> +typedef unsigned short __kernel_gid16_t;
> +
> +typedef struct {
> +       int     val[2];
> +} __kernel_fsid_t;
> +
> +#ifdef __KERNEL__
> +
> +#undef __FD_SET
> +static inline void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
> +{
> +       unsigned long __tmp = __fd / __NFDBITS;
> +       unsigned long __rem = __fd % __NFDBITS;
> +       __fdsetp->fds_bits[__tmp] |= (1UL<<__rem);
> +}
> +
> +#undef __FD_CLR
> +static inline void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
> +{
> +       unsigned long __tmp = __fd / __NFDBITS;
> +       unsigned long __rem = __fd % __NFDBITS;
> +       __fdsetp->fds_bits[__tmp] &= ~(1UL<<__rem);
> +}
> +
> +#undef __FD_ISSET
> +static inline int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__p)
> +{
> +       unsigned long __tmp = __fd / __NFDBITS;
> +       unsigned long __rem = __fd % __NFDBITS;
> +       return (__p->fds_bits[__tmp] & (1UL<<__rem)) != 0;
> +}
> +
> +/*
> + * This will unroll the loop for the normal constant case (8 ints,
> + * for a 256-bit fd_set)
> + */
> +#undef __FD_ZERO
> +static inline void __FD_ZERO(__kernel_fd_set *__p)
> +{
> +       unsigned long *__tmp = __p->fds_bits;
> +       int __i;
> +
> +       if (__builtin_constant_p(__FDSET_LONGS)) {
> +               switch (__FDSET_LONGS) {
> +               case 16:
> +                       __tmp[ 0] = 0; __tmp[ 1] = 0;
> +                       __tmp[ 2] = 0; __tmp[ 3] = 0;
> +                       __tmp[ 4] = 0; __tmp[ 5] = 0;
> +                       __tmp[ 6] = 0; __tmp[ 7] = 0;
> +                       __tmp[ 8] = 0; __tmp[ 9] = 0;
> +                       __tmp[10] = 0; __tmp[11] = 0;
> +                       __tmp[12] = 0; __tmp[13] = 0;
> +                       __tmp[14] = 0; __tmp[15] = 0;
> +                       return;
> +
> +               case 8:
> +                       __tmp[ 0] = 0; __tmp[ 1] = 0;
> +                       __tmp[ 2] = 0; __tmp[ 3] = 0;
> +                       __tmp[ 4] = 0; __tmp[ 5] = 0;
> +                       __tmp[ 6] = 0; __tmp[ 7] = 0;
> +                       return;
> +
> +               case 4:
> +                       __tmp[ 0] = 0; __tmp[ 1] = 0;
> +                       __tmp[ 2] = 0; __tmp[ 3] = 0;
> +                       return;
> +               }
> +       }
> +       __i = __FDSET_LONGS;
> +       while (__i) {
> +               __i--;
> +               *__tmp = 0;
> +               __tmp++;
> +       }
> +}
> +
> +#endif /* __KERNEL__ */
> +
> +#endif /* __ASM_GENERIC_POSIX_TYPES_H */
> diff --git a/include/asm-generic/types.h b/include/asm-generic/types.h
> new file mode 100644
> index 0000000..147b553
> --- /dev/null
> +++ b/include/asm-generic/types.h
> @@ -0,0 +1,63 @@
> +#ifndef _ASM_GENERIC_TYPES_H
> +#define _ASM_GENERIC_TYPES_H
> +
> +/*
> + * int-ll64 is used practically everywhere now,
> + * so use it as a reasonable default.
> + */
> +#include <asm-generic/int-ll64.h>
> +
> +#ifndef __ASSEMBLY__
> +
> +typedef unsigned short umode_t;
> +
> +#endif /* __ASSEMBLY__ */
> +
> +/*
> + * There seems to be no way of detecting this automatically from user
> + * space, so 64 bit architectures should override this in their types.h.
> + */
> +#ifndef __BITS_PER_LONG
> +#define __BITS_PER_LONG 32
> +#endif

Why is this define required? It doesn't seem to be in any existing headers.

> +
> +/*
> + * These aren't exported outside the kernel to avoid name space clashes
> + */
> +#ifdef __KERNEL__
> +
> +#ifdef CONFIG_64BIT
> +#define BITS_PER_LONG 64
> +#else
> +#define BITS_PER_LONG 32
> +#endif /* CONFIG_64BIT */
> +
> +#if BITS_PER_LONG != __BITS_PER_LONG
> +#error cannot determine word size
> +#endif
> +
> +#ifndef __ASSEMBLY__
> +
> +/*
> + * DMA addresses may be very different from physical addresses
> + * and pointers. i386 and powerpc may have 64 bit DMA on 32 bit
> + * systems, while sparc64 uses 32 bit DMA addresses for 64 bit
> + * physical addresses.
> + * This default defines dma_addr_t to have the same size as
> + * phys_addr_t, which is the most common way.
> + * Do not define the dma64_addr_t type, which never really
> + * worked.
> + */
> +#ifndef dma_addr_t
> +#ifdef CONFIG_PHYS_ADDR_T_64BIT
> +typedef u64 dma_addr_t;
> +#else
> +typedef u32 dma_addr_t;
> +#endif /* CONFIG_PHYS_ADDR_T_64BIT */
> +#endif /* dma_addr_t */
> +
> +#endif /* __ASSEMBLY__ */
> +
> +#endif /* __KERNEL__ */
> +
> +#endif /* _ASM_GENERIC_TYPES_H */

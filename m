Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbZBUAsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbZBUAsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 19:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZBUAry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 19:47:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:50620 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZBUArx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 19:47:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [announce] Performance Counters for Linux, v6
Date: Sat, 21 Feb 2009 01:47:18 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
References: <20090121185021.GA8852@elte.hu>
In-Reply-To: <20090121185021.GA8852@elte.hu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902210147.20785.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+zRiG3PWza3e1N7BlZeUGZ4grHxMR2s1FELi4
 y9tFVl3XEMaL/6hx3tP7y0xYEjz+fT1F18lvissuC2yeNR9QEu
 Zz94HnEXN+Iaz1wrRa6Hw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009, Ingo Molnar wrote:

> diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
> index 72353f6..4c8095f 100644
> --- a/arch/powerpc/include/asm/systbl.h
> +++ b/arch/powerpc/include/asm/systbl.h
> @@ -322,3 +322,4 @@ SYSCALL_SPU(epoll_create1)
>  SYSCALL_SPU(dup3)
>  SYSCALL_SPU(pipe2)
>  SYSCALL(inotify_init1)
> +SYSCALL(perf_counter_open)

Is there a reason to forbid this on the SPU? It's probably not particularly
useful, but it shouldn't hurt.

> +
> +#ifdef CONFIG_PERF_COUNTERS
> +# include <asm/perf_counter.h>
> +#endif
> +
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/rculist.h>
> +#include <linux/rcupdate.h>
> +#include <linux/spinlock.h>

I guess all */perf_counter.h files should be exported, but then
the #ifdef won't work when the file is included from user space.
Also, some of the included headers are not exported.

> +/*
> + * Hardware event to monitor via a performance monitoring counter:
> + */
> +struct perf_counter_hw_event {
> +	s64			type;
> +
> +	u64			irq_period;
> +	u32			record_type;
> +
> +	u32			disabled     :  1, /* off by default      */
> +				nmi	     :  1, /* NMI sampling        */
> +				raw	     :  1, /* raw event type      */
> +				inherit	     :  1, /* children inherit it */
> +				pinned	     :  1, /* must always be on PMU */
> +				exclusive    :  1, /* only counter on PMU */
> +
> +				__reserved_1 : 26;
> +
> +	u64			__reserved_2;
> +};

When exported, the types should be __s64 etc instead of s64.

> +/*
> + * Ioctls that can be done on a perf counter fd:
> + */
> +#define PERF_COUNTER_IOC_ENABLE		_IO('$', 0)
> +#define PERF_COUNTER_IOC_DISABLE	_IO('$', 1)
> +
> +/*
> + * Kernel-internal data types:
> + */

The kernel internal parts of the header should be hidden in #ifdef
__KERNEL__.

> +
> +asmlinkage int sys_perf_counter_open(
> +
> +	struct perf_counter_hw_event	*hw_event_uptr		__user,
> +	pid_t				pid,
> +	int				cpu,
> +	int				group_fd);

For the syscall, I'd suggest sys_perf_counter_fd or sys_perfcounterfd
to go along with signalfd, eventfd, etc. The only other _open syscall
we have is sys_mq_open(), which is different since it actually performs
an open() on a (hidden) file.

All system calls should return a 'long' value to make sure that the
errno handling works on all architectures.

> +static const struct file_operations perf_fops = {
> +	.release		= perf_release,
> +	.read			= perf_read,
> +	.poll			= perf_poll,
> +	.unlocked_ioctl		= perf_ioctl,
> +	.compat_ioctl		= perf_ioctl,
> +};

It feels inconsistent to combine a syscall for getting the fd with ioctl.
Assuming the interface is semantically right, I'd suggest using either
a chardev with more ioctls or more syscalls but not both:

asmlinkage long sys_perfcounter_fd(
	struct perf_counter_hw_event	*hw_event_uptr		__user,
	pid_t				pid,
	int				cpu,
	int				group_fd);
asmlinkage long sys_perfcounter_setflags(int fd, u32 flags);

or

struct perf_counter_setup {
	struct perf_counter_hw_event event;
	__u64 pid;
	__u32 cpu;
	__u32 group_fd;
};
#define PERF_COUNTER_IOC_SETUP _IOW('$', 1, struct perf_counter_setup)
#define PERF_COUNTER_IOC_SETFLAGS _IOW('$', 2, __u32)

	Arnd <><

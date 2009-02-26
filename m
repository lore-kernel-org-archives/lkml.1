Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbZBZJuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbZBZJuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 04:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZBZJtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 04:49:50 -0500
Received: from bilbo.ozlabs.org ([203.10.76.25]:37156 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbZBZJts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 04:49:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18854.26007.890850.336512@cargo.ozlabs.ibm.com>
Date: Thu, 26 Feb 2009 20:49:11 +1100
From: Paul Mackerras <paulus@samba.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] Performance Counters for Linux, v6
In-Reply-To: <200902210147.20785.arnd@arndb.de>
References: <20090121185021.GA8852@elte.hu>
	<200902210147.20785.arnd@arndb.de>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann writes:

> On Wednesday 21 January 2009, Ingo Molnar wrote:
> 
> > diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
> > index 72353f6..4c8095f 100644
> > --- a/arch/powerpc/include/asm/systbl.h
> > +++ b/arch/powerpc/include/asm/systbl.h
> > @@ -322,3 +322,4 @@ SYSCALL_SPU(epoll_create1)
> >  SYSCALL_SPU(dup3)
> >  SYSCALL_SPU(pipe2)
> >  SYSCALL(inotify_init1)
> > +SYSCALL(perf_counter_open)
> 
> Is there a reason to forbid this on the SPU? It's probably not particularly
> useful, but it shouldn't hurt.

No, it's just an oversight, plus the fact that this stuff doesn't
support the hardware counters on Cell, which I've heard is rather
unusual.  Don't you have to hcalls to access it on machines with a
hypervisor?  Also, is there any facility for counting events on the
SPUs?

> > +#ifdef CONFIG_PERF_COUNTERS
> > +# include <asm/perf_counter.h>
> > +#endif
> > +
> > +#include <linux/list.h>
> > +#include <linux/mutex.h>
> > +#include <linux/rculist.h>
> > +#include <linux/rcupdate.h>
> > +#include <linux/spinlock.h>
> 
> I guess all */perf_counter.h files should be exported, but then
> the #ifdef won't work when the file is included from user space.
> Also, some of the included headers are not exported.

You're right, we do need to clean this up a bit.  So far, userspace
programs have tended to use their own copies of the relevant
definitions.

I think all that userspace needs is the hw_event_types enum, the
perf_counter_record_type enum, the perf_counter_hw_event struct, and
the ioctl definitions.  I don't see why userspace would need the asm
bits.

> > +/*
> > + * Hardware event to monitor via a performance monitoring counter:
> > + */
> > +struct perf_counter_hw_event {
> > +	s64			type;
> > +
> > +	u64			irq_period;
> > +	u32			record_type;
> > +
> > +	u32			disabled     :  1, /* off by default      */
> > +				nmi	     :  1, /* NMI sampling        */
> > +				raw	     :  1, /* raw event type      */
> > +				inherit	     :  1, /* children inherit it */
> > +				pinned	     :  1, /* must always be on PMU */
> > +				exclusive    :  1, /* only counter on PMU */
> > +
> > +				__reserved_1 : 26;
> > +
> > +	u64			__reserved_2;
> > +};
> 
> When exported, the types should be __s64 etc instead of s64.

Yep.

> > +/*
> > + * Ioctls that can be done on a perf counter fd:
> > + */
> > +#define PERF_COUNTER_IOC_ENABLE		_IO('$', 0)
> > +#define PERF_COUNTER_IOC_DISABLE	_IO('$', 1)
> > +
> > +/*
> > + * Kernel-internal data types:
> > + */
> 
> The kernel internal parts of the header should be hidden in #ifdef
> __KERNEL__.

Agreed.

> > +
> > +asmlinkage int sys_perf_counter_open(
> > +
> > +	struct perf_counter_hw_event	*hw_event_uptr		__user,
> > +	pid_t				pid,
> > +	int				cpu,
> > +	int				group_fd);
> 
> For the syscall, I'd suggest sys_perf_counter_fd or sys_perfcounterfd
> to go along with signalfd, eventfd, etc. The only other _open syscall
> we have is sys_mq_open(), which is different since it actually performs
> an open() on a (hidden) file.

I don't have a strong opinion on that either way; maybe Ingo does.

> All system calls should return a 'long' value to make sure that the
> errno handling works on all architectures.

True.

> > +static const struct file_operations perf_fops = {
> > +	.release		= perf_release,
> > +	.read			= perf_read,
> > +	.poll			= perf_poll,
> > +	.unlocked_ioctl		= perf_ioctl,
> > +	.compat_ioctl		= perf_ioctl,
> > +};
> 
> It feels inconsistent to combine a syscall for getting the fd with ioctl.

Why?  Once you have an fd, what's inconsistent about doing an ioctl on
it?

> Assuming the interface is semantically right, I'd suggest using either
> a chardev with more ioctls or more syscalls but not both:
> 
> asmlinkage long sys_perfcounter_fd(
> 	struct perf_counter_hw_event	*hw_event_uptr		__user,
> 	pid_t				pid,
> 	int				cpu,
> 	int				group_fd);
> asmlinkage long sys_perfcounter_setflags(int fd, u32 flags);
> 
> or
> 
> struct perf_counter_setup {
> 	struct perf_counter_hw_event event;
> 	__u64 pid;
> 	__u32 cpu;
> 	__u32 group_fd;
> };
> #define PERF_COUNTER_IOC_SETUP _IOW('$', 1, struct perf_counter_setup)
> #define PERF_COUNTER_IOC_SETFLAGS _IOW('$', 2, __u32)

I don't see any compelling value in either of those suggestions,
sorry.  Possibly, if it turns out that read() or ioctl() are just too
slow (and can't be improved), we might consider adding syscalls.

Paul.

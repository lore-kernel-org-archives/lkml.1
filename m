Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbZBZNjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbZBZNjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZBZNjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:39:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:56412 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbZBZNjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:39:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [announce] Performance Counters for Linux, v6
Date: Thu, 26 Feb 2009 14:37:40 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>, Mike Galbraith <efault@gmx.de>
References: <20090121185021.GA8852@elte.hu> <200902210147.20785.arnd@arndb.de> <18854.26007.890850.336512@cargo.ozlabs.ibm.com>
In-Reply-To: <18854.26007.890850.336512@cargo.ozlabs.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902261437.41833.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18ihWLLS4iwAkKt9AjJh/8KRanFZmGojnns8g5
 WHqAkNDK6SWBbGq40lbb0gAPpmbYKMqqClCg7Wtutnm50+iP9/
 ZuNALDxdrXBYh9SJCteww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Paul Mackerras wrote:
> Arnd Bergmann writes:
> No, it's just an oversight, plus the fact that this stuff doesn't
> support the hardware counters on Cell, which I've heard is rather
> unusual.  Don't you have to hcalls to access it on machines with a
> hypervisor?  Also, is there any facility for counting events on the
> SPUs?

Yes, there is, and it's suported in both oprofile and perfmon2.
It uses a set of hooks in the spu scheduler to know about what
code got loaded into it, and the platform interface is a combination
of mmio and rtas/hcall accesses.

> > > +static const struct file_operations perf_fops = {
> > > +	.release		= perf_release,
> > > +	.read			= perf_read,
> > > +	.poll			= perf_poll,
> > > +	.unlocked_ioctl		= perf_ioctl,
> > > +	.compat_ioctl		= perf_ioctl,
> > > +};
> > 
> > It feels inconsistent to combine a syscall for getting the fd with ioctl.
> 
> Why?  Once you have an fd, what's inconsistent about doing an ioctl on
> it?

I don't think we have any interface doing that today outside of the
traditional chardev, blockdev, socket and regular file descriptors.
The first inconsistency would be in having another type of object
that you can do ioctl on.

Back in the original spufs interface design, I had similar plans
for adding a combination of syscall and ioctl interfaces. The point
that convinced me to go with just syscall and regular file operations
was that syscall and ioctl are basically two interchangeable ways of
doing the same thing (adding an arbitrary function call into the kernel).
When you look in /proc/misc, half the stuff in there only exists as
a cheap way to sneak a syscall into the kernel without the necessary
review.

The inconsistency in combining the two would be the same as having
sys_timerfd_settime an ioctl on the fd from sys_timerfd_create,
or getdents an ioctl on a directory fd.

The most significant impact of allowing ioctl on the fd is certainly
that it allows adding many more interfaces on top of the performance
counters as soon as the code is initially merged. Whether you count
that as a an advantage or a disadvantage depends on your point
of view ;-).

> > Assuming the interface is semantically right, I'd suggest using either
> > a chardev with more ioctls or more syscalls but not both:
> > 
> > asmlinkage long sys_perfcounter_fd(
> > 	struct perf_counter_hw_event	*hw_event_uptr		__user,
> > 	pid_t				pid,
> > 	int				cpu,
> > 	int				group_fd);
> > asmlinkage long sys_perfcounter_setflags(int fd, u32 flags);
> > 
> > or
> > 
> > struct perf_counter_setup {
> > 	struct perf_counter_hw_event event;
> > 	__u64 pid;
> > 	__u32 cpu;
> > 	__u32 group_fd;
> > };
> > #define PERF_COUNTER_IOC_SETUP _IOW('$', 1, struct perf_counter_setup)
> > #define PERF_COUNTER_IOC_SETFLAGS _IOW('$', 2, __u32)
> 
> I don't see any compelling value in either of those suggestions,
> sorry.  Possibly, if it turns out that read() or ioctl() are just too
> slow (and can't be improved), we might consider adding syscalls.

I don't think that performance is an issue here, read() is quite well
optimized and ioctl() would only be used in the slowpath.

My second example is a bit constructed, if you wanted to go with a
chardev, that would probably imply larger interface changes than that.

One way to improve the interface over PERF_COUNTER_IOC_ENABLE might
be to use write() for enable/disable, but if sys_perfcounter_fd (or
whatever we call it) stays, using other syscalls for operating on
it seems to be the most consistant way of doing it.

Another point that now occurred to me is that in sys_perfcounter_fd(),
you should probably put the group descriptor argument first, to be
more consistent with the openat() family of syscalls which all take
the relative position as their first argument.

	Arnd <><

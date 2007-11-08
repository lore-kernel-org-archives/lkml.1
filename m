Return-Path: <linux-kernel-owner+w=401wt.eu-S1758237AbXKHAT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbXKHAT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbXKHATt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:19:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35796 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540AbXKHATt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:19:49 -0500
Date: Wed, 7 Nov 2007 16:18:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: lkml@davidb.org, linux-kernel@vger.kernel.org, drepper@redhat.com,
       mtk-manpages@gmx.net
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
Message-Id: <20071107161853.044b6e8f.akpm@linux-foundation.org>
In-Reply-To: <20071107152833.6f302c2a.akpm@linux-foundation.org>
References: <20071107224722.GA20204@old.davidb.org>
	<20071107152833.6f302c2a.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 7 Nov 2007 15:28:33 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 7 Nov 2007 14:47:22 -0800 David Brown <lkml@davidb.org> wrote:
> > compat_sys_times() has bogus return until jiffies is >= 0.  I discovered
> > this running LTP within 5 minutes of booting.
> > 
> > The return result
> > 
> > 	return compat_jiffies_to_clock_t(jiffies);
> > 
> > will return '-1' to user space and set the negated clock_t value to errno.
> > 
> > I'm not sure what the correct fix for this is.  I can come up with a patch
> > if anyone has ideas on how to fix it.
> > 
> > At minimum, perhaps it should return a sane errno value.
> 
> RETURN VALUE
>        times()  returns  the  number of clock ticks that have elapsed since an
>        arbitrary point in the past.  For Linux 2.4 and earlier this  point  is
>        the  moment  the  system  was  booted.   Since Linux 2.6, this point is
>        (2^32/HZ) - 300 (i.e., about 429 million) seconds  before  system  boot
>        time.   The  return  value  may  overflow  the  possible  range of type
>        clock_t.  On error, (clock_t) -1 is returned, and errno is  set  appro-
>        priately.
> 
> 
> Perhaps this is a bug in glibc: it is interpreting the times() return value
> in the same way as other syscalls.
> 
> It would have been sensible for us to add INITIAL_JIFFIES to the value
> instead of exposing this kernel-only detail to the world, although the
> problem will of course reoccur once jiffies hits 0x80000000.  Unfortunately
> we've even gone and enshrined this bogon in the manpage.
> 
> Proposed fix:
> 
> -        return compat_jiffies_to_clock_t(jiffies);
> +        return compat_jiffies_to_clock_t((jiffies + INITIAL_JIFFIES) &
> +						0x7fffffff);
> 
> ?

Like this?

It gets messy.


From: Andrew Morton <akpm@linux-foundation.org>

David Brown points out that compat_sys_times() (and sys_times()) can return
arbitrary 32-bit (or 64-bit values).  If these happen to be negative (jiffy
wrap, or before INITIAL_JIFFIES) then libc will interpret this as an error and
will return -1 to the libc user and will set errno.

The manpage for times(2) says:

       times()  returns  the  number of clock ticks that have elapsed since an
       arbitrary point in the past.  For Linux 2.4 and earlier this  point  is
       the  moment  the  system  was  booted.   Since Linux 2.6, this point is
       (2^32/HZ) - 300 (i.e., about 429 million) seconds  before  system  boot
       time.   The  return  value  may  overflow  the  possible  range of type
       clock_t.  On error, (clock_t) -1 is returned, and errno is  set  appro-
       priately.

We can fix this by masking the return value down to a 31-bit (63-bit) value.

Also, let's correct for INTIAL_JIFFIES - this isn't a detail which should be
exposed to userspace.

Unfortunately this change can break userspace.  If a program was (correctly)
doing:

	unsigned long start = times(...);
	...
	unsigned long end = times(...);
	unsigned long delta = end - start;

then `delta' can be grossly wrong if we wrapped in the interval.  Instead
userspace will need to mask `delta' by 0x7fffffff (0x7fffffffffffffff) to get
the correct number.

But userspace was already busted in the presence of wraparound, due to glibc's
convert-to-negative-one behaviour.

Given all this stuff, the return value from sys_times() doesn't seem a
particularly useful or reliable kernel interface.

Cc: David Brown <lkml@davidb.org>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/compat.c |    3 ++-
 kernel/sys.c    |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/sys.c~a kernel/sys.c
--- a/kernel/sys.c~a
+++ a/kernel/sys.c
@@ -897,7 +897,8 @@ asmlinkage long sys_times(struct tms __u
 		if (copy_to_user(tbuf, &tmp, sizeof(struct tms)))
 			return -EFAULT;
 	}
-	return (long) jiffies_64_to_clock_t(get_jiffies_64());
+	return jiffies_64_to_clock_t((get_jiffies_64() + INITIAL_JIFFIES) &
+						LONG_MAX);
 }
 
 /*
diff -puN kernel/compat.c~a kernel/compat.c
--- a/kernel/compat.c~a
+++ a/kernel/compat.c
@@ -162,7 +162,8 @@ asmlinkage long compat_sys_times(struct 
 		if (copy_to_user(tbuf, &tmp, sizeof(tmp)))
 			return -EFAULT;
 	}
-	return compat_jiffies_to_clock_t(jiffies);
+	return compat_jiffies_to_clock_t((jiffies + INITIAL_JIFFIES) &
+						LONG_MAX);
 }
 
 /*
_


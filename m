Return-Path: <linux-kernel-owner+w=401wt.eu-S1751133AbXCZJ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133AbXCZJ6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbXCZJ6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:58:21 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51171 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbXCZJ6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:58:20 -0400
Date: Mon, 26 Mar 2007 01:57:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre.Peiffer@bull.net
Cc: mingo@elte.hu, drepper@redhat.com, linux-kernel@vger.kernel.org,
       jean-pierre.dion@bull.net, Sebastien Dugue <sebastien.dugue@bull.net>,
       Pierre Peiffer <pierre.peiffer@bull.net>
Subject: Re: [PATCH 2.6.21-rc4-mm1 2/4] Make futex_wait() use an hrtimer for
 timeout
Message-Id: <20070326015749.e3f7c928.akpm@linux-foundation.org>
In-Reply-To: <20070321100535.887091576@bull.net>
References: <20070321095432.207136068@bull.net>
	<20070321100535.887091576@bull.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 10:54:34 +0100 Pierre.Peiffer@bull.net wrote:

> This patch modifies futex_wait() to use an hrtimer + schedule() in place of
> schedule_timeout().
> 
>   schedule_timeout() is tick based, therefore the timeout granularity is
> the tick (1 ms, 4 ms or 10 ms depending on HZ). By using a high resolution
> timer for timeout wakeup, we can attain a much finer timeout granularity
> (in the microsecond range). This parallels what is already done for
> futex_lock_pi().
> 
>   The timeout passed to the syscall is no longer converted to jiffies
> and is therefore passed to do_futex() and futex_wait() as an absolute
> ktime_t therefore keeping nanosecond resolution.
> 
>   Also this removes the need to pass the nanoseconds timeout part to
> futex_lock_pi() in val2.
> 
>   In futex_wait(), if there is no timeout then a regular schedule() is
> performed. Otherwise, an hrtimer is fired before schedule() is called.
> 

Problem.

> --- a/include/linux/futex.h
> +++ b/include/linux/futex.h
> @@ -1,6 +1,7 @@
>  #ifndef _LINUX_FUTEX_H
>  #define _LINUX_FUTEX_H
>  
> +#include <linux/ktime.h>
>  #include <linux/sched.h>
>  

For a start, please print out a copy of Documentation/SubmitChecklist and
tape it to your monitor.  It's really good.

`make headers_check' fails with

/usr/src/devel/usr/include/linux/futex.h requires linux/ktime.h, which does not exist in exported headers



This fixes it:


diff -puN include/linux/Kbuild~make-futex_wait-use-an-hrtimer-for-timeout-fix include/linux/Kbuild
--- a/include/linux/Kbuild~make-futex_wait-use-an-hrtimer-for-timeout-fix
+++ a/include/linux/Kbuild
@@ -40,6 +40,7 @@ header-y += baycom.h
 header-y += bfs_fs.h
 header-y += blkpg.h
 header-y += bpqether.h
+header-y += calc64.h
 header-y += cdk.h
 header-y += chio.h
 header-y += coda_psdev.h
@@ -99,7 +100,9 @@ header-y += isdn_divertif.h
 header-y += iso_fs.h
 header-y += ixjuser.h
 header-y += jffs2.h
+header-y += jiffies.h
 header-y += keyctl.h
+header-y += ktime.h
 header-y += kvm.h
 header-y += limits.h
 header-y += lock_dlm_plock.h
diff -puN include/asm-i386/Kbuild~make-futex_wait-use-an-hrtimer-for-timeout-fix include/asm-i386/Kbuild
--- a/include/asm-i386/Kbuild~make-futex_wait-use-an-hrtimer-for-timeout-fix
+++ a/include/asm-i386/Kbuild
@@ -2,6 +2,7 @@ include include/asm-generic/Kbuild.asm
 
 header-y += boot.h
 header-y += debugreg.h
+header-y += div64.h
 header-y += ldt.h
 header-y += ptrace-abi.h
 header-y += ucontext.h
_

But only for i386, and no way do we want to export all those headers.


Now.  What blithering idiot carefully went and made ktime_t a typedef so we
cannot forward declare it?  Sigh.  We tell 'em, but they don't listen.


This fixes ktime:


diff -puN include/linux/ktime.h~declare-struct-ktime include/linux/ktime.h
--- a/include/linux/ktime.h~declare-struct-ktime
+++ a/include/linux/ktime.h
@@ -43,7 +43,7 @@
  * plain scalar nanosecond based representation can be selected by the
  * config switch CONFIG_KTIME_SCALAR.
  */
-typedef union {
+union ktime {
 	s64	tv64;
 #if BITS_PER_LONG != 64 && !defined(CONFIG_KTIME_SCALAR)
 	struct {
@@ -54,7 +54,9 @@ typedef union {
 # endif
 	} tv;
 #endif
-} ktime_t;
+};
+
+typedef union ktime ktime_t;		/* Kill this */
 
 #define KTIME_MAX			((s64)~((u64)1 << 63))
 #if (BITS_PER_LONG == 64)
_

And this fixes your patch:

--- a/include/linux/futex.h~make-futex_wait-use-an-hrtimer-for-timeout-fix
+++ a/include/linux/futex.h
@@ -1,9 +1,10 @@
 #ifndef _LINUX_FUTEX_H
 #define _LINUX_FUTEX_H
 
-#include <linux/ktime.h>
 #include <linux/sched.h>
 
+union ktime;
+
 /* Second argument to futex syscall */
 
 
@@ -95,7 +96,7 @@ struct robust_list_head {
 #define ROBUST_LIST_LIMIT	2048
 
 #ifdef __KERNEL__
-long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
+long do_futex(u32 __user *uaddr, int op, u32 val, union ktime *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 
 extern int
_


And now someone needs to go all over the kernel and do a s/ktime_t/union ktime/g.
Again.  How often must we do this?


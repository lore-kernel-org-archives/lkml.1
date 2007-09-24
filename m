Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbXIXGxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbXIXGxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 02:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbXIXGx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 02:53:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:55700 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751487AbXIXGxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 02:53:25 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX19vMuBMXvJvUkDzePpScWG9vgNG9D7aa/tQvLkmYz
	kS1cM1MUGVKQl4
Message-ID: <46F75E4D.2080209@gmx.net>
Date: Mon, 24 Sep 2007 08:50:53 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/3] new timerfd API - wire the new timerfd API to the
 x86 family
References: <send-serie.davidel@xmailserver.org.19354.1190587750.2>
In-Reply-To: <send-serie.davidel@xmailserver.org.19354.1190587750.2>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide,

Is it perhaps not better to group the three syscalls contiguously with
respect to syscall numbers?  The old timerfd slot can be re-used for some
other syscall later.

Cheers,

Michael

Davide Libenzi wrote:
> Wires up the new timerfd API to the x86 family.
> 
> 
> 
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> 
> 
> - Davide
> 
> 
> ---
>  arch/i386/kernel/syscall_table.S |    5 ++++-
>  arch/x86_64/ia32/ia32entry.S     |    4 +++-
>  include/asm-i386/unistd.h        |    6 ++++--
>  include/asm-x86_64/unistd.h      |    8 ++++++--
>  4 files changed, 17 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6.mod/arch/i386/kernel/syscall_table.S
> ===================================================================
> --- linux-2.6.mod.orig/arch/i386/kernel/syscall_table.S	2007-09-23 15:28:48.000000000 -0700
> +++ linux-2.6.mod/arch/i386/kernel/syscall_table.S	2007-09-23 15:28:52.000000000 -0700
> @@ -321,6 +321,9 @@
>  	.long sys_epoll_pwait
>  	.long sys_utimensat		/* 320 */
>  	.long sys_signalfd
> -	.long sys_timerfd
> +	.long sys_timerfd_create
>  	.long sys_eventfd
>  	.long sys_fallocate
> +	.long sys_timerfd_settime	/* 325 */
> +	.long sys_timerfd_gettime
> +
> Index: linux-2.6.mod/arch/x86_64/ia32/ia32entry.S
> ===================================================================
> --- linux-2.6.mod.orig/arch/x86_64/ia32/ia32entry.S	2007-09-23 15:28:48.000000000 -0700
> +++ linux-2.6.mod/arch/x86_64/ia32/ia32entry.S	2007-09-23 15:28:52.000000000 -0700
> @@ -730,7 +730,9 @@
>  	.quad sys_epoll_pwait
>  	.quad compat_sys_utimensat	/* 320 */
>  	.quad compat_sys_signalfd
> -	.quad compat_sys_timerfd
> +	.quad sys_timerfd_create
>  	.quad sys_eventfd
>  	.quad sys32_fallocate
> +	.quad compat_sys_timerfd_settime	/* 325 */
> +	.quad compat_sys_timerfd_gettime
>  ia32_syscall_end:
> Index: linux-2.6.mod/include/asm-i386/unistd.h
> ===================================================================
> --- linux-2.6.mod.orig/include/asm-i386/unistd.h	2007-09-23 15:28:48.000000000 -0700
> +++ linux-2.6.mod/include/asm-i386/unistd.h	2007-09-23 15:28:52.000000000 -0700
> @@ -327,13 +327,15 @@
>  #define __NR_epoll_pwait	319
>  #define __NR_utimensat		320
>  #define __NR_signalfd		321
> -#define __NR_timerfd		322
> +#define __NR_timerfd_create	322
>  #define __NR_eventfd		323
>  #define __NR_fallocate		324
> +#define __NR_timerfd_settime	325
> +#define __NR_timerfd_gettime	326
>  
>  #ifdef __KERNEL__
>  
> -#define NR_syscalls 325
> +#define NR_syscalls 327
>  
>  #define __ARCH_WANT_IPC_PARSE_VERSION
>  #define __ARCH_WANT_OLD_READDIR
> Index: linux-2.6.mod/include/asm-x86_64/unistd.h
> ===================================================================
> --- linux-2.6.mod.orig/include/asm-x86_64/unistd.h	2007-09-23 15:28:48.000000000 -0700
> +++ linux-2.6.mod/include/asm-x86_64/unistd.h	2007-09-23 15:28:52.000000000 -0700
> @@ -626,12 +626,16 @@
>  __SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
>  #define __NR_signalfd		282
>  __SYSCALL(__NR_signalfd, sys_signalfd)
> -#define __NR_timerfd		283
> -__SYSCALL(__NR_timerfd, sys_timerfd)
> +#define __NR_timerfd_create	283
> +__SYSCALL(__NR_timerfd_create, sys_timerfd_create)
>  #define __NR_eventfd		284
>  __SYSCALL(__NR_eventfd, sys_eventfd)
>  #define __NR_fallocate		285
>  __SYSCALL(__NR_fallocate, sys_fallocate)
> +#define __NR_timerfd_settime	286
> +__SYSCALL(__NR_timerfd_settime, sys_timerfd_settime)
> +#define __NR_timerfd_gettime	287
> +__SYSCALL(__NR_timerfd_gettime, sys_timerfd_gettime)
>  
>  #ifndef __NO_STUBS
>  #define __ARCH_WANT_OLD_READDIR
> 

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbXD0VUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbXD0VUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757320AbXD0VUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:20:10 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757319AbXD0VUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:20:08 -0400
Date: Fri, 27 Apr 2007 14:19:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch 12/13] signal/timer/event fds v10 - eventfd wire up
 x86_64 arch ...
Message-Id: <20070427141941.a7891c62.akpm@linux-foundation.org>
In-Reply-To: <send-serie.davidel@xmailserver.org.10599.1175553997.12>
References: <send-serie.davidel@xmailserver.org.10599.1175553997.12>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Apr 2007 15:46:31 -0700
Davide Libenzi <davidel@xmailserver.org> wrote:

> This patch wire the eventfd system call to the x86_64 architecture.
> 
> 
> 
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> 
> 
> - Davide
> 
> 
> 
> Index: linux-2.6.21-rc5.fds/arch/x86_64/ia32/ia32entry.S
> ===================================================================
> --- linux-2.6.21-rc5.fds.orig/arch/x86_64/ia32/ia32entry.S	2007-04-02 15:06:40.000000000 -0700
> +++ linux-2.6.21-rc5.fds/arch/x86_64/ia32/ia32entry.S	2007-04-02 15:06:46.000000000 -0700
> @@ -721,4 +721,5 @@
>  	.quad sys_epoll_pwait
>  	.quad sys_signalfd		/* 320 */
>  	.quad sys_timerfd
> +	.quad sys_eventfd
>  ia32_syscall_end:		
> Index: linux-2.6.21-rc5.fds/include/asm-x86_64/unistd.h
> ===================================================================
> --- linux-2.6.21-rc5.fds.orig/include/asm-x86_64/unistd.h	2007-04-02 15:06:40.000000000 -0700
> +++ linux-2.6.21-rc5.fds/include/asm-x86_64/unistd.h	2007-04-02 15:06:46.000000000 -0700
> @@ -623,8 +623,10 @@
>  __SYSCALL(__NR_signalfd, sys_signalfd)
>  #define __NR_timerfd		281
>  __SYSCALL(__NR_timerfd, sys_timerfd)
> +#define __NR_eventfd		282
> +__SYSCALL(__NR_eventfd, sys_eventfd)
>  
> -#define __NR_syscall_max __NR_timerfd
> +#define __NR_syscall_max __NR_eventfd
>  
>  #ifndef __NO_STUBS
>  #define __ARCH_WANT_OLD_READDIR

General point: the first hunk here which wires up the 32-bit entry point
should arguably be part of the "wire up i386" patch, not the "wire up
x86_64" patch.

This is not a clear-cut thing.  The problem with the approach you've taken
here is that if we wire up i386 and not x86_64's i386 table (for example)
there are ways in which intervening patches can accidentally get i386 and
x86_64 emulation's syscall tables out of sync.  And, of course, 32-bit
applications will run on i386 but won't run on x86_64 or vice-versa.

So I think the best way to avoid all such problems is to always wire up
i386 and x86_64 (both 32- and 64-bit) in the same patch.


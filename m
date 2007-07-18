Return-Path: <linux-kernel-owner+w=401wt.eu-S1760901AbXGRBHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901AbXGRBHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 21:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761274AbXGRBHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 21:07:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56985 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758049AbXGRBHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 21:07:03 -0400
Date: Tue, 17 Jul 2007 18:06:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Schwab <schwab@suse.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Ulrich Drepper <drepper@redhat.com>, stable@kernel.org
Subject: Re: [PATCH] Pass nr_wake2 to futex_wake_op
Message-Id: <20070717180628.ec649a78.akpm@linux-foundation.org>
In-Reply-To: <jey7hfs1v2.fsf@sykes.suse.de>
References: <jey7hfs1v2.fsf@sykes.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 13:31:29 +0200
Andreas Schwab <schwab@suse.de> wrote:

> The fourth argument of sys_futex is ignored when op == FUTEX_WAKE_OP,
> but futex_wake_op expects it as its nr_wake2 parameter.
> 
> The only user of this operation in glibc is always passing 1, so this
> bug had no consequences so far.
> 
> Signed-off-by: Andreas Schwab <schwab@suse.de>
> 
> ---
>  kernel/futex.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.22.orig/kernel/futex.c	2007-07-02 00:40:44.000000000 +0200
> +++ linux-2.6.22/kernel/futex.c	2007-07-07 15:56:42.000000000 +0200
> @@ -2061,8 +2061,10 @@ asmlinkage long sys_futex(u32 __user *ua
>  	}
>  	/*
>  	 * requeue parameter in 'utime' if cmd == FUTEX_REQUEUE.
> +	 * number of waiters to wake in 'utime' if cmd == FUTEX_WAKE_OP.
>  	 */
> -	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
> +	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
> +	    cmd == FUTEX_WAKE_OP)
>  		val2 = (u32) (unsigned long) utime;
>  
>  	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
> 

So if an application or glibc _does_ start passing in non-1 values, it
will malfunction on earlier kernels?

So that userspace code would need to have a test for the kernel version, I
assume?

All a bit of a hassle.  Still, I'd propose that this change (if the
thus-far-silent cc'ees agree with it?) go into 2.6.22.x at least.  If it
gets accepted into 2.6.22.x then applications (or glibc) will need to test
for kernels as far back as 2.6.22.  Really they would need to test for the
correct value of x in 2.6.22.x, but I don't know if glibc is set up for
that.

Thoughts?

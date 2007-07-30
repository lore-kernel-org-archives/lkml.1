Return-Path: <linux-kernel-owner+w=401wt.eu-S937884AbXG3Xgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937884AbXG3Xgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 19:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760346AbXG3Xgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 19:36:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761226AbXG3Xgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 19:36:44 -0400
Date: Mon, 30 Jul 2007 16:35:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] Use ERESTARTNOHAND if poll() is interrupted by a signal
Message-Id: <20070730163538.67b256da.akpm@linux-foundation.org>
In-Reply-To: <200707291705.l6TH554a003344@colorfullife.mysite.adiungo.com>
References: <200707291705.l6TH554a003344@colorfullife.mysite.adiungo.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007 19:05:05 +0200
Manfred Spraul <manfred@colorfullife.com> wrote:

> Hi Andrew,
> 
> poll() returns -EINTR if a signal is pending.
> EINTR is a bad choice: it means that poll returns to user space if the
> task is stopped by SIGSTOP/SIGCONT or by the freezer.
> select() and ppoll() both use ERESTARTNOHAND, this avoids a return to
> user space for signals that are handled by the kernel.
> 
> The patch switches poll() to ERESTARTNOHAND.
> Tested with FC6. Patch against 2.6.23-rc1-mm1.

hm.  Is this a fix against
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/broken-out/do_poll-return-eintr-when-signalled.patch
only, or does mainline also need fixing?

I guess the consequences of the thing-which-this-fixes aren't huge, s I ca
queue this up for 2.6.24, after Oleg's
do_poll-return-eintr-when-signalled.patch?

> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> 
> --- 2.6/fs/select.c	2007-07-28 20:31:51.000000000 +0200
> +++ build-2.6/fs/select.c	2007-07-28 21:21:52.000000000 +0200
> @@ -621,7 +621,7 @@ static int do_poll(unsigned int nfds,  s
>  		if (!count) {
>  			count = wait->error;
>  			if (signal_pending(current))
> -				count = -EINTR;
> +				count = -ERESTARTNOHAND;
>  		}
>  		if (count || !*timeout)
>  			break;
> @@ -774,7 +774,7 @@ asmlinkage long sys_ppoll(struct pollfd 
>  	ret = do_sys_poll(ufds, nfds, &timeout);
>  
>  	/* We can restart this syscall, usually */
> -	if (ret == -EINTR) {
> +	if (ret == -ERESTARTNOHAND) {
>  		/*
>  		 * Don't restore the signal mask yet. Let do_signal() deliver
>  		 * the signal on the way back to userspace, before the signal
> @@ -785,7 +785,6 @@ asmlinkage long sys_ppoll(struct pollfd 
>  					sizeof(sigsaved));
>  			set_thread_flag(TIF_RESTORE_SIGMASK);
>  		}
> -		ret = -ERESTARTNOHAND;
>  	} else if (sigmask)
>  		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
>  

I spied this comment in there:

/*
 * We can actually return ERESTARTSYS instead of EINTR, but I'd
 * like to be certain this leads to no problems. So I return
 * EINTR just for safety.
 *
 * Update: ERESTARTSYS breaks at least the xview clock binary, so
 * I'm trying ERESTARTNOHAND which restart only when you want to.
 */

it is very old and perhaps is no longer relevant?

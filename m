Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbZHQQe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbZHQQe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 12:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZHQQe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 12:34:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39884 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZHQQe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 12:34:56 -0400
Date: Mon, 17 Aug 2009 18:31:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] inline __fatal_signal_pending
Message-ID: <20090817163126.GA14581@redhat.com>
References: <20090815003250.8101E40595@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090815003250.8101E40595@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14, Roland McGrath wrote:
>
> __fatal_signal_pending inlines to one instruction on x86, probably two
> instructions on other machines.  It takes two longer x86 instructions
> just to call it and test its return value, not to mention the function
> itself.
>
> On my random x86_64 config, this saved 70 bytes of text (59 of those
> being __fatal_signal_pending itself).

Agreed.


In fact, I think we do not need 2 helpers. I mean, fatal_signal_pending()
does not need the signal_pending() check, we can just rename
__fatal_signal_pending() to fatal_signal_pending(). Should be another
change of course.

Oleg.

> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  include/linux/sched.h |    5 ++++-
>  kernel/signal.c       |    6 ------
>  2 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 3ab08e4..fabe715 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2250,7 +2250,10 @@ static inline int signal_pending(struct task_struct *p)
>  	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
>  }
>  
> -extern int __fatal_signal_pending(struct task_struct *p);
> +static inline int __fatal_signal_pending(struct task_struct *p)
> +{
> +	return unlikely(sigismember(&p->pending.signal, SIGKILL));
> +}
>  
>  static inline int fatal_signal_pending(struct task_struct *p)
>  {
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 64c5dee..d441e3d 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1036,12 +1036,6 @@ void zap_other_threads(struct task_struct *p)
>  	}
>  }
>  
> -int __fatal_signal_pending(struct task_struct *tsk)
> -{
> -	return sigismember(&tsk->pending.signal, SIGKILL);
> -}
> -EXPORT_SYMBOL(__fatal_signal_pending);
> -
>  struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long *flags)
>  {
>  	struct sighand_struct *sighand;


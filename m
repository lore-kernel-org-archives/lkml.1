Return-Path: <linux-kernel-owner+w=401wt.eu-S1763710AbXHPPtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763710AbXHPPtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 11:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758175AbXHPPtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 11:49:06 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:42848 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758237AbXHPPtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 11:49:05 -0400
Date: Thu, 16 Aug 2007 19:51:31 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Subject: Re: [PATCH take2] Use ERESTART_RESTARTBLOCK if poll() is interrupted by a signal
Message-ID: <20070816155131.GA213@tv-sign.ru>
References: <200707291705.l6TH554a003344@colorfullife.mysite.adiungo.com> <20070730163538.67b256da.akpm@linux-foundation.org> <46AF9C2D.70808@colorfullife.com> <20070731210817.GA97@tv-sign.ru> <20070804063947.GQ3672@sequoia.sous-sol.org> <20070804110721.GA83@tv-sign.ru> <20070815222737.GC3672@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815222737.GC3672@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15, Chris Wright wrote:
>
>  fs/select.c |   31 ++++++++++++++++++++++++++++++-
>  1 files changed, 30 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/select.c b/fs/select.c
> index a974082..5562195 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -736,10 +736,28 @@ out_fds:
>  	return err;
>  }
>  
> +long do_restart_poll(struct restart_block *restart_block)
> +{
> +	struct pollfd __user *ufds = (struct pollfd __user*)restart_block->arg0;
> +	int nfds = restart_block->arg1;
> +	s64 timeout = ((s64)restart_block->arg3<<32) | (s64)restart_block->arg2;
> +	int ret;
> +
> +	ret = do_sys_poll(ufds, nfds, &timeout);
> +	if (ret == -EINTR) {
> +		restart_block->fn = do_restart_poll;
> +		restart_block->arg2 = timeout & 0xFFFFFFFF;
> +		restart_block->arg3 = (u64)timeout >> 32;
> +		ret = -ERESTART_RESTARTBLOCK;
> +	}
> +	return ret;
> +}
> +
>  asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
>  			long timeout_msecs)
>  {
>  	s64 timeout_jiffies;
> +	int ret;
>  
>  	if (timeout_msecs > 0) {
>  #if HZ > 1000
> @@ -754,7 +772,18 @@ asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
>  		timeout_jiffies = timeout_msecs;
>  	}
>  
> -	return do_sys_poll(ufds, nfds, &timeout_jiffies);
> +	ret = do_sys_poll(ufds, nfds, &timeout_jiffies);
> +	if (ret == -EINTR) {
> +		struct restart_block *restart_block;
> +		restart_block = &current_thread_info()->restart_block;
> +		restart_block->fn = do_restart_poll;
> +		restart_block->arg0 = (unsigned long)ufds;
> +		restart_block->arg1 = nfds;
> +		restart_block->arg2 = timeout_jiffies & 0xFFFFFFFF;
> +		restart_block->arg3 = (u64)timeout_jiffies >> 32;
> +		ret = -ERESTART_RESTARTBLOCK;
> +	}
> +	return ret;
>  }
>  
>  #ifdef TIF_RESTORE_SIGMASK

Great, I think the patch is correct.

Oleg.


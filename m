Return-Path: <linux-kernel-owner+w=401wt.eu-S934266AbZLMBsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266AbZLMBsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934251AbZLMBsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:48:52 -0500
Received: from www.tglx.de ([62.245.132.106]:34360 "HELO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934158AbZLMBsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:48:33 -0500
Date: Sat, 12 Dec 2009 23:33:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <gregkh@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
In-Reply-To: <alpine.LFD.2.00.0912121418490.3526@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0912122331200.3089@localhost.localdomain>
References: <20091211232805.GA10652@kroah.com> <20091212084611.GA28266@elte.hu> <20091212013927.58d386d1.akpm@linux-foundation.org> <20091212101032.GB25286@elte.hu> <20091212023603.93768833.akpm@linux-foundation.org> <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
 <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain> <20091212214235.31429790@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0912121418490.3526@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009, Linus Torvalds wrote:
 
> 
> On Sat, 12 Dec 2009, Alan Cox wrote:
> 
> > > I think we could possibly add a "__might_sleep()" to _lock_kernel(). It 
> > > doesn't really sleep, but it's invalid to take the kernel lock in an 
> > > atomic region, so __might_sleep() might be the right thing anyway.
> > 
> > It's only invalid if you don't already hold the lock.
> 
> True.
> 
> > The old tty code worked because every path into tty_fasync already held 
> > the lock ! That specific case - taking it the first time should 
> > definitely __might_sleep().
> 
> That would give us at least somewhat better debugging. And it's a very 
> natural thing to do. IOW, just something like the appended.
> 
> But maybe it complains about valid (but unusual) things. For example, it's 
> not strictly speaking _wrong_ to take the kernel lock while preemption is 
> disabled, even though it's a really bad idea.
> 
> Anybody willing to be the guinea-pig?

Replaced my patch with yours and it works the same way (except for the
PREEMPT=n case)

Acked-and-Tested-by: Thomas Gleixner <tglx@linutronix.de>
 
> 		Linus
> 
> ---
>  lib/kernel_lock.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
> index 4ebfa5a..5526b46 100644
> --- a/lib/kernel_lock.c
> +++ b/lib/kernel_lock.c
> @@ -122,8 +122,10 @@ void __lockfunc _lock_kernel(const char *func, const char *file, int line)
>  
>  	trace_lock_kernel(func, file, line);
>  
> -	if (likely(!depth))
> +	if (likely(!depth)) {
> +		might_sleep();
>  		__lock_kernel();
> +	}
>  	current->lock_depth = depth;
>  }
>  
> 

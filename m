Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYLPM5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYLPM5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 07:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbYLPM5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 07:57:33 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51924 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbYLPM5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 07:57:33 -0500
Date: Tue, 16 Dec 2008 13:57:21 +0100
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
Message-ID: <20081216125720.GC1684@ucw.cz>
References: <20081214212829.GA9435@elte.hu> <20081216122229.GA1430@ucw.cz> <20081216125000.GC25019@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216125000.GC25019@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-12-16 13:50:00, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@suse.cz> wrote:
> 
> > Hmm, if I timec some setuid program, what happens?
> 
> yes, i already had a quick look at that a few days ago when i implemented 
> counter inheritance (for different reasons) and couldnt find the cleanest 
> place to put the exec() flushing into so i procrastinated that a bit :)
> 
> > Performance counters seem like great tool to pull secret keys out of 
> > other processes :-).
> 
> if you worry about _that_ angle you also have to:
> 
>  - turn off the cycle counter
> 
>  - turn off precise utimes

Probably good idea, yes.

>  - plus you have to forbid SMT CPUs as well. On HT a task could
>    co-schedule with your setuid task and observe its timing
>    characteristics via its _own_ behavior. (which is impacted by whatever
>    is running on another SMT/HT thread.)

Yes, SMT is evil.

> the real exec() worry are: active, IRQ driven samples/events. Not possible 
> yet via the current iteration of counter inheritance (hence my 
> procrastination) - but it makes sense and that's why i was looking at the 
> exec() angle.
> 
> and that will flush simple counters too, removing your theoretical attack 
> angle as well.
> 
> So how about the patch below?

Thanks!

> Subject: perfcounters: flush on setuid exec
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue Dec 16 13:40:44 CET 2008
> 
> Pavel Machek pointed out that performance counters should be flushed
> when crossing protection domains on setuid execution.
> 
> Reported-by: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Pavel Machek <pavel@suse.cz>

> @@ -1015,6 +1016,13 @@ int flush_old_exec(struct linux_binprm *
>  		set_dumpable(current->mm, suid_dumpable);
>  	}
>  
> +	/*
> +	 * Flush performance counters when crossing a
> +	 * security domain:
> +	 */
> +	if (!get_dumpable(current->mm))
> +		perf_counter_exit_task(current);
> +
>  	/* An exec changes our domain. We are no longer part of the thread
>  	   group */
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

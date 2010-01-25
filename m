Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190Ab0AYWLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0AYWLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 17:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021Ab0AYWLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 17:11:12 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53948 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab0AYWLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 17:11:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rauft5UBX55mRW1OFh8b5mi7pWIKqPvQt51AlJxvba1YWPUyWx+TBm5tbAoSAvsVDb
         L5ve/f4JtthFl3Oatt41suKHqIETgip6gt7UjsKh1AjNwrH//73oXkJPb6YtaiH4GZ6R
         9wXTBSLwS3sMn7Rb4TlZMjgiFQ9Bq+DutWNb0=
Date: Mon, 25 Jan 2010 23:11:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC Patch 2/2][Bugfix][x86][hw-breakpoint] Fix return-code to
	notifier chain in hw_breakpoint_handler
Message-ID: <20100125221101.GE5087@nowhere>
References: <20091226175533.149765731@linux.vnet.ibm.com> <20091226182833.GC9494@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091226182833.GC9494@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 26, 2009 at 11:58:33PM +0530, K.Prasad wrote:
> The hw-breakpoint handler will return NOTIFY_DONE for user-space breakpoints
> to generate SIGTRAP signal (and not for kernel-space addresses). 


Please tell a bit more in your changelogs. It took me some time
to guess whether this is a fix or not.

And this is not a fix but an optimization because SIGTRAP
is only sent if needed.

Here is what happens in do_debug() after handling the
breakpoint:

	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
		send_sigtrap(tsk, regs, error_code, si_code);

This can only happen if we took the ptrace handler path.

Also:


> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/hw_breakpoint.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6-tip/arch/x86/kernel/hw_breakpoint.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/x86/kernel/hw_breakpoint.c
> +++ linux-2.6-tip/arch/x86/kernel/hw_breakpoint.c
> @@ -502,8 +502,6 @@ static int __kprobes hw_breakpoint_handl
>  		rcu_read_lock();
>  
>  		bp = per_cpu(bp_per_reg[i], cpu);
> -		if (bp)
> -			rc = NOTIFY_DONE;
>  		/*
>  		 * Reset the 'i'th TRAP bit in dr6 to denote completion of
>  		 * exception handling
> @@ -517,6 +515,13 @@ static int __kprobes hw_breakpoint_handl
>  			rcu_read_unlock();
>  			break;
>  		}
> +		/*
> +		 * Further processing in do_debug() is needed for a) user-space
> +		 * breakpoints (to generate signals) and b) when the system has
> +		 * taken exception due to multiple causes
> +		 */
> +		if (bp->attr.bp_addr < TASK_SIZE)
> +			rc = NOTIFY_DONE;



Is that < TASK_SIZE an accurate check? We want support for
userspace breakpoints on perf tools later, and those don't want
signals.

We do this cleanup in the beginning of the breakpoint handler:

	current->thread.debugreg6 &= ~DR_TRAP_BITS;

And from ptrace.c:ptrace_triggered():

	thread->debugreg6 |= (DR_TRAP0 << i);

This is called on perf_bp_event().
Instead of checking if this is a userspace thread, we should actually
check if this is a ptrace breakpoint by looking at this
in the end of hw_breakpoint_handler().


	current->thread.debugreg6 & DR_TRAP_BITS


Only ptrace breakpoints require signals.

Thanks.


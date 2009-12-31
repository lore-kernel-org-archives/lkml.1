Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbZLaAiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbZLaAiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 19:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZLaAiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 19:38:12 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63875 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZLaAiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 19:38:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pQbG3ndY2gG0C9rN6Do96x/lcjpmjXxdb4MJhEROJQ3n3QY59eLrMOi26BZQTvyRNa
         dLJtrDGcVQ2o4B99+LNPM1rgnDVN3/iqIpoi+o9CGElQoLldjCGDBvu7ANu5NdgcHMaz
         ziTF0ickkmfHMM5xgk/BBpnc5/5O2/jLBROlA=
Date: Thu, 31 Dec 2009 01:38:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC Patch 2/2][Bugfix][x86][hw-breakpoint] Fix return-code to
	notifier chain in hw_breakpoint_handler
Message-ID: <20091231003808.GC23808@nowhere>
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
> 
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
>  
>  		perf_bp_event(bp, args->regs);
>  
> 


Oh and now that I see this patch, the previous one indeed makes sense
with this check:

if (dr6 & (~DR_TRAP_BITS))
	rc = NOTIFY_DONE;

That said, it means thread.debugreg6 won't get the reserved bits anymore.
I see some use of them from kvm (it restores the reserved bits on guest<->host
switch). Not sure if this inconsistency could affect kvm...


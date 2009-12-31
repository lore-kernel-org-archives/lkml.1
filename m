Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbZLaAd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbZLaAd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 19:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZLaAd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 19:33:56 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49386 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZLaAdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 19:33:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wlt2esJSnPoaPzhtxohTXtC1NKGve+mywiVzAqHpKACDEfbi6Xc9vUhI+S0qwkWJSB
         QTbM1bIiPl6mUkgbejzMemm4yEEGUl+bsoBmrEn+9MVxSbpa3EtQybE9IbrYImeYXtUh
         XboU8WrKuoXu5WmJo70aksZEbRRcaq3/Ly510=
Date: Thu, 31 Dec 2009 01:33:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC Patch 2/2][Bugfix][x86][hw-breakpoint] Fix return-code to
	notifier chain in hw_breakpoint_handler
Message-ID: <20091231003348.GB23808@nowhere>
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


Looks good. This stops any further checks though. This
is fine in case we have the DR_STEP bit as we will
toggle to NOTIFY_DONE. But what about vm86 case? Is it
possible we might still have something to handle in this
side? (although I don't quite understand how we can have
a breakpoint triggered in vm86 mode).


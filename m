Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbZLRDGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbZLRDGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 22:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbZLRDGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 22:06:11 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42233 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZLRDGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 22:06:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YGMHebXjv3oZtf6zvafbigZ/HjW5jfme6zDV6zSawjfFbFviEoirVukmjeHAVcrMWj
         qV9jY+8kTCO1TxhmZ07T3V8fx4HLlH23WwwtNEQTcUywcn7opJJQjOSoniAndibXNJ5o
         mfiUrgDOfPkxp68GmSYYxfqgJUrTlltwB//vM=
Date: Fri, 18 Dec 2009 04:06:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: x86: do_debug && PTRACE_SINGLESTEP broken by
	08d68323d1f0c34452e614263b212ca556dae47f
Message-ID: <20091218030601.GB16470@nowhere>
References: <20091218005650.GA20667@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218005650.GA20667@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 01:56:50AM +0100, Oleg Nesterov wrote:
> Hi.
> 
> do_debug() is obviously wrong wrt PTRACE_SINGLESTEP/TIF_SINGLESTEP, no?
> 
> Afaics this was broken by
> 
> 	hw-breakpoints: modifying generic debug exception to use thread-specific debug registers
> 	commit 08d68323d1f0c34452e614263b212ca556dae47f
> 
> To verify, the "patch" below fixes the stepping for me, not sure what
> is the proper fix...
> 
> Oleg.
> 
> --- arch/x86/kernel/traps.c~	2009-12-18 00:20:49.000000000 +0100
> +++ arch/x86/kernel/traps.c	2009-12-18 01:44:05.000000000 +0100
> @@ -575,7 +575,7 @@ dotraplinkage void __kprobes do_debug(st
>  		regs->flags &= ~X86_EFLAGS_TF;
>  	}
>  	si_code = get_si_code(tsk->thread.debugreg6);
> -	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
> +//	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
>  		send_sigtrap(tsk, regs, error_code, si_code);



But I don't understand why it is broken with the check.
If we are in a singlestep exception, dr6 should have its
DR_STEP bit set...

Single stepping works well for me, after a quick check on
gdb. How did you trigger the bug?

Thanks.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1764850AbYDVTEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764850AbYDVTEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757883AbYDVTEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:04:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754166AbYDVTEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:04:30 -0400
Date: Tue, 22 Apr 2008 12:03:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       npiggin@suse.de, peterz@infradead.org, sam@ravnborg.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function
 calls
In-Reply-To: <1208890227-24808-3-git-send-email-jens.axboe@oracle.com>
Message-ID: <alpine.LFD.1.10.0804221157220.2779@woody.linux-foundation.org>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-3-git-send-email-jens.axboe@oracle.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Ingo added to cc, since this is x86-specific ]

On Tue, 22 Apr 2008, Jens Axboe wrote:
> +++ b/arch/x86/kernel/apic_32.c
> @@ -1357,6 +1357,10 @@ void __init smp_intr_init(void)
>  
>  	/* IPI for generic function call */
>  	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
> +
> +	/* IPI for single call function */
> +	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
> +				call_function_single_interrupt);

Ok, one more comment..

Why bother with separate vectors for this?

Why not just make the single vector do

	void smp_call_function_interrupt(void)
	{
		ack_APIC_irq();
		irq_enter();
		generic_smp_call_function_single_interrupt();
		generic_smp_call_function_interrupt();
	#ifdef CONFIG_X86_32
		__get_cpu_var(irq_stat).irq_call_count++;
	#else
		add_pda(irq_call_count, 1);
	#endif
		irq_exit();
	}

since they are both doing the exact same thing anyway?

Do we really require us to be able to handle the "single" case _while_ a 
"multiple" case is busy? Aren't we running all of these things with 
interrupts disabled anyway, so that it cannot happen?

Or is it just a performance optimization?  Do we expect to really have so 
many of the multiple interrupts that it's expensive to walk the list just 
because we also had a single interrupt to another CPU? That sounds a bit 
unlikely, but if true, very interesting..

Inquiring minds want to know..

			Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763724AbYBNLYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763724AbYBNLYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 06:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYBNLYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 06:24:32 -0500
Received: from r00tworld.com ([212.85.137.21]:50944 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbYBNLYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 06:24:31 -0500
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Thu, 14 Feb 2008 12:23:38 +0200
MIME-Version: 1.0
Subject: Re: vmsplice exploits, stack protector and Makefiles
Reply-to: pageexec@freemail.hu
CC: Sam Ravnborg <sam@ravnborg.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-ID: <47B432CA.28524.E15DB6A@pageexec.freemail.hu>
In-reply-to: <20080214073003.GA25699@elte.hu>
References: <20080213164853.GA25476@elte.hu>, <20080214061648.GB31327@elte.hu>, <20080214073003.GA25699@elte.hu>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Thu, 14 Feb 2008 12:21:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Feb 2008 at 8:30, Ingo Molnar wrote:

> --- linux-x86.q.orig/arch/x86/kernel/process_64.c
> +++ linux-x86.q/arch/x86/kernel/process_64.c
> @@ -166,6 +166,15 @@ static inline void play_dead(void)
>  void cpu_idle(void)
>  {
>  	current_thread_info()->status |= TS_POLLING;
> +
> +#ifdef CONFIG_CC_STACKPROTECTOR
> +	/*
> +	 * If we're the non-boot CPU, nothing set the PDA stack
> +	 * canary up for us. This is as good a place as any for
> +	 * doing that.
> +	 */
> +	write_pda(stack_canary, current->stack_canary);
> +#endif

i wonder if these #ifdef's are really needed at all, even if one doesn't
use -fstack-protector, having the code set up the canary has like 0
performance impact. not to mention that i think the change in switch_to
means that it won't compile without CONFIG_CC_STACKPROTECTOR enabled and
instead of making that macro conditional it's just a lot easier to enable
the canary all the time.


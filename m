Return-Path: <linux-kernel-owner+w=401wt.eu-S1764198AbYBLQuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764198AbYBLQuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbYBLQtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:49:55 -0500
Received: from mail.windriver.com ([147.11.1.11]:50840 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbYBLQty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:49:54 -0500
Message-ID: <47B1CDDC.3090708@windriver.com>
Date: Tue, 12 Feb 2008 10:48:28 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
References: <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <47B19F67.5050105@windriver.com> <20080212143949.GA2258@one.firstfloor.org> <47B1AEC3.2080402@windriver.com> <20080212153612.GA2944@one.firstfloor.org> <47B1C76F.6070908@windriver.com> <20080212171028.GC4191@one.firstfloor.org>
In-Reply-To: <20080212171028.GC4191@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2008 16:48:05.0489 (UTC) FILETIME=[09F96E10:01C86D97]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> It is more than a simple recursion check (which is already in the code)
>> because there are some conditions we can recover from.  I'd rather not
>> crash the system out if it can be recovered.
>>     
>
> Ok I'm trying to understand the code as you describe it. As far 
> as I can see (in kgdb-light-v10) it is:
>
> +       addr = kgdb_arch_pc(ks->ex_vector, ks->linux_regs);
> +       kgdb_deactivate_sw_breakpoints();
> +
> +       /*
> +        * If the break point removed ok at the place exception
> +        * occurred, try to recover and print a warning to the end
> +        * user because the user planted a breakpoint in a place that
> +        * KGDB needs in order to function.
> +        */
> +       if (kgdb_remove_sw_break(addr) == 0) {
>
> and
>
> +static int kgdb_remove_sw_break(unsigned long addr)
> +{
> +       int i;
> +
> +       for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
> +               if ((kgdb_break[i].state == BP_SET) &&
> +                               (kgdb_break[i].bpt_addr == addr)) {
> +                       kgdb_break[i].state = BP_REMOVED;
> +                       return 0;
> +               }
> +       }
> +       return -ENOENT;
>
> correct? 
>
> I don't think that code does what you describe at all. Are you
> sure we're talking about the same thing? 
>
> There is certainly no real protection against break points in
> debugger code in there as far as I can see (except for the reentry
> counter)
>
>   

Perhaps we are talking about different things.  I will agree that there
is no protection against putting a breakpoint in some code that is part
of the debugger.  That was certainly not what I was talking about.

You might be able to perform some protections at the breakpoint set time
or request to single step, but that is much more complex than is worth
it for the time being.  The recursion check guards against basic
stupidity or accidental stepping out of a frame you didn't mean to. 
Also there are a lot of non-obvious code paths that can get executed via
kgdb such as the fault handlers.  The simple recursion check covers
enough cases that you don't want to live without it.

If you want to improve it please provide some patches or further
elaborate on what needs to be fixed.

Jason

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbYAOSHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbYAOSHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 13:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYAOSGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 13:06:53 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:60659 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYAOSGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 13:06:53 -0500
Date: Tue, 15 Jan 2008 13:06:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Luotao Fu <l.fu@pengutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc7-rt2
In-Reply-To: <20080115162729.GF5859@pengutronix.de>
Message-ID: <Pine.LNX.4.58.0801151301550.26624@gandalf.stny.rr.com>
References: <1200336080.318.8.camel@localhost.localdomain>
 <20080115162729.GF5859@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jan 2008, Luotao Fu wrote:
>
> Compiling with tracing function turned seemed still to be broken to me:

Could you email me your config (privately)

> kernel/built-in.o: In function `early_printk_name':
> latency_trace.c:(.text+0x3cd18): undefined reference to `early_printk'
> latency_trace.c:(.text+0x3cd40): undefined reference to `early_printk'
> kernel/built-in.o: In function `early_print_entry':
> latency_trace.c:(.text+0x3cd80): undefined reference to `early_printk'
> latency_trace.c:(.text+0x3cdd8): undefined reference to `early_printk'
> latency_trace.c:(.text+0x3cdfc): undefined reference to `early_printk'
>
> We made a early_printk patch based on the 8250_early for powerpc 32bit here.
> (still absolutely untested and incomplete, we will post it asap). I added
> early_printk() and exported _mcount() and could compile succesfully. However the
> kernel will not boot. I attached a bdi to it and found out that it stucks at
> _mcount in arch/powerpc/kernel/entry_32.S at about line 1080, where the variable
> mcount_enabled is loaded and checked. Obviously the variable is still not valid
> at the time of check. To check this I took out the lines like above
>
> --- arch/powerpc/kernel/entry_32.S.orig 2008-01-15 17:01:25.000000000 +0100
> +++ arch/powerpc/kernel/entry_32.S      2008-01-15 17:17:18.000000000 +0100
> @@ -1075,9 +1075,6 @@
>         stw     r6, 24(r1)
>         mflr    r3      /* will use as first arg to __trace() */
>         mfcr    r4
> -       lis     r5,mcount_enabled@ha
> -       lwz     r5,mcount_enabled@l(r5)
> -       cmpwi   r5,0
>         stw     r3, 44(r1)      /* lr */
>         stw     r4,  8(r1)      /* cr */
>         stw     r7, 28(r1)
>
> After recompiling the kernel started normally and it seems to work. I was even
> able to make a trace with cyclictest. However there were several crashes (which
> might be caused by other problems). I still have to take a closer look.
>
> I am just wondering why the check for mcount_enabled is there at all and I think
> that there due to be some better fixes than just throw it out ;-). On the other
> side, I just can't find in which way mcount_enabled is used in the tracer at
> all. Could you give me some hints on this one?
>

The way we turn on and off mcount function calls at run time is through
mcount_enable.  I'll look into why this is broken for you. I'm able to run
with this. My box is a ppc64, and my ppc32 (powerbook) wont come close to
booting RT (never did).  On boot up it locks up right away and the screen
looks like it starts to melt. No serial, so I don't have much to debug
that with.

Anyway, I'll take a deeper look into this.

Thanks,

-- Steve


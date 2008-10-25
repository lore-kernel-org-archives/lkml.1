Return-Path: <linux-kernel-owner+w=401wt.eu-S1752486AbYJYIYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbYJYIYk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 04:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYJYIYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 04:24:25 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:58939 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbYJYIYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 04:24:23 -0400
Date: Sat, 25 Oct 2008 10:24:11 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Richard Henderson <rth@twiddle.net>, Greg Ungerer <gerg@uclinux.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ftrace: handle archs that do not support irqs_disabled_flags
In-Reply-To: <alpine.DEB.1.10.0810240937130.3882@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.64.0810251018370.15317@anakin>
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
 <20081023121145.GB27984@x200.localdomain> <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com>
 <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com>
 <49008D12.5090204@gmail.com> <Pine.LNX.4.64.0810231635440.18978@anakin>
 <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com>
 <Pine.LNX.4.64.0810231727430.18978@anakin> <4900B414.7090002@gmail.com>
 <20081023163433.GA3160@x200.localdomain> <20081023163850.GB16591@elte.hu>
 <4901D8CD.7000405@gmail.com> <alpine.DEB.1.10.0810240937130.3882@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008, Steven Rostedt wrote:
> Some architectures do not support a way to read the irq flags that
> is set from "local_irq_save(flags)" to determine if interrupts were
> disabled or enabled. Ftrace uses this information to display to the user
> if the trace occurred with interrupts enabled or disabled.

Both alpha

	#define irqs_disabled() (getipl() == IPL_MAX)

and m68k

	static inline int irqs_disabled(void)
	{
		unsigned long flags;
		local_save_flags(flags);
		return flags & ~ALLOWINT;
	}

do have irqs_disabled(), but they don't have irqs_disabled_flags().

M68knommu has both, but they don't check the same thing:

	#define irqs_disabled()                 \
	({                                      \
		unsigned long flags;            \
		local_save_flags(flags);        \
		((flags & 0x0700) == 0x0700);   \
	})

	static inline int irqs_disabled_flags(unsigned long flags)
	{
		if (flags & 0x0700)
			return 0;
		else
			return 1;
	}

Is there a semantic difference between them (except that the latter takes the
flags as a parameter)?

Or can we just extract the core logic of irqs_disabled() into
irqs_disabled_flags()?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

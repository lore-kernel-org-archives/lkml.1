Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbYJ1HaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbYJ1HaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 03:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYJ1HaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 03:30:04 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:49153 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752371AbYJ1HaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 03:30:00 -0400
Message-ID: <4906BE61.1090000@snapgear.com>
Date: Tue, 28 Oct 2008 17:25:21 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Richard Henderson <rth@twiddle.net>, Greg Ungerer <gerg@uclinux.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ftrace: handle archs that do not support irqs_disabled_flags
References: <20081023213637.eff9b414.sfr@canb.auug.org.au> <20081023121145.GB27984@x200.localdomain> <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com> <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com> <49008D12.5090204@gmail.com> <Pine.LNX.4.64.0810231635440.18978@anakin> <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com> <Pine.LNX.4.64.0810231727430.18978@anakin> <4900B414.7090002@gmail.com> <20081023163433.GA3160@x200.localdomain> <20081023163850.GB16591@elte.hu> <4901D8CD.7000405@gmail.com> <alpine.DEB.1.10.0810240937130.3882@gandalf.stny.rr.com> <Pine.LNX.4.64.0810251018370.15317@anakin>
In-Reply-To: <Pine.LNX.4.64.0810251018370.15317@anakin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Geert Uytterhoeven wrote:
> On Fri, 24 Oct 2008, Steven Rostedt wrote:
>> Some architectures do not support a way to read the irq flags that
>> is set from "local_irq_save(flags)" to determine if interrupts were
>> disabled or enabled. Ftrace uses this information to display to the user
>> if the trace occurred with interrupts enabled or disabled.
> 
> Both alpha
> 
> 	#define irqs_disabled() (getipl() == IPL_MAX)
> 
> and m68k
> 
> 	static inline int irqs_disabled(void)
> 	{
> 		unsigned long flags;
> 		local_save_flags(flags);
> 		return flags & ~ALLOWINT;
> 	}
> 
> do have irqs_disabled(), but they don't have irqs_disabled_flags().
> 
> M68knommu has both, but they don't check the same thing:
> 
> 	#define irqs_disabled()                 \
> 	({                                      \
> 		unsigned long flags;            \
> 		local_save_flags(flags);        \
> 		((flags & 0x0700) == 0x0700);   \
> 	})
> 
> 	static inline int irqs_disabled_flags(unsigned long flags)
> 	{
> 		if (flags & 0x0700)
> 			return 0;
> 		else
> 			return 1;
> 	}
> 
> Is there a semantic difference between them (except that the latter takes the
> flags as a parameter)?

No...


> Or can we just extract the core logic of irqs_disabled() into
> irqs_disabled_flags()?

Yep, could certainly do that. I'll put a patch together.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com

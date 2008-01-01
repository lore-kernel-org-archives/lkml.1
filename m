Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbYAAVxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbYAAVxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbYAAVxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:53:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59762 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbYAAVxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:53:15 -0500
Message-ID: <477AB5B8.2070509@zytor.com>
Date: Tue, 01 Jan 2008 13:50:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christer Weinigel <christer@weinigel.se>
CC: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <47667366.7010405@gmail.com>	<4766AE88.4080904@zytor.com>	<4766D175.7040807@reed.com>	<20071217212509.5edaa372@the-village.bc.nu>	<477A634C.8040000@reed.com>	<20080101161557.3ce2d5f8@the-village.bc.nu>	<20080101164338.GA901@elte.hu>	<20080101183238.74307174@weinigel.se>	<20080101184659.GA9250@elte.hu>	<20080101203518.26e889f2@weinigel.se>	<20080101210143.GB759@elte.hu> <20080101224241.2ce431bd@weinigel.se>
In-Reply-To: <20080101224241.2ce431bd@weinigel.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christer Weinigel wrote:
> 
> And once again, the _p in the code that talks to the PIT is very much
> non-bogus.  And it is a critical path that's called a lot.  The i8253
> PIT and the i8259 interrupt controller are probably the only ones that
> are relevant on a modern machine, and it seems that even some fairly
> modern chipsets have limitations on how fast you can drive them.
> 

I actually analyzed the case of the PIT in the case of the 
implementation of a real chipset.  In our case, running the PIT at 
1.19318 MHz when the rest of the chipset core was running at 100 MHz 
introduced a huge amount of extra complexity and we really wanted to get 
rid of it.  As it turns out, the PIT interface is ill-defined if run at 
a higher frequency; you can get undefined values as a result of a write 
followed by a read if there is no intervening PIT clock, which of course 
in the standard interface never happens.  So in the end, we had to build 
all the synchronizers, backpressure controls and other crap that went 
along with an additional clock domain.

As a result of that experience, I really don't think you will *ever* see 
a PIT that runs at a modern frequency.

Building a 100 MHz PIC, however, was not a problem, and being able to 
sink accesses at full speed meant we didn't have to implement flow control.

	-hpa

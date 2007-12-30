Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbXL3RGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbXL3RGz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 12:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbXL3RGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 12:06:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47966 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbXL3RGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 12:06:46 -0500
Date: Sun, 30 Dec 2007 18:06:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230170612.GA16502@elte.hu>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <4777BDA5.4050203@keyaccess.nl> <20071230160751.GB26221@elte.hu> <4777C6E8.7060202@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4777C6E8.7060202@keyaccess.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@keyaccess.nl> wrote:

>>> Hardly. Duron 1300 on AMD756:
>>
>> but that does not matter at all: that's not '90s era hardware that we 
>> are (slightly) worried about wrt. IO delays in misc_32.c. (i.e. on 
>> _real_ ISA systems)
>
> Real ISA systems will also generally respond faster to it than the 
> unused port (this thing actually has an ISA bus but not VGA on it 
> ofcourse) which means that "a perfect delay register" it is not. But 
> yes, I have an actual Am386DX-40 with ISA VGA up and running which 
> also doesn't care either way, about the ones in misc_32.c or anywhere 
> else for that matter.

yeah - and that's typical of most _p() use: most of them are totally 
bogus, but the global existence of the delay was used as a "it _might_ 
break system" boogey-man against replacing it.

so _IF_ we do any delay in x86 platform drivers, we at most do a delay 
on the order of the round-trip latency to the same piece of hardware we 
are handling. That isolates the quirk to the same hardware category, 
instead of creating these cross-dependencies and assumed dependencies on 
fixed, absolute timings. (and most hardware timing bugs are not absolute 
but depend on some bus speed/frequency, thus round-trip latency of that 
hardware is a good approximation of that. The round-trip to the same 
hardware also correctly adds any assumed PCI posting dependencies.)

So the current plan is to go with an io_delay=udelay default in v2.6.25, 
to give this a migration window, and io_delay=none in v2.6.26 [and a 
complete removal of arch/x86/kernel/io_delay.c], once the _p() uses are 
fixed up. This is gradual enough to notice any regressions we care about 
and also makes it nicely bisectable and gradual.

	Ingo

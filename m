Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYAAUCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYAAUCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 15:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbYAAUCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 15:02:33 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:57393 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbYAAUCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 15:02:33 -0500
Message-ID: <477A9B98.2090608@keyaccess.nl>
Date: Tue, 01 Jan 2008 20:59:20 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Christer Weinigel <christer@weinigel.se>
CC: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@gmail.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4765DCB0.8030901@gmail.com>	<4765EE7F.80002@zytor.com>	<47667366.7010405@gmail.com>	<4766AE88.4080904@zytor.com>	<4766D175.7040807@reed.com>	<20071217212509.5edaa372@the-village.bc.nu>	<477A634C.8040000@reed.com>	<20080101161557.3ce2d5f8@the-village.bc.nu>	<20080101164338.GA901@elte.hu>	<20080101183238.74307174@weinigel.se>	<20080101184659.GA9250@elte.hu> <20080101203518.26e889f2@weinigel.se>
In-Reply-To: <20080101203518.26e889f2@weinigel.se>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01-01-08 20:35, Christer Weinigel wrote:

> On Tue, 1 Jan 2008 19:46:59 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Christer Weinigel <christer@weinigel.se> wrote:
>>
>>> What I'm afraid is that udelay will be significantly slower, [...]
>> why should it be significantly slower?
> 
> out 80h, al is only two bytes.  Any alternative that has been suggested
> in this discussion will use more space.  mov dx, alt_port; out dx, al
> will be larger, a function call will definitely be a lot larger. People
> have been making changes to the kernel to save a couple of hundred
> bytes of text size.
> 
> On old hardware (or anything with an ISA bus which I'd guess includes
> the Geode SCx200 SoC which is basically a MediaGX processor, a
> southbridge and an ISA bus with a Super I/O chip on it) an out to 80h
> will use exactly one ISA cycle.

Not to disagree with the point but more like 8 (1 us at 8 MHz). It's the 
timeout property.

> A call to udelay will need a margin,
> so it will be slightly slower.  And that's assuming that you can find
> out the speed of the ISA bus, if you can't you'll have to assume the
> slowest possible bus (6 MHz I guess) which will be a lot slower.
> 
> I don't know if the difference in code size or the udelay will be
> significantly slower, but I think it might be.

There's also the bit about microseconds being very losely defined pre 
loops_per_jiffy calibration. Per CPU-family init helps somewhat but 
certainly for family 6 (Pentium Pro, II, III -- lots of hardware with ISA 
busses therefore) speeds vary quite a bit still.

> And to take the MediaGX as an example, the TSC is not usable on that
> CPU, so Linux has to use the PIT timer for gettimeofday.  As I wrote
> in a different post, I believe the PIT on the SCx200 needs outb_p to
> work reliably.  So if outb_p becomes significantly slower that will
> affect a critical path on a very common embedded CPU.
> 
> I'm not sure what Alan meant with his comments about locking, but if
> changing outb_p to use an udelay means that we have to add locking,
> that is also going to affect the code size and speed.

Explained here:

http://lkml.org/lkml/2007/12/30/136

However, that's not an argument. Missing locking is a bug, and current outb 
I/O delay use hiding it doesn't change that.

Rene.

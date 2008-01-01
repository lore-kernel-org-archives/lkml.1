Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYAATf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYAATf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 14:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbYAATfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 14:35:21 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:59272 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbYAATfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 14:35:21 -0500
Date: Tue, 1 Jan 2008 20:35:18 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080101203518.26e889f2@weinigel.se>
In-Reply-To: <20080101184659.GA9250@elte.hu>
References: <4765DCB0.8030901@gmail.com>
	<4765EE7F.80002@zytor.com>
	<47667366.7010405@gmail.com>
	<4766AE88.4080904@zytor.com>
	<4766D175.7040807@reed.com>
	<20071217212509.5edaa372@the-village.bc.nu>
	<477A634C.8040000@reed.com>
	<20080101161557.3ce2d5f8@the-village.bc.nu>
	<20080101164338.GA901@elte.hu>
	<20080101183238.74307174@weinigel.se>
	<20080101184659.GA9250@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008 19:46:59 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Christer Weinigel <christer@weinigel.se> wrote:
> 
> > What I'm afraid is that udelay will be significantly slower, [...]
> 
> why should it be significantly slower?

out 80h, al is only two bytes.  Any alternative that has been suggested
in this discussion will use more space.  mov dx, alt_port; out dx, al
will be larger, a function call will definitely be a lot larger. People
have been making changes to the kernel to save a couple of hundred
bytes of text size.

On old hardware (or anything with an ISA bus which I'd guess includes
the Geode SCx200 SoC which is basically a MediaGX processor, a
southbridge and an ISA bus with a Super I/O chip on it) an out to 80h
will use exactly one ISA cycle.  A call to udelay will need a margin,
so it will be slightly slower.  And that's assuming that you can find
out the speed of the ISA bus, if you can't you'll have to assume the
slowest possible bus (6 MHz I guess) which will be a lot slower.

I don't know if the difference in code size or the udelay will be
significantly slower, but I think it might be.

And to take the MediaGX as an example, the TSC is not usable on that
CPU, so Linux has to use the PIT timer for gettimeofday.  As I wrote
in a different post, I believe the PIT on the SCx200 needs outb_p to
work reliably.  So if outb_p becomes significantly slower that will
affect a critical path on a very common embedded CPU.

I'm not sure what Alan meant with his comments about locking, but if
changing outb_p to use an udelay means that we have to add locking,
that is also going to affect the code size and speed.

  /Christer






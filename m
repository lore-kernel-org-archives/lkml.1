Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbYAAVmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbYAAVmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYAAVmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:42:43 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:48148 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbYAAVmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:42:43 -0500
Date: Tue, 1 Jan 2008 22:42:41 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080101224241.2ce431bd@weinigel.se>
In-Reply-To: <20080101210143.GB759@elte.hu>
References: <47667366.7010405@gmail.com>
	<4766AE88.4080904@zytor.com>
	<4766D175.7040807@reed.com>
	<20071217212509.5edaa372@the-village.bc.nu>
	<477A634C.8040000@reed.com>
	<20080101161557.3ce2d5f8@the-village.bc.nu>
	<20080101164338.GA901@elte.hu>
	<20080101183238.74307174@weinigel.se>
	<20080101184659.GA9250@elte.hu>
	<20080101203518.26e889f2@weinigel.se>
	<20080101210143.GB759@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008 22:01:43 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> > out 80h, al is only two bytes.  Any alternative that has been 
> > suggested in this discussion will use more space.  mov dx,
> > alt_port; out dx, al will be larger, a function call will
> > definitely be a lot larger. People have been making changes to the
> > kernel to save a couple of hundred bytes of text size.
> 
> i've done dozens of patches that saved much less of text size, so
> yes, i very much care about code size. But it has been stated in this
> thread that most of the _p() API uses in the kernel today are bogus.
> So eventually getting rid of the bogus ones will be a net code size 
> _reduction_. (But even that is besides the point, we prefer clean and 
> easier to maintain code.)

And once again, the _p in the code that talks to the PIT is very much
non-bogus.  And it is a critical path that's called a lot.  The i8253
PIT and the i8259 interrupt controller are probably the only ones that
are relevant on a modern machine, and it seems that even some fairly
modern chipsets have limitations on how fast you can drive them.

BTW, I just checked the Intel M8253 data sheet (dead tree variant), and
it says under A.C Characteristics, READ CYCLE:

    Recovery Time Between /READ and Any Other Control Signal: 1 us

So at least for the original M8253 a udelay(1) might be more
appropriate than outb_p, since the delay is not expressed in clock
cycles but absolute time.

The data sheet for the Intel M8259A says:

    End of /RD to Next Command: 300 ns
    End of /WR to Next Command: 370 ns

On the other hand, I don't know how all the i8253/i8259 clones or the
numerous variants of Super I/O chips behave.  It wouldn't surprise me
if some Super I/O chip uses the ISA bus clock to latch the values
internally so that the delay is dependent on the bus frequency instead.

> > I don't know if the difference in code size or the udelay will be 
> > significantly slower, but I think it might be.
> 
> ok, "I dont know but it might be slower" is a perfectly fine
> statement instead of your original "it will be slower".

I didn't say that, I said I'm afraid it will be slower. :-)

  /Christer

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYJ2Py2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYJ2Py2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYJ2PyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:54:19 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:39803 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752823AbYJ2PyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:54:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vx79jQIV3S8xSN71u1znAGlK5okobL3r/xSmLU+GHpexoSVJ3jPXeuprvchNdvpJ85FRI4LtqS1JLbfUoHxkbzRLzOIRhYnc2POz2OtSceLgwKlpBsYqG6OOEFUcxsIjQ/moHEhMfhu1rB64bjz3EU5iaRFXXmNGk4qJyrmrbV0=  ;
X-YMail-OSG: BxXUv9cVM1mTkc4ntngxwvhnx3CEpZauKQdJcfUw0z4Kr08hICpB3UfjEykq80y6sahDJ.BnOlu7TQsBpe0_RWen6m63Huf3xd3M1qT3bWYsDY4IF8THdlNX6Z._XbGln6YZEVUb6_ezMGjvGFV7hjVq
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [patch 2.6.28-rc2] atmel_serial: keep clock off when it's not needed
Date: Wed, 29 Oct 2008 08:54:15 -0700
User-Agent: KMail/1.9.10
Cc: "Andrew Victor" <avictor.za@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Nicolas Ferre" <nicolas.ferre@rfo.atmel.com>
References: <200810271406.24110.david-b@pacbell.net> <200810281251.30031.david-b@pacbell.net> <20081029110845.309a7548@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20081029110845.309a7548@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810290854.15506.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2008, Haavard Skinnemoen wrote:
> David Brownell <david-b@pacbell.net> wrote:
> > On Tuesday 28 October 2008, Andrew Victor wrote:
> > > 
> > > > I verified it on AT91, where the console is normally DBGU and the
> > > > other USARTs do get an open().
> > > 
> > > The DBGU is part of the system peripherals, which are clocked from MCK
> > > and which is always enabled.
> > 
> > Exactly.
> 
> Exactly what?

Exactly the point I was making by describing the testing:
it covered "normal" behavior where the console was clocked
when Linux started.  But not the case you described.


> That your patch has exactly zero effect on your test case? 

Hardly; if that were the case, I wouldn't have posted it!

The other UARTs' clocks again behaved correctly during normal
operation ... acting like they did a few years ago when last I
happened to look at how clocks interacted with this driver.
(Or maybe "with its predecessor".)


> > > Therefore I don't think this is a valid test-case.
> > 
> > Not for the oddball case Haavard mentioned, no:  the console port
> > being something the boot loader wasn't using, which couldn't show
> > the early boot messages (before console setup) in any case.  Those
> > kinds of systems aren't especially debuggable (it's JTAG or nothing).
> 
> Since when is it acceptable to lock up solid in "oddball" cases?

I'm not sure why you're asking *me* that, instead of some
person who said it was OK.  I pointed out that a system
configured like that would have a lot more rude failure
modes than just the one you were pointing out.  Enough to
ensure such configurations wouldn't find much use at all.


> Not to work
> mention that I don't think this is an "oddball" case at all -- the
> bootloader has absolutely _no_ way of influencing the initial enable
> count of the clock, so the kernel will turn it off as soon as it gets
> the chance.

That's a nuance that the platform's clock code needs to handle.

Rule of thumb:  don't turn off "unused" clocks until late in the
system boot sequence ... when drivers for various devices, like
the console, have been fully initialized.  Else you'll turn off
something that was used implicitly during booting:  clocks for
intermediate busses, boot media, console, etc.


> > I don't have any issue with getting that fixed too ... but unless
> > someone has a platform that relies on that case (or can be made to
> > do so, for testing), then it's hard for me to worry about it!
> 
> David, I can't believe you're taking such an easy attitude towards
> basic correctness!

Call it pragmatism.  In a choice between fixing a bug that's been
observed to happen, or not doing so because of an issue that's never
been observed (and won't appear on production systems) ... I'd fix
the bug, and worry about that issue later (if at all).


> I agree that the clock management is already wrong, but keeping a
> couple of clocks enabled when they could have been disabled is far less
> of a problem than locking up the console.

And I asked what systems would actually see such a lockup.  What
system will let me talk to the boot loader on a console, telling
it how to boot, but then lock up when it gets into Linux?


> I also understand if you don't want to fix the console issue I pointed
> out, but I'm surprised that you aren't even willing to acknowledge the
> problem, brushing it off with words like "normally" and "as a rule".

Reread the words of mine that you quoted above; I acknowledged the
issue but can't see it being critical.

- Dave

Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbYEFUHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbYEFUHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbYEFUHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:07:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51076 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215AbYEFUHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:07:17 -0400
Date: Tue, 6 May 2008 17:06:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Alistair John Strachan <alistair@devzero.co.uk>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc1
Message-ID: <20080506170623.53732e78@gaivota>
In-Reply-To: <4820B524.5080100@s5r6.in-berlin.de>
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>
	<20080504160904.GF19717@sgi.com>
	<Pine.LNX.4.64.0805051656180.3218@bombadil.infradead.org>
	<200805060902.25835.alistair@devzero.co.uk>
	<20080506073134.424780a3@gaivota>
	<48206C73.80509@s5r6.in-berlin.de>
	<20080506161346.183f367c@gaivota>
	<4820B524.5080100@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2008 21:44:36 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Mauro Carvalho Chehab wrote:
> > On Tue, 06 May 2008 16:34:27 +0200
> > Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> But it is /trivial/ to fix.  If A selects B, you have to copy all of B's
> >> dependencies to A or select these dependencies by A.
> >>
> >> So it's totally simple to do it right.  The only nuisance is that you
> >> always have to update B's dependencies and selections whenever A's
> >> dependencies are changed.
> > 
> > This is easy to maintain, if you have just a few selects, but this is not the
> > case of V4L drivers. Look some examples:
> > 
> > IVTV driver:
> [...]
> > You may argue to not use select, but it is really hard to avoid, since each of
> > those main drivers (cx88, ivtv, bttv, etc) supports a large number of different
> > devices, that needs different chips. Most V4L/DVB devices has an internal I2C
> > bus that gives the flexibility for the board manufacturers to add/replace the
> > internal components at the i2c bus. So, the Kernel uses abstraction layers that
> > allows that the same driver to use different internal components.
> 
> Shouldn't layers actually untangle dependencies, i.e. concentrate 
> dependencies?  A "high-level driver" does not depend on "low-level 
> drivers" and the low-level drivers' dependencies anymore.  It only 
> depends on a "core driver" and on foreign subsystem APIs.

> And yes, the core driver may very well provide some functionality which 
> not all of the high-level drivers need, or not all of the low-level 
> drivers are able to support.
> 
> (All theoretical since I have no idea of what kinds of modules of 
> functionality you have/need and whether it really can be simpler organized.)

This is the way it is designed.

For example, if you have a em28xx device with msp3400 and tvp5150 and another
em28xx device with saa7113.

If you remove the select's for MSP3400, TVP5150 and SAA7113, at, em28xx, the
module will compile without problems.

The only issue is that you won't be able to see any images (due to the lack of
tvp5150 or saa7113 analog TV demoduler) or listen to the audio, if the device
needs msp3400 to decode audio.

So, you'll just spend kernelspace for a completely useless driver ;)

Ok, let's consider a scenario where there are 3 options, for each of the above.

Now, the user will need to open the USB stick, without breaking anything,
to identify what chips it have inside the internal i2c bus, before compiling the kernel.

Also, since V4L/DVB has more than 230 drivers (most of them are those I2C
helper drivers), the number of items for the user to understand and select will
be huge.

It is much better for the user to just select EM28XX and let the Kconfig do the
hard work of selecting what low-level driver applies for em28xx-based devices.

This causes lots of select, being very hard to maintain. The better would be to
have a select-like clause that could check the dependencies automatically.

Another alternative would be some sort of script (checkpatch.pl?) that would
check if all selected dependencies are ok.

Cheers,
Mauro

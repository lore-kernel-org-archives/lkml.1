Return-Path: <linux-kernel-owner+w=401wt.eu-S932887AbZFLWEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887AbZFLWEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757255AbZFLWEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:04:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53525 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbZFLWEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:04:46 -0400
Date: Sat, 13 Jun 2009 00:04:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090612220439.GD17688@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz> <20090610194852.GA28787@n2100.arm.linux.org.uk> <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com> <20090610213710.GA8472@elf.ucw.cz> <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com> <20090611082532.GE8592@elf.ucw.cz> <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com> <20090612150504.GA15084@elf.ucw.cz> <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > Well, it is still a driver for your baseband chip, right?
> >>
> >> Yes -- what I meant is more "does it belong under arch/arm/mach-msm/"
> >> (given that it's very specific to that architecture and unlikely to
> >> ever be useful elsewhere) or "does it belong somewhere else" (because
> >> it's a pretty big pile of code compared to other stuff like
> >> gpio/interrupt/etc stuff that tends to live under arch/arm/mach-*/).
> >
> > If it is driver for baseband, then it could live outside mach-msm,
> > right?
> 
> Some of the higher level bits, probably.  The lower level bits are
> essential for operation.  These are SoCs with integrated baseband and
> the baseband is the "master" (boots first, owns key resources like
> clocks/vregs, etc).

Uch, ouch. hw3d.c is certainly not required for boot. htc_* probably
can live elsewhere.

Actually, htc_acoustic... that's some kind of microphone mixer. That
should reside in sound/ and use normal ALSA interface...? 

> >> Interesting -- reading up more on staging now.  I know that Greg KH
> >> has been pulling some of the "generic" android drivers into staging
> >> (Thanks, Greg!), but hadn't really looked at the rationale behind
> >> staging in general.
> >
> > staging is for GPLed code that needs to be cleaned up, first. Horrible
> > stuff like drivers for windows in windows coding style go there.
> 
> Ahhh.  Our stuff hopefully is not quite that ugly.

Some qdsp5 stuff is example of similar code, but your stuff is
actually quite okay. Its just... there's quite a lot of it.

I was not trying to say that your code is horrible. I was trying to
point out that drivers/staging accepts even horrible code, and that it
is "submit first, checkpatch next".

> >> Sounds like packing up the serial, sdio, nand, framebuffer, etc
> >> drivers for submission into staging might make sense.  We can do the
> >> obvious stuff like make sure they're checkpatch clean and reasonably
> >> tidy first.
> >
> > Actually, I believe it would be better to submit them first and
> > checkpatch later. I quickly went through the patches (122KLoC)... and
> > most are pretty much okay, but some have issues bigger than coding
> > style (like wrong userland interfaces).
> 
> We've been trying to stay as style clean as possible, though not
> everything's perfect.  What are some of the specific userland
> interfaces you're worried about?

timed_output is "interesting", but probably acceptable. openmoko uses
/sys/class/leds/gta01\:vibrator/brightness for vibrator control; that
has advantage of having access to trigger infrastructure.

lcd-backlight should be in /sys/class/backlight, not /sys/class/leds.

class/switch is "interesting". I'd expect keyboard open/closed, but
instead do sd door. Why is mass storage there?

> > What is htc_pwrsink infrastructure? Some kind of power accounting
> > infrastructure for better battery estimates?
> 
> Yup.  It's an HTC specific thing -- some of their devices don't have a
> battery gauge IC and estimate current drain based on hints provided to
> the baseband from the apps processor.  I'm not particularly thrilled
> with the interface, but without it the battery level estimation is
> flakier.

Thanks!

> > I see stuff like jpeg and mp3 coprocessors. That's oncrpc?
> 
> That's done by one of the DSPs (the other one is dedicated to the
> baseband for network stuff).  oncrpc is used to talk to some
> management services on the baseband to request dsp module loading,
> setup audio hardware, etc.  a direct shared memory mailbox interface
> is used to communicate withe the DSP once things are up and going.
> The qdsp5 code deals with this.

Ok. It would be nice to provide description how the system looks like
somewhere in the docs.

> >> > Is it all neccessary for boot? Getting it booting with display should
> >> > be the first goal... GPS/RTC/... can come later.
> >>
> >> The lowest layer IPC (proc_comm) is used for clock/power control and
> >> is already in mainline, and that gets the clk_* framework functional
> >> and allows most of the peripheral drivers to work, thankfully.  Things
> >> like the serial driver, framebuffer, sdio, nand controller, etc all
> >> should be happy without additional core architecture support.
> >
> > Good, with framebuffer+nand we have "usable" machine, right?
> 
> That should get you something that can boot to a fb console from
> onboard flash.  The serial driver for debugging and sdio for more
> storage (if you want to fire up debian or something) would probably be
> nice to have.

Ok, plus a keyboard would be cool :-). Fortunately, those are the
components that seem to be reasonably simple.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

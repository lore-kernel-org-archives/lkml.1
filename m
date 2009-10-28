Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbZJ1KDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbZJ1KDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 06:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbZJ1KDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 06:03:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbZJ1KDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 06:03:08 -0400
Date: Wed, 28 Oct 2009 11:03:18 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH][RFC] input: remove bios I8042_CTR_XLATE check to make
	keyboard usable
Message-ID: <20091028100318.GA4861@suse.cz>
References: <20091027053404.GA2241@darkstar.vlan7> <20091028054309.GA2368@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028054309.GA2368@core.coreip.homeip.net>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 10:43:10PM -0700, Dmitry Torokhov wrote:
> Hi Dave,
> 
> On Tue, Oct 27, 2009 at 01:34:04PM +0800, Dave Young wrote:
> > 
> > Pressing somekey at early booting phase cause keyboard to be not usable
> > (The hardware is DELL latitude e5400):

Does early booting mean while the BIOS is coming up? Does the keyboard
work in GRUB then? Or is it during the early init of the Linux kernel?
 
> > atkbd.c: Unknown key pressed (raw set 2, code 0xd3 on isa0060/serio0).
> > atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.
> > atkbd.c: Unknown key pressed (raw set 2, code 0x1d3 on isa0060/serio0).
> > atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.
> > 
> > i8042.c set i8042_direct to true when the controller init. But the result
> > is keyboard not usable, The only option is press the power button to shutdown. 
> > 
> > So here remove the bios check to fix it.

My question would be: Why this happens? Could it be that the probe is
confused by the keypress and reads the CTR incorrectly? Or is it just
that the keyboard controller is in fact in translating mode, yet the CTR
indicates otherwise?

A i8042.debug=1 log of the bad init would be good.

> I would be a little hesitant to force translation by default on all
> architectures, although it may make sense on x86...

The old 2.4 kernel sources say that there are some IBM PowerPC portables
that don't support translation at all. I wouldn't be surprised if there
were more examples like that in the embedded space.

I'm not aware of any x86 machine that wouldn't support the translated
mode.

> Vojtech, you wrote the thing, do you see any issues with forcing
> translation? I think most of the x86 boxes work in translated mode and
> the only time it is in raw is when BIOS screwed up initialization.
> 
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > ---
> >  drivers/input/serio/i8042.c |    8 --------
> >  1 file changed, 8 deletions(-)
> > 
> > --- linux-2.6.orig/drivers/input/serio/i8042.c	2009-10-13 08:57:07.000000000 +0800
> > +++ linux-2.6/drivers/input/serio/i8042.c	2009-10-27 13:15:13.000000000 +0800
> > @@ -869,14 +869,6 @@ static int i8042_controller_init(void)
> >  	spin_unlock_irqrestore(&i8042_lock, flags);
> >  
> >  /*
> > - * If the chip is configured into nontranslated mode by the BIOS, don't
> > - * bother enabling translating and be happy.
> > - */
> > -
> > -	if (~i8042_ctr & I8042_CTR_XLATE)
> > -		i8042_direct = true;
> > -
> > -/*
> >   * Set nontranslated mode for the kbd interface if requested by an option.
> >   * After this the kbd interface becomes a simple serial in/out, like the aux
> >   * interface is. We don't do this by default, since it can confuse notebook

-- 
Vojtech Pavlik
Director SuSE Labs

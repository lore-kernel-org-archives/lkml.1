Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbZBMM2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbZBMM2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZBMM2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:28:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59640 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbZBMM2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:28:31 -0500
Date: Fri, 13 Feb 2009 13:28:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: ?ric Piel <eric.piel@tremplin-utc.net>
Cc: akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       trenn@suse.de, vbotka@suse.cz, jikos@suse.cz
Subject: Re: hp accelerometer: add freefall detection
Message-ID: <20090213122828.GA25941@atrey.karlin.mff.cuni.cz>
References: <200901162234.n0GMYB8Z022317@imap1.linux-foundation.org> <4992C57E.9050109@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4992C57E.9050109@tremplin-utc.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pavel Machek <pavel@suse.cz>
> > 
> > This adds freefall handling to hp_accel driver.  According to HP, it
> > should just work, without us having to set the chip up by hand.
> > 
> > hpfall.c is example .c program that parks the disk when accelerometer
> > detects free fall.  It should work; for now, it uses fixed 20seconds
> > protection period.
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > Cc: Thomas Renninger <trenn@suse.de>
> > Cc: ???ric Piel <eric.piel@tremplin-utc.net>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Hi Pavel,
> Sorry for being amazingly late, reading the latest patches from
> Giuseppe, I noticed some parts in this patch which are strange.
> Basically you scrap all the init and all the poweroff. Some of the
> things there were put for some purpose, and I wonder if you've verified
> everything keeps working correctly.

Yes; HP tells me I do not need to touch the hardware, and in my tests
touching the hardware actually broke the stuff. Yes, position and
freefall detection still worked without manually touching the hw.

Unfortunately, I don't have the hardware any more...

> > @@ -110,26 +114,13 @@ static void lis3lv02d_get_xyz(acpi_handl
> >  void lis3lv02d_poweroff(acpi_handle handle)
> >  {
> >  	adev.is_on = 0;
> > -	/* disable X,Y,Z axis and power down */
> > -	adev.write(handle, CTRL_REG1, 0x00);
> So we are not turning off the device on poweroff()?! Why? Did you notice
> problems when we were doing it?

Well, HP told me not to touch the hardware, so I'm not touching it.

> Actually I've always wondered if it was worthy to turn it off because
> I've never been able to measure a difference in power consumption. Have
> you done the measurement and noticed there is no effect? I'd be glad we
> can get rid of this power management thing, but then we can scratch much
> more than just this line!

Well,  if you can't measure the difference, it is probably not worth
doing ... for HP notebooks anyway.

> > -	/*
> > -	 * BDU: LSB and MSB values are not updated until both have been read.
> > -	 *      So the value read will always be correct.
> > -	 * IEN: Interrupt for free-fall and DD, not for data-ready.
> > -	 */
> > -	adev.read(handle, CTRL_REG2, &val);
> > -	val |= CTRL2_BDU | CTRL2_IEN;
> > -	adev.write(handle, CTRL_REG2, val);
> This part is rather scary. Did you read the comment? If you don't
> activate BDU you cannot be sure that the data you read is valid. I see
> no reason why this would interfere with the free-fall detection so
> unless you have a really good case, let's keep it. On the other hand, I
> don't mind removing IEN if you've noticed that it's not useful or
> interfering.

Well, I just removed all the writes at once and notice it
helped... And HP tells me I don't need to touch the hardware...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

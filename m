Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbYDOA3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbYDOA3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 20:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbYDOA3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 20:29:12 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:46217 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753686AbYDOA3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 20:29:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=oL0hmUeAS9HrTpBbqZupId44962Fc0kaYrM0hlQeZzxJS2a1lEsVUxXU1o57RIyziUJu3SEIjgdH/fzzvJoOnExe5bL+Hr7Xg9HUEkFe6vh85qIB+69fcboZ2MP4r1LxlYnb4m1fleXmfY7QRnCGWYsX+QGvuvmfEYQ3Lq+0UFI=  ;
X-YMail-OSG: _syhcocVM1kG7kueTxeJN_hS_v4wq9zIa9V75HBByuVVgWE3
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 3/3] wm97xx-core: Support use as a wakeup source
Date: Mon, 14 Apr 2008 17:29:07 -0700
User-Agent: KMail/1.9.6
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080414173841.GA2213@rakim.wolfsonmicro.main> <1208194775-4293-3-git-send-email-broonie@opensource.wolfsonmicro.com> <20080414163033.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080414163033.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200804141729.08036.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008, Dmitry Torokhov wrote:
> Hi Mark,
> 
> On Mon, Apr 14, 2008 at 06:39:35PM +0100, Mark Brown wrote:
> > The PENDOWN signal from the WM97xx touch screen controllers can be used
> > to generate a wakeup event when the system is suspended. Provide a new
> > machine configuration option 'suspend_mode' allowing machine drivers to
> > enable this. If no suspend_mode is provided then the touch panel will be
> > powered down when the system is suspended.
> > 
> 
> Hmm, another unique module option... How about using device_can_wakeup()
> infrastructure that we already have. I'm adding David Brownell to CC since
> I believe he's doing a lot of similar work.

I don't quite follow the technical content of this "suspend_mode"
mask, but it sure looks as if it should use the driver model flags
in addition to whatever that mask is doing.

There are two aspects to this:

 (a) Whether on a given system the touchscreen *can* issue wakeup
     events ... call device_init_wakeup(dev, true) to say it can.
     In this case, presumably suspend_mode == 0 means it can't.
     Board setup, or at latest probe(), should device_init_wakeup().

 (b) Whether it *should* do so ... e.g. the Nokia N810 has a mode
     where it doesn't, and usually when you're carrying one around
     in a pocket (or purse, or whatever) you would say "doesn't".
     Userspace manages that answer via a sysfs file, and drivers
     test the answer with device_may_wakeup(dev).

So:  yes, this should initialize and use those driver model flags.


> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > ---
> >  drivers/input/touchscreen/wm97xx-core.c |   22 ++++++++++++++++++++++
> >  include/linux/wm97xx.h                  |    3 +++
> >  2 files changed, 25 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
> > index fec07c2..e1a1ca0 100644
> > --- a/drivers/input/touchscreen/wm97xx-core.c
> > +++ b/drivers/input/touchscreen/wm97xx-core.c
> > @@ -689,10 +689,32 @@ static int wm97xx_remove(struct device *dev)
> >  static int wm97xx_suspend(struct device *dev, pm_message_t state)
> >  {
> >  	struct wm97xx *wm = dev_get_drvdata(dev);
> > +	u16 reg;
> > +	int suspend_mode;
> > +
> > +	if (wm->mach_ops)
> > +		suspend_mode = wm->mach_ops->suspend_mode;
> > +	else
> > +		suspend_mode = 0;
> >  
> >  	if (wm->input_dev->users)
> >  		cancel_delayed_work_sync(&wm->ts_reader);
> >  
> > +	/* Power down the digitiser (bypassing the cache for resume) */
> > +	reg = wm97xx_reg_read(wm, AC97_WM97XX_DIGITISER2);
> > +	reg &= ~WM97XX_PRP_DET_DIG;
> > +	if (wm->input_dev->users && suspend_mode)

This should probably check device_may_wakeup(SOMEDEV), rather
than testing suspend_mode.

The wakeup mechanism here isn't clear to me.  Does this assume
that the touchscreen IRQ is wakeup-capable?  I don't see any
calls to enable_irq_wake() or disable_irq_wake() ... or for that
matter any other calls that might affect system behavior.


> > +		reg |= suspend_mode;
> > +	wm->ac97->bus->ops->write(wm->ac97, AC97_WM97XX_DIGITISER2, reg);
> > +
> > +	/* WM9713 has an additional power bit - turn it off if there
> > +	 * are no users or if suspend mode is zero. */
> > +	if (wm->id == WM9713_ID2 &&
> > +	    (!wm->input_dev->users || !suspend_mode)) {
> > +		reg = wm97xx_reg_read(wm, AC97_EXTENDED_MID) | 0x8000;
> > +		wm97xx_reg_write(wm, AC97_EXTENDED_MID, reg);
> > +	}
> > +
> >  	return 0;
> >  }
> >  
> > diff --git a/include/linux/wm97xx.h b/include/linux/wm97xx.h
> > index ed01c7d..2082833 100644
> > --- a/include/linux/wm97xx.h
> > +++ b/include/linux/wm97xx.h
> > @@ -258,6 +258,9 @@ struct wm97xx_mach_ops {
> >  	/* pre and post sample - can be used to minimise any analog noise */
> >  	void (*pre_sample) (int);  /* function to run before sampling */
> >  	void (*post_sample) (int);  /* function to run after sampling */
> > +
> > +	/* WM97XX_PRP value to configure while system is suspended */
> > +	u16 suspend_mode;

I'm more accustomed to thinking that the driver will
know "the" setup bit values to assign which will
ensure that the chip issues wakeup events ... that
stuff is usually not board-specific.


> >  };
> >  
> >  struct wm97xx {
> > -- 
> > 1.5.5
> > 
> 
> -- 
> Dmitry
> 



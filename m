Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbZGNJql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbZGNJql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZGNJqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:46:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38670 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbZGNJqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:46:40 -0400
Date: Tue, 14 Jul 2009 11:46:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC: touchscreen driver
Message-ID: <20090714094629.GB2076@elf.ucw.cz>
References: <20090710084323.GA6522@elf.ucw.cz> <a55d774e0907100155m25366994pe9ec5d0f5f868818@mail.gmail.com> <20090710103243.GB7789@elf.ucw.cz> <a55d774e0907100431j3fdc4671i6b185019594367fa@mail.gmail.com> <20090713202302.GC2569@elf.ucw.cz> <20090713205749.GE2569@elf.ucw.cz> <20090713220726.GA28375@elf.ucw.cz> <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >        if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> >                printk(KERN_ERR "synaptics_ts_probe: need I2C_FUNC_I2C\n");
> > @@ -269,6 +354,9 @@ static int synaptics_ts_probe(
> >        pdata = client->dev.platform_data;
> >        if (pdata)
> >                ts->power = pdata->power;
> > +       else
> > +               pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> > +
> 
> Where do you free this?

Well, nowhere; but it should not actually matter. ... btw can this
path (!pdata) actually trigger? The driver will not be working,
anyway, in that case..

> > -       if (ts->use_irq)
> > -               enable_irq(client->irq);
> > -
> > -       if (!ts->use_irq)
> > -               hrtimer_start(&ts->timer, ktime_set(1, 0), HRTIMER_MODE_REL);
> > -       else
> > -               i2c_smbus_write_byte_data(ts->client, 0xf1, 0x01); /* enable abs int */
> > -
> > -       return 0;
> > -}
> 
> Why did you remove suspend and resume?

I thought it depended on earlysuspend.


> >  static const struct i2c_device_id synaptics_ts_id[] = {
> >        { SYNAPTICS_I2C_RMI_NAME, 0 },
> > @@ -600,10 +515,6 @@ static const struct i2c_device_id synaptics_ts_id[] = {
> >  static struct i2c_driver synaptics_ts_driver = {
> >        .probe          = synaptics_ts_probe,
> >        .remove         = synaptics_ts_remove,
> > -#ifndef CONFIG_HAS_EARLYSUSPEND
> > -       .suspend        = synaptics_ts_suspend,
> > -       .resume         = synaptics_ts_resume,
> > -#endif
> 
> Remove #ifndef only, not the content.

Aha, I see; yes, my fault.

> > +       u32 flags;
> > +       u32 inactive_left; /* 0x10000 = screen width */
> > +       u32 inactive_right; /* 0x10000 = screen width */
> > +       u32 inactive_top; /* 0x10000 = screen height */
> > +       u32 inactive_bottom; /* 0x10000 = screen height */
> > +       u32 snap_left_on; /* 0x10000 = screen width */
> > +       u32 snap_left_off; /* 0x10000 = screen width */
> > +       u32 snap_right_on; /* 0x10000 = screen width */
> > +       u32 snap_right_off; /* 0x10000 = screen width */
> > +       u32 snap_top_on; /* 0x10000 = screen height */
> > +       u32 snap_top_off; /* 0x10000 = screen height */
> > +       u32 snap_bottom_on; /* 0x10000 = screen height */
> > +       u32 snap_bottom_off; /* 0x10000 = screen height */
> > +       u32 fuzz_x; /* 0x10000 = screen width */
> > +       u32 fuzz_y; /* 0x10000 = screen height */
> 
> I prefer the existing C99 types.

Yes, well, the rest of kernel disagrees with you.

> This driver only supports a subset of Synaptics' devices so a more
> generic driver will eventually be needed. The patch below adds support
> for a more recent but similar panel.

Ok, that should be simple enough to apply, but lets do improvements
when we cleaned the code enough for the mainline...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

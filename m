Return-Path: <linux-kernel-owner+w=401wt.eu-S1759842AbYA1JMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbYA1JMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759490AbYA1JMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:12:15 -0500
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:56743 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759381AbYA1JMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:12:12 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2008 04:12:12 EST
Date: Mon, 28 Jan 2008 01:05:30 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Adrian Bunk <bunk@kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Hans Verkuil <hverkuil@xs4all.nl>, v4l-dvb-maintainer@linuxtv.org,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] 2.6.25 regression: VIDEO_DEV=y/m,	I2C=n
 compile error
In-Reply-To: <20080128084001.GB1001@does.not.exist>
Message-ID: <Pine.LNX.4.58.0801280053010.15635@shell4.speakeasy.net>
References: <20080127185216.GB13300@does.not.exist> <20080127223334.696fce6e@gaivota>
 <20080128084001.GB1001@does.not.exist>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008, Adrian Bunk wrote:
> On Sun, Jan 27, 2008 at 10:33:34PM -0200, Mauro Carvalho Chehab wrote:
> > On Sun, 27 Jan 2008 20:52:16 +0200
> > Adrian Bunk <bunk@kernel.org> wrote:
> >
> > > Commit 8ffbc6559493c64d6194c92d856196fdaeb8a5fb causes the following
> > > compile error with CONFIG_VIDEO_DEV=y/m, CONFIG_I2C=n:
> > >
> > > ERROR: "i2c_attach_client" [drivers/media/video/v4l2-common.ko] undefined!

> > Thanks for getting this regression. Please test the enclosed patch.
>
> It doesn't enable the code if CONFIG_VIDEO_DEV=m, CONFIG_I2C=m.
>
> And what should happen if CONFIG_VIDEO_DEV=y, CONFIG_I2C=m?
>
> If the latter should offer this code to modules we'll have to put it
> into an own module.

Adrian beat me to it, but I was going to point out the same thing.  Also
only the function v4l2_i2c_attach() is a problem.  The other functions,
like v4l2_chip_match_i2c_client(), which the patch put inside an #ifdef
don't use any i2c symbols and don't need to be protected.
v4l2_chip_match_host() could even easily be used by a driver that doesn't
need I2C.

Maybe the kernel headers should provide a couple macros for testing
configs, since people get it wrong over and over again?

#define CONFIG_ON(x) (defined(CONFIG_##x) || defined(CONFIG_##x##_MODULE))
#define CONFIG_AVAIABLE(x) (defined(CONFIG_##x) || (defined(MODULE) && defined(CONFIG_##x##_MODULE)))

Would save typing too.

Not sure what to do about VIDEO_DEV=y, I2C=m.  It should be possible except
for this function.

> > diff -r b0815101889d linux/drivers/media/video/v4l2-common.c
> > --- a/linux/drivers/media/video/v4l2-common.c	Sun Jan 27 20:39:00 2008
> > -0200 +++ b/linux/drivers/media/video/v4l2-common.c	Sun Jan 27 22:23:25
> > 2008 -0200 @@ -1585,6 +1585,7 @@ u32 v4l2_ctrl_next(const u32 * const * c
> >  	return **ctrl_classes;
> >  }
> >
> > +#ifdef CONFIG_I2C
> >  int v4l2_chip_match_i2c_client(struct i2c_client *c, u32 match_type, u32
> > match_chip) {
> >  	switch (match_type) {
> > @@ -1596,6 +1597,7 @@ int v4l2_chip_match_i2c_client(struct i2
> >  		return 0;
> >  	}
> >  }
> > +EXPORT_SYMBOL(v4l2_chip_match_i2c_client);
> >
> >  int v4l2_chip_ident_i2c_client(struct i2c_client *c, struct v4l2_chip_ident
> > *chip, u32 ident, u32 revision)
> > @@ -1612,6 +1614,7 @@ int v4l2_chip_ident_i2c_client(struct i2
> >  	}
> >  	return 0;
> >  }
> > +EXPORT_SYMBOL(v4l2_chip_ident_i2c_client);
> >
> >  int v4l2_chip_match_host(u32 match_type, u32 match_chip)
> >  {
> > @@ -1622,6 +1625,7 @@ int v4l2_chip_match_host(u32 match_type,
> >  		return 0;
> >  	}
> >  }
> > +EXPORT_SYMBOL(v4l2_chip_match_host);
> >
> >  /* ----------------------------------------------------------------- */
> >
> > @@ -1656,6 +1660,8 @@ int v4l2_i2c_attach(struct i2c_adapter *
> >  	}
> >  	return err != -ENOMEM ? 0 : err;
> >  }
> > +EXPORT_SYMBOL(v4l2_i2c_attach);
> > +#endif

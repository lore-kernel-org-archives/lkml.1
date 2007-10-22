Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbXJVFaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbXJVFaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 01:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbXJVF3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 01:29:53 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:59415 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbXJVF3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 01:29:52 -0400
Date: Sun, 21 Oct 2007 22:29:51 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Michael Krufky <mkrufky@linuxtv.org>
cc: Adrian Bunk <bunk@kernel.org>, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] fix CONFIG_TUNER_TEA5761=m
In-Reply-To: <471C19F1.8090505@linuxtv.org>
Message-ID: <Pine.LNX.4.58.0710212201060.16052@shell4.speakeasy.net>
References: <20071022024755.GJ30533@stusta.de> <471C19F1.8090505@linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007, Michael Krufky wrote:
> Adrian Bunk wrote:
> > This patch fixes CONFIG_TUNER_TEA5761=m broken by
> > commit ca805d57cf5ea7482ed3da28653f30621249ee45.
> >
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >
> > ---
> >
> >  drivers/media/video/tuner-core.c |    6 ------
> >  1 file changed, 6 deletions(-)
> >
> > 26336c30e76c37bda368a24b8b12978388a18cf3
> > diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
> > index 9484308..1795b78 100644
> > --- a/drivers/media/video/tuner-core.c
> > +++ b/drivers/media/video/tuner-core.c
> > @@ -30,9 +30,7 @@
> >
> >  /* standard i2c insmod options */
> >  static unsigned short normal_i2c[] = {
> > -#ifdef CONFIG_TUNER_TEA5761
> >  	0x10,
> > -#endif
> >
> ^^^ I believe that we want to keep these #ifdef's above...  The removals
> below are fine.

Won't leaving in the call to tea5761_autodetection() when tea5761 is not
compiled in result in an undefined symbol error?

I think what we want to do put in the typical if(TEA5761 >= TUNER) include tea5761
code in tuner logic that the rest of the selectable sub-driver use.

#if defined(CONFIG_TUNER_TEA5761) || (defined(CONFIG_TUNER_TEA5761_MODULE) && defined(MODULE))

Of course compiling TEA5761 lower than TUNER doesn't make any sense now
since the only thing that uses tea5761 is the tuner.  But it's still
possible, you just end up with a tuner that doesn't support tea5761 and a
tea5761 module that isn't needed by anything.

>
>
> >  	0x42, 0x43, 0x4a, 0x4b,			/* tda8290 */
> >  	0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67,
> >  	0x68, 0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e, 0x6f,
> > @@ -292,7 +290,6 @@ static void set_type(struct i2c_client *c, unsigned int type,
> >  		}
> >  		t->mode_mask = T_RADIO;
> >  		break;
> > -#ifdef CONFIG_TUNER_TEA5761
> >  	case TUNER_TEA5761:
> >  		if (tea5761_attach(&t->fe, t->i2c.adapter, t->i2c.addr) == NULL) {
> >  			t->type = TUNER_ABSENT;
> > @@ -301,7 +298,6 @@ static void set_type(struct i2c_client *c, unsigned int type,
> >  		}
> >  		t->mode_mask = T_RADIO;
> >  		break;
> > -#endif
> >  	case TUNER_PHILIPS_FMD1216ME_MK3:
> >  		buffer[0] = 0x0b;
> >  		buffer[1] = 0xdc;
> > @@ -594,7 +590,6 @@ static int tuner_attach(struct i2c_adapter *adap, int addr, int kind)
> >  	/* autodetection code based on the i2c addr */
> >  	if (!no_autodetect) {
> >  		switch (addr) {
> > -#ifdef CONFIG_TUNER_TEA5761
> >  		case 0x10:
> >  			if (tea5761_autodetection(t->i2c.adapter, t->i2c.addr) != EINVAL) {
> >  				t->type = TUNER_TEA5761;
> > @@ -606,7 +601,6 @@ static int tuner_attach(struct i2c_adapter *adap, int addr, int kind)
> >  				goto register_client;
> >  			}
> >  			break;
> > -#endif
> >  		case 0x42:
> >  		case 0x43:
> >  		case 0x4a:
> >
> >
> Regards,
>
> Mike Krufky
>
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer
>

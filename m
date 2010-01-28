Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988Ab0A1HlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab0A1HlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 02:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882Ab0A1HlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 02:41:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53902 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab0A1HlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 02:41:06 -0500
Date: Thu, 28 Jan 2010 08:41:01 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
       trivial@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] imxfb: correct location of callbacks in suspend and
	resume
Message-ID: <20100128074101.GA13756@pengutronix.de>
References: <1263226881-28008-1-git-send-email-u.kleine-koenig@pengutronix.de> <1264433854-878-1-git-send-email-u.kleine-koenig@pengutronix.de> <20100127154818.de91e255.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100127154818.de91e255.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 27, 2010 at 03:48:18PM -0800, Andrew Morton wrote:
> On Mon, 25 Jan 2010 16:37:34 +0100
> Uwe Kleine-K__nig  <u.kleine-koenig@pengutronix.de> wrote:
> 
> > The probe function passes a pointer to a struct fb_info to
> > platform_set_drvdata, so don't interpret the return value of
> > platform_get_drvdata as a pointer to struct imxfb_info.
> > 
> > Signed-off-by: Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de>
> > Acked-by: Sascha Hauer <kernel@pengutronix.de>
> > Cc: linux-arm-kernel@lists.infradead.org
> > ---
> >  drivers/video/imxfb.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
> > index 66358fa..b4b6dec 100644
> > --- a/drivers/video/imxfb.c
> > +++ b/drivers/video/imxfb.c
> > @@ -593,7 +593,8 @@ static int imxfb_activate_var(struct fb_var_screeninfo *var, struct fb_info *inf
> >   */
> >  static int imxfb_suspend(struct platform_device *dev, pm_message_t state)
> >  {
> > -	struct imxfb_info *fbi = platform_get_drvdata(dev);
> > +	struct fb_info *info = platform_get_drvdata(dev);
> > +	struct imxfb_info *fbi = info->par;
> >  
> >  	pr_debug("%s\n", __func__);
> >  
> > @@ -603,7 +604,8 @@ static int imxfb_suspend(struct platform_device *dev, pm_message_t state)
> >  
> >  static int imxfb_resume(struct platform_device *dev)
> >  {
> > -	struct imxfb_info *fbi = platform_get_drvdata(dev);
> > +	struct fb_info *info = platform_get_drvdata(dev);
> > +	struct imxfb_info *fbi = info->par;
> >  
> >  	pr_debug("%s\n", __func__);
> >  
> 
> What were the runtime effects of this bug?
For me it was that in the original imxfb_info *fbi backlight_power was
NULL but in imxfb_suspend it was 4 resulting in an oops as imxfb_suspend
calls imxfb_disable_controller(fbi) which in turn has

	if (fbi->backlight_power)
		fbi->backlight_power(0);

.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |

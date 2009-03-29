Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZC2SQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZC2SQg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 14:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZC2SQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 14:16:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34052 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbZC2SQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 14:16:25 -0400
Date: Sun, 29 Mar 2009 20:15:28 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       "George G. Davis" <gdavis@mvista.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 35/58] move omap_wdt's probe function to .devinit.text
Message-ID: <20090329181528.GA25077@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de> <1238196439-16535-35-git-send-email-u.kleine-koenig@pengutronix.de> <20090329180912.GA6979@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090329180912.GA6979@infomag.iguana.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

On Sun, Mar 29, 2009 at 08:09:12PM +0200, Wim Van Sebroeck wrote:
> Hi Uwe,
> 
> > A pointer to omap_wdt_probe is passed to the core via
> > platform_driver_register and so the function must not disappear when the
> > .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> > unbinding and binding a device to the driver via sysfs will result in an
> > oops as does a device being registered late.
> > 
> > An alternative to this patch is using platform_driver_probe instead of
> > platform_driver_register plus removing the pointer to the probe function
> > from the struct platform_driver.
> 
> Agree with the explanation, but ...
> 
> > diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
> > index 2f2ce74..c9c14dd 100644
> > --- a/drivers/watchdog/omap_wdt.c
> > +++ b/drivers/watchdog/omap_wdt.c
> > @@ -269,7 +269,7 @@ static const struct file_operations omap_wdt_fops = {
> >  	.release = omap_wdt_release,
> >  };
> >  
> > -static int __init omap_wdt_probe(struct platform_device *pdev)
> > +static int __devinit omap_wdt_probe(struct platform_device *pdev)
> >  {
> >  	struct resource *res, *mem;
> >  	struct omap_wdt_dev *wdev;
> 
> ...imho this would be the correct fix:
> 
> diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
> index aa5ad6e..f271385 100644
> --- a/drivers/watchdog/omap_wdt.c
> +++ b/drivers/watchdog/omap_wdt.c
> @@ -258,7 +258,7 @@ static const struct file_operations omap_wdt_fops = {
>  	.release = omap_wdt_release,
>  };
>  
> -static int __init omap_wdt_probe(struct platform_device *pdev)
> +static int __devinit omap_wdt_probe(struct platform_device *pdev)
>  {
>  	struct resource *res, *mem;
>  	struct omap_wdt_dev *wdev;
> @@ -367,7 +367,7 @@ static void omap_wdt_shutdown(struct platform_device *pdev)
>  		omap_wdt_disable(wdev);
>  }
>  
> -static int omap_wdt_remove(struct platform_device *pdev)
> +static int __devexit omap_wdt_remove(struct platform_device *pdev)
>  {
>  	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
>  	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -426,7 +426,7 @@ static int omap_wdt_resume(struct platform_device *pdev)
>  
>  static struct platform_driver omap_wdt_driver = {
>  	.probe		= omap_wdt_probe,
> -	.remove		= omap_wdt_remove,
> +	.remove		= __devexit_p(omap_wdt_remove),
>  	.shutdown	= omap_wdt_shutdown,
>  	.suspend	= omap_wdt_suspend,
>  	.resume		= omap_wdt_resume,
Your change is OK, but only "my" part is an important fix.  With
omap_wdt_probe being defined with __init your kernel can oops.
omap_wdt_remove only occupies memory for too long if defined without
__devexit.  That's why I only fixed the first part (with the remove
functions on my todo list though).

Grüßle
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |

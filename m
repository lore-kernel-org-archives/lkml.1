Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbYKCTfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbYKCTfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 14:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYKCTe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 14:34:57 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:8377 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750859AbYKCTe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 14:34:57 -0500
Date: Mon, 3 Nov 2008 22:34:55 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru,
       Andrew Morton <akpm@linux-foundation.org>,
       Marek Vasut <marek.vasut@gmail.com>,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>
Subject: Re: [PATCH] power_supply: change the way how wm97xx-bat driver is
	registered
Message-ID: <20081103193455.GA17958@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com> <1225271050-21171-2-git-send-email-dbaryshkov@gmail.com> <20081103151151.GB23466@oksana.dev.rtsoft.ru> <20081103182955.GA17171@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081103182955.GA17171@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 09:29:55PM +0300, Dmitry Baryshkov wrote:
> On Mon, Nov 03, 2008 at 06:11:51PM +0300, Anton Vorontsov wrote:
> > On Wed, Oct 29, 2008 at 12:04:10PM +0300, Dmitry Baryshkov wrote:
> > >  #ifdef CONFIG_BATTERY_WM97XX
> > > -void __init wm97xx_bat_set_pdata(struct wm97xx_batt_info *data);
> > > +int wm97xx_bat_set_pdata(struct wm97xx_batt_info *data);
> > >  #else
> > > -static inline void wm97xx_bat_set_pdata(struct wm97xx_batt_info *data) {}
> > > +static inline int wm97xx_bat_set_pdata(struct wm97xx_batt_info *data)
> > > +{
> > > +	return -ENODEV;
> > > +}
> > >  #endif
> > 
> > How that supposed to work when BATTERY_WM97XX is a module?
> > #ifdef CONFIG_BATTERY_WM97XX will evaluate to false, and you'll have
> > dummy wm97xx_bat_set_pdata() that returns -ENODEV...
> 
> This won't of course fix the wm97xx driver model, but the module issue
> should be fixed. What about this patch?
[...]
> -#ifdef CONFIG_BATTERY_WM97XX
> -void __init wm97xx_bat_set_pdata(struct wm97xx_batt_info *data);
> +#if defined(CONFIG_BATTERY_WM97XX) || defined(CONFIG_BATTERY_WM97XX_MODULE)
> +int wm97xx_bat_set_pdata(struct wm97xx_batt_info *data);

In case of CONFIG_BATTERY_WM97XX_MODULE, the build will break at link
time, since wm97xx_bat_set_pdata() might be called from the built-in
code (i.e. arch/arm/mach-pxa/palmtx.c).

>  #else
> -static inline void wm97xx_bat_set_pdata(struct wm97xx_batt_info *data) {}
> +static inline int wm97xx_bat_set_pdata(struct wm97xx_batt_info *data)
> +{
> +	return -ENODEV;
> +}
>  #endif
>  
>  #endif
> -- 
> 1.5.6.5

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

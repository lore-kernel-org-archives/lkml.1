Return-Path: <linux-kernel-owner+w=401wt.eu-S1759818AbYEGIZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818AbYEGIZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 04:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932594AbYEGIYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 04:24:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53489 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762605AbYEGIY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 04:24:29 -0400
Subject: Re: [rtc-linux] [RFC][PATCH 1/4] RTC: Class device support for
	persistent clock
From: David Woodhouse <dwmw2@infradead.org>
To: rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>, Jean Delvare <khali@linux-fr.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, i2c@lm-sensors.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.55.0805070015360.16173@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805070015360.16173@cliff.in.clinika.pl>
Content-Type: text/plain
Date: Wed, 07 May 2008 09:24:15 +0100
Message-Id: <1210148655.25560.825.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-07 at 01:40 +0100, Maciej W. Rozycki wrote:
> 
> +int rtc_update_persistent_clock(struct timespec now)
> +{
> +       struct rtc_device *rtc =
> rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
> +       int err;
> +
> +       if (rtc == NULL) {
> +               printk(KERN_ERR "hctosys: unable to open rtc device (%
> s)\n",
> +                      CONFIG_RTC_HCTOSYS_DEVICE);
> +               err = -ENXIO;
> +               goto out;
>         }
> -       else
> +       err = rtc_set_mmss(rtc, now.tv_sec);
> +       if (err < 0) {
>                 dev_err(rtc->dev.parent,
> -                       "hctosys: unable to read the hardware clock
> \n");
> +                       "hctosys: unable to set the hardware clock
> \n");
> +               goto out_close;
> +       }
>  
> +       err = 0;
> +
> +out_close:
>         rtc_class_close(rtc);
> +out:
> +       return err;
> +}

Ooh, shiny -- you saved me the trouble of doing this (and hopefully also
the trouble of looking through it to check whether all the callers of
read_persistent_clock() can sleep, etc.?)

One thing I was going to do in rtc_update_persistent_clock() was make it
use mutex_trylock() for grabbing rtc->lock. We go to great lengths to
make sure we're updating the clock at the correct time -- we don't want
to be doing things which delay the update. So we should probably just
use mutex_trylock() and abort the update (this time) if it fails.

I was also thinking of holding the RTC_HCTOSYS device open all the time,
too. If it's a problem that you then couldn't unload the module, perhaps
a sysfs interface to set/change/clear which device is used for this?

When we discussed it last week, Alessandro was concerned that the
'update at precisely 500ms past the second' rule was not universal to
all RTC devices, although I'm not entirely sure. It might be worth
moving that logic into a 'default' NTP-sync routine provided by the RTC
class, so that if any strange devices exist which require different
treatment, they can override that.

I wouldn't worry too much about leaving the old
update_persistent_clock() and read_persistent_clock() -- I hope we can
plan to remove those entirely in favour of the RTC class methods.

-- 
dwmw2


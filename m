Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYISWlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYISWlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 18:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYISWkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 18:40:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48416 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbYISWki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 18:40:38 -0400
Date: Fri, 19 Sep 2008 23:40:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>, Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
Subject: Re: [PATCH 1/5] watchdog: sync linux-omap changes
Message-ID: <20080919224019.GC9675@flint.arm.linux.org.uk>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-2-git-send-email-felipe.balbi@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221820359-8943-2-git-send-email-felipe.balbi@nokia.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You're getting there with this patch, but still not completely up to
snuff.

On Fri, Sep 19, 2008 at 01:32:35PM +0300, Felipe Balbi wrote:
> diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
> index 3a11dad..e55f2cc 100644
> --- a/drivers/watchdog/omap_wdt.c
> +++ b/drivers/watchdog/omap_wdt.c
> @@ -39,6 +39,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/moduleparam.h>
>  #include <linux/clk.h>
> +
>  #include <linux/bitops.h>
>  #include <linux/io.h>
>  #include <linux/uaccess.h>

This hunk is unnecessary.

> @@ -218,19 +240,18 @@ static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
>  			return -EFAULT;
>  		omap_wdt_adjust_timeout(new_margin);
>  
> -		spin_lock(&wdt_lock);
> -		omap_wdt_disable();
> -		omap_wdt_set_timeout();
> -		omap_wdt_enable();
> +		omap_wdt_disable(wdev);
> +		omap_wdt_set_timeout(wdev);
> +		omap_wdt_enable(wdev);
>  
> -		omap_wdt_ping();
> -		spin_unlock(&wdt_lock);
> +		omap_wdt_ping(wdev);

This is removing the spin lock which should remain.

>  		/* Fall */
>  	case WDIOC_GETTIMEOUT:
>  		return put_user(timer_margin, (int __user *)arg);
>  	default:
>  		return -ENOTTY;
>  	}
> +	return 0;

And this return statement shouldn't be required.

Apart from those three points, nice work.

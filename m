Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067AbYHMOeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbYHMOeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYHMOdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:33:51 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39410 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbYHMOdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:33:50 -0400
Date: Wed, 13 Aug 2008 17:31:59 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Dave Jones <davej@redhat.com>, Wim Van Sebroeck <wim@iguana.be>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] [WATCHDOG] mpc8xxx_wdt: fix modular build
Message-ID: <20080813143159.GD26351@cs181140183.pp.htv.fi>
References: <20080806202918.GA29386@infomag.infomag.iguana.be> <20080813031044.GA11258@redhat.com> <20080813122341.GA31815@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080813122341.GA31815@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 04:23:41PM +0400, Anton Vorontsov wrote:
>...
> --- a/drivers/watchdog/mpc8xxx_wdt.c
> +++ b/drivers/watchdog/mpc8xxx_wdt.c
> @@ -48,6 +48,7 @@ struct mpc8xxx_wdt_type {
>  };
>  
>  static struct mpc8xxx_wdt __iomem *wd_base;
> +static int mpc8xxx_wdt_init_late(void);
>  
>  static u16 timeout = 0xffff;
>  module_param(timeout, ushort, 0);
> @@ -213,6 +214,12 @@ static int __devinit mpc8xxx_wdt_probe(struct of_device *ofdev,
>  	else
>  		timeout_sec = timeout / freq;
>  
> +#ifdef CONFIG_8xxx_WDT_MODULE
> +	ret = mpc8xxx_wdt_init_late();
> +	if (ret)
> +		goto err_unmap;
> +#endif

In mpc8xxx_wdt_probe()?

Isn't mpc8xxx_wdt_init() the correct place?

>  	pr_info("WDT driver for MPC8xxx initialized. mode:%s timeout=%d "
>  		"(%d seconds)\n", reset ? "reset" : "interrupt", timeout,
>  		timeout_sec);
> @@ -280,7 +287,7 @@ static struct of_platform_driver mpc8xxx_wdt_driver = {
>   * very early to start pinging the watchdog (misc devices are not yet
>   * available), and later module_init() just registers the misc device.
>   */
> -static int __init mpc8xxx_wdt_init_late(void)
> +static int mpc8xxx_wdt_init_late(void)
>  {
>  	int ret;
>  
> @@ -295,7 +302,9 @@ static int __init mpc8xxx_wdt_init_late(void)
>  	}
>  	return 0;
>  }
> +#ifndef CONFIG_8xxx_WDT_MODULE

Your #ifdef is correct, but "#ifdef MODULE" would express this better.

>  module_init(mpc8xxx_wdt_init_late);
> +#endif
>  
>  static int __init mpc8xxx_wdt_init(void)
>  {

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


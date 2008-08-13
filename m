Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbYHMRVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbYHMRVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYHMRVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:21:43 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:61775 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750782AbYHMRVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:21:42 -0400
Date: Wed, 13 Aug 2008 21:21:40 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Dave Jones <davej@redhat.com>, Wim Van Sebroeck <wim@iguana.be>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] [WATCHDOG] mpc8xxx_wdt: fix modular build
Message-ID: <20080813172140.GA5095@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080806202918.GA29386@infomag.infomag.iguana.be> <20080813031044.GA11258@redhat.com> <20080813122341.GA31815@oksana.dev.rtsoft.ru> <20080813143159.GD26351@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20080813143159.GD26351@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 05:31:59PM +0300, Adrian Bunk wrote:
> On Wed, Aug 13, 2008 at 04:23:41PM +0400, Anton Vorontsov wrote:
> >...
> > --- a/drivers/watchdog/mpc8xxx_wdt.c
> > +++ b/drivers/watchdog/mpc8xxx_wdt.c
> > @@ -48,6 +48,7 @@ struct mpc8xxx_wdt_type {
> >  };
> >  
> >  static struct mpc8xxx_wdt __iomem *wd_base;
> > +static int mpc8xxx_wdt_init_late(void);
> >  
> >  static u16 timeout = 0xffff;
> >  module_param(timeout, ushort, 0);
> > @@ -213,6 +214,12 @@ static int __devinit mpc8xxx_wdt_probe(struct of_device *ofdev,
> >  	else
> >  		timeout_sec = timeout / freq;
> >  
> > +#ifdef CONFIG_8xxx_WDT_MODULE
> > +	ret = mpc8xxx_wdt_init_late();
> > +	if (ret)
> > +		goto err_unmap;
> > +#endif
> 
> In mpc8xxx_wdt_probe()?

Yes.

> Isn't mpc8xxx_wdt_init() the correct place?

Not exactly. In case of non-modular build we rely on the fact
that OF devices are populated before module_init(), so _probe
is executed before _init_late.

But with modules, we can do the right thing: just register the driver
and await for the usual probe, then probe the wdt, and then register
userspace interface. Yes, kind of complicated, but we really need
this on 8xx.

> >  	pr_info("WDT driver for MPC8xxx initialized. mode:%s timeout=%d "
> >  		"(%d seconds)\n", reset ? "reset" : "interrupt", timeout,
> >  		timeout_sec);
> > @@ -280,7 +287,7 @@ static struct of_platform_driver mpc8xxx_wdt_driver = {
> >   * very early to start pinging the watchdog (misc devices are not yet
> >   * available), and later module_init() just registers the misc device.
> >   */
> > -static int __init mpc8xxx_wdt_init_late(void)
> > +static int mpc8xxx_wdt_init_late(void)
> >  {
> >  	int ret;
> >  
> > @@ -295,7 +302,9 @@ static int __init mpc8xxx_wdt_init_late(void)
> >  	}
> >  	return 0;
> >  }
> > +#ifndef CONFIG_8xxx_WDT_MODULE
> 
> Your #ifdef is correct, but "#ifdef MODULE" would express this better.

Thanks, will repost soon.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

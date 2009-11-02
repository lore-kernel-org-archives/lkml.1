Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZKBMXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZKBMXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbZKBMXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:23:01 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54182 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbZKBMXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:23:01 -0500
Date: Mon, 2 Nov 2009 13:22:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: dsaxena@laptop.org, alan@linux.intel.com, gregkh@suse.de,
       Daniel Mack <daniel@caiaq.de>, linux-arm-kernel@lists.infradead.org,
       Eric <eric.y.miao@gmail.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com, dbaryshkov@gmail.com, omegamoon@gmail.com,
       utx@penguin.cz, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Possible suspend/resume regression in .32-rc?
Message-ID: <20091102122258.GA22624@elf.ucw.cz>
References: <20091031013427.GL14091@buzzloop.caiaq.de>
 <20091101205449.GT14091@buzzloop.caiaq.de>
 <20091101213343.GA31345@elf.ucw.cz>
 <20091101220341.GA16698@elf.ucw.cz>
 <771cded00911020122o3bb5cc96q957c8be1ce7cae46@mail.gmail.com>
 <20091102093840.GA11426@elf.ucw.cz>
 <771cded00911020248s2b2b6577o5ec2f3772a09e7b9@mail.gmail.com>
 <20091102105141.GB11426@elf.ucw.cz>
 <771cded00911020318u3939a06dq75cd3504d6c0eb50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <771cded00911020318u3939a06dq75cd3504d6c0eb50@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> > Given that it hangs very early, in arch_suspend_enable_irqs() (see my
> >> > other mail), I don't trust your analysis.
> >> >
> >> > I'm not using serial console on spitz, and I have never had successful
> >> > resume with the patch applied.
...
> I see. You can chech my patch in below. I need to save IPRs in suspend
> resume routine.
...
> >From 1764e836424d42a0654b8b73c402a2dddb118dc4 Mon Sep 17 00:00:00 2001
> From: Haojian Zhuang <haojian.zhuang@marvell.com>
> Date: Mon, 2 Nov 2009 14:02:21 -0500
> Subject: [PATCH] pxa: fix system resume issue on pxa27x and pxa3xx
> 
> Since interrupt handler is changed to use interrupt priority, we also need to
> save and restore these interrupt controller registers in suspend/resume
> routine.
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>

Acked-by: Pavel Machek <pavel@ucw.cz>
Tested-by: Pavel Machek <pavel@ucw.cz>

> @@ -150,6 +150,7 @@ void __init pxa_init_irq(int irq_nr, set_wake_t fn)
> 
>  #ifdef CONFIG_PM
>  static unsigned long saved_icmr[2];
> +static unsigned long saved_ipr[128];
> 
>  static int pxa_irq_suspend(struct sys_device *dev, pm_message_t state)
>  {
> @@ -159,6 +160,10 @@ static int pxa_irq_suspend(struct sys_device
> *dev, pm_message_t state)

Note: Your mail client is word-wrapping.

>  		saved_icmr[i] = _ICMR(irq);
>  		_ICMR(irq) = 0;
>  	}
> +	if (pxa_internal_irq_nr > 128)
> +		BUG();

BUG_ON()? WARN_ON() then irq_nr = 128? User is very unlikely to read
the BUG() message at this point...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

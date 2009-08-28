Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbZH1AaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbZH1AaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 20:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZH1AaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 20:30:10 -0400
Received: from ru.mvista.com ([213.79.90.228]:18626 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751349AbZH1AaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 20:30:09 -0400
Date: Fri, 28 Aug 2009 04:30:10 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben-linux@fluff.org>,
       Jean Delvare <khali@linux-fr.org>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH] rtc: Set wakeup capability for I2C and SPI RTC drivers
Message-ID: <20090828003010.GA19160@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090827182207.GA7358@oksana.dev.rtsoft.ru>
 <200908271452.37358.david-b@pacbell.net>
 <20090827231925.GA1131@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090827231925.GA1131@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 03:19:25AM +0400, Anton Vorontsov wrote:
[...]
> > That is why platform code should device_init_wakeup() and
> > drivers should check device_can_wakeup(dev) ...
> 
> They should (and do) check may_wakeup() (i.e. should_wakeup) before
> suspending, not can_wakeup().
> 
> static int ds1374_suspend(struct i2c_client *client, pm_message_t state)
> {
>         if (client->irq >= 0 && device_may_wakeup(&client->dev))
>                 enable_irq_wake(client->irq);
>         return 0;
> }
> 
> (quite funny, they issue enable_irq_wake(), assuming that otherwise
> IRQ line won't trigger CPU wakeup. But in reality, there are interrupt
> controllers that you can't control in that regard: any IRQ activity
> will always resume CPU. And so 'echo disable > /sys/.../wakeup' won't
> guarantee anything. Unreliable, nasty? Could be.)

BTW, of course we can fix this by masking interrupts before
suspending, but nobody actually do this (but should, I think).

And if RTC's IRQ is wired to power switch you're in trouble
without any way to fix this.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

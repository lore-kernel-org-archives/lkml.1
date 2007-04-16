Return-Path: <linux-kernel-owner+w=401wt.eu-S1030971AbXDPVMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030971AbXDPVMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030974AbXDPVMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:12:33 -0400
Received: from mx33.mail.ru ([194.67.23.194]:19549 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030971AbXDPVMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:12:32 -0400
Date: Tue, 17 Apr 2007 01:08:29 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [PATCH 7/7] [RFC] APM emulation driver for class batteries
Message-ID: <20070416210829.GA5107@zarina>
Reply-To: cbou@mail.ru
References: <20070411232644.GG20095@zarina> <20070413135005.GE20618@zarina> <20070416202421.GC19713@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070416202421.GC19713@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 09:24:21PM +0100, Russell King wrote:
> On Fri, Apr 13, 2007 at 05:50:43PM +0400, Anton Vorontsov wrote:
> > +static void (*old_apm_get_power_status)(struct apm_power_info*);
> > +
> > +static int __init apm_battery_init(void)
> > +{
> > +	printk(KERN_INFO "APM Battery Driver\n");
> > +
> > +	old_apm_get_power_status = apm_get_power_status;
> > +	apm_get_power_status = apm_battery_apm_get_power_status;
> > +	return 0;
> > +}
> > +
> > +static void __exit apm_battery_exit(void)
> > +{
> > +	apm_get_power_status = old_apm_get_power_status;
> > +	return;
> > +}
> 
> Utterly unsafe.  What happens if some other module gets loaded which
> does this, and then this module is unloaded followed by the other
> module.  Result: Oops.

Right. And loading two modules which changing apm_get_power_status
is a race already. Thus, APM interface needs a mutex.

Or pda_power should be marked "bool" in Kconfig, as it is done
in arch/arm/common/sharpsl_pm.c. Sharpsl_pm is safe only because it
can't be a module.

Personally I'd keep things as is for now (i.e. I'd want tristate for
PDA_POWER, not bool). Later APM API can be fixed.

> -- 
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

Thanks,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2

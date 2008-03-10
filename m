Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbYCJN3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbYCJN3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbYCJN33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:29:29 -0400
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:1936 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750968AbYCJN33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:29:29 -0400
Date: Mon, 10 Mar 2008 14:29:21 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Christian Kujau <lists@nerdbynature.de>, bruno.roussel@free.fr,
       LKML <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org
Subject: Re: possible recursive locking detected
Message-ID: <20080310142921.2696e8b9@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0803092332160.18589@twin.jikos.cz>
References: <1205082504.47d41988f0db5@imp.free.fr>
	<alpine.DEB.1.00.0803092215010.5349@sheep.housecafe.de>
	<Pine.LNX.4.64.0803092332160.18589@twin.jikos.cz>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008 23:41:50 +0100 (CET), Jiri Kosina wrote:
> On Sun, 9 Mar 2008, Christian Kujau wrote:
> 
> > > =============================================
> > > [ INFO: possible recursive locking detected ]
> > > 2.6.24.2-1mdv #1
> > > ---------------------------------------------
> > Hm, strange: a similiar looking issue has been reported back in 2006, it 
> > even comes with a patch: http://lkml.org/lkml/2006/10/14/38
> > ..but I cannot tell if the patch made it into mainline. I've Cc'ed the i2c
> > folks, maybe they can tell what's going on here.
> 
> I don't recall this, but from looking at the source it seems that only 
> part of my patch made it upstream for some reason ...

I applied the i2c-core part:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=6ea23039cb1cc7c379eb5fba0ed2c53291e9bea7

But I have no idea what happened to the DVB device-driver specific part.

> 
> Bruno, does the patch below remove the warning for you? (we should rather 
> used lockdep_set_class() now, when this is already available ... it wasn't 
> in the time I was doping the original patch back in 2006).
> 
> 
> 
> Set locking depth properly (level == 0 for DVB frontend, level == 1 for 
> DVB adapter).
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c b/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c
> index 23428cd..8c5dc35 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-i2c.c
> @@ -27,6 +27,7 @@ int dvb_usb_i2c_init(struct dvb_usb_device *d)
>  #endif
>  	d->i2c_adap.algo      = d->props.i2c_algo;
>  	d->i2c_adap.algo_data = NULL;
> +	d->i2c_adap.level = 1;
>  	d->i2c_adap.dev.parent = &d->udev->dev;
>  
>  	i2c_set_adapdata(&d->i2c_adap, d);
> diff --git a/drivers/media/dvb/frontends/dibx000_common.c b/drivers/media/dvb/frontends/dibx000_common.c
> index 315e09e..a3ed8cf 100644
> --- a/drivers/media/dvb/frontends/dibx000_common.c
> +++ b/drivers/media/dvb/frontends/dibx000_common.c
> @@ -111,6 +111,7 @@ static int i2c_adapter_init(struct i2c_adapter *i2c_adap, struct i2c_algorithm *
>  	i2c_adap->class     = I2C_CLASS_TV_DIGITAL,
>  	i2c_adap->algo      = algo;
>  	i2c_adap->algo_data = NULL;
> +	i2c_adap->level = 0;
>  	i2c_set_adapdata(i2c_adap, mst);
>  	if (i2c_add_adapter(i2c_adap) < 0)
>  		return -ENODEV;

Also note:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=cea443a81c9c6257bf2d00f1392f7d1d4ce03b75

This patch that was applied recently to i2c-core might cause lockdep
issues. For some reason there's no "nested" variant of mutex_trylock?

-- 
Jean Delvare

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761375AbYBLI1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761375AbYBLI1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYBLI1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:27:34 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:3849 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750851AbYBLI1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:27:33 -0500
Date: Tue, 12 Feb 2008 09:27:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: "Greg KH" <greg@kroah.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: (adm1026) Properly terminate sysfs groups (Was:
 panic about sysfs with adm1026)
Message-ID: <20080212092722.32c30eac@hyperion.delvare>
In-Reply-To: <86802c440802111539w7eeb84dcu97103733364f7a7b@mail.gmail.com>
References: <86802c440802092355l7393fe07gfbd021e9cef66181@mail.gmail.com>
	<20080210171004.GB25353@kroah.com>
	<20080210190115.2ebd4124@hyperion.delvare>
	<86802c440802111539w7eeb84dcu97103733364f7a7b@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

On Mon, 11 Feb 2008 15:39:39 -0800, Yinghai Lu wrote:
> On Feb 10, 2008 10:01 AM, Jean Delvare <khali@linux-fr.org> wrote:
> > Yeah, I am an idiot. In 5b34dbcd88251508d02e48ad9b0f9b8232a13ee0 I
> > introduced two new sysfs file groups but forgot to NULL-terminate them.
> > Sorry about that, here's the fix:
> >
> > * * * * *
> >
> > The missing NULL at the end of two sysfs file groups causes a kernel
> > crash when calling sysfs_create_group().
> >
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > ---
> >  drivers/hwmon/adm1026.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > --- linux-2.6.25-rc0.orig/drivers/hwmon/adm1026.c       2008-02-10 11:21:54.000000000 +0100
> > +++ linux-2.6.25-rc0/drivers/hwmon/adm1026.c    2008-02-10 18:51:00.000000000 +0100
> > @@ -1624,6 +1624,7 @@ static struct attribute *adm1026_attribu
> >         &dev_attr_temp3_crit_enable.attr,
> >         &dev_attr_temp3_auto_point1_pwm.attr,
> >         &dev_attr_temp3_auto_point2_pwm.attr,
> > +       NULL
> >  };
> >
> >  static const struct attribute_group adm1026_group_temp3 = {
> > @@ -1639,6 +1640,7 @@ static struct attribute *adm1026_attribu
> >         &sensor_dev_attr_in9_max.dev_attr.attr,
> >         &sensor_dev_attr_in9_min.dev_attr.attr,
> >         &sensor_dev_attr_in9_alarm.dev_attr.attr,
> > +       NULL
> >  };
> >
> >  static const struct attribute_group adm1026_group_in8_9 = {
> >
> > * * * * *
> 
> it works. Thanks

Great, thanks. Mark, please include this patch in your next patch to
Linus for 2.6.25.

> > Yinghai, the bug crept in because I do not have an ADM1026 chip to test
> > my changes. Could you please send a dump of your chip to me, so that I
> > can emulate it? This would avoid similar problems in the future.
> >
> > First you have to find out at which address the ADM1026 chip lives. The
> > first line of "sensors" should tell, otherwise you can run "i2cdetect
> > 1". The ADM1026 can live at 0x2c, 0x2d or 0x2e. Once you know the
> > address, run the following command to get the dump:
> >
> > rmmod adm1026
> > i2cdump 1 0x2d b
> 
> LBSuse:/x/kernel.org # ./i2cdetect 1
> WARNING! This program can confuse your I2C bus, cause data loss and worse!
> I will probe file /dev/i2c-1.
> I will probe address range 0x03-0x77.
> Continue? [Y/n] y
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00:          -- -- -- -- -- 08 -- -- -- -- -- -- --
> 10: -- -- -- -- -- -- -- -- 18 19 -- -- 1c 1d -- --
> 20: -- -- -- -- -- -- -- -- -- -- -- -- UU UU -- --
> 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 40: 40 41 -- -- -- -- -- -- 48 49 4a -- -- -- -- --
> 50: UU UU UU UU UU UU -- -- -- -- -- -- -- -- -- --
> 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 70: -- -- -- -- -- -- -- --
> LBSuse:/x/kernel.org # ./i2cdump 1 0x2c b
> Error: Could not set address to 0x2c: Device or resource busy
> LBSuse:/x/kernel.org # ./i2cdump 1 0x2d b
> Error: Could not set address to 0x2d: Device or resource busy

You must unload the adm1026 driver before dumping (see the "rmmod
adm1026" above in my example.)

Thanks,
-- 
Jean Delvare

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbZFIPw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbZFIPw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbZFIPwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:52:50 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:56051 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZFIPwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:52:49 -0400
Date: Tue, 9 Jun 2009 17:52:35 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Message-ID: <20090609155235.GK18591@gundam.enneenne.com>
Mail-Followup-To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
References: <20090609135947.GB18591@gundam.enneenne.com> <20090609151834.GA30774@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609151834.GA30774@rakim.wolfsonmicro.main>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: regulator_register() API
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 04:18:34PM +0100, Mark Brown wrote:
> On Tue, Jun 09, 2009 at 03:59:47PM +0200, Rodolfo Giometti wrote:
> 
> > Current regulator_register() implementation forces the caller to
> > allocate a proper device for each regulators and also the line:
> 
> >    struct regulator_init_data *init_data = dev->platform_data;
> 
> > forces the user to define the pointer platform_data as a "struct
> > regulator_init_data" only.
> 
> That's not the case in current mainline - the init data is passed in as
> an argument to regulator_register().  There should be no requirement
> that the struct device be unique, you should be able to use the same
> struct device for all the regulators on the device.  It's mostly just
> used for printk.
> 
> > However if the regulator_register() worked in a similar way to
> > led_classdev_register(), I simply can do something like this:
> 
> >         for (i = 0; i < regulators_num; i++) {
> > 	       /* init regulators structs */
> > 	       ...
> > 
> >                ret = regulator_register(&client->dev, &reg[i].dev);
> >                if (ret < 0)
> > 		       dev_warn(&client->dev, "unable to register\n");
> >         }
> 
> You can do exactly this in current mainline.  You do need to supply init
> data for each regulator to make them useful.  The change came in commit
> 0527100fd11d9710c7e153d791da78824b7b46fa which was merged during the
> 2.6.30 merge window.

Great! However this resolve one issue, the caller still needs to
allocate a device struct by itsown. On the other hand, doing like
led_classdev_register() does will resolve it also!

See first lines of the function:

   int led_classdev_register(struct device *parent, struct led_classdev
   *led_cdev)
   {
           int rc;

           led_cdev->dev = device_create(leds_class, parent, 0, led_cdev,
                                         "%s", led_cdev->name);
           if (IS_ERR(led_cdev->dev))
                   return PTR_ERR(led_cdev->dev);

           /* register the attributes */
           rc = device_create_file(led_cdev->dev, &dev_attr_brightness);
           if (rc)
                   goto err_out;

	   ...

As you can see in this case I simply can do:

        /* Register the led devices */
        for (i = 0; i < 6; i++)
                if (pdata->led[i].name) {
                        data->led[i].dev.name = pdata->led[i].name;
                        data->led[i].dev.brightness = pdata->led[i].brightness;
                        data->led[i].dev.brightness_set = max8821_led_set;
#ifdef CONFIG_LEDS_TRIGGERS
                        data->led[i].dev.default_trigger =
                                                pdata->led[i].trigger;
#endif
                        INIT_WORK(&data->led[i].work, max8821_led_set_work);
                        ret = led_classdev_register(&client->dev,
                                                        &data->led[i].dev);
                        if (ret < 0)
                                dev_warn(&client->dev, "unable to register "
                                                "led%d into the system\n",
                                                i + 1);
                }

No device allocation at all, I simply supply the parent device and the
register function does the rest, also all info regarding the led
device are into "struct led_classdev".

> > This will keep backward compatibility with old drivers and may offer a
> > more versatile way to define a regulator expecially for
> > multifunctional devices.
> 
> Most of the regulators currently supported are part of multi-function
> devices so they're not an unusual case here.  

But I never said that it is an unusual case, I said it's more complex
to manage. :)

By doing a "struct regulator_classdev" and defining a
regulator_classdev_register() the device driver writer will be easier!
Maybe we can just adding the regulator_classdev_register() as a
wrapper function...

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti

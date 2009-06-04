Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbZFDJf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbZFDJf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbZFDJfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:35:17 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:12837 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbZFDJfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:35:16 -0400
Date: Thu, 4 Jun 2009 11:35:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Minkyu Kang <mk7.kang@samsung.com>
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, kyungmin.park@samsung.com,
       Anton Vorontsov <cbou@mail.ru>,
       Andrew Morton <akpm@linux-foundation.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2] add MAX17040 Fuel Gauge driver
Message-ID: <20090604113504.5370775b@hyperion.delvare>
In-Reply-To: <5d5443650906040216h2314b7bbt1ae2e89c709b566e@mail.gmail.com>
References: <4A278C08.5000206@samsung.com>
	<5d5443650906040216h2314b7bbt1ae2e89c709b566e@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 14:46:45 +0530, Trilok Soni wrote:
> Hi Minkyu Kang,
> 
> Adding linux-i2c mailing list, so not deleting any code.
> 
> On Thu, Jun 4, 2009 at 2:25 PM, Minkyu Kang <mk7.kang@samsung.com> wrote:
> > The MAX17040 is a I2C interfaced Fuel Gauge systems for lithium-ion batteries
> > This patch adds support the MAX17040 Fuel Gauge
> >
> > Cc: Anton Vorontsov <cbou@mail.ru>
> > Signed-off-by: Minkyu Kang <mk7.kang@samsung.com>
> > ---
> >  drivers/power/Kconfig            |    8 +
> >  drivers/power/Makefile           |    3 +-
> >  drivers/power/max17040_battery.c |  306 ++++++++++++++++++++++++++++++++++++++
> >  include/linux/max17040_battery.h |   19 +++
> >  4 files changed, 335 insertions(+), 1 deletions(-)
> >  create mode 100644 drivers/power/max17040_battery.c
> >  create mode 100644 include/linux/max17040_battery.h
> > (...)
> > +static u8 max17040_read_reg(int reg)
> > +{
> > +       int ret;
> > +
> > +       ret = i2c_smbus_read_byte_data(max17040->client, reg);
> > +
> > +       if (ret < 0) {
> > +               dev_err(&max17040->client->dev,
> > +                               "%s: reg 0x%x, err %d\n",
> > +                               __func__, reg, ret);
> > +       }
> > +
> > +       return ret;
> > +}

In case of error, this will wrap the error code into a u8 and the
caller won't notice. So you'll return a random value, depending on the
actual error which happened. No good.

You should either return an int there, and have the caller check for
errors, or if you don't want to care about errors, return an arbitrary
value on error (e.g. 0.)

> > (...)
> > +static int __devinit max17040_probe(struct i2c_client *client,
> > +                       const struct i2c_device_id *id)
> > +{
> > +       struct max17040_chip *chip;
> > +       int ret;
> > +
> > +       chip = kzalloc(sizeof(struct max17040_chip), GFP_KERNEL);
> > +       if (!chip)
> > +               return -ENOMEM;
> > +
> > +       chip->client = client;
> > +       pdata = client->dev.platform_data;
> > +
> > +       i2c_set_clientdata(client, chip);
> 
> Please add i2c_check_functionality check before doing any smbus
> read/write operations.
> 
> > +       max17040 = chip;
> 
> This means that we support only one instance of this chip, right?
> 
> > +
> > +       max17040_reset();
> > +
> > +       max17040_get_version();
> > +
> > +       INIT_DELAYED_WORK_DEFERRABLE(&chip->work, max17040_work);
> > +       schedule_delayed_work(&chip->work, MAX17040_DELAY);
> > +
> > +       bat_ps.properties = max17040_battery_props;
> > +       bat_ps.num_properties = ARRAY_SIZE(max17040_battery_props);
> > +
> > +       ret = power_supply_register(&client->dev, &bat_ps);
> > +       if (ret) {
> > +               dev_err(&max17040->client->dev,
> > +                               "failed: power supply register\n");
> > +               cancel_delayed_work(&chip->work);
> > +               i2c_set_clientdata(client, NULL);
> > +               kfree(chip);
> > +               max17040 = NULL;
> > +               return -1;

Please come up with a better error code.

> > +       }
> > +
> > +       return 0;
> > +}

-- 
Jean Delvare

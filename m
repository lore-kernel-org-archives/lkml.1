Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZFDHhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZFDHhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 03:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZFDHha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 03:37:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbZFDHh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 03:37:29 -0400
Date: Thu, 4 Jun 2009 00:37:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minkyu Kang <mk7.kang@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       kyungmin.park@samsung.com, Anton Vorontsov <cbou@mail.ru>
Subject: Re: [PATCH] add MAX17040 Fuel Gauge driver
Message-Id: <20090604003717.b6941159.akpm@linux-foundation.org>
In-Reply-To: <4A25DB40.6010904@samsung.com>
References: <4A25DB40.6010904@samsung.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Jun 2009 11:09:04 +0900 Minkyu Kang <mk7.kang@samsung.com> wrote:

> The MAX17040 is a I2C interfaced Fuel Gauge systems for lithium-ion batteries
> This patch adds support the MAX17040 Fuel Gauge
> 
> Signed-off-by: Minkyu Kang <mk7.kang@samsung.com>
> ---
>  drivers/power/Kconfig            |    8 +
>  drivers/power/Makefile           |    3 +-
>  drivers/power/max17040_battery.c |  304 ++++++++++++++++++++++++++++++++++++++
>  include/linux/max17040_battery.h |   19 +++

Please Cc Anton Vorontsov <cbou@mail.ru> on drivers/power patches.

>
> ...
>
> +static int __devinit max17040_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct max17040_chip *chip;
> +	int ret;
> +
> +	chip = kzalloc(sizeof(struct max17040_chip), GFP_KERNEL);
> +	if (!chip)
> +		return -ENOMEM;
> +
> +	chip->client = client;
> +	pdata = client->dev.platform_data;
> +
> +	i2c_set_clientdata(client, chip);
> +	max17040 = chip;
> +
> +	max17040_reset();
> +
> +	max17040_get_version();
> +
> +	INIT_DELAYED_WORK_DEFERRABLE(&chip->work, max17040_work);
> +	schedule_delayed_work(&chip->work, MAX17040_DELAY);
> +
> +	bat_ps.properties = max17040_battery_props;
> +	bat_ps.num_properties = ARRAY_SIZE(max17040_battery_props);
> +
> +	ret = power_supply_register(&client->dev, &bat_ps);
> +	if (ret) {
> +		dev_err(&max17040->client->dev,
> +				"failed: power supply register\n");
> +		kfree(chip);
> +		max17040 = NULL;
> +		i2c_set_clientdata(client, NULL);
> +		return -1;

This leaves the delayed work still pending.

> +	}
> +
> +	return 0;
> +}
> +
> +static int __devexit max17040_remove(struct i2c_client *client)
> +{
> +	struct max17040_chip *chip = i2c_get_clientdata(client);
> +
> +	kfree(chip);
> +	max17040 = NULL;
> +	i2c_set_clientdata(client, NULL);
> +	power_supply_unregister(&bat_ps);
> +	return 0;
> +}

Shouldn't max17040_remove() also cancel the delayed_work?

> +static int max17040_suspend(struct i2c_client *client,
> +		pm_message_t state)
> +{
> +	struct max17040_chip *chip = i2c_get_clientdata(client);
> +
> +	cancel_delayed_work(&chip->work);
> +	return 0;
> +}
> +
> +static int max17040_resume(struct i2c_client *client)
> +{
> +	struct max17040_chip *chip = i2c_get_clientdata(client);
> +
> +	schedule_delayed_work(&chip->work, MAX17040_DELAY);
> +	return 0;
> +}


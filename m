Return-Path: <linux-kernel-owner+w=401wt.eu-S932591AbXJQTNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbXJQTNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbXJQTNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:13:45 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:30027 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbXJQTNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:13:44 -0400
X-IronPort-AV: i="4.21,290,1188792000"; 
   d="scan'208"; a="41919709:sNHT86681266"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH try #4] Input/Joystick Driver: add support AD7142 joystick  driver
Date: Wed, 17 Oct 2007 15:14:40 -0400
User-Agent: KMail/1.9.5
Cc: bryan.wu@analog.com, "Andrey Panin" <pazke@donpac.ru>,
       "Roel Kluin" <12o3l@tiscali.nl>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <1192605120.7920.15.camel@roc-laptop> <20071017160702.3316fc24@hyperion.delvare>
In-Reply-To: <20071017160702.3316fc24@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710171514.40941.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 17 Oct 2007 19:13:42.0573 (UTC) FILETIME=[D4F025D0:01C810F1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 17 Oct 2007 10:07, Jean Delvare pondered:
> Hi Bryan,
> 
> On Wed, 17 Oct 2007 15:12:00 +0800, Bryan Wu wrote:
> > Subject: [PATCH try #4] Input/Joystick Driver: add support AD7142
> joystick driver
> > +#define AD7142_I2C_ADDR		0x2C
> 
> Not worth a define IMHO, as you use it only once and the context is
> completely clear.

> > +static int ad7142_probe(struct i2c_adapter *adap, int addr, int kind)
> > +{
> > +	struct ad7142_data *data;
> > +	struct i2c_client *client;
> > +	struct input_dev *input_dev;
> > +	int rc;
> > +
> > +	data = kzalloc(sizeof(struct ad7142_data), GFP_KERNEL);
> > +	if (!data)
> > +		return -ENOMEM;
> > +
> > +	client = &data->client;
> > +
> > +	strlcpy(client->name, AD7142_DRV_NAME, I2C_NAME_SIZE);
> > +	client->addr = addr;
> > +	client->adapter = adap;
> > +	client->driver = &ad7142_driver;
> > +
> 
> This is unsafe: you're not doing any kind of detection here. 

I assume that in order to do things "right", all possible addresses should be 
probed (for this part, that is 0x2C, 0x2D, 0x2E, 0x2F)?

And it should read a device ID (register 0x17 == 0xE62n (where n==rev number))

How many values/registers do you need to read before you say "this is the 
one"? rather than a temp sensor with a similar value somewhere. Is there a 
table anywhere that maps this out?

It is pretty difficult just to probe on reset values, since that disallows 
warm resets. This part - like most other I2C parts, has no external reset, 
only software reset.

> The risk is mitigated by the fact
> that your driver is currently built for Blackfin only, but this might
> change in the future. 

The hope is that others can use it - it shouldn't be specific to Blackfin.

> This is a very good reason to switch to a 
> new-style i2c driver.
> 

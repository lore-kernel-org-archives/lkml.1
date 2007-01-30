Return-Path: <linux-kernel-owner+w=401wt.eu-S933029AbXA3Kfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029AbXA3Kfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933149AbXA3Kfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:35:38 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52366 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933029AbXA3Kfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:35:37 -0500
Date: Tue, 30 Jan 2007 02:35:12 -0800
From: Andrew Morton <akpm@osdl.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] TSL2550 support (I2C device driver)
Message-Id: <20070130023512.5768aca6.akpm@osdl.org>
In-Reply-To: <20070130102642.GC8882@enneenne.com>
References: <20070129235619.GA8882@enneenne.com>
	<20070129183950.00ef3a04.akpm@osdl.org>
	<20070130102642.GC8882@enneenne.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 11:26:42 +0100
Rodolfo Giometti <giometti@enneenne.com> wrote:

> > > +static int tsl2550_get_adc_value(struct i2c_client *client, int channel)
> > > +{
> > > +	u8 cmd = channel == 0 ? TSL2550_READ_ADC0 : TSL2550_READ_ADC1;
> > > +	int timeout, ret;
> > > +
> > > +	/* Read ADC channel waiting at most 400ms (see data sheet for further
> > > +         * info) */
> > > +	for (timeout = 400; timeout > 0; timeout--) {
> > > +		i2c_smbus_write_byte(client, cmd);
> > > +		mdelay(1);
> > > +		ret = i2c_smbus_read_byte(client);
> > > +		if (ret < 0)
> > > +			return ret;
> > > +		else if (ret & 0x0080)
> > > +			break;
> > > +	}
> > > +	if (timeout == 0)
> > > +		return -EIO;
> > > +	return ((u8) ret) & 0x7f;	/* remove the "valid" bit */
> > > +}
> > 
> > eek.  Is there no way to avoid the busy-wait?  We cannot sleep here?
> 
> That's why I have to retry reading data for at most 400ms otherwise
> the chip will start a new ADC conversion.
> 
> I can replace mdelay(1) with schedule_timeout(HZ/1000) but doing this
> I'm not sure that just 1ms has elapesed. Also the chip has no irq
> lines to use for that.

I expect an msleep(1) will be OK, if you can indeed sleep on this
codepath.  Yes, that can delay for longer: ten milliseconds for sure
if HZ=100.

If that's a problem I guess you could spin for a millisecond or two, then
start sleeping:

	end = jiffies + msecs_to_jiffies(400);
	while (time_before(jiffies, end)) {
		loop++;
		...
		if (loop < 5)
			mdelay(1);
		else
			msleep(1);
	}

or something like that.

Return-Path: <linux-kernel-owner+w=401wt.eu-S932984AbXA3K0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984AbXA3K0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 05:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933015AbXA3K0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 05:26:48 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:51416 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578AbXA3K0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 05:26:43 -0500
Date: Tue, 30 Jan 2007 11:26:42 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Message-ID: <20070130102642.GC8882@enneenne.com>
References: <20070129235619.GA8882@enneenne.com> <20070129183950.00ef3a04.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129183950.00ef3a04.akpm@osdl.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] TSL2550 support (I2C device driver)
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 06:39:50PM -0800, Andrew Morton wrote:

> > +/* Insmod parameters */
> > +I2C_CLIENT_INSMOD_1(tsl2550);
> > +
> > +static int operating_mode = 0;
> 
> The `= 0' is unneeded and undesirable.

Fixed.

> > ...
> >
> > +static int tsl2550_get_adc_value(struct i2c_client *client, int channel)
> > +{
> > +	u8 cmd = channel == 0 ? TSL2550_READ_ADC0 : TSL2550_READ_ADC1;
> > +	int timeout, ret;
> > +
> > +	/* Read ADC channel waiting at most 400ms (see data sheet for further
> > +         * info) */
> > +	for (timeout = 400; timeout > 0; timeout--) {
> > +		i2c_smbus_write_byte(client, cmd);
> > +		mdelay(1);
> > +		ret = i2c_smbus_read_byte(client);
> > +		if (ret < 0)
> > +			return ret;
> > +		else if (ret & 0x0080)
> > +			break;
> > +	}
> > +	if (timeout == 0)
> > +		return -EIO;
> > +	return ((u8) ret) & 0x7f;	/* remove the "valid" bit */
> > +}
> 
> eek.  Is there no way to avoid the busy-wait?  We cannot sleep here?

That's why I have to retry reading data for at most 400ms otherwise
the chip will start a new ADC conversion.

I can replace mdelay(1) with schedule_timeout(HZ/1000) but doing this
I'm not sure that just 1ms has elapesed. Also the chip has no irq
lines to use for that.

> > +/* --- LUX calculation ----------------------------------------------------- */
> > +
> > +#define	TSL2550_MAX_LUX		1846
> > +
> > +static u8 ratio_lut[] = {
> > +	100, 100, 100, 100, 100, 100, 100, 100, 
> > [snip]
> > +
> > +static u16 count_lut[] = {
> > +	0, 1, 2, 3, 4, 5, 6, 7, 
> > [snip]
> 
> These tables could perhaps be const?

Fixed.

> > +static ssize_t tsl2550_show_power_state(struct device *dev, struct device_attribute *attr, char *buf)
> 
> It's preferred to try to fit the code into an 80-col window.  (But some
> people disagree with this specifically for function definitions such as
> this).

I agree with them. :)

> Preferred coding style is
> 
> 	err = i2c_detach_client(client);
> 	if (err)
> 		return err;
> 
> (multiple places)

Fixed.

I'm going to repost the patch after some tests.

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127

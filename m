Return-Path: <linux-kernel-owner+w=401wt.eu-S932691AbZJLPxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbZJLPxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932647AbZJLPxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:53:08 -0400
Received: from poutre.nerim.net ([62.4.16.124]:57047 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619AbZJLPxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:53:06 -0400
Date: Mon, 12 Oct 2009 17:52:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       "Michele De Candia (VT)" <michele.decandia@valueteam.com>,
       Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] ALS: TSL2550 driver move from i2c/chips
Message-ID: <20091012175216.6d844623@hyperion.delvare>
In-Reply-To: <4AD33ADB.4000500@cam.ac.uk>
References: <4ACF4AC6.7070802@cam.ac.uk>
	<20091010185200.671846c5@hyperion.delvare>
	<4AD33ADB.4000500@cam.ac.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Mon, 12 Oct 2009 15:19:07 +0100, Jonathan Cameron wrote:
> >> @@ -60,9 +65,41 @@ static const u8 TSL2550_MODE_RANGE[2] = {
> >>  };
> >>  
> >>  /*
> >> + * IDR to assign each registered device a unique id
> >> + */
> >> +static DEFINE_IDR(tsl2550_idr);
> >> +static DEFINE_SPINLOCK(tsl2550_idr_lock);
> >> +#define TSL2550_DEV_MAX 9
> > 
> > Such an arbitrary limit is simply not acceptable.
>
> Fair enough, but it is based on restricting the size
> of the char array needed for the name when registering
> with als.  Hence single digit decimal maximum.
> Do you suggest leaving it unrestricted (which makes code
> a little fiddly given variable size of max idr) or some other
> limit?

The name size really isn't an issue. You won't notice 16 bytes instead
of 9. And it's not like we'll have millions of these devices.

> >> +static int tsl2550_get_id(void)
> >> +{
> >> +	int ret, val;
> >> +
> >> +idr_again:
> >> +	if (unlikely(idr_pre_get(&tsl2550_idr, GFP_KERNEL) == 0))
> >> +		return -ENOMEM;
> >> +	spin_lock(&tsl2550_idr_lock);
> >> +	ret = idr_get_new(&tsl2550_idr, NULL, &val);
> >> +	if (unlikely(ret == -EAGAIN))
> >> +		goto idr_again;
> >> +	else if (unlikely(ret))
> >> +		return ret;
> >> +	if (val > TSL2550_DEV_MAX)
> >> +		return -ENOMEM;
> >> +	return val;
> >> +}
> >> +
> >> +static void tsl2550_free_id(int val)
> >> +{
> >> +	spin_lock(&tsl2550_idr_lock);
> >> +	idr_remove(&tsl2550_idr, val);
> >> +	spin_unlock(&tsl2550_idr_lock);
> >> +}
> > 
> > Having to implement this in _every_ ALS driver sounds wrong and
> > painful. If uniqueness of any kind must be provided, it should be
> > handled by the ALS core and not by individual drivers, otherwise you
> > can be certain that at least one driver will get it wrong someday.
>
> I agree. The reason this originally occurred is that the acpi layer
> apparently doesn't allow for simultaneous probing of multiple drivers
> and hence can get away with a simple counter and no locking.
>
> > I'd imaging that als-class devices are simply named als%u. Just like
> > hwmon devices are named hwmon%u, input devices are names input%u and
> > event%u, etc. I don't know of any class pushing the naming down to its
> > drivers, do you? The only example I can remember are i2c drivers back
> > in year 1999, when they were part of lm-sensors.I have personally put
> > an end to this years ago.
>
> This debate started in the als thread. Personally I couldn't care less
> either way but it does need to be put to bed before that subsystem merges.
> To my mind either approach is trivially handled in a userspace library
> so it doesn't matter.  I don't suppose you can remember what the original
> reasons for squashing this naming approach were?

Code duplication. Having the same unique-id handling code repeated in
50 drivers was no fun, as it did not add any value compared to a
central handling.

> >> @@ -296,13 +333,13 @@ static ssize_t tsl2550_show_lux1_input(struct device *dev,
> >>  	return ret;
> >>  }
> >>  
> >> -static DEVICE_ATTR(lux1_input, S_IRUGO,
> >> +static DEVICE_ATTR(illuminance, S_IRUGO,
> >>  		   tsl2550_show_lux1_input, NULL);
> > 
> > Question: if I have a light sensing chip with two sensors, how are we
> > going to handle it? Will we register 2 als class devices? The initial
> > naming convention had the advantage that you could have more than one
> > sensor per device, but I don't know if it is desirable in practice.
>
> This only becomes and issue if we have two sensors measuring illuminance
> (or approximation of it).  The only two sensor chips I know of have one
> broadband and one in the infrared tsl2561 and I think the isl chip with
> a driver currently in misc.  The combination of these two are needed to
> calculate illuminance.  Some of the original discussion went into how
> to support separate access to the individual sensors.  Decision was to
> leave that question until it becomes relevant.  Basically we would put
> the current drivers in just supporting illuminance and see if anyone asked
> for furthers support.  One tricky aspect is what the units should be for
> particular frequency ranges. At least illuminance is cleanly defined
> (even if chips are only fairly coarsely approximating it. 

Hmm, this isn't the point I was raising. I was thinking of a light
sensor chip which would sense light in different locations. Think chip
with remote sensors. This is done frequently for thermal sensors, so I
guess it could be done for light sensors as well. A practical
application could be sensing the ambient light on two sides of an
object, so that you get the correct measurement regardless of the
position.

I'm not saying such chips exist, I really don't know. I am just raising
the question of how we'd handle them if they do. The current naming
scheme implies that we'd need a separate als instance for each sensor,
and I want you to be aware of this.

> >>  static struct attribute *tsl2550_attributes[] = {
> >>  	&dev_attr_power_state.attr,
> >>  	&dev_attr_operating_mode.attr,
> >> -	&dev_attr_lux1_input.attr,
> >> +	&dev_attr_illuminance.attr,
> >>  	NULL
> >>  };
> >>  
> >> @@ -350,6 +387,7 @@ static int __devinit tsl2550_probe(struct i2c_client *client,
> >>  	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> >>  	struct tsl2550_data *data;
> >>  	int *opmode, err = 0;
> >> +	char name[9];
> >>  
> >>  	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WRITE_BYTE
> >>  					    | I2C_FUNC_SMBUS_READ_BYTE_DATA)) {
> >> @@ -387,15 +425,31 @@ static int __devinit tsl2550_probe(struct i2c_client *client,
> >>  	if (err)
> >>  		goto exit_kfree;
> >>  
> >> +	data->id = tsl2550_get_id();
> >> +	if (data->id < 0) {
> >> +		err = data->id;
> >> +		goto exit_kfree;
> >> +	}
> >> +	sprintf(name, "tsl2550%d", data->id);
> > 
> > Please no. For one thing you should always use snprintf and not sprintf
> > when writing to such small buffers. It's way too easy to get things
> > wrong otherwise. And you really want a separator between the chip name
> > and the id, because "tsl25500" will be confusing as hell.
>
> The length is fine with the restriction above, but I agree we need a separation
> (hadn't really thought this through!).

The length is fine until someone needs more sensors, changes
TSL2550_DEV_MAX to 16, and then the code crashes and nobody knows why.
You can't assume that other developers won't touch your code. Thus it
is much better to handle a given limitation in a single place. Here you
can simply check the value returned by snprintf() and then you know if
your name was correctly set.

Again, not that it matters, because the name buffer should simply be
large enough that it always fits.

-- 
Jean Delvare

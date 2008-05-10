Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYEJIgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYEJIgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 04:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYEJIgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 04:36:12 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:34544 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYEJIgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 04:36:10 -0400
Date: Sat, 10 May 2008 10:35:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Alexander Bigga <ab@mycable.de>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       i2c@lm-sensors.org, rtc-linux@googlegroups.com,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 4/4] RTC: SMBus support for the M41T80
Message-ID: <20080510103544.701c7b3f@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.55.0805100116290.10552@cliff.in.clinika.pl>
References: <200805070120.03821.david-b@pacbell.net>
	<Pine.LNX.4.55.0805072226180.25644@cliff.in.clinika.pl>
	<20080508093456.340a42b0@hyperion.delvare>
	<Pine.LNX.4.55.0805091917370.10552@cliff.in.clinika.pl>
	<20080509222754.03de1c54@hyperion.delvare>
	<Pine.LNX.4.55.0805100116290.10552@cliff.in.clinika.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,

On Sat, 10 May 2008 02:35:18 +0100 (BST), Maciej W. Rozycki wrote:
> > >  Ah, I see -- I must have missed it from documentation or perhaps it is
> > > somewhat unclear.  You mean our I2C API implies a driver for a
> > 
> > It's documented in Documentation/i2c/functionality. If something is
> > unclear, please let me know and/or send a patch.
> 
>  Well, I had a look at this file while writing my changes and this is the 
> very thing that is unclear.  The only place the description refers to 
> emulation is the I2C_FUNC_SMBUS_EMUL flag and there is nothing said
> about any other I2C_FUNC_SMBUS_* flag in the context of emulation.  The 
> rest of the file refers to functionality provided by the adapter, which 
> can be reasonably assumed to be such provided directly by hardware.

OK, I've just spent some time trying to improve this piece of
documentation. I'll send it to you and the i2c list in a moment, to not
overload this thread. Please tell me if my proposed changes make the
document clearer.

> (...)
>  Will see.  For now here is a new version of the change -- aside taking 
> your and other people's comments into account I have improved the logic 
> behind required bus adapter's feature determination.

Only commenting on the i2c bits...

> -static int m41t80_get_datetime(struct i2c_client *client,
> -			       struct rtc_time *tm)
> +
> +static int m41t80_transfer(struct i2c_client *client, int write,
> +			   u8 reg, u8 num, u8 *buf)
>  {
> -	u8 buf[M41T80_DATETIME_REG_SIZE], dt_addr[1] = { M41T80_REG_SEC };
> -	struct i2c_msg msgs[] = {
> -		{
> -			.addr	= client->addr,
> -			.flags	= 0,
> -			.len	= 1,
> -			.buf	= dt_addr,
> -		},
> -		{
> -			.addr	= client->addr,
> -			.flags	= I2C_M_RD,
> -			.len	= M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
> -			.buf	= buf + M41T80_REG_SEC,
> -		},
> -	};
> +	int i, rc;
>  
> -	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
> -		dev_err(&client->dev, "read error\n");
> -		return -EIO;
> +	if (write) {
> +		if (i2c_check_functionality(client->adapter,
> +					    I2C_FUNC_SMBUS_WRITE_I2C_BLOCK)) {
> +			i = i2c_smbus_write_i2c_block_data(client,
> +							   reg, num, buf);
> +		} else {
> +			for (i = 0; i < num; i++) {
> +				rc = i2c_smbus_write_byte_data(client, reg + i,
> +							       buf[i]);
> +				if (rc < 0) {
> +					i = rc;
> +					goto out;
> +				}
> +			}
> +		}
> +	} else {
> +		if (i2c_check_functionality(client->adapter,
> +					    I2C_FUNC_SMBUS_READ_I2C_BLOCK)) {
> +			i = i2c_smbus_read_i2c_block_data(client,
> +							  reg, num, buf);
> +		} else {
> +			for (i = 0; i < num; i++) {
> +				rc = i2c_smbus_read_byte_data(client, reg + i);
> +				if (rc < 0) {
> +					i = rc;
> +					goto out;
> +				}
> +				buf[i] = rc;
> +			}
> +		}
>  	}
> +out:
> +	return i;
> +}

I don't understand why you insist on having a single m41t80_transfer()
function for read and write transactions, when the read and write cases
share zero code. Separate functions would perform better.

> (...)
> -	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C
> -				     | I2C_FUNC_SMBUS_BYTE_DATA)) {
> +	func = i2c_get_functionality(client->adapter);
> +	if (!(func & (I2C_FUNC_SMBUS_READ_I2C_BLOCK |
> +		      I2C_FUNC_SMBUS_READ_BYTE)) ||
> +	    !(func & (I2C_FUNC_SMBUS_WRITE_I2C_BLOCK |
> +		      I2C_FUNC_SMBUS_WRITE_BYTE))) {
>  		rc = -ENODEV;
>  		goto exit;
>  	}

Still not correct, sorry. The driver is still making unconditional
calls to i2c_smbus_read_byte_data() and i2c_smbus_write_byte_data(), so
the underlying adapter _must_ support I2C_FUNC_SMBUS_READ_BYTE_DATA and
I2C_FUNC_SMBUS_WRITE_BYTE_DATA (i.e. I2C_FUNC_SMBUS_BYTE_DATA), even if
it also supports the block transactions. Also, you don't have to check
for the availability of these block transactions at this point, because
you test for them at run-time in m41t80_transfer(), and the driver will
work find without them.

So the proper test here would simply be:

	if (!i2c_check_functionality(client->adapter,
				     I2C_FUNC_SMBUS_BYTE_DATA)) {
 		rc = -ENODEV;
 		goto exit;
 	}

-- 
Jean Delvare

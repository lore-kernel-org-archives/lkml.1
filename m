Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbYJ3IQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbYJ3IQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 04:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYJ3IQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 04:16:37 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:34468 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750705AbYJ3IQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 04:16:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0/dS15nLQvVduBTJB5AT/7uDFcDFUX7DJQjVnGbQ1nef6hhoJY6C0S3Wz1octjigYNhibxGlUE22aYdUav1gJAVtlEqK/9d+AUlpLv5w8PW3foyyC2LE8U08ubavU3eTIocUmjwZnYk45KSFmY0cbrbci2smiFznL5WAJfVxMHs=  ;
X-YMail-OSG: ASlU8CYVM1kfI1urDngWyg81SxQlR6IlqymviddVl4dxygaCeyKJx5c7WlOiRjjbvPGaUKX1bgeTla17NYsAXWD16i2aWI4J4GRhgdpeOmwkWk_nt9lkdo8V8ywoXCPhaXze5kyIfOOZ_b36Bo48.sW5ALqMUOIBQ66I27oJ4MymQpGgq91NwmdP_6_x
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Nate Case <ncase@xes-inc.com>
Subject: Re: [PATCH] rtc-ds1307: Reset bogus register values on m41t00
Date: Thu, 30 Oct 2008 01:16:32 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <1225301377-9092-1-git-send-email-ncase@xes-inc.com>
In-Reply-To: <1225301377-9092-1-git-send-email-ncase@xes-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810300116.33131.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2008, Nate Case wrote:
> On the M41T00, registers are in a random state if the Vbat power
> was lost before the driver probes it (regardless of whether or
> not the oscillator is still running).  In this case, give all
> registers valid values so that the bogus values don't cause it to
> error out and skip the device.

Hmm, you're doing this also for the ds1307 -- not just m41t00.
Do you know that the ds1307 has this same problem?  We've had
at least one recent report that it doesn't; see LKML archives
for the discussion preceding the patch at the URL below.

Seems to me it would be good to do this whenever the oscillator
gets (re)started, not just for m41t00 chips ... when the clock
value is garbage, it can't hurt to initialize it.

Also, can you rework this so it applies on top of the patch
removing these register checks?  It's in the MM tree now, and
is archived at

  http://groups.google.com/group/rtc-linux/browse_thread/thread/96f89b3d8201dfef

That rework probably won't be more than removing the last bit of
the patch you sent.  (And didn't you get a compiler warning about
the unused "exit_bad" label?)


> 
> Signed-off-by: Nate Case <ncase@xes-inc.com>
> ---
>  drivers/rtc/rtc-ds1307.c |   61 +++++++++++++++++++++++++++++++++++----------
>  1 files changed, 47 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
> index 162330b..aec17bb 100644
> --- a/drivers/rtc/rtc-ds1307.c
> +++ b/drivers/rtc/rtc-ds1307.c
> @@ -198,6 +198,29 @@ static irqreturn_t ds1307_irq(int irq, void *dev_id)
>  
>  /*----------------------------------------------------------------------*/
>  
> +static int ds1307_regs_valid(struct ds1307 *ds1307)
> +{
> +	int tmp, valid = 1;
> +
> +	tmp = bcd2bin(ds1307->regs[DS1307_REG_SECS] & 0x7f);
> +	if (tmp > 60)
> +		valid = 0;
> +
> +	tmp = bcd2bin(ds1307->regs[DS1307_REG_MIN] & 0x7f);
> +	if (tmp > 60)
> +		valid = 0;
> +
> +	tmp = bcd2bin(ds1307->regs[DS1307_REG_MDAY] & 0x3f);
> +	if (tmp == 0 || tmp > 31)
> +		valid = 0;
> +
> +	tmp = bcd2bin(ds1307->regs[DS1307_REG_MONTH] & 0x1f);
> +	if (tmp == 0 || tmp > 12)
> +		valid = 0;
> +
> +	return valid;
> +}
> +
>  static int ds1307_get_time(struct device *dev, struct rtc_time *t)
>  {
>  	struct ds1307	*ds1307 = dev_get_drvdata(dev);
> @@ -571,6 +594,7 @@ static int __devinit ds1307_probe(struct i2c_client *client,
>  	const struct chip_desc	*chip = &chips[id->driver_data];
>  	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
>  	int			want_irq = false;
> +	int			already_reset = false;
>  
>  	if (!i2c_check_functionality(adapter,
>  			I2C_FUNC_I2C | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
> @@ -663,6 +687,28 @@ read_rtc:
>  	switch (ds1307->type) {
>  	case ds_1307:
>  	case m41t00:
> +		/*
> +		 * Registers can be in random state if the Vbat power
> +		 * was lost, and sometimes this will happen even with
> +		 * the oscillator running.  Give all registers valid
> +		 * values so that the bogus values don't cause it to
> +		 * error out later on.
> +		 */
> +		if (!ds1307_regs_valid(ds1307)) {
> +			if (already_reset)
> +				goto exit_bad;
> +			i2c_smbus_write_byte_data(client, DS1307_REG_YEAR, 1);
> +			i2c_smbus_write_byte_data(client, DS1307_REG_MONTH, 1);
> +			i2c_smbus_write_byte_data(client, DS1307_REG_MDAY, 1);
> +			i2c_smbus_write_byte_data(client, DS1307_REG_WDAY, 1);
> +			i2c_smbus_write_byte_data(client, DS1307_REG_HOUR, 0);
> +			i2c_smbus_write_byte_data(client, DS1307_REG_MIN, 0);
> +			i2c_smbus_write_byte_data(client, DS1307_REG_SECS, 1);
> +			dev_warn(&client->dev, "reset bogus registers\n");
> +			already_reset = true;
> +			goto read_rtc;
> +		}
> +
>  		/* clock halted?  turn it on, so clock can tick. */
>  		if (tmp & DS1307_BIT_CH) {
>  			i2c_smbus_write_byte_data(client, DS1307_REG_SECS, 0);
> @@ -707,20 +753,7 @@ read_rtc:
>  		break;
>  	}
>  
> -	tmp = ds1307->regs[DS1307_REG_SECS];
> -	tmp = bcd2bin(tmp & 0x7f);
> -	if (tmp > 60)
> -		goto exit_bad;
> -	tmp = bcd2bin(ds1307->regs[DS1307_REG_MIN] & 0x7f);
> -	if (tmp > 60)
> -		goto exit_bad;
> -
> -	tmp = bcd2bin(ds1307->regs[DS1307_REG_MDAY] & 0x3f);
> -	if (tmp == 0 || tmp > 31)
> -		goto exit_bad;
> -
> -	tmp = bcd2bin(ds1307->regs[DS1307_REG_MONTH] & 0x1f);
> -	if (tmp == 0 || tmp > 12)
> +	if (!ds1307_regs_valid(ds1307))
>  		goto exit_bad;
>  
>  	tmp = ds1307->regs[DS1307_REG_HOUR];
> -- 
> 1.6.0.2
> 
> 



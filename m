Return-Path: <linux-kernel-owner+w=401wt.eu-S1761724AbZATKnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761724AbZATKnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761462AbZATKnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:43:18 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:37341 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298AbZATKnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:43:16 -0500
Date: Tue, 20 Jan 2009 11:43:04 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Ed Swierk <eswierk@aristanetworks.com>
Cc: linux-i2c@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       BARRE Sebastien <sbarre@sdelcc.com>
Subject: Re: [PATCH] rtc-ds1307: True SMBus compatibility
Message-ID: <20090120114304.3b956189@hyperion.delvare>
In-Reply-To: <1232409577.25123.11.camel@localhost.localdomain>
References: <1231177261.13443.20.camel@localhost.localdomain>
	<20090107142426.4be04d4d@hyperion.delvare>
	<9ae48b020901070722l77bebc6boc8fa2fd0bcc8da28@mail.gmail.com>
	<20090107162709.755982c0@hyperion.delvare>
	<1232409577.25123.11.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ed,

On Mon, 19 Jan 2009 15:59:37 -0800, Ed Swierk wrote:
> Here is an updated patch for rtc-ds1307 that allows the driver to work
> with SMBus controllers like nforce2 that do not support i2c block
> transfers.  The driver now checks the capabilities of the controller and
> emulates the block transfers with SMBus byte transfers only if
> necessary.
> 
> Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>

Patch looks reasonable, with just minor objections:

> Index: linux-2.6.27.4/drivers/rtc/rtc-ds1307.c
> ===================================================================
> --- linux-2.6.27.4.orig/drivers/rtc/rtc-ds1307.c
> +++ linux-2.6.27.4/drivers/rtc/rtc-ds1307.c
> @@ -94,6 +94,10 @@ struct ds1307 {
>  	struct i2c_client	*client;
>  	struct rtc_device	*rtc;
>  	struct work_struct	work;
> +	s32 (*read_block_data)(struct i2c_client *client, u8 command,
> +			       u8 length, u8 *values);
> +	s32 (*write_block_data)(struct i2c_client *client, u8 command,
> +				u8 length, const u8 *values);
>  };
>  
>  struct chip_desc {
> @@ -132,6 +136,61 @@ MODULE_DEVICE_TABLE(i2c, ds1307_id);
>  
>  /*----------------------------------------------------------------------*/
>  
> +static s32 ds1307_read_block_data_once(struct i2c_client *client, u8 command,
> +				  u8 length, u8 *values)
> +{
> +	s32 i, data;
> +	for (i = 0; i < length; i++) {
> +		data = i2c_smbus_read_byte_data(client, command + i);
> +		if (data < 0)
> +			return data;
> +		*(values + i) = data;
> +	}
> +	return i;
> +}
> +
> +static s32 ds1307_read_block_data(struct i2c_client *client, u8 command,
> +				  u8 length, u8 *values)
> +{
> +	u8 oldvalues[I2C_SMBUS_BLOCK_MAX];
> +	s32 ret;
> +	pr_debug("ds1307_read_block_data (length=%d)\n", length);

Please use dev_dbg(&client->dev, ...).

> +	ret = ds1307_read_block_data_once(client, command, length, values);
> +	if (ret < 0)
> +		return ret;
> +	do {
> +		s32 ret;

Redeclaring a variable that already exists?

> +		memcpy(oldvalues, values, length);
> +		ret = ds1307_read_block_data_once(client, command, length, values);
> +		if (ret < 0)
> +			return ret;
> +	} while (memcmp(oldvalues, values, length));

What guarantee do you have that you'll ever leave this loop?

> +	return length;
> +}
> +
> +static s32 ds1307_write_block_data(struct i2c_client *client, u8 command,
> +				   u8 length, const u8 *values)
> +{
> +	u8 currvalues[I2C_SMBUS_BLOCK_MAX];
> +	pr_debug("ds1307_write_block_data (length=%d)\n", length);

dev_dbg

> +	do {
> +		s32 i, ret;
> +		for (i = 0; i < length; i++) {
> +			ret = i2c_smbus_write_byte_data(client, command + i,
> +							*(values + i));
> +			if (ret < 0)
> +				return ret;
> +		}
> +		ret = ds1307_read_block_data_once(client, command, length,
> +						  currvalues);
> +		if (ret < 0)
> +			return ret;
> +	} while (memcmp(currvalues, values, length));

Same question as above, what if you get stuck in the loop?

> +	return length;
> +}
> +
> +/*----------------------------------------------------------------------*/
> +
>  /*

All the rest is fine.

-- 
Jean Delvare

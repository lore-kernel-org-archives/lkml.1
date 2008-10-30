Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbYJ3NNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbYJ3NNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 09:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbYJ3NNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 09:13:04 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:43991 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbYJ3NNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 09:13:02 -0400
Date: Thu, 30 Oct 2008 14:12:53 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: i2c: struct device - replace bus_id with dev_name(),
 dev_set_name()
Message-ID: <20081030141253.6405b739@hyperion.delvare>
In-Reply-To: <1225330161.5970.86.camel@nga.site>
References: <1225330161.5970.86.camel@nga.site>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kay,

On Thu, 30 Oct 2008 02:29:21 +0100, Kay Sievers wrote:
> This patch is part of a larger patch series which will remove
> the "char bus_id[20]" name string from struct device. The device
> name is managed in the kobject anyway, and without any size
> limitation, and just needlessly copied into "struct device".
> 
> To set and read the device name dev_name(dev) and dev_set_name(dev)
> must be used. If your code uses static kobjects, which it shouldn't
> do, "const char *init_name" can be used to statically provide the
> name the registered device should have. At registration time, the
> init_name field is cleared, to enforce the use of dev_name(dev) to
> access the device name at a later time.
> 
> We need to get rid of all occurrences of bus_id in the entire tree
> to be able to enable the new interface. Please apply this patch,
> and possibly convert any remaining remaining occurrences of bus_id.

OK, I'll convert all other users under drivers/i2c.

> We want to submit a patch to -next, which will remove bus_id from
> "struct device", to find the remaining pieces to convert, and finally
> switch over to the new api, which will remove the 20 bytes array
> and does no longer have a size limitation.
>
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: i2c: struct device - replace bus_id with dev_name(), dev_set_name()
> 
> Cc: Jean Delvare <khali@linux-fr.org>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
> ---
> 
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 5a485c2..ce3cd48 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -459,7 +459,7 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
>  		pr_debug("I2C adapter driver [%s] forgot to specify "
>  			 "physical device\n", adap->name);
>  	}
> -	sprintf(adap->dev.bus_id, "i2c-%d", adap->nr);
> +	dev_set_name(&adap->dev, "i2c-%d", adap->nr);
>  	adap->dev.release = &i2c_adapter_dev_release;
>  	adap->dev.class = &i2c_adapter_class;
>  	res = device_register(&adap->dev);
> @@ -845,8 +845,7 @@ int i2c_attach_client(struct i2c_client *client)
>  	} else
>  		client->dev.release = i2c_client_dev_release;
>  
> -	snprintf(&client->dev.bus_id[0], sizeof(client->dev.bus_id),
> -		"%d-%04x", i2c_adapter_id(adapter), client->addr);
> +	dev_set_name(&client->dev, "%d-%04x", i2c_adapter_id(adapter), client->addr);
>  	res = device_register(&client->dev);
>  	if (res)
>  		goto out_err;
> @@ -856,7 +855,7 @@ int i2c_attach_client(struct i2c_client *client)
>  	mutex_unlock(&adapter->clist_lock);
>  
>  	dev_dbg(&adapter->dev, "client [%s] registered with bus id %s\n",
> -		client->name, client->dev.bus_id);
> +		client->name, dev_name(&client->dev));
>  
>  	if (adapter->client_register)  {
>  		if (adapter->client_register(client)) {
> 
> 

Applied, with 2 checkpatch fixes, thanks.

-- 
Jean Delvare

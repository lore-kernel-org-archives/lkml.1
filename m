Return-Path: <linux-kernel-owner+w=401wt.eu-S1751315AbXJUBhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315AbXJUBhf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 21:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbXJUBha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 21:37:30 -0400
Received: from smtp-dmz-230-sunday.dmz.nerim.net ([195.5.254.230]:57625 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750831AbXJUBh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 21:37:29 -0400
Date: Sat, 20 Oct 2007 23:30:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Adrian Bunk <bunk@kernel.org>, "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2] ibmpex: Change printk to dev_{info,err} macros
Message-ID: <20071020233052.19e7ffbf@hyperion.delvare>
In-Reply-To: <20071019233507.GI31309@tree.beaverton.ibm.com>
References: <20071017192902.GB3778@stusta.de>
	<20071017225850.7d8a9e88@hyperion.delvare>
	<20071017221503.GC31309@tree.beaverton.ibm.com>
	<20071019105402.546da123@hyperion.delvare>
	<20071019233507.GI31309@tree.beaverton.ibm.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 16:35:07 -0700, Darrick J. Wong wrote:
> Ok, I'll change the message to be a bit more accurate.
> ---
> Clean up printk use in ibmpex.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---

Acked-by: Jean Delvare <khali@linux-fr.org>

> 
>  drivers/hwmon/ibmpex.c |   48 +++++++++++++++++++++++-------------------------
>  1 files changed, 23 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
> index c462824..9c9cdb0 100644
> --- a/drivers/hwmon/ibmpex.c
> +++ b/drivers/hwmon/ibmpex.c
> @@ -140,10 +140,10 @@ static int ibmpex_send_message(struct ibmpex_bmc_data *data)
>  
>  	return 0;
>  out1:
> -	printk(KERN_ERR "%s: request_settime=%x\n", __FUNCTION__, err);
> +	dev_err(data->bmc_device, "request_settime=%x\n", err);
>  	return err;
>  out:
> -	printk(KERN_ERR "%s: validate_addr=%x\n", __FUNCTION__, err);
> +	dev_err(data->bmc_device, "validate_addr=%x\n", err);
>  	return err;
>  }
>  
> @@ -161,14 +161,14 @@ static int ibmpex_ver_check(struct ibmpex_bmc_data *data)
>  	data->sensor_major = data->rx_msg_data[0];
>  	data->sensor_minor = data->rx_msg_data[1];
>  
> -	printk(KERN_INFO DRVNAME ": Found BMC with sensor interface "
> -	       "v%d.%d %d-%02d-%02d on interface %d\n",
> -	       data->sensor_major,
> -	       data->sensor_minor,
> -	       extract_value(data->rx_msg_data, 2),
> -	       data->rx_msg_data[4],
> -	       data->rx_msg_data[5],
> -	       data->interface);
> +	dev_info(data->bmc_device, "Found BMC with sensor interface "
> +		 "v%d.%d %d-%02d-%02d on interface %d\n",
> +		 data->sensor_major,
> +		 data->sensor_minor,
> +		 extract_value(data->rx_msg_data, 2),
> +		 data->rx_msg_data[4],
> +		 data->rx_msg_data[5],
> +		 data->interface);
>  
>  	return 0;
>  }
> @@ -212,8 +212,8 @@ static int ibmpex_query_sensor_data(struct ibmpex_bmc_data *data, int sensor)
>  	wait_for_completion(&data->read_complete);
>  
>  	if (data->rx_result || data->rx_msg_len < 26) {
> -		printk(KERN_ERR "Error reading sensor %d, please check.\n",
> -		       sensor);
> +		dev_err(data->bmc_device, "Error reading sensor %d.\n",
> +			sensor);
>  		return -ENOENT;
>  	}
>  
> @@ -456,8 +456,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
>  
>  	data = kzalloc(sizeof(*data), GFP_KERNEL);
>  	if (!data) {
> -		printk(KERN_ERR DRVNAME ": Insufficient memory for BMC "
> -		       "interface %d.\n", data->interface);
> +		dev_err(dev, "Insufficient memory for BMC interface.\n");
>  		return;
>  	}
>  
> @@ -471,9 +470,8 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
>  	err = ipmi_create_user(data->interface, &driver_data.ipmi_hndlrs,
>  			       data, &data->user);
>  	if (err < 0) {
> -		printk(KERN_ERR DRVNAME ": Error, unable to register user with "
> -		       "ipmi interface %d\n",
> -		       data->interface);
> +		dev_err(dev, "Unable to register user with IPMI "
> +			"interface %d\n", data->interface);
>  		goto out;
>  	}
>  
> @@ -495,9 +493,9 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
>  	data->hwmon_dev = hwmon_device_register(data->bmc_device);
>  
>  	if (IS_ERR(data->hwmon_dev)) {
> -		printk(KERN_ERR DRVNAME ": Error, unable to register hwmon "
> -		       "class device for interface %d\n",
> -		       data->interface);
> +		dev_err(data->bmc_device, "Unable to register hwmon "
> +			"device for IPMI interface %d\n",
> +			data->interface);
>  		goto out_user;
>  	}
>  
> @@ -508,7 +506,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
>  	/* Now go find all the sensors */
>  	err = ibmpex_find_sensors(data);
>  	if (err) {
> -		printk(KERN_ERR "Error %d allocating memory\n", err);
> +		dev_err(data->bmc_device, "Error %d finding sensors\n", err);
>  		goto out_register;
>  	}
>  
> @@ -561,10 +559,10 @@ static void ibmpex_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
>  	struct ibmpex_bmc_data *data = (struct ibmpex_bmc_data *)user_msg_data;
>  
>  	if (msg->msgid != data->tx_msgid) {
> -		printk(KERN_ERR "Received msgid (%02x) and transmitted "
> -		       "msgid (%02x) mismatch!\n",
> -		       (int)msg->msgid,
> -		       (int)data->tx_msgid);
> +		dev_err(data->bmc_device, "Mismatch between received msgid "
> +			"(%02x) and transmitted msgid (%02x)!\n",
> +			(int)msg->msgid,
> +			(int)data->tx_msgid);
>  		ipmi_free_recv_msg(msg);
>  		return;
>  	}
> 
> !DSPAM:47193f59493201721698080!
> 


-- 
Jean Delvare

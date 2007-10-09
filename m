Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbXJIQob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbXJIQob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 12:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbXJIQoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 12:44:24 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:55679 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbXJIQoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 12:44:23 -0400
Message-ID: <470BAFD7.10305@tiscali.nl>
Date: Tue, 09 Oct 2007 18:44:07 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
CC: "Darrick J. Wong" <djwong@us.ibm.com>, Jean Delvare <khali@linux-fr.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       haveblue@us.ibm.com
Subject: Re: [PATCH v4] IBM power meter driver
References: <20070827211446.GG32667@tree.beaverton.ibm.com> <20070828015029.GA10107@khazad-dum.debian.net> <20070828131942.18449886@hyperion.delvare> <20070828164905.GM32667@tree.beaverton.ibm.com> <20070828232504.GP32667@tree.beaverton.ibm.com> <20070911132335.GJ31992@jupiter.solarsys.private> <20070914193346.GM30825@tree.beaverton.ibm.com> <20071009120044.GP3835@jupiter.solarsys.private>
In-Reply-To: <20071009120044.GP3835@jupiter.solarsys.private>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark M. Hoffman wrote:
>> +static void ibmpex_register_bmc(int iface, struct device *dev)
>> +{
>> +	struct ibmpex_bmc_data *data;
>> +	int err;
>> +
>> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
>> +	if (!data) {
>> +		printk(KERN_ERR DRVNAME ": Insufficient memory for BMC "
>> +		       "interface %d.\n", data->interface);
>> +		return;
>> +	}
>> +
>> +	data->address.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
>> +	data->address.channel = IPMI_BMC_CHANNEL;
>> +	data->address.data[0] = 0;
>> +	data->interface = iface;
>> +	data->bmc_device = dev;
>> +
>> +	/* Create IPMI messaging interface user */
>> +	err = ipmi_create_user(data->interface, &driver_data.ipmi_hndlrs,
>> +			       data, &data->user);
>> +	if (err < 0) {
>> +		printk(KERN_ERR DRVNAME ": Error, unable to register user with "
>> +		       "ipmi interface %d\n",
>> +		       data->interface);
>> +		goto out;
>> +	}
>> +
>> +	mutex_init(&data->lock);
>> +
>> +	/* Initialize message */
>> +	data->tx_msgid = 0;
>> +	init_completion(&data->read_complete);
>> +	data->tx_message.netfn = PEX_NET_FUNCTION;
>> +	data->tx_message.cmd = PEX_COMMAND;
>> +	data->tx_message.data = data->tx_msg_data;
>> +
>> +	/* Does this BMC support PowerExecutive? */
>> +	err = ibmpex_ver_check(data);
>> +	if (err)
>> +		goto out_user;
>> +
>> +	/* Register the BMC as a HWMON class device */
>> +	data->hwmon_dev = hwmon_device_register(data->bmc_device);
>> +
>> +	if (IS_ERR(data->hwmon_dev)) {
>> +		printk(KERN_ERR DRVNAME ": Error, unable to register hwmon "
>> +		       "class device for interface %d\n",
>> +		       data->interface);
>> +		kfree(data);
>> +		return;

don't you want to goto out_user here instead?

>> +	}
>> +
>> +	/* finally add the new bmc data to the bmc data list */
>> +	dev_set_drvdata(dev, data);
>> +	list_add_tail(&data->list, &driver_data.bmc_data);
>> +
>> +	/* Now go find all the sensors */
>> +	err = ibmpex_find_sensors(data);
>> +	if (err) {
>> +		printk(KERN_ERR "Error %d allocating memory\n", err);
>> +		goto out_register;
>> +	}
>> +
>> +	return;
>> +
>> +out_register:
>> +	hwmon_device_unregister(data->hwmon_dev);
>> +out_user:
>> +	ipmi_destroy_user(data->user);
>> +out:
>> +	kfree(data);
>> +}



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbZDUNzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbZDUNzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZDUNyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:54:55 -0400
Received: from cathcart.site5.com ([74.54.107.137]:46024 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZDUNyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:54:54 -0400
Message-ID: <49EDD02B.5020407@compulab.co.il>
Date: Tue, 21 Apr 2009 16:54:51 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] voltage/current regulator consumer interface
References: <49EC8775.8060609@compulab.co.il> <20090420145627.GA5281@rakim.wolfsonmicro.main> <49EDB569.2060701@compulab.co.il> <20090421125528.GD25828@sirena.org.uk>
In-Reply-To: <20090421125528.GD25828@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Tue, Apr 21, 2009 at 03:00:41PM +0300, Mike Rapoport wrote:
> 
>> I've managed to create some preliminary "line-consumer" driver. I don't really
>> like the name, but I couldn't think of something better and "virtual" is
>> already taken :)
> 
> "userspace" or "user"?  The goal here is to let userspace applications
> be consumers.

I don't quite understand your intention here. Do you mean that it would bebetter
to use a character device rather than sysfs?

>> +static ssize_t set_state(struct device *dev, struct device_attribute *attr,
>> +			 const char *buf, size_t count)
>> +{
>> +	struct line_consumer_data *data = dev_get_drvdata(dev);
>> +	bool enabled;
>> +	int ret;
>> +
>> +	/*
>> +	 * sysfs_streq() doesn't need the \n's, but we add them so the strings
>> +	 * will be shared with show_state(), above.
>> +	 */
>> +	if (sysfs_streq(buf, "enabled\n") == 0)
>> +		enabled = true;
>> +	else if (sysfs_streq(buf, "disabled\n") == 0)
>> +		enabled = false;
> 
> I'd be inclined to also accept 1 and 0 here.
> 
>> +static DEVICE_ATTR(name, 0444, show_name, NULL);
>> +static DEVICE_ATTR(state, 0666, show_state, set_state);
> 
> Permissions for set_state() should probably be tighter?
> 
>> +	for (i = 0; i < ARRAY_SIZE(attributes); i++) {
>> +		ret = device_create_file(&pdev->dev, attributes[i]);
>> +		if (ret != 0)
>> +			goto err_create_attrs;
>> +	}
> 
> device_add_attributes()?
> 
>> +	if (pdata->init_on)
>> +		ret = regulator_bulk_enable(drvdata->num_supplies,
>> +					    drvdata->supplies);
>> +	else
>> +		ret = regulator_bulk_disable(drvdata->num_supplies,
>> +					     drvdata->supplies);
> 
> The disable case will lead to unbalanced enables and disables, loosing
> a reference to the supply.  Just don't do anything if the supplies
> should not be enabled.
> 
>> +static int regulator_line_consumer_remove(struct platform_device *pdev)
>> +{
>> +	struct line_consumer_data *drvdata = platform_get_drvdata(pdev);
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(attributes); i++)
>> +		device_remove_file(&pdev->dev, attributes[i]);
>> +
>> +	regulator_bulk_free(drvdata->num_supplies, drvdata->supplies);
>> +	kfree(drvdata->supplies);
>> +	kfree(drvdata);
>> +
>> +	return 0;
>> +}
> 
> Hrm.  You probably want to disable the supplies if you weren't using
> them here.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Sincerely yours,
Mike.




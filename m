Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbZDUMzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbZDUMzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 08:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbZDUMzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 08:55:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56322 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZDUMza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 08:55:30 -0400
Date: Tue, 21 Apr 2009 13:55:29 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] voltage/current regulator consumer interface
Message-ID: <20090421125528.GD25828@sirena.org.uk>
References: <49EC8775.8060609@compulab.co.il> <20090420145627.GA5281@rakim.wolfsonmicro.main> <49EDB569.2060701@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EDB569.2060701@compulab.co.il>
X-Cookie: Rubber bands have snappy endings!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 03:00:41PM +0300, Mike Rapoport wrote:

> I've managed to create some preliminary "line-consumer" driver. I don't really
> like the name, but I couldn't think of something better and "virtual" is
> already taken :)

"userspace" or "user"?  The goal here is to let userspace applications
be consumers.

> +static ssize_t set_state(struct device *dev, struct device_attribute *attr,
> +			 const char *buf, size_t count)
> +{
> +	struct line_consumer_data *data = dev_get_drvdata(dev);
> +	bool enabled;
> +	int ret;
> +
> +	/*
> +	 * sysfs_streq() doesn't need the \n's, but we add them so the strings
> +	 * will be shared with show_state(), above.
> +	 */
> +	if (sysfs_streq(buf, "enabled\n") == 0)
> +		enabled = true;
> +	else if (sysfs_streq(buf, "disabled\n") == 0)
> +		enabled = false;

I'd be inclined to also accept 1 and 0 here.

> +static DEVICE_ATTR(name, 0444, show_name, NULL);
> +static DEVICE_ATTR(state, 0666, show_state, set_state);

Permissions for set_state() should probably be tighter?

> +	for (i = 0; i < ARRAY_SIZE(attributes); i++) {
> +		ret = device_create_file(&pdev->dev, attributes[i]);
> +		if (ret != 0)
> +			goto err_create_attrs;
> +	}

device_add_attributes()?

> +	if (pdata->init_on)
> +		ret = regulator_bulk_enable(drvdata->num_supplies,
> +					    drvdata->supplies);
> +	else
> +		ret = regulator_bulk_disable(drvdata->num_supplies,
> +					     drvdata->supplies);

The disable case will lead to unbalanced enables and disables, loosing
a reference to the supply.  Just don't do anything if the supplies
should not be enabled.

> +static int regulator_line_consumer_remove(struct platform_device *pdev)
> +{
> +	struct line_consumer_data *drvdata = platform_get_drvdata(pdev);
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(attributes); i++)
> +		device_remove_file(&pdev->dev, attributes[i]);
> +
> +	regulator_bulk_free(drvdata->num_supplies, drvdata->supplies);
> +	kfree(drvdata->supplies);
> +	kfree(drvdata);
> +
> +	return 0;
> +}

Hrm.  You probably want to disable the supplies if you weren't using
them here.

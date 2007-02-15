Return-Path: <linux-kernel-owner+w=401wt.eu-S1161114AbXBOUMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161114AbXBOUMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161131AbXBOUMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:12:37 -0500
Received: from outmx024.isp.belgacom.be ([195.238.4.128]:53815 "EHLO
	outmx024.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161114AbXBOUMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:12:37 -0500
Message-ID: <45D4BE7E.7000109@246tNt.com>
Date: Thu, 15 Feb 2007 21:11:42 +0100
From: Sylvain Munaut <tnt@246tNt.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060615)
MIME-Version: 1.0
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
CC: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       johnrose@us.ibm.com, fenkes@de.ibm.com, pmac@au1.ibm.com
Subject: Re: [PATCH 2.6.21-rc1] ibmebus: Support dynamic addition and removal
 of	adapters
References: <200702151755.13009.hnguyen@linux.vnet.ibm.com>
In-Reply-To: <200702151755.13009.hnguyen@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hoang-Nam Nguyen wrote:
> Additionally, the uevent interface is now implemented in the driver.
>   
Mmmh, I posted a patch that added a common uevent interface for all
of_device based
bus. And that kinda clash with this one.

I think it's a much cleaner approach to make it as common as possible.
But as
"ibm,loc_code" is local to this bus it's not handled by my code. Is it
necessary
to match the correct driver ?

By the way you generate your uevent string is wrong imho:
 - it doesn't account for the fact that there can be multiple strings in
"compatible".
 - it can be a lot nicer if you use the helper add_uevent_var to fill
the event.
 - you generate a string "ibmebus:T%s:S%s:L%s" but did you just invent that
string ? I see no support for the "ibmebus" marker in mod_devicetable.h, nor
in file2alias.c nor any where else for that matter.


    Sylvain


>  
> +static int ibmebus_uevent(struct device *dev, char **envp, int num_envp,
> +			char *buffer, int buffer_size)
> +{
> +	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
> +	char *name, *cp, *loc_code;
> +	int length;
> +
> +	if (!num_envp)
> +		return -ENOMEM;
> +
> +	if (!ebus_dev->ofdev.node)
> +		return -ENODEV;
> +
> +	name = (char *)get_property(ebus_dev->ofdev.node, "name", NULL);
> +	cp = (char *)get_property(ebus_dev->ofdev.node, "compatible", NULL);
> +	loc_code = (char *)get_property(ebus_dev->ofdev.node,
> +					"ibm,loc-code", NULL);
> +	if (!(name && cp && loc_code))
> +		return -ENODEV;
> +
> +	envp[0] = buffer;
> +	length = scnprintf(buffer, buffer_size,
> +			   "MODALIAS=ibmebus:T%s:S%s:L%s",
> +			   name, cp, loc_code);
> +	if (buffer_size - length <= 0)
> +		return -ENOMEM;
> +	envp[1] = NULL;
> +
> +	return 0;
> +}
> +
>   


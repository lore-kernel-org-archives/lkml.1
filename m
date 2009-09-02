Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbZIBWjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbZIBWjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 18:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbZIBWjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 18:39:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:56193 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbZIBWjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 18:39:05 -0400
Message-ID: <4A9EF402.7090800@kernel.org>
Date: Thu, 03 Sep 2009 07:38:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Shane Huang <Shane.Huang@amd.com>
Subject: Re: [PATCH] pci: separate out pci_add_dynid()
References: <4A9E38FA.3000506@kernel.org> <20090902161048.GA5405@lackof.org>
In-Reply-To: <20090902161048.GA5405@lackof.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 02 Sep 2009 22:39:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Grant.

Grant Grundler wrote:
>> -/*
>> - * Dynamic device IDs are disabled for !CONFIG_HOTPLUG
>> - */
> 
> The comment was removed here. Ok.

Yeap, because dynids as a whole are no longer dependent on
CONFIG_HOTPLUG.

>> +	spin_lock(&drv->dynids.lock);
>> +	list_add_tail(&dynid->node, &drv->dynids.list);
>> +	spin_unlock(&drv->dynids.lock);
>> +
>> +	get_driver(&drv->driver);
> 
> Return value ignored caught my attention... But I can't say if that's wrong.
> 
> I'm not finding any documentation on get_driver() in Documentation/ .
> Looking at drivers/base/driver.c:get_driver() code, I'm confused why this
> function bothers returning struct device_driver *. My expectation is 
> the input parameter "drv" is the same as "priv->driver" that gets returned.
> No?

Yes, it is.

> In any case, if the Docbook comments for get_driver() could explain
> whatever subtle difference there is, that would be helpful.

It's one of the gripes I've had with the driver core interface.
Returning the object which had its reference bumped up is nice to do
do_something(get_driver(driver)); but it should have been made clear
that the return value always equals the input parameter.  IIRC, in the
early days of the current driver model and kref, there were intentions
to make kref somehow more capable and handle the last reference
problem from within it so that if (get_driver(driver)) test is
actually meaningful but that turned out to be not too feasible, so we
ended up with unnecessary if () around driver model get functions.  I
try to remove them whenever an affected piece of code is being
modified but there still are plenty left.  I'll update comment on
driver core get functions.

>> +/*
>> + * Dynamic device ID manipulation via sysfs is disabled for !CONFIG_HOTPLUG
>> + */
> 
> But same comment added back here. Is this comment correct?

Yes, dynid in general is enabled regardless but sysfs access is
available iff CONFIG_HOTPLUG.

> If comments are the only thing that change, please add:
>   Reviewed-by: Grant Grundler <grundler@parisc-linux.org>
> 
> This patch seems pretty straight forward.

Thanks.

-- 
tejun

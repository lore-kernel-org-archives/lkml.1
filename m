Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbXFIQdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbXFIQdR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 12:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbXFIQdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 12:33:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42790 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbXFIQdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 12:33:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <466AD638.9030409@s5r6.in-berlin.de>
Date: Sat, 09 Jun 2007 18:32:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] driver core: multithreaded device matching with dependency
References: <9D7649D18729DE4BB2BD7B494F7FEDC2041319@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <9D7649D18729DE4BB2BD7B494F7FEDC2041319@pdsmsx415.ccr.corp.intel.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> Can this mechanism solve the demand of IEEE1394 subsystem effectively?

Probably.  I don't know when I will have time to try it.

(BTW, we should actually be able to probe subunits in parallel, however
I suspect that some firmwares will not tolerate this.)

...
> +/**
> + *	device_match_thaw - renable device/driver matching and check all
> + *	pending device/driver matching.

This has to be a single line.

> + *	@thread: number of threads to do device/driver matching.
> + *
> + *	All devices are checked for driver matching, multithreaded

...
> +EXPORT_SYMBOL_GPL(device_match_freeze);
> +EXPORT_SYMBOL_GPL(device_match_thaw);

I don't know, perhaps names like "device_driver_matching_disable" and
"device_driver_matching_enable" would be more to the point.  Or do you
actually "freeze" (i.e. halt) ongoing driver probes?

> Index: linux-2.6.22-rc4/include/linux/device.h
> ===================================================================
> --- linux-2.6.22-rc4.orig/include/linux/device.h	2007-06-08
> 18:26:11.000000000 +0800
> +++ linux-2.6.22-rc4/include/linux/device.h	2007-06-09
> 19:41:03.000000000 +0800
> @@ -413,12 +413,17 @@
>  	struct klist_node	knode_driver;
>  	struct klist_node	knode_bus;
>  	struct device		*parent;
> +	struct device		*depend;

Is this core-internal now?  If not, add a comment what it does and how
it has to be written and read.

I'm curious how this has to be used; perhaps it will turn out that the
whole thing is over-engineered this way.  I.e. there might be easier
options like:
  - Let subsystems which don't want multithreaded probing at all
    disable multithreaded probing globally by a susbsystem flag.
    (Or rather, let subsystems which want multithreaded probing
    enable it globally by a subsystem flag. IOW make singlethreaded
    probing the default.  Multithreaded probing has to be tested
    thoroughly for each subsystem.)
  - Let subsystems which want only partially multithreaded probing
    serialize the necessary regions on their own by subsystem-internal
    mutexes.

However, this really depends on what the actual cost of dev->depend is.

>  	struct kobject kobj;
>  	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
>  	struct device_type	*type;
>  	unsigned		is_registered:1;
>  	unsigned		uevent_suppress:1;
> +	unsigned		is_matched:1;
> +	unsigned		is_checking:1;
> +	unsigned		is_checked:1;
> +	unsigned		singlethreaded_probe:1;
...

Ditto here:  Which of these belong to the public API?  Those flags which
are not private to the core need to be commented.

PS:  There is also a kerneldoc format for structs.  It also allows to
mark private struct members, i.e. those which do not belong to the API.
See Documentation/kernel-doc-nano-HOWTO.txt.

PPS:  Sadly, the whole struct device and some other driver core API
items lack kerneldocs.  It's ironic that the deprecated class_device is
the only drivercore struct which comes with a kerneldoc.
-- 
Stefan Richter
-=====-=-=== -==- -=--=
http://arcgraph.de/sr/

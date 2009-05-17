Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbZEQCPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbZEQCPt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 22:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZEQCPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 22:15:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40852 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752328AbZEQCPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 22:15:38 -0400
Date: Sat, 16 May 2009 19:13:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kay Sievers <kay.sievers@vrfy.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
In-Reply-To: <1242522109.2635.6.camel@poy>
Message-ID: <alpine.LFD.2.01.0905161908100.3301@localhost.localdomain>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>  <alpine.LFD.2.01.0905161644350.3301@localhost.localdomain>  <ac3eb2510905161715m7d42879bqdc0d59c465521e99@mail.gmail.com> <1242522109.2635.6.camel@poy>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 17 May 2009, Kay Sievers wrote:
> 
> This makes the oops in the driver-core, caused by the rtc driver
> unregister, go away. The original issue is also fixed in the rtc driver
> itself.

I don't think this is sufficient.

> --- a/drivers/base/driver.c
> +++ b/drivers/base/driver.c
> @@ -257,6 +257,8 @@ EXPORT_SYMBOL_GPL(driver_register);
>   */
>  void driver_unregister(struct device_driver *drv)
>  {
> +	if (!drv || !drv->p)
> +		return;
>  	driver_remove_groups(drv, drv->groups);
>  	bus_remove_driver(drv);
>  }

Ok, fine so far, but look at "driver_register()".

It will set drv->p, but then not unset it if it fails! (For a certain 
class of failures)

So for a certain failure pattern, drv->p will point to some stale value. 
Should we not clear drv->p in the "out_unregister" patch?

To confuse the thing more, there are actually "half-way failures" that 
_succeed_ in driver registration, but then return an error code. See that 
whole


	kobject_uevent(&priv->kobj, KOBJ_ADD);
	return error;

case in the "success" path driver_register(). We may return an error 
despite the fact that we actually attached the driver to bus, but 
"add_bind_files()" failed. A caller would be understandable very unhappy.

So I suspect we should do something like the appended (in addition to your 
patch). Comments?

			Linus
---

 drivers/base/bus.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index dc030f1..dcd499d 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -700,8 +700,9 @@ int bus_add_driver(struct device_driver *drv)
 	}
 
 	kobject_uevent(&priv->kobj, KOBJ_ADD);
-	return error;
+	return 0;
 out_unregister:
+	drv->p = NULL;
 	kobject_put(&priv->kobj);
 out_put_bus:
 	bus_put(bus);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbXLAMO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbXLAMO3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 07:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbXLAMOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 07:14:20 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:60476 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbXLAMOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 07:14:19 -0500
Message-ID: <47514CE2.3000600@gmail.com>
Date: Sat, 01 Dec 2007 13:00:34 +0100
From: Jiri Slaby <jirislaby@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <matthew@wil.cx>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: <linux-pm@lists.linux-foundation.org>
Cc: <drzeus@drzeus.cx>
Subject: Re: WARNING: at kernel/resource.c:189 __release_resource
References: <4745F77C.7040402@gmail.com>
	<200711301408.13422.bjorn.helgaas@hp.com> <47509393.8000703@gmail.com>
	<200711301558.13538.bjorn.helgaas@hp.com> <47511751.2010707@gmail.com>
In-Reply-To: <47511751.2010707@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2007 09:12 AM, Jiri Slaby wrote:
> On 11/30/2007 11:58 PM, Bjorn Helgaas wrote:
>> On Friday 30 November 2007 03:49:55 pm Jiri Slaby wrote:
>>> On 11/30/2007 10:08 PM, Bjorn Helgaas wrote:
>>>> On Thursday 29 November 2007 05:42:07 pm Andrew Morton wrote:
>>>>> On Thu, 29 Nov 2007 16:40:37 -0700
>>>>>> Maybe we could either remove the pnp_{stop,start}_dev() calls
>>>>>> from the suspend/resume path, or move the PNP resource management
>>>>>> out of pnp_{start,stop}_dev().
>>>>>>
>>>>>> Bjorn
>>>>>>
>>>>>> [1] http://lkml.org/lkml/2005/11/30/39
>>>>> So was this particular problem caused/exposed by
>>>>> pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch,
>>>>> or is
>>>>> it in mainline?
>>>> I'm pretty sure this problem is caused by that patch, so we
>>>> we shouldn't see this in mainline.
>>>>
>>>> Jiri, can you try the additional patch below, please?
>>>>
>>>> Index: linux-mm/drivers/pnp/driver.c
>>>> ===================================================================
>>>> --- linux-mm.orig/drivers/pnp/driver.c	2007-11-30
>>>> 13:58:25.000000000 -0700
>>>> +++ linux-mm/drivers/pnp/driver.c	2007-11-30 13:59:37.000000000
>>>> -0700
>>>> @@ -161,13 +161,6 @@
>>>>  			return error;
>>>>  	}
>>>>  
>>>> -	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE) &&
>>>> -	    pnp_can_disable(pnp_dev)) {
>>>> -		error = pnp_stop_dev(pnp_dev);
>>>> -		if (error)
>>>> -			return error;
>>>> -	}
>>>> -
>>>>  	if (pnp_dev->protocol && pnp_dev->protocol->suspend)
>>>>  		pnp_dev->protocol->suspend(pnp_dev, state);
>>>>  	return 0;
>>>> @@ -185,12 +178,6 @@
>>>>  	if (pnp_dev->protocol && pnp_dev->protocol->resume)
>>>>  		pnp_dev->protocol->resume(pnp_dev);
>>>>  
>>>> -	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE)) {
>>>> -		error = pnp_start_dev(pnp_dev);
>>>> -		if (error)
>>>> -			return error;
>>>> -	}
>>>> -
>>>>  	if (pnp_drv->resume)
>>>>  		return pnp_drv->resume(pnp_dev);
>>>>  
>>> No, it breaks suspend.
>> Thanks for trying it.  What are the symptoms?  I'd like to understand
>> why we need to stop the devices before suspend.
> 
> Ho hum, it's not so easy, it's kind of nondeterministic now. Maybe
> some other
> issue. If I remove 8250* modules from the kernel, it works. Otherwise
> it locks
> in the middle of suspend after disks and graphics go down no matter if
> the patch
> has been applied or not. Trying to investigate this further...

I didn't get it. Maybe some trolls poking around or something (maybe the
ext3 breakage which fsck fixed). It works after recompilation of the
whole tree. And the important part -- the warning has gone. Just a note,
fold this -fix into it:

diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
index f5b64ee..b0fc3ee 100644
--- a/drivers/pnp/driver.c
+++ b/drivers/pnp/driver.c
@@ -170,7 +170,6 @@ static int pnp_bus_resume(struct device *dev)
 {
 	struct pnp_dev *pnp_dev = to_pnp_dev(dev);
 	struct pnp_driver *pnp_drv = pnp_dev->driver;
-	int error;
 
 	if (!pnp_drv)
 		return 0;

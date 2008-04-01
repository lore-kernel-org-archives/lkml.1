Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbYDAFUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbYDAFUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 01:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYDAFT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 01:19:56 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:27214 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYDAFTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 01:19:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EMJfEoT2M9IFBVUsD6F/NVygyxHscBBm+Kj5ti5Y9z37gb3X2Sx1asuq06naEXG3djCWdaYNhyUDBxIcxQBUUGafw+/1u2QBQX+dyylbzXVInVdHHJJ6rI/drPQagHAoqVEVFZT7/b6hJg3Eg96ym7aT9DXv5fYDm3sN3utpvNw=
Date: Tue, 1 Apr 2008 01:19:47 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Clarifying platform_device_unregister
Message-ID: <20080401051947.GD18041@anvil.corenet.prv>
References: <45a44e480803311814q22bc85dbx9a7d128d84b7db08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45a44e480803311814q22bc85dbx9a7d128d84b7db08@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaya,

On Mon, Mar 31, 2008 at 09:14:35PM -0400, Jaya Kumar wrote:
> Hi,
> 
> I'm trying to figure out a problem I'm experiencing with
> platform_device_unregister. Here's what I'm seeing with a piece of
> test code based on corgi_pm.c:
> 
> static int mydata;
> static struct platform_device *mytest_device;
> static int __devinit mytest_init(void)
> {
>         int ret;
> 
>         mytest_device = platform_device_alloc("no_such_driver", -1);
> 
> // no_such_driver intentionally doesn't exist. i want to test this
> mytest module being insmod-ed/rmmod-ed without ever being bound to a
> platform driver.
> 
>         if (!mytest_device)
>                 return -ENOMEM;
> 
> 
>         mytest_device->dev.platform_data = &mydata;

Platform device code does kfree(pdev->dev.platform_data) unpon
unregistration, so it is not a good idea to assign address of
statically-allocated variable here. You should be using:

	platform_device_add_data(mytest_device, &mydata, sizeof(mydata));


>         ret = platform_device_add(mytest_device);
> 
>         if (ret)
>                 platform_device_put(mytest_device);
> 
>         return ret;
> }
> 
> static void mytest_exit(void)
> {
>         platform_device_unregister(mytest_device);
> }
> 
> 

Hope this helps.

-- 
Dmitry

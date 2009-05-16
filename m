Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbZEPXgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbZEPXgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 19:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbZEPXgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 19:36:36 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37232 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbZEPXgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 19:36:36 -0400
MIME-Version: 1.0
In-Reply-To: <20090516154912.a0efc677.akpm@linux-foundation.org>
References: <4A0C43C3.9090404@pardus.org.tr> <20090515174056.GD29647@elte.hu> 
	<20090515210134.758f3123@i1501.lan.towertech.it> <20090516154912.a0efc677.akpm@linux-foundation.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 17 May 2009 01:36:17 +0200
Message-ID: <ac3eb2510905161636j5137717crdb72ea94e846d4b9@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [BUG 2.6.30_rc5] Null pointer dereference in 
	rtc-cmos driver
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, mingo@elte.hu,
       =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>,
       David Brownell <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 00:49, Andrew Morton <akpm@linux-foundation.org> wrote:

> This should fix the symptoms:

> +++ a/drivers/rtc/rtc-cmos.c
> @@ -1179,7 +1179,9 @@ static int __init cmos_init(void)
>        int retval = 0;
>
>  #ifdef CONFIG_PNP
> -       pnp_register_driver(&cmos_pnp_driver);
> +       retval = pnp_register_driver(&cmos_pnp_driver);
> +       if (retval < 0)
> +               return retval;
>  #endif

That looks like a good fix.

> Can someone please test it?

I'll try to reproduce it.

>> > > [   10.428728] BUG: unable to handle kernel NULL pointer dereference at 00000018
...
>> > > [   10.459009]  [<c03037e6>] ? driver_remove_file+0xf/0x11

> But we have arguably multiple more bugs here.
> pnp_unregister_driver(unregistered-driver) shouldn't oops the kernel.
> Neither pnp_unregister_driver() nor driver_unregister() nor
> bus_remove_driver() nor driver_remove_file() nor sysfs_remove_file()
> detected this.
>
> Kay, Greg: there are already a pile of checks on that path, but it
> seems there's one missing.  Could you please take a look and decide at
> the design level where this check should be occurring?

The issue is caused by a trying to unregister a driver which never got
registered before. I guess we try to access the private part of the
driver to reach the kobject, but for unregistered drivers there is no
such thing at that time. In:
  driver_remove_file()
we try to access the private part:
  sysfs_remove_file(&drv->p->kobj, ...
and that is NULL, for an unregistered driver, I would expect.

I'll try to reproduce the issue, and see if your fix cover the real problem.
If I can reproduce it, I'll take a look where to add a check for this.

Thanks,
Kay

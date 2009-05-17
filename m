Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbZEQBCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbZEQBCB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 21:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbZEQBBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 21:01:51 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:38343 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909AbZEQBBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 21:01:50 -0400
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
From: Kay Sievers <kay.sievers@vrfy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <ac3eb2510905161715m7d42879bqdc0d59c465521e99@mail.gmail.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
	 <alpine.LFD.2.01.0905161644350.3301@localhost.localdomain>
	 <ac3eb2510905161715m7d42879bqdc0d59c465521e99@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 17 May 2009 03:01:49 +0200
Message-Id: <1242522109.2635.6.camel@poy>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-17 at 02:15 +0200, Kay Sievers wrote:
> On Sun, May 17, 2009 at 02:01, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> 
> >        [   10.428691] Error: Driver 'rtc_cmos' is already registered, aborting...
> >
> > but the driver doesn't really care whether that succeeded or not, but then
> > the platform_driver_probe fails (because the thing is already in use), so
> > then it ends up unregistering something that never got registered in the
> > first place.
> >
> > I think this is strictly speaking a bug in driver_unregister(), which is
> > too fragile. If you unregister a drivert that wasn't registered, we
> > shouldn't oops.
> >
> > But we could certainly do it at the rtc-cmos.c level too, and just not
> > unregister it if the registration failed. My gut feel is that we should
> > aim for the core driver helpers to be less fragile, though - we'll always
> > have driver bugs.
> 
> In:
>  driver_remove_file()
> we try to access the private part:
>  sysfs_remove_file(&drv->p->kobj, ...
> and that is NULL, for an unregistered driver, I would expect.
> 
> I'm looking into it.

This makes the oops in the driver-core, caused by the rtc driver
unregister, go away. The original issue is also fixed in the rtc driver
itself.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Driver Core: do not oops when driver_unregister() is called for unregistered drivers

Handle the case someone tries to unregister a non-registered driver
more gracefully.

  Error: Driver 'rtc_cmos' is already registered, aborting...
  BUG: unable to handle kernel NULL pointer dereference at 00000018
  [<c01e16ba>] sysfs_remove_file+0x1/0xf

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

 driver.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -257,6 +257,8 @@ EXPORT_SYMBOL_GPL(driver_register);
  */
 void driver_unregister(struct device_driver *drv)
 {
+	if (!drv || !drv->p)
+		return;
 	driver_remove_groups(drv, drv->groups);
 	bus_remove_driver(drv);
 }



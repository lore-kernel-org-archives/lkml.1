Return-Path: <linux-kernel-owner+w=401wt.eu-S933629AbXDARUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbXDARUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 13:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933688AbXDARUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 13:20:45 -0400
Received: from smtp.osdl.org ([65.172.181.24]:46143 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933629AbXDARUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 13:20:44 -0400
Date: Sun, 1 Apr 2007 10:17:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [bug] hung bootup in various drivers, was: "2.6.21-rc5: known
 regressions"
In-Reply-To: <20070401074929.GA4722@ucw.cz>
Message-ID: <Pine.LNX.4.64.0704011011080.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
 <20070327015929.GY16477@stusta.de> <20070330120416.GA19373@elte.hu>
 <20070401074929.GA4722@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 1 Apr 2007, Pavel Machek wrote:
> 
> > @@ -183,7 +183,8 @@ int driver_register(struct device_driver
> >  void driver_unregister(struct device_driver * drv)
> >  {
> >  	bus_remove_driver(drv);
> > -	wait_for_completion(&drv->unloaded);
> > +	if (!drv->unloaded.done)
> > +		WARN_ON(1);
> >  }
> 
> WARN_ON(!done)?

I think the whole "wait_for_completion()" is just broken. 

We asked to *unregister* the driver, not to wait for users.

I would suggest that for 2.6.21, the minimal fix is actually something 
like the appended. Comments? Ingo, does this fix things for you?

In general, I think the whole "wait for locks" or "wait for users" is 
almost always a sign of a much bigger bug in reference counting. Modules 
are special, though, since module code/data doesn't really get reference 
counted. But doing it for built-in stuff when you don't need to really 
just sounds *wrong*.

		Linus

---
 drivers/base/driver.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 1214cbd..082bfde 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -183,7 +183,14 @@ int driver_register(struct device_driver * drv)
 void driver_unregister(struct device_driver * drv)
 {
 	bus_remove_driver(drv);
-	wait_for_completion(&drv->unloaded);
+	/*
+	 * If the driver is a module, we are probably in
+	 * the module unload path, and we want to wait
+	 * for everything to unload before we can actually
+	 * finish the unload.
+	 */
+	if (drv->owner)
+		wait_for_completion(&drv->unloaded);
 }
 
 /**

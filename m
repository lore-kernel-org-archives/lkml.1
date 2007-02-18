Return-Path: <linux-kernel-owner+w=401wt.eu-S1161104AbXBRICo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161104AbXBRICo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 03:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161106AbXBRICo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 03:02:44 -0500
Received: from mail.gmx.net ([213.165.64.20]:49704 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161104AbXBRICn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 03:02:43 -0500
X-Provags-ID: V01U2FsdGVkX1/X9rQfNCPXJqJyVEP/0lHvbF2r6bY0wUfKw+TAGt
	M5mw==
Subject: Re: 2.6.20.git regression: 'PCI: add the sysfs driver name to all
	modules' causes hard hang on boot
From: Mike Galbraith <efault@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1171700401.6443.16.camel@Homer.simpson.net>
References: <1171619710.6828.24.camel@Homer.simpson.net>
	 <20070216223609.GA6165@kroah.com>
	 <1171676288.6448.9.camel@Homer.simpson.net>
	 <20070217015048.GB18591@kroah.com>
	 <1171700401.6443.16.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sun, 18 Feb 2007 09:02:32 +0100
Message-Id: <1171785752.6787.17.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-17 at 09:20 +0100, Mike Galbraith wrote:
> On Fri, 2007-02-16 at 17:50 -0800, Greg KH wrote:
> > On Sat, Feb 17, 2007 at 02:38:08AM +0100, Mike Galbraith wrote:
> > > On Fri, 2007-02-16 at 14:36 -0800, Greg KH wrote:
> > > > On Fri, Feb 16, 2007 at 10:55:10AM +0100, Mike Galbraith wrote:
> > > > > Greetings,
> > > > > 
> > > > > Per $subject, git.yesterday hangs hard on boot here. A git bisect
> > > > > fingered the commit below, which I verified via git bisect reset; git
> > > > > revert -n 725522b5453dd680412f2b6463a988e4fd148757, after which box
> > > > > boots fine.  (well, I hope I verified... i'm git-ignorant)
> > > > 
> > > > If you change CONFIG_SYSFS_DEPRECATED to Y, does that solve the problem?
> > > 
> > > It's already set.
> > 
> > It's not set in the config file you sent to me and the list :)
> 
> Oops.  (Lysdexic mouse, or friends+Aerosmith+beer+2:30A.M.:) Makes no
> difference.  Nada from nmi_watchdog either btw.

The reason it's hanging is that nobody releases the driver, so we wait
forever in driver_unregister().  With the below, box boots fine...

--- drivers/base/bus.c.org	2007-02-18 08:38:57.000000000 +0100
+++ drivers/base/bus.c	2007-02-18 08:39:09.000000000 +0100
@@ -593,6 +593,7 @@ void bus_remove_driver(struct device_dri
 	driver_detach(drv);
 	module_remove_driver(drv);
 	kobject_unregister(&drv->kobj);
+	driver_release(&drv->kobj);
 	put_bus(drv->bus);
 }
 

...but that can't be right given that the darn thing booted just fine
prior to the naming patch with an equally unhappy init_ipmi_si().  Hmm.

	-Mike


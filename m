Return-Path: <linux-kernel-owner+w=401wt.eu-S934127AbXHGUYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934127AbXHGUYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbXHGUYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:24:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34285 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757273AbXHGUYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:24:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Subject: Re: Disk spin down issue on shut down/suspend to disk
Date: Tue, 7 Aug 2007 22:33:51 +0200
User-Agent: KMail/1.9.5
Cc: "Michael Sedkowski" <sedmich@gmail.com>, trenn@suse.de,
       "Tejun Heo" <htejun@gmail.com>, "Robert Hancock" <hancockr@shaw.ca>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no> <1186514618.5622.9.camel@nx6310> <8db1092f0708071309h5cf6f68bo80b44d9a2fbeabeb@mail.gmail.com>
In-Reply-To: <8db1092f0708071309h5cf6f68bo80b44d9a2fbeabeb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708072233.52500.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 7 August 2007 22:09, Maciej Rutecki wrote:
> 2007/8/7, Michael Sedkowski <sedmich@gmail.com>:
> > I did some additional checking today...
> > On kernels prior to 2.6.22 line, the bug exists and manifests itself
> > exactly the same way. However, when I removed the "-h" flag
> > from /etc/init.d/halt, the drive spins down only once on "Power down"
> > message and there is no sign of the bug and the emergency unload count
> > remains constant. I've verified this on kernels 2.6.21.6; 2.6.20.4;
> > 2.6.18-4-686-Etch.
> > The obvious conclusion is that something must have changed it the 2.6.22
> > kernels, so that removing the "-h" has no effect.
> > I dunno if my observations are of any value, but I thought You should
> > know...
> 
> I confirm this. First 2.6.21-rcx works OK (if I remember).  In
> 2.6.22(.1) remove -h option doesn't help - only warning message
> dissapear, and double spin down also exists in suspend to disk.

Well, on my box (nx6325) with the appended (experimental) patch applied
on top of 2.6.23-rc1 with the patchset from
http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.23-rc2/patches/ , the
double spin down doesn't occur during hibernation and the system is shut down
notceably faster.

Greetings,
Rafael


---
 kernel/power/disk.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

Index: linux-2.6.23-rc2/kernel/power/disk.c
===================================================================
--- linux-2.6.23-rc2.orig/kernel/power/disk.c	2007-08-06 14:04:07.000000000 +0200
+++ linux-2.6.23-rc2/kernel/power/disk.c	2007-08-07 21:10:59.000000000 +0200
@@ -223,15 +223,23 @@ int hibernation_platform_enter(void)
 	int error;
 
 	if (hibernation_ops) {
-		kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
 		/*
 		 * We have cancelled the power transition by running
 		 * hibernation_ops->finish() before saving the image, so we
 		 * should let the firmware know that we're going to enter the
 		 * sleep state after all
 		 */
-		error = hibernation_ops->prepare();
-		sysdev_shutdown();
+		error = hibernation_ops->start();
+		if (!error) {
+			suspend_console();
+			error = device_suspend(PMSG_SUSPEND);
+		}
+		if (!error)
+			error = hibernation_ops->prepare();
+		if (!error)
+			error = disable_nonboot_cpus();
+		if (!error)
+			error = device_power_down(PMSG_SUSPEND);
 		if (!error)
 			error = hibernation_ops->enter();
 	} else {

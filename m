Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbXK3VJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbXK3VJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 16:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbXK3VJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 16:09:04 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:31228 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbXK3VJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 16:09:03 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at kernel/resource.c:189 __release_resource
Date: Fri, 30 Nov 2007 14:08:12 -0700
User-Agent: KMail/1.9.6
Cc: jirislaby@gmail.com, matthew@wil.cx, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, drzeus@drzeus.cx
References: <4745F77C.7040402@gmail.com> <200711291640.38158.bjorn.helgaas@hp.com> <20071129164207.fd7bcd30.akpm@linux-foundation.org>
In-Reply-To: <20071129164207.fd7bcd30.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711301408.13422.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 November 2007 05:42:07 pm Andrew Morton wrote:
> On Thu, 29 Nov 2007 16:40:37 -0700
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > On Monday 26 November 2007 11:05:38 pm Andrew Morton wrote:
> > > On Thu, 22 Nov 2007 22:41:16 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:
> > > > Ok, I hit the bug, suspend of 00:06 device complains about it:
> > > > WARNING: at .../kernel/resource.c:185 __release_resource()
> > > > 
> > > > Call Trace:
> > > >  [<ffffffff8023f7b5>] release_resource+0xb5/0xf0
> > > >  [<ffffffff8036cda0>] pnp_release_resources+0x70/0x130
> > > >  [<ffffffff8036db85>] pnp_stop_dev+0x45/0x90
> > > >  [<ffffffff8036c942>] pnp_bus_suspend+0x92/0xb0
> > > >  [<ffffffff803b9f73>] suspend_device+0x113/0x180
> > > >  [<ffffffff803ba330>] device_suspend+0x200/0x320
> > > >  [<ffffffff80266905>] suspend_devices_and_enter+0xa5/0x170
> > > >  [<ffffffff80266bd9>] enter_state+0x209/0x270
> > > >  [<ffffffff80266cef>] state_store+0xaf/0xf0
> > > >  [<ffffffff8032ca67>] kobj_attr_store+0x17/0x20
> > > >  [<ffffffff802e459e>] sysfs_write_file+0xce/0x140
> > > >  [<ffffffff80299cc7>] vfs_write+0xc7/0x170
> > > >  [<ffffffff8029a360>] sys_write+0x50/0x90
> > > >  [<ffffffff8020bcde>] system_call+0x7e/0x83
> > > > 
> > > > # LANG=en ll /sys/devices/pnp0/00:06/
> > > > total 0
> > > > lrwxrwxrwx 1 root root    0 Nov 22 22:35 driver -> ../../../bus/pnp/drivers/serial
> > > > -r--r--r-- 1 root root 4096 Nov 22 22:35 id
> > > > -r--r--r-- 1 root root 4096 Nov 22 22:35 options
> > > > drwxr-xr-x 2 root root    0 Nov 22 22:35 power
> > > > -rw-r--r-- 1 root root 4096 Nov 22 22:35 resources
> > > > lrwxrwxrwx 1 root root    0 Nov 22 22:35 subsystem -> ../../../bus/pnp
> > > > drwxr-xr-x 3 root root    0 Nov 22 22:35 tty
> > > > -rw-r--r-- 1 root root 4096 Nov 22 22:35 uevent
> > > 
> > > I suppose that's a genuine leak, presumably in 8250_pnp.
> > 
> > We used to have only the serial driver resource reservation.  We now
> > have an additional 00:06 resource that is the parent of the serial
> > resource, e.g.,
> > 
> >   03f8-03ff : 00:06
> >     03f8-03ff : serial
> > 
> > I think this problem happens because pnp_bus_suspend() calls
> > serial_pnp_suspend(), which suspends the driver but does nothing
> > with the resources.  Then it calls pnp_stop_dev(), which releases
> > the 00:06 resource, which still has a serial child resource.
> > 
> > The corresponding PCI code in pci_device_suspend() does not do
> > any generic device disable or resource release.  I don't know
> > why PNP disables the device on suspend.  I glanced through the
> > ACPI spec but didn't see a requirement for it.  Maybe Pierre [1]
> > remembers.
> > 
> > Maybe we could either remove the pnp_{stop,start}_dev() calls
> > from the suspend/resume path, or move the PNP resource management
> > out of pnp_{start,stop}_dev().
> > 
> > Bjorn
> > 
> > [1] http://lkml.org/lkml/2005/11/30/39
> 
> So was this particular problem caused/exposed by
> pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch, or is
> it in mainline?

I'm pretty sure this problem is caused by that patch, so we
we shouldn't see this in mainline.

Jiri, can you try the additional patch below, please?

Index: linux-mm/drivers/pnp/driver.c
===================================================================
--- linux-mm.orig/drivers/pnp/driver.c	2007-11-30 13:58:25.000000000 -0700
+++ linux-mm/drivers/pnp/driver.c	2007-11-30 13:59:37.000000000 -0700
@@ -161,13 +161,6 @@
 			return error;
 	}
 
-	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE) &&
-	    pnp_can_disable(pnp_dev)) {
-		error = pnp_stop_dev(pnp_dev);
-		if (error)
-			return error;
-	}
-
 	if (pnp_dev->protocol && pnp_dev->protocol->suspend)
 		pnp_dev->protocol->suspend(pnp_dev, state);
 	return 0;
@@ -185,12 +178,6 @@
 	if (pnp_dev->protocol && pnp_dev->protocol->resume)
 		pnp_dev->protocol->resume(pnp_dev);
 
-	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE)) {
-		error = pnp_start_dev(pnp_dev);
-		if (error)
-			return error;
-	}
-
 	if (pnp_drv->resume)
 		return pnp_drv->resume(pnp_dev);
 

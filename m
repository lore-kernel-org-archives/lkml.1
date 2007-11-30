Return-Path: <linux-kernel-owner+w=401wt.eu-S933766AbXK3Amp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766AbXK3Amp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 19:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762009AbXK3Amh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 19:42:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44200 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758311AbXK3Amg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 19:42:36 -0500
Date: Thu, 29 Nov 2007 16:42:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: jirislaby@gmail.com, matthew@wil.cx, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, drzeus@drzeus.cx
Subject: Re: WARNING: at kernel/resource.c:189 __release_resource
Message-Id: <20071129164207.fd7bcd30.akpm@linux-foundation.org>
In-Reply-To: <200711291640.38158.bjorn.helgaas@hp.com>
References: <4745F77C.7040402@gmail.com>
	<20071126220538.1aed9c33.akpm@linux-foundation.org>
	<200711291640.38158.bjorn.helgaas@hp.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 16:40:37 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Monday 26 November 2007 11:05:38 pm Andrew Morton wrote:
> > On Thu, 22 Nov 2007 22:41:16 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:
> > > Ok, I hit the bug, suspend of 00:06 device complains about it:
> > > WARNING: at .../kernel/resource.c:185 __release_resource()
> > > 
> > > Call Trace:
> > >  [<ffffffff8023f7b5>] release_resource+0xb5/0xf0
> > >  [<ffffffff8036cda0>] pnp_release_resources+0x70/0x130
> > >  [<ffffffff8036db85>] pnp_stop_dev+0x45/0x90
> > >  [<ffffffff8036c942>] pnp_bus_suspend+0x92/0xb0
> > >  [<ffffffff803b9f73>] suspend_device+0x113/0x180
> > >  [<ffffffff803ba330>] device_suspend+0x200/0x320
> > >  [<ffffffff80266905>] suspend_devices_and_enter+0xa5/0x170
> > >  [<ffffffff80266bd9>] enter_state+0x209/0x270
> > >  [<ffffffff80266cef>] state_store+0xaf/0xf0
> > >  [<ffffffff8032ca67>] kobj_attr_store+0x17/0x20
> > >  [<ffffffff802e459e>] sysfs_write_file+0xce/0x140
> > >  [<ffffffff80299cc7>] vfs_write+0xc7/0x170
> > >  [<ffffffff8029a360>] sys_write+0x50/0x90
> > >  [<ffffffff8020bcde>] system_call+0x7e/0x83
> > > 
> > > # LANG=en ll /sys/devices/pnp0/00:06/
> > > total 0
> > > lrwxrwxrwx 1 root root    0 Nov 22 22:35 driver -> ../../../bus/pnp/drivers/serial
> > > -r--r--r-- 1 root root 4096 Nov 22 22:35 id
> > > -r--r--r-- 1 root root 4096 Nov 22 22:35 options
> > > drwxr-xr-x 2 root root    0 Nov 22 22:35 power
> > > -rw-r--r-- 1 root root 4096 Nov 22 22:35 resources
> > > lrwxrwxrwx 1 root root    0 Nov 22 22:35 subsystem -> ../../../bus/pnp
> > > drwxr-xr-x 3 root root    0 Nov 22 22:35 tty
> > > -rw-r--r-- 1 root root 4096 Nov 22 22:35 uevent
> > 
> > I suppose that's a genuine leak, presumably in 8250_pnp.
> 
> We used to have only the serial driver resource reservation.  We now
> have an additional 00:06 resource that is the parent of the serial
> resource, e.g.,
> 
>   03f8-03ff : 00:06
>     03f8-03ff : serial
> 
> I think this problem happens because pnp_bus_suspend() calls
> serial_pnp_suspend(), which suspends the driver but does nothing
> with the resources.  Then it calls pnp_stop_dev(), which releases
> the 00:06 resource, which still has a serial child resource.
> 
> The corresponding PCI code in pci_device_suspend() does not do
> any generic device disable or resource release.  I don't know
> why PNP disables the device on suspend.  I glanced through the
> ACPI spec but didn't see a requirement for it.  Maybe Pierre [1]
> remembers.
> 
> Maybe we could either remove the pnp_{stop,start}_dev() calls
> from the suspend/resume path, or move the PNP resource management
> out of pnp_{start,stop}_dev().
> 
> Bjorn
> 
> [1] http://lkml.org/lkml/2005/11/30/39

So was this particular problem caused/exposed by
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch, or is
it in mainline?

Thanks.

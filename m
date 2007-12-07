Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbXLGHVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbXLGHVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 02:21:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbXLGHUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 02:20:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:61695 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbXLGHUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 02:20:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,265,1194249600"; 
   d="scan'208";a="423016545"
Subject: Re: RFC: PNP: do not stop/start devices in suspend/resume path
From: Shaohua Li <shaohua.li@intel.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, matthew@wil.cx,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, drzeus@drzeus.cx,
       linux-acpi@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Matthieu Castet <castet.matthieu@free.fr>, Len Brown <lenb@kernel.org>
In-Reply-To: <200712051124.18852.bjorn.helgaas@hp.com>
References: <4745F77C.7040402@gmail.com> <47511751.2010707@gmail.com>
	 <47514CE2.3000600@gmail.com>  <200712051124.18852.bjorn.helgaas@hp.com>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 15:13:35 +0800
Message-Id: <1197011615.21100.1.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-06 at 02:24 +0800, Bjorn Helgaas wrote:
> Re: warning on suspend-to-RAM caused by
> pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch,
> thread here: http://lkml.org/lkml/2007/11/22/110
> 
> On Saturday 01 December 2007 05:00:34 am Jiri Slaby wrote:
> > I didn't get it. Maybe some trolls poking around or something (maybe
> the
> > ext3 breakage which fsck fixed). It works after recompilation of the
> > whole tree. And the important part -- the warning has gone.
> 
> Good.  It's not clear to me whether it is safe to leave devices
> enabled while we sleep.  I don't see an actual problem, but there
> might be something related to hotplug while we're asleep or something.
> So I'll cc: some additional people who might have some insight.
> 
> 
> 
> RFC: PNP: do not stop/start devices in suspend/resume path
> 
> Do not disable PNP devices in the suspend path.  We still call
> the driver's suspend method, which should prevent further use of
> the device, and the protocol suspend method, which may put the
> device in a low-power state.
> 
> This means we will not disable the device and release its
> resources.  The driver suspend method typically does not release
> its resources in the suspend path.  For example, if we have:
> 
>   03f8-03ff : 00:06
>     03f8-03ff : serial
> 
> pnp_stop_dev() would release the 00:06 region, which still
> has a child.  This causes a warning from __release_resource
> and corrupts /proc/ioports.
> 
> However, we should do this the same way Windows does, so if
> Windows disables devices before going to sleep, we should, too.
> It doesn't *look* necessary to me because
> 
>   - In the ACPI 3.0b spec, I can't find any mention of _DIS in
>     connection with sleep.  And Device Object Notifications,
>     Section 5.6.3, Table 5-43, says we should get a bus check
>     after awakening if hardware was removed while we slept.
> 
>     This: http://msdn2.microsoft.com/en-us/library/ms810079.aspx
>     makes a similar point about how the OS re-enumerates devices
>     as a result of a power state change (3rd last paragraph of
>     text).
> 
>   - This: http://msdn2.microsoft.com/en-us/library/aa489874.aspx
>     suggests that Windows only stops a device to rebalance hardware
>     resources.
> 
> [This should go before
> pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
> for best bisect-ability.]
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> Index: linux-mm/drivers/pnp/driver.c
> ===================================================================
> --- linux-mm.orig/drivers/pnp/driver.c  2007-11-30 13:58:25.000000000
> -0700
> +++ linux-mm/drivers/pnp/driver.c       2007-12-03 09:58:35.000000000
> -0700
> @@ -161,13 +161,6 @@
>                         return error;
>         }
> 
> -       if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE) &&
> -           pnp_can_disable(pnp_dev)) {
> -               error = pnp_stop_dev(pnp_dev);
> -               if (error)
> -                       return error;
> -       }
> -
>         if (pnp_dev->protocol && pnp_dev->protocol->suspend)
>                 pnp_dev->protocol->suspend(pnp_dev, state);
>         return 0;
> @@ -177,7 +170,6 @@
>  {
>         struct pnp_dev *pnp_dev = to_pnp_dev(dev);
>         struct pnp_driver *pnp_drv = pnp_dev->driver;
> -       int error;
> 
>         if (!pnp_drv)
>                 return 0;
> @@ -185,12 +177,6 @@
>         if (pnp_dev->protocol && pnp_dev->protocol->resume)
>                 pnp_dev->protocol->resume(pnp_dev);
> 
> -       if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE)) {
> -               error = pnp_start_dev(pnp_dev);
> -               if (error)
> -                       return error;
> -       }
> -
I'd suggest keep pnp_start_dev here to prevent BIOS not or assign
different resources after a resume.

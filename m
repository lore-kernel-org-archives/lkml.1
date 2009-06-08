Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbZFHPAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbZFHPAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 11:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbZFHPAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 11:00:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40438 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbZFHPAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 11:00:45 -0400
Date: Mon, 8 Jun 2009 16:00:39 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: alan-jenkins@tuffmail.co.uk, Pekka Enberg <penberg@cs.helsinki.fi>,
       Corentin Chary <corentin.chary@gmail.com>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
Message-ID: <20090608150039.GB17579@srcf.ucam.org>
References: <20090608030732.GA7018@srcf.ucam.org> <Pine.LNX.4.44L0.0906072309560.28801-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0906072309560.28801-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 11:10:52PM -0400, Alan Stern wrote:
> On Mon, 8 Jun 2009, Matthew Garrett wrote:
> 
> > On Sun, Jun 07, 2009 at 11:03:48PM -0400, Alan Stern wrote:
> > 
> > > There's no mechanism for this.  It many environments it couldn't work,
> > > because the decision about whether to enable autosuspend is made when
> > > the device is first created (i.e., when the creation uevent is
> > > received), whereas driver binding doesn't occur until later.
> > 
> > There's a lot of power management situations where you don't end up with 
> > the optimal power configuration until a driver's bound. It's certainly 
> > possible to do this in userspace, but if we know that the hardware 
> > supported by a given driver will always work then it seems reasonable to 
> > have it whitelist autosuspend on that device.
> 
> Sure.  Such a thing could be added easily enough.  It just doesn't 
> exist now, that's all.

Something roughly like this? We'd probably also want a function call so 
drivers can do it based on the ID of the device they're handling, but in 
some cases we can probably assume that all devices supported by the 
driver will work.

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index d0a21a5..36f63a7 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -355,6 +355,8 @@ int usb_driver_claim_interface(struct usb_driver *driver,
 	iface->condition = USB_INTERFACE_BOUND;
 	mark_active(iface);
 	iface->pm_usage_cnt = !(driver->supports_autosuspend);
+	if (driver->supports_autosuspend && driver->enable_autosuspend)
+		udev->autosuspend_disabled=0;
 	usb_pm_unlock(udev);
 
 	/* if interface was already added, bind now; else let
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 3aa2cd1..b4696f2 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -819,6 +819,8 @@ struct usbdrv_wrap {
  *	added to this driver by preventing the sysfs file from being created.
  * @supports_autosuspend: if set to 0, the USB core will not allow autosuspend
  *	for interfaces bound to this driver.
+ * @enable_autosuspend: if set to 1, the USB core will automatically enable
+ *	autosuspend for interfaces bound to this driver.
  * @soft_unbind: if set to 1, the USB core will not kill URBs and disable
  *	endpoints before calling the driver's disconnect method.
  *
@@ -861,6 +863,7 @@ struct usb_driver {
 	struct usbdrv_wrap drvwrap;
 	unsigned int no_dynamic_id:1;
 	unsigned int supports_autosuspend:1;
+	unsigned int enable_autosuspend:1;
 	unsigned int soft_unbind:1;
 };
 #define	to_usb_driver(d) container_of(d, struct usb_driver, drvwrap.driver)


-- 
Matthew Garrett | mjg59@srcf.ucam.org

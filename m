Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbZGNBon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbZGNBon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 21:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZGNBom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 21:44:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:60507 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbZGNBok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 21:44:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,394,1243839600"; 
   d="scan'208";a="429960627"
Subject: Re: [PATCH 1/2] acpi: don't free non-existant backlight in acpi
	video module
From: Zhang Rui <rui.zhang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "keithp@keithp.com" <keithp@keithp.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090713164143.035152be.akpm@linux-foundation.org>
References: <1247381251-27031-1-git-send-email-keithp@keithp.com>
	 <20090713164143.035152be.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 09:45:29 +0800
Message-Id: <1247535929.5771.12.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 07:41 +0800, Andrew Morton wrote:
> > acpi: don't free non-existant backlight in acpi video module
> 
> "existent" :)
> 
> On Sat, 11 Jul 2009 23:47:31 -0700
> keithp@keithp.com wrote:
> 
> > From: Keith Packard <keithp@keithp.com>
> > 
> > acpi_video_put_one_device was attempting to remove sysfs entries and
> > unregister a backlight device without first checking that said backlight
> > device structure had been created.
> > 
> > Signed-off-by: Keith Packard <keithp@keithp.com>
> > ---
> >  drivers/acpi/video.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> > index 8851315..60ea984 100644
> > --- a/drivers/acpi/video.c
> > +++ b/drivers/acpi/video.c
> > @@ -2004,8 +2004,11 @@ static int acpi_video_bus_put_one_device(struct acpi_video_device *device)
> >  	status = acpi_remove_notify_handler(device->dev->handle,
> >  					    ACPI_DEVICE_NOTIFY,
> >  					    acpi_video_device_notify);
> > -	sysfs_remove_link(&device->backlight->dev.kobj, "device");
> > -	backlight_device_unregister(device->backlight);
> > +	if (device->backlight) {
> > +		sysfs_remove_link(&device->backlight->dev.kobj, "device");
> > +		backlight_device_unregister(device->backlight);
> > +		device->backlight = NULL;
> > +	}
> >  	if (device->cdev) {
> >  		sysfs_remove_link(&device->dev->dev.kobj,
> >  				  "thermal_cooling");
> 
> um, OK.
> 
> Under which circumstances was this observed?
> 
Only part of the ACPI video devices support backlight switching.
device->backlight is NULL for many ACPI video devices, like, CRT, TV,
DVI, etc.

> For symmetry we could instead test acpi_video_backlight_support() here.
> 
No.
device->backlight is NULL for the devices that declare to support
backlight control while provides INVALID ACPI backlight control methods.

> The patch assumes that someone initially zeroed device->backlight.  Is
> that true and reliable?

yes.

>   If so, is the 
> 
> 	memset(&device->cap, 0, sizeof(device->cap));
> 
> in acpi_video_device_find_cap() needed?
> 
right. IMO, we can remove this.
patch attached.

thanks,
rui


device->cap and video->cap is zerod initially so we don't need
to clear it again.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/video.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6/drivers/acpi/video.c
===================================================================
--- linux-2.6.orig/drivers/acpi/video.c
+++ linux-2.6/drivers/acpi/video.c
@@ -934,9 +934,6 @@ static void acpi_video_device_find_cap(s
 {
 	acpi_handle h_dummy1;
 
-
-	memset(&device->cap, 0, sizeof(device->cap));
-
 	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_ADR", &h_dummy1))) {
 		device->cap._ADR = 1;
 	}
@@ -1039,7 +1036,6 @@ static void acpi_video_bus_find_cap(stru
 {
 	acpi_handle h_dummy1;
 
-	memset(&video->cap, 0, sizeof(video->cap));
 	if (ACPI_SUCCESS(acpi_get_handle(video->device->handle, "_DOS", &h_dummy1))) {
 		video->cap._DOS = 1;
 	}




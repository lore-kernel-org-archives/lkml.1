Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbYBLP6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbYBLP6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYBLP54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:57:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:1712 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbYBLP5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:57:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,341,1199692800"; 
   d="scan'208";a="257591064"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Bug-fix]:2.6.25-rc0 Generic thermal management [Patch 1/2]: validating input parameters
Date: Tue, 12 Feb 2008 21:27:44 +0530
Message-ID: <05B550FD4BD2014E841D83547B62600802A6B2A7@bgsmsx411.gar.corp.intel.com>
In-Reply-To: <20080211133827.16140ba0.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Bug-fix]:2.6.25-rc0 Generic thermal management [Patch 1/2]: validating input parameters
Thread-Index: Achs9/DDGBEk3ZbUTVeqAV9glbBqswAl8Fpw
References: <05B550FD4BD2014E841D83547B62600802A3A1B0@bgsmsx411.gar.corp.intel.com> <20080211133827.16140ba0.akpm@linux-foundation.org>
From: "Thomas, Sujith" <sujith.thomas@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <lenb@kernel.org>, <mingo@elte.hu>, <torvalds@linux-foundation.org>,
       <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>,
       "Zhang, Rui" <rui.zhang@intel.com>
X-OriginalArrivalTime: 12 Feb 2008 15:57:51.0689 (UTC) FILETIME=[059C0B90:01C86D90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 11 Feb 2008 15:57:06 +0530
> "Thomas, Sujith" <sujith.thomas@intel.com> wrote:

> > From: Thomas Sujith <sujith.thomas@intel.com>
> > 
> > Added sanity checks for interface functions in thermal with
> > other modules such as fan, processor, video etc..
> > 
> > Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
> > ---
> > drivers/thermal/thermal.c |   69
> > +++++++++++++++++++++++++++++-----------------
> 
> The patch is fairly seriously wordwrapped.
Should be fixed now.
> 
> >  1 files changed, 44 insertions(+), 25 deletions(-)
> > 
> > Index: linux-2.6.24-rc3/drivers/thermal/thermal.c
> > ===================================================================
> > --- linux-2.6.24-rc3.orig/drivers/thermal/thermal.c
> > +++ linux-2.6.24-rc3/drivers/thermal/thermal.c
> > @@ -301,13 +301,27 @@ int thermal_zone_bind_cooling_device(str
> >  {
> >  	struct thermal_cooling_device_instance *dev;
> >  	struct thermal_cooling_device_instance *pos;
> > +	struct thermal_zone_device *pos1;
> > +	struct thermal_cooling_device *pos2;
> >  	int result;
> >  
> > +	if (!tz || !cdev)
> > +		return -EINVAL;
> 
> Is this change actually needed?  It's sloppy for a caller to be
passing
> invalid arguments into a callee, and it's not good for the callee to
just
> hide that sloppiness.
I agree; removed
> 
> > -		return NULL;
> > +		return  ERR_PTR(-EINVAL);
> 
> the patch adds several spaces like this in places where we don't
normally
> put them.
I agree; removed


From: Thomas Sujith <sujith.thomas@intel.com>

Added sanity checks for interface functions in thermal with
other modules such as fan, processor, video etc. Using ERR_PTR
to return errors.
 
Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
---
 drivers/thermal/thermal.c |   63
+++++++++++++++++++++++++++-------------------
 1 files changed, 38 insertions(+), 25 deletions(-)

Index: linux-2.6.24-rc3/drivers/thermal/thermal.c
===================================================================
--- linux-2.6.24-rc3.orig/drivers/thermal/thermal.c
+++ linux-2.6.24-rc3/drivers/thermal/thermal.c
@@ -301,13 +301,24 @@ int thermal_zone_bind_cooling_device(str
 {
 	struct thermal_cooling_device_instance *dev;
 	struct thermal_cooling_device_instance *pos;
+	struct thermal_zone_device *pos1;
+	struct thermal_cooling_device *pos2;
 	int result;
 
 	if (trip >= tz->trips ||
 	    (trip < 0 && trip != THERMAL_TRIPS_NONE))
 		return -EINVAL;
 
-	if (!tz || !cdev)
+	list_for_each_entry(pos1, &thermal_tz_list, node) {
+		if (pos1 == tz)
+			break;
+	}
+	list_for_each_entry(pos2, &thermal_cdev_list, node) {
+		if (pos2 == cdev)
+			break;
+	}
+
+	if (tz != pos1 || cdev != pos2)
 		return -EINVAL;
 
 	dev =
@@ -427,21 +438,24 @@ struct thermal_cooling_device *thermal_c
 	struct thermal_zone_device *pos;
 	int result;
 
+	if (!type)
+		return ERR_PTR(-EINVAL);
+
 	if (strlen(type) >= THERMAL_NAME_LENGTH)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	if (!ops || !ops->get_max_state || !ops->get_cur_state ||
 		!ops->set_cur_state)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	cdev = kzalloc(sizeof(struct thermal_cooling_device),
GFP_KERNEL);
 	if (!cdev)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	result = get_idr(&thermal_cdev_idr, &thermal_idr_lock,
&cdev->id);
 	if (result) {
 		kfree(cdev);
-		return NULL;
+		return ERR_PTR(result);
 	}
 
 	strcpy(cdev->type, type);
@@ -453,16 +467,14 @@ struct thermal_cooling_device *thermal_c
 	if (result) {
 		release_idr(&thermal_cdev_idr, &thermal_idr_lock,
cdev->id);
 		kfree(cdev);
-		return NULL;
+		return ERR_PTR(result);
 	}
 
 	/* sys I/F */
-	if (type) {
-		result = device_create_file(&cdev->device,
-					    &dev_attr_cdev_type);
-		if (result)
-			goto unregister;
-	}
+	result = device_create_file(&cdev->device,
+				    &dev_attr_cdev_type);
+	if (result)
+		goto unregister;
 
 	result = device_create_file(&cdev->device, &dev_attr_max_state);
 	if (result)
@@ -490,7 +502,7 @@ struct thermal_cooling_device *thermal_c
       unregister:
 	release_idr(&thermal_cdev_idr, &thermal_idr_lock, cdev->id);
 	device_unregister(&cdev->device);
-	return NULL;
+	return ERR_PTR(result);
 }
 EXPORT_SYMBOL(thermal_cooling_device_register);
 
@@ -559,18 +571,21 @@ struct thermal_zone_device *thermal_zone
 	int result;
 	int count;
 
+	if (!type)
+		return ERR_PTR(-EINVAL);
+
 	if (strlen(type) >= THERMAL_NAME_LENGTH)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	if (trips > THERMAL_MAX_TRIPS || trips < 0)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	if (!ops || !ops->get_temp)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	tz = kzalloc(sizeof(struct thermal_zone_device), GFP_KERNEL);
 	if (!tz)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&tz->cooling_devices);
 	idr_init(&tz->idr);
@@ -578,7 +593,7 @@ struct thermal_zone_device *thermal_zone
 	result = get_idr(&thermal_tz_idr, &thermal_idr_lock, &tz->id);
 	if (result) {
 		kfree(tz);
-		return NULL;
+		return ERR_PTR(result);
 	}
 
 	strcpy(tz->type, type);
@@ -591,15 +606,13 @@ struct thermal_zone_device *thermal_zone
 	if (result) {
 		release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
 		kfree(tz);
-		return NULL;
+		return ERR_PTR(result);
 	}
 
 	/* sys I/F */
-	if (type) {
-		result = device_create_file(&tz->device,
&dev_attr_type);
-		if (result)
-			goto unregister;
-	}
+	result = device_create_file(&tz->device, &dev_attr_type);
+	if (result)
+		goto unregister;
 
 	result = device_create_file(&tz->device, &dev_attr_temp);
 	if (result)
@@ -633,7 +646,7 @@ struct thermal_zone_device *thermal_zone
       unregister:
 	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
 	device_unregister(&tz->device);
-	return NULL;
+	return ERR_PTR(result);
 }
 EXPORT_SYMBOL(thermal_zone_device_register);
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbYE2R5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbYE2R5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 13:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbYE2R5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 13:57:06 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:47968 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYE2R5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 13:57:05 -0400
Date: Thu, 29 May 2008 19:56:37 +0200
Message-Id: <297064421@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: akinobu.mita@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edd: fix error paths in module_init
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+DZChKfwIjwDEi9FO57d1f2HH8QHIxzPQtvhk902i8JEQZA
 FmMdy6xEK1/3hXq0rkoEXqvTxlREkDqPUGOYzrJcUR+sMQI5Ug=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akinobu, 

it looks that your patch is fixing this one :

https://bugzilla.novell.com/show_bug.cgi?id=394571
https://bugzilla.novell.com/attachment.cgi?id=218198

i didn`t yet try, but maybe you are able to take a look and confirm ?

if this is correct - how did you manage looking two days into the future ? ;)

roland



List:       linux-kernel
Subject:    Re: [PATCH] edd: fix error paths in module_init
From:       Akinobu Mita <akinobu.mita () gmail ! com>
Date:       2008-05-24 8:13:09
Message-ID: 20080524081308.GA30441 () APFDCB5C
[Download message RAW]

On Sat, May 24, 2008 at 12:22:05AM -0500, Matt Domsch wrote:
> On Sat, May 24, 2008 at 11:03:23AM +0900, Akinobu Mita wrote:
> > This patch fixes error handlings when kzalloc() or edd_device_register()
> > failed in module_init. It needs to clean registered edd_devices before
> > return error.
> > 
> > Also this patch fixes return value of module_init. module_init should not
> > return positive value.
> 
> Thanks for these.  You caught me on holiday; I'll take a more thorough
> look when I'm back next week.

Thanks!

> > --- 2.6-git.orig/drivers/firmware/edd.c
> > +++ 2.6-git/drivers/firmware/edd.c
> > @@ -718,8 +718,7 @@ edd_device_register(struct edd_device *e
> >  {
> >  	int error;
> >  
> > -	if (!edev)
> > -		return 1;
> > +	BUG_ON(!edev);
> 
> Wouldn't WARN_ON() and return failure be sufficient?  I hate crashing
> the system when loading a driver if I can avoid it.

OK.

> > @@ -753,29 +752,36 @@ edd_init(void)
> >  
> >  	if (!edd_num_devices()) {
> >  		printk(KERN_INFO "EDD information not available.\n");
> > -		return 1;
> > +		return -ENODEV;
> >  	}
> >  
> >  	edd_kset = kset_create_and_add("edd", NULL, firmware_kobj);
> >  	if (!edd_kset)
> >  		return -ENOMEM;
> >  
> > -	for (i = 0; i < edd_num_devices() && !rc; i++) {
> > +	for (i = 0; i < edd_num_devices(); i++) {
> >  		edev = kzalloc(sizeof (*edev), GFP_KERNEL);
> > -		if (!edev)
> > -			return -ENOMEM;
> > +		if (!edev) {
> > +			rc = -ENOMEM;
> > +			goto out;
> > +		}
> >  
> >  		rc = edd_device_register(edev, i);
> >  		if (rc) {
> >  			kfree(edev);
> > -			break;
> > +			goto out;
> >  		}
> >  		edd_devices[i] = edev;
> >  	}
> >  
> > -	if (rc)
> > -		kset_unregister(edd_kset);
> > -	return rc;
> > +	return 0;
> > +out:
> > +	while (--i >= 0)
> > +		edd_device_unregister(edd_devices[i]);
> > +
> > +	kset_unregister(edd_kset);
> > +
> > +  	return rc;
> 
> I didn't really like my initial approach, but the question was: when
> you hit a failure, do you try to back completely out (unregister
> everything that had successfully registered until now), or do you
> leave the things that have succeeded, and only fail the current and
> future devices?  For my purposes, having even the first device be
> reported, even if the others couldn't be, is useful.  Hence why I
> didn't undo all the registrations on failure.

OK. This is update patch.

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: edd: fix error paths in module_init 

If kzalloc() or edd_device_register() failed in module_init, it returns
error without cleanup the devices already registered.

Rather than fixing it to back completely out (unregister everything that had
successfully registered until now) and return error, This patch makes it
have succeeded. Because having even the first device be reported, even if
the others couldn't be, is useful.

Also this patch fixes return value of module_init. module_init should not
return positive value.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
---
 drivers/firmware/edd.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

Index: 2.6-git/drivers/firmware/edd.c
===================================================================
--- 2.6-git.orig/drivers/firmware/edd.c
+++ 2.6-git/drivers/firmware/edd.c
@@ -718,8 +718,8 @@ edd_device_register(struct edd_device *e
 {
 	int error;
 
-	if (!edev)
-		return 1;
+	if (WARN_ON(!edev))
+		return -EINVAL;
 	edd_dev_set_info(edev, i);
 	edev->kobj.kset = edd_kset;
 	error = kobject_init_and_add(&edev->kobj, &edd_ktype, NULL,
@@ -744,8 +744,8 @@ static inline int edd_num_devices(void)
 static int __init
 edd_init(void)
 {
-	unsigned int i;
-	int rc=0;
+	int i;
+	int rc;
 	struct edd_device *edev;
 
 	printk(KERN_INFO "BIOS EDD facility v%s %s, %d devices found\n",
@@ -753,29 +753,27 @@ edd_init(void)
 
 	if (!edd_num_devices()) {
 		printk(KERN_INFO "EDD information not available.\n");
-		return 1;
+		return -ENODEV;
 	}
 
 	edd_kset = kset_create_and_add("edd", NULL, firmware_kobj);
 	if (!edd_kset)
 		return -ENOMEM;
 
-	for (i = 0; i < edd_num_devices() && !rc; i++) {
+	for (i = 0; i < edd_num_devices(); i++) {
 		edev = kzalloc(sizeof (*edev), GFP_KERNEL);
 		if (!edev)
-			return -ENOMEM;
+			continue;
 
 		rc = edd_device_register(edev, i);
 		if (rc) {
 			kfree(edev);
-			break;
+			continue;
 		}
 		edd_devices[i] = edev;
 	}
 
-	if (rc)
-		kset_unregister(edd_kset);
-	return rc;
+	return 0;
 }
 
 static void __exit
--
_______________________________________________________________________
EINE FÜR ALLE: die kostenlose WEB.DE-Plattform für Freunde und Deine
Homepage mit eigenem Namen. Jetzt starten! http://unddu.de/?kid=kid@mf2


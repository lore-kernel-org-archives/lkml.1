Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbXKFSSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbXKFSSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbXKFSSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:18:37 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:49254 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbXKFSSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:18:36 -0500
Subject: Re: mm snapshot broken-out-2007-11-06-02-32.tar.gz uploaded -
	build failure - rpadlpar_sysfs
From: Badari Pulavarty <pbadari@gmail.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <4730896A.9060701@linux.vnet.ibm.com>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
	 <4730896A.9060701@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 06 Nov 2007 10:19:28 -0800
Message-Id: <1194373168.25901.3.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-06 at 21:04 +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The build fails with following error
>  
>   CC      drivers/pci/hotplug/rpadlpar_sysfs.o
> drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: initializer element is not constant
> drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: (near initialization for `dlpar_io_kset.kobj.parent')
> drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: initializer element is not constant
> drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: (near initialization for `dlpar_io_kset.kobj')
> drivers/pci/hotplug/rpadlpar_sysfs.c:134: error: unknown field `ktype' specified in initializer
> drivers/pci/hotplug/rpadlpar_sysfs.c:134: warning: initialization from incompatible pointer type
> make[3]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
> make[2]: *** [drivers/pci/hotplug] Error 2
> make[1]: *** [drivers/pci] Error 2
> make: *** [drivers] Error 2
> 
> The patch, gregkh-driver-kset-convert-pci-hotplug-to-use-kset_create_and_register.patch
> is causing the build failure.

Here is the fix (against 24-rc1 mm-brokenout). Can you try it ?

Thanks,
Badari

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com> 
---
 drivers/pci/hotplug/rpadlpar_sysfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6.24-rc1/drivers/pci/hotplug/rpadlpar_sysfs.c
===================================================================
--- linux-2.6.24-rc1.orig/drivers/pci/hotplug/rpadlpar_sysfs.c	2007-11-06 10:09:10.000000000 -0800
+++ linux-2.6.24-rc1/drivers/pci/hotplug/rpadlpar_sysfs.c	2007-11-06 10:11:33.000000000 -0800
@@ -129,14 +129,13 @@ struct kobj_type ktype_dlpar_io = {
 };
 
 struct kset dlpar_io_kset = {
-	.kobj = {.ktype = &ktype_dlpar_io,
-		 .parent = &pci_hotplug_slots_kset->kobj},
-	.ktype = &ktype_dlpar_io,
+	.kobj = {.ktype = &ktype_dlpar_io},
 };
 
 int dlpar_sysfs_init(void)
 {
 	kobject_set_name(&dlpar_io_kset.kobj, DLPAR_KOBJ_NAME);
+	dlpar_io_kset.kobj.parent = &pci_hotplug_slots_kset->kobj;
 	if (kset_register(&dlpar_io_kset)) {
 		printk(KERN_ERR "rpadlpar_io: cannot register kset for %s\n",
 				kobject_name(&dlpar_io_kset.kobj));



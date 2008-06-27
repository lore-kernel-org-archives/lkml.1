Return-Path: <linux-kernel-owner+w=401wt.eu-S1763897AbYF0S15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763897AbYF0S15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761934AbYF0SZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:25:56 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11722 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753304AbYF0SZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:25:50 -0400
Date: Fri, 27 Jun 2008 12:13:18 -0600
From: dougthompson@xmission.com
To: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 6/13] EDAC core fix to use dynamic kobject
Message-ID: <48652dbe.SF7MlWWZTgLf0S/h%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Arthur Jones <ajones@riverbed.com>

Applied to linux-2.6.26-rc5-mm3

Static kobjects are not supported in linux kernel.
Convert the edac_pci_top_main_kobj from static to
dynamic.  This avoids the double free of the
edac_pci_top_main_kobj.name that we see on module
reload of the e752x edac driver (and probably
others as well).
 
In addition Greg KH <greg@kroah.com> has pointed
out that this code may be cleaned up significantly.
I will look at that as a follow-on patch, for now,
I just want the minimum fix to get this double-free
oops bug squashed...
 
Many thanks to Greg KH for his patience in showing
me what the Documentation/kobject.txt already said
(oops)...

Signed-off-by:  Arthur Jones <ajones@riverbed.com>
Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 edac_pci_sysfs.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

Index: linux-2.6.26-rc5/drivers/edac/edac_pci_sysfs.c
===================================================================
--- linux-2.6.26-rc5.orig/drivers/edac/edac_pci_sysfs.c
+++ linux-2.6.26-rc5/drivers/edac/edac_pci_sysfs.c
@@ -28,7 +28,7 @@ static int edac_pci_poll_msec = 1000;	/*
 static atomic_t pci_parity_count = ATOMIC_INIT(0);
 static atomic_t pci_nonparity_count = ATOMIC_INIT(0);
 
-static struct kobject edac_pci_top_main_kobj;
+static struct kobject *edac_pci_top_main_kobj;
 static atomic_t edac_pci_sysfs_refcount = ATOMIC_INIT(0);
 
 /* getter functions for the data variables */
@@ -83,7 +83,7 @@ static void edac_pci_instance_release(st
 	pci = to_instance(kobj);
 
 	/* decrement reference count on top main kobj */
-	kobject_put(&edac_pci_top_main_kobj);
+	kobject_put(edac_pci_top_main_kobj);
 
 	kfree(pci);	/* Free the control struct */
 }
@@ -166,7 +166,7 @@ static int edac_pci_create_instance_kobj
 	 * track the number of PCI instances we have, and thus nest
 	 * properly on keeping the module loaded
 	 */
-	main_kobj = kobject_get(&edac_pci_top_main_kobj);
+	main_kobj = kobject_get(edac_pci_top_main_kobj);
 	if (!main_kobj) {
 		err = -ENODEV;
 		goto error_out;
@@ -174,11 +174,11 @@ static int edac_pci_create_instance_kobj
 
 	/* And now register this new kobject under the main kobj */
 	err = kobject_init_and_add(&pci->kobj, &ktype_pci_instance,
-				   &edac_pci_top_main_kobj, "pci%d", idx);
+				   edac_pci_top_main_kobj, "pci%d", idx);
 	if (err != 0) {
 		debugf2("%s() failed to register instance pci%d\n",
 			__func__, idx);
-		kobject_put(&edac_pci_top_main_kobj);
+		kobject_put(edac_pci_top_main_kobj);
 		goto error_out;
 	}
 
@@ -316,9 +316,10 @@ static struct edac_pci_dev_attribute *ed
  */
 static void edac_pci_release_main_kobj(struct kobject *kobj)
 {
-
 	debugf0("%s() here to module_put(THIS_MODULE)\n", __func__);
 
+	kfree(kobj);
+
 	/* last reference to top EDAC PCI kobject has been removed,
 	 * NOW release our ref count on the core module
 	 */
@@ -369,8 +370,16 @@ static int edac_pci_main_kobj_setup(void
 		goto decrement_count_fail;
 	}
 
+	edac_pci_top_main_kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
+	if (!edac_pci_top_main_kobj) {
+		debugf1("Failed to allocate\n");
+		err = -ENOMEM;
+		goto kzalloc_fail;
+	}
+
 	/* Instanstiate the pci object */
-	err = kobject_init_and_add(&edac_pci_top_main_kobj, &ktype_edac_pci_main_kobj,
+	err = kobject_init_and_add(edac_pci_top_main_kobj,
+				   &ktype_edac_pci_main_kobj,
 				   &edac_class->kset.kobj, "pci");
 	if (err) {
 		debugf1("Failed to register '.../edac/pci'\n");
@@ -381,13 +390,16 @@ static int edac_pci_main_kobj_setup(void
 	 * for EDAC PCI, then edac_pci_main_kobj_teardown()
 	 * must be used, for resources to be cleaned up properly
 	 */
-	kobject_uevent(&edac_pci_top_main_kobj, KOBJ_ADD);
+	kobject_uevent(edac_pci_top_main_kobj, KOBJ_ADD);
 	debugf1("Registered '.../edac/pci' kobject\n");
 
 	return 0;
 
 	/* Error unwind statck */
 kobject_init_and_add_fail:
+	kfree(edac_pci_top_main_kobj);
+
+kzalloc_fail:
 	module_put(THIS_MODULE);
 
 decrement_count_fail:
@@ -414,7 +426,7 @@ static void edac_pci_main_kobj_teardown(
 	if (atomic_dec_return(&edac_pci_sysfs_refcount) == 0) {
 		debugf0("%s() called kobject_put on main kobj\n",
 			__func__);
-		kobject_put(&edac_pci_top_main_kobj);
+		kobject_put(edac_pci_top_main_kobj);
 	}
 }
 

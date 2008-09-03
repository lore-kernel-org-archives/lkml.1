Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYICQ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYICQ1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbYICQ0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:26:48 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:61971 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbYICQ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:26:47 -0400
Date: Wed, 3 Sep 2008 18:26:40 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg K-H <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [Patch 1/2] Driver core: Clarify device cleanup.
Message-ID: <20080903182640.14279526@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080903162808.36bb2405@gondolin.boeblingen.de.ibm.com>
References: <20080903162808.36bb2405@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the comments on how to use device_initialize(), device_add()
and device_register() a bit clearer - in particular, explicitly
note that put_device() must be used once we tried to add the device
to the hierarchy.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/base/core.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -524,11 +524,16 @@ static void klist_children_put(struct kl
  * device_initialize - init device structure.
  * @dev: device.
  *
- * This prepares the device for use by other layers,
- * including adding it to the device hierarchy.
+ * This prepares the device for use by other layers by initializing
+ * its fields.
  * It is the first half of device_register(), if called by
- * that, though it can also be called separately, so one
- * may use @dev's fields (e.g. the refcount).
+ * that function, though it can also be called separately, so one
+ * may use @dev's fields. In particular, get_device()/put_device()
+ * may be used for reference counting of @dev after calling this
+ * function.
+ *
+ * NOTE: Use put_device() to give up your reference instead of freeing
+ * @dev directly once you have called this function.
  */
 void device_initialize(struct device *dev)
 {
@@ -836,9 +841,13 @@ static void device_remove_sys_dev_entry(
  * This is part 2 of device_register(), though may be called
  * separately _iff_ device_initialize() has been called separately.
  *
- * This adds it to the kobject hierarchy via kobject_add(), adds it
+ * This adds @dev to the kobject hierarchy via kobject_add(), adds it
  * to the global and sibling lists for the device, then
  * adds it to the other relevant subsystems of the driver model.
+ *
+ * NOTE: _Never_ directly free @dev after calling this function, even
+ * if it returned an error! Always use put_device() to give up your
+ * reference instead.
  */
 int device_add(struct device *dev)
 {
@@ -958,6 +967,10 @@ int device_add(struct device *dev)
  * I.e. you should only call the two helpers separately if
  * have a clearly defined need to use and refcount the device
  * before it is added to the hierarchy.
+ *
+ * NOTE: _Never_ directly free @dev after calling this function, even
+ * if it returned an error! Always use put_device() to give up the
+ * reference initialized in this function instead.
  */
 int device_register(struct device *dev)
 {

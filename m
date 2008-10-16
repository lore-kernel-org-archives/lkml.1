Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbYJPRZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbYJPRZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756357AbYJPROp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:45 -0400
Received: from kroah.org ([198.145.64.141]:46990 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756335AbYJPROo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:44 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/46] Driver core: Clarify device cleanup.
Date: Thu, 16 Oct 2008 10:10:28 -0700
Message-Id: <1224177047-11859-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Make the comments on how to use device_initialize(), device_add()
and device_register() a bit clearer - in particular, explicitly
note that put_device() must be used once we tried to add the device
to the hierarchy.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index b98cb14..aac91e8 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -523,11 +523,16 @@ static void klist_children_put(struct klist_node *n)
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
@@ -835,9 +840,13 @@ static void device_remove_sys_dev_entry(struct device *dev)
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
@@ -965,6 +974,10 @@ done:
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
-- 
1.6.0.2


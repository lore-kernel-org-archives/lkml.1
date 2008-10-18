Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbYJRTEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbYJRTEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYJRTCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:02:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbYJRTCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:02:53 -0400
Date: Sat, 18 Oct 2008 11:34:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [patch 04/17] Driver core: Clarify device cleanup.
Message-ID: <20081018183404.GE14035@suse.de>
References: <20081018182721.521723254@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="driver-core-clarify-device-cleanup.patch"
In-Reply-To: <20081018183334.GA14035@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Cornelia Huck <cornelia.huck@de.ibm.com>

commit 5739411acbaa63a6c22c91e340fdcdbcc7d82a51 upstream

Make the comments on how to use device_initialize(), device_add()
and device_register() a bit clearer - in particular, explicitly
note that put_device() must be used once we tried to add the device
to the hierarchy.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/core.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -523,11 +523,16 @@ static void klist_children_put(struct kl
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

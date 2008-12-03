Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbYLCUBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbYLCUBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYLCTwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:52:23 -0500
Received: from kroah.org ([198.145.64.141]:59812 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754801AbYLCTwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:52:21 -0500
Date: Wed, 3 Dec 2008 11:50:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, kristen.c.accardi@intel.com, matthew@wil.cx,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 029/104] PCI: update pci_create_slot() to take a hotplug
	param
Message-ID: <20081203195046.GD8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-update-pci_create_slot-to-take-a-hotplug-param.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alex Chiang <achiang@hp.com>

commit 828f37683e6d3ab5912989df0d04201db7ad798e upstream.

Slot detection drivers can co-exist with hotplug drivers. The names
of the detected/claimed slots may be different depending on module
load order.

For legacy reasons, we need to allow hotplug drivers to override
the slot name if a detection driver is loaded first (and they find
the same slots).

Creating and overriding slot names should be an atomic operation,
otherwise you get a locking nightmare as various drivers race to
call pci_create_slot().

pci_create_slot() is already serialized by grabbing the pci_bus_sem.

We update the API and add a 'hotplug' param, which is:

	set if the caller is a hotplug driver
	NULL if the caller is a detection driver

pci_create_slot() does not actually use the 'hotplug' parameter in this
patch. A later patch will add the logic that uses it.

Cc: kristen.c.accardi@intel.com
Cc: matthew@wil.cx
Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/pci_slot.c                |    2 +-
 drivers/pci/hotplug/pci_hotplug_core.c |    2 +-
 drivers/pci/slot.c                     |    4 +++-
 include/linux/pci.h                    |    3 ++-
 4 files changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -150,7 +150,7 @@ register_slot(acpi_handle handle, u32 lv
 	}
 
 	snprintf(name, sizeof(name), "%u", (u32)sun);
-	pci_slot = pci_create_slot(pci_bus, device, name);
+	pci_slot = pci_create_slot(pci_bus, device, name, NULL);
 	if (IS_ERR(pci_slot)) {
 		err("pci_create_slot returned %ld\n", PTR_ERR(pci_slot));
 		kfree(slot);
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -579,7 +579,7 @@ int pci_hp_register(struct hotplug_slot 
 	 * driver and call it here again. If we've already created the
 	 * pci_slot, the interface will simply bump the refcount.
 	 */
-	pci_slot = pci_create_slot(bus, slot_nr, name);
+	pci_slot = pci_create_slot(bus, slot_nr, name, slot);
 	if (IS_ERR(pci_slot))
 		return PTR_ERR(pci_slot);
 
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -78,6 +78,7 @@ static struct kobj_type pci_slot_ktype =
  * @parent: struct pci_bus of parent bridge
  * @slot_nr: PCI_SLOT(pci_dev->devfn) or -1 for placeholder
  * @name: user visible string presented in /sys/bus/pci/slots/<name>
+ * @hotplug: set if caller is hotplug driver, NULL otherwise
  *
  * PCI slots have first class attributes such as address, speed, width,
  * and a &struct pci_slot is used to manage them. This interface will
@@ -106,7 +107,8 @@ static struct kobj_type pci_slot_ktype =
  */
 
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
-				 const char *name)
+				 const char *name,
+				 struct hotplug_slot *hotplug)
 {
 	struct pci_slot *slot;
 	int err;
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -509,7 +509,8 @@ struct pci_bus *pci_create_bus(struct de
 struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
 				int busnr);
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
-				 const char *name);
+				 const char *name,
+				 struct hotplug_slot *hotplug);
 void pci_destroy_slot(struct pci_slot *slot);
 void pci_update_slot_number(struct pci_slot *slot, int slot_nr);
 int pci_scan_slot(struct pci_bus *bus, int devfn);


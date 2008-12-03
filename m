Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbYLCUGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbYLCUGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbYLCTwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:52:49 -0500
Received: from kroah.org ([198.145.64.141]:60034 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752392AbYLCTwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:52:47 -0500
Date: Wed, 3 Dec 2008 11:51:17 -0800
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
Subject: [patch 042/104] PCI: Hotplug core: remove name
Message-ID: <20081203195117.GQ8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-hotplug-core-remove-name.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alex Chiang <achiang@hp.com>

commit 58319b802a614f10f1b5238fbde7a4b2e9a60069 upstream.

Now that the PCI core manages the 'name' for each individual
hotplug driver, and all drivers (except rpaphp) have been converted
to use hotplug_slot_name(), there is no need for the PCI hotplug
core to drag around its own copy of name either.

Cc: kristen.c.accardi@intel.com
Cc: matthew@wil.cx
Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/hotplug/pci_hotplug_core.c |    6 +++---
 include/linux/pci_hotplug.h            |    3 ---
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -533,7 +533,7 @@ static struct hotplug_slot *get_slot_fro
 
 	list_for_each (tmp, &pci_hotplug_slot_list) {
 		slot = list_entry (tmp, struct hotplug_slot, slot_list);
-		if (strcmp(slot->name, name) == 0)
+		if (strcmp(hotplug_slot_name(slot), name) == 0)
 			return slot;
 	}
 	return NULL;
@@ -611,7 +611,7 @@ int pci_hp_deregister(struct hotplug_slo
 		return -ENODEV;
 
 	mutex_lock(&pci_hp_mutex);
-	temp = get_slot_from_name(hotplug->name);
+	temp = get_slot_from_name(hotplug_slot_name(hotplug));
 	if (temp != hotplug) {
 		mutex_unlock(&pci_hp_mutex);
 		return -ENODEV;
@@ -621,7 +621,7 @@ int pci_hp_deregister(struct hotplug_slo
 
 	slot = hotplug->pci_slot;
 	fs_remove_slot(slot);
-	dbg("Removed slot %s from the list\n", hotplug->name);
+	dbg("Removed slot %s from the list\n", hotplug_slot_name(hotplug));
 
 	hotplug->release(hotplug);
 	slot->hotplug = NULL;
--- a/include/linux/pci_hotplug.h
+++ b/include/linux/pci_hotplug.h
@@ -142,8 +142,6 @@ struct hotplug_slot_info {
 
 /**
  * struct hotplug_slot - used to register a physical slot with the hotplug pci core
- * @name: the name of the slot being registered.  This string must
- * be unique amoung slots registered on this system.
  * @ops: pointer to the &struct hotplug_slot_ops to be used for this slot
  * @info: pointer to the &struct hotplug_slot_info for the initial values for
  * this slot.
@@ -153,7 +151,6 @@ struct hotplug_slot_info {
  * needs.
  */
 struct hotplug_slot {
-	char				*name;
 	struct hotplug_slot_ops		*ops;
 	struct hotplug_slot_info	*info;
 	void (*release) (struct hotplug_slot *slot);


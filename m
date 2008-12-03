Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbYLCUEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbYLCUEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbYLCTwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:52:38 -0500
Received: from kroah.org ([198.145.64.141]:59949 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754513AbYLCTwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:52:37 -0500
Date: Wed, 3 Dec 2008 11:51:04 -0800
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
       alan@lxorguk.ukuu.org.uk, kristen.c.accardi@intel.com,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 037/104] PCI: ibmphp: stop managing hotplug_slot->name
Message-ID: <20081203195104.GL8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-ibmphp-stop-managing-hotplug_slot-name.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alex Chiang <achiang@hp.com>

commit a32615a1a661f83661e8a26c3bc7763f716da8f3 upstream.

We no longer need to manage our version of hotplug_slot->name
since the PCI and hotplug core manage it on our behalf.

Now, we simply advise the PCI core of the name that we would
like, and let the core take care of the rest.

Additionally, slightly rearrange the members of struct slot
so they are naturally aligned to eliminate holes.

Cc: kristen.c.accardi@intel.com
Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/hotplug/ibmphp.h      |    5 ++---
 drivers/pci/hotplug/ibmphp_ebda.c |   20 +++++++-------------
 2 files changed, 9 insertions(+), 16 deletions(-)

--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -620,11 +620,14 @@ static u8 calculate_first_slot (u8 slot_
 	return first_slot + 1;
 
 }
+
+#define SLOT_NAME_SIZE 30
+
 static char *create_file_name (struct slot * slot_cur)
 {
 	struct opt_rio *opt_vg_ptr = NULL;
 	struct opt_rio_lo *opt_lo_ptr = NULL;
-	static char str[30];
+	static char str[SLOT_NAME_SIZE];
 	int which = 0; /* rxe = 1, chassis = 0 */
 	u8 number = 1; /* either chassis or rxe # */
 	u8 first_slot = 1;
@@ -736,7 +739,6 @@ static void release_slot(struct hotplug_
 
 	slot = hotplug_slot->private;
 	kfree(slot->hotplug_slot->info);
-	kfree(slot->hotplug_slot->name);
 	kfree(slot->hotplug_slot);
 	slot->ctrl = NULL;
 	slot->bus_on = NULL;
@@ -768,6 +770,7 @@ static int __init ebda_rsrc_controller (
 	int rc;
 	struct slot *tmp_slot;
 	struct list_head *list;
+	char name[SLOT_NAME_SIZE];
 
 	addr = hpc_list_ptr->phys_addr;
 	for (ctlr = 0; ctlr < hpc_list_ptr->num_ctlrs; ctlr++) {
@@ -931,12 +934,6 @@ static int __init ebda_rsrc_controller (
 				goto error_no_hp_info;
 			}
 
-			hp_slot_ptr->name = kmalloc(30, GFP_KERNEL);
-			if (!hp_slot_ptr->name) {
-				rc = -ENOMEM;
-				goto error_no_hp_name;
-			}
-
 			tmp_slot = kzalloc(sizeof(*tmp_slot), GFP_KERNEL);
 			if (!tmp_slot) {
 				rc = -ENOMEM;
@@ -1000,10 +997,9 @@ static int __init ebda_rsrc_controller (
 	list_for_each (list, &ibmphp_slot_head) {
 		tmp_slot = list_entry (list, struct slot, ibm_slot_list);
 
-		snprintf (tmp_slot->hotplug_slot->name, 30, "%s", create_file_name (tmp_slot));
+		snprintf(name, SLOT_NAME_SIZE, "%s", create_file_name(tmp_slot));
 		pci_hp_register(tmp_slot->hotplug_slot,
-			pci_find_bus(0, tmp_slot->bus), tmp_slot->device,
-			tmp_slot->hotplug_slot->name);
+			pci_find_bus(0, tmp_slot->bus), tmp_slot->device, name);
 	}
 
 	print_ebda_hpc ();
@@ -1013,8 +1009,6 @@ static int __init ebda_rsrc_controller (
 error:
 	kfree (hp_slot_ptr->private);
 error_no_slot:
-	kfree (hp_slot_ptr->name);
-error_no_hp_name:
 	kfree (hp_slot_ptr->info);
 error_no_hp_info:
 	kfree (hp_slot_ptr);
--- a/drivers/pci/hotplug/ibmphp.h
+++ b/drivers/pci/hotplug/ibmphp.h
@@ -707,17 +707,16 @@ struct slot {
 	u8 device;
 	u8 number;
 	u8 real_physical_slot_num;
-	char name[100];
 	u32 capabilities;
 	u8 supported_speed;
 	u8 supported_bus_mode;
+	u8 flag;		/* this is for disable slot and polling */
+	u8 ctlr_index;
 	struct hotplug_slot *hotplug_slot;
 	struct controller *ctrl;
 	struct pci_func *func;
 	u8 irq[4];
-	u8 flag;		/* this is for disable slot and polling */
 	int bit_mode;		/* 0 = 32, 1 = 64 */
-	u8 ctlr_index;
 	struct bus_info *bus_on;
 	struct list_head ibm_slot_list;
 	u8 status;


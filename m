Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbYIIKDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbYIIKDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbYIIKAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:00:44 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:40257 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbYIIKAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:00:43 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 08/13] PCI: ibmphp: stop managing hotplug_slot->name
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       Alex Chiang <achiang@hp.com>
Date: Tue, 09 Sep 2008 04:00:42 -0600
Message-ID: <20080909100042.29542.3995.stgit@bob.kio>
In-Reply-To: <20080909091813.29542.85613.stgit@bob.kio>
References: <20080909091813.29542.85613.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer need to manage our version of hotplug_slot->name
since the PCI and hotplug core manage it on our behalf.

Now, we simply advise the PCI core of the name that we would
like, and let the core take care of the rest.

Additionally, slightly rearrange the members of struct slot
so they are naturally aligned to eliminate holes.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/ibmphp.h      |    5 ++---
 drivers/pci/hotplug/ibmphp_ebda.c |   20 +++++++-------------
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/hotplug/ibmphp.h b/drivers/pci/hotplug/ibmphp.h
index 612d963..a8d391a 100644
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
diff --git a/drivers/pci/hotplug/ibmphp_ebda.c b/drivers/pci/hotplug/ibmphp_ebda.c
index 85528d6..402dc10 100644
--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -587,11 +587,14 @@ static u8 calculate_first_slot (u8 slot_num)
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
@@ -703,7 +706,6 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 
 	slot = hotplug_slot->private;
 	kfree(slot->hotplug_slot->info);
-	kfree(slot->hotplug_slot->name);
 	kfree(slot->hotplug_slot);
 	slot->ctrl = NULL;
 	slot->bus_on = NULL;
@@ -734,6 +736,7 @@ static int __init ebda_rsrc_controller (void)
 	struct bus_info *bus_info_ptr1, *bus_info_ptr2;
 	int rc;
 	struct slot *tmp_slot;
+	char name[SLOT_NAME_SIZE];
 
 	addr = hpc_list_ptr->phys_addr;
 	for (ctlr = 0; ctlr < hpc_list_ptr->num_ctlrs; ctlr++) {
@@ -897,12 +900,6 @@ static int __init ebda_rsrc_controller (void)
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
@@ -964,10 +961,9 @@ static int __init ebda_rsrc_controller (void)
 	}			/* each hpc  */
 
 	list_for_each_entry(tmp_slot, &ibmphp_slot_head, ibm_slot_list) {
-		snprintf (tmp_slot->hotplug_slot->name, 30, "%s", create_file_name (tmp_slot));
+		snprintf(name, SLOT_NAME_SIZE, "%s", create_file_name(tmp_slot));
 		pci_hp_register(tmp_slot->hotplug_slot,
-			pci_find_bus(0, tmp_slot->bus), tmp_slot->device,
-			tmp_slot->hotplug_slot->name);
+			pci_find_bus(0, tmp_slot->bus), tmp_slot->device, name);
 	}
 
 	print_ebda_hpc ();
@@ -977,8 +973,6 @@ static int __init ebda_rsrc_controller (void)
 error:
 	kfree (hp_slot_ptr->private);
 error_no_slot:
-	kfree (hp_slot_ptr->name);
-error_no_hp_name:
 	kfree (hp_slot_ptr->info);
 error_no_hp_info:
 	kfree (hp_slot_ptr);


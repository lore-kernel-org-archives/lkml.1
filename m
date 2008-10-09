Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbYJIEu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbYJIEu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 00:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbYJIErd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 00:47:33 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:19955 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890AbYJIErb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 00:47:31 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v5 12/16] PCI: rpaphp: kmalloc/kfree slot->name directly
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alex Chiang <achiang@hp.com>
Date: Wed, 08 Oct 2008 22:47:30 -0600
Message-ID: <20081009044730.8678.91003.stgit@bob.kio>
In-Reply-To: <20081009043140.8678.44164.stgit@bob.kio>
References: <20081009043140.8678.44164.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rpaphp tends to use slot->name directly everywhere, and doesn't
ever need slot->hotplug_slot->name.

struct hotplug_slot->name is going away, so convert rpaphp directly
manipulate its own slot->name everywhere, and don't bother touching
slot->hotplug_slot->name.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/rpaphp_slot.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/hotplug/rpaphp_slot.c b/drivers/pci/hotplug/rpaphp_slot.c
index 736d3b4..2ea9cf1 100644
--- a/drivers/pci/hotplug/rpaphp_slot.c
+++ b/drivers/pci/hotplug/rpaphp_slot.c
@@ -43,7 +43,7 @@ static void rpaphp_release_slot(struct hotplug_slot *hotplug_slot)
 void dealloc_slot_struct(struct slot *slot)
 {
 	kfree(slot->hotplug_slot->info);
-	kfree(slot->hotplug_slot->name);
+	kfree(slot->name);
 	kfree(slot->hotplug_slot);
 	kfree(slot);
 }
@@ -63,11 +63,9 @@ struct slot *alloc_slot_struct(struct device_node *dn,
 					   GFP_KERNEL);
 	if (!slot->hotplug_slot->info)
 		goto error_hpslot;
-	slot->hotplug_slot->name = kmalloc(strlen(drc_name) + 1, GFP_KERNEL);
-	if (!slot->hotplug_slot->name)
+	slot->name = kstrdup(drc_name, GFP_KERNEL);
+	if (!slot->name)
 		goto error_info;	
-	slot->name = slot->hotplug_slot->name;
-	strcpy(slot->name, drc_name);
 	slot->dn = dn;
 	slot->index = drc_index;
 	slot->power_domain = power_domain;


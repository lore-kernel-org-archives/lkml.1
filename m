Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbYJNH3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbYJNH3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbYJNH0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:26:11 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:25149 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319AbYJNH0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:26:09 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v6-resend 13/17] PCI: rpaphp: kmalloc/kfree slot->name directly
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alex Chiang <achiang@hp.com>
Date: Tue, 14 Oct 2008 01:26:08 -0600
Message-ID: <20081014072608.24319.15805.stgit@bob.kio>
In-Reply-To: <20081014072311.24319.27334.stgit@bob.kio>
References: <20081014072311.24319.27334.stgit@bob.kio>
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


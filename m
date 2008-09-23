Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbYIWQtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbYIWQtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbYIWQq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:46:28 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:47817 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbYIWQqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:46:25 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v3 14/14] PCI Hotplug: fakephp: add duplicate slot name
	debugging
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, Alex Chiang <achiang@hp.com>
Date: Tue, 23 Sep 2008 10:46:24 -0600
Message-ID: <20080923164624.12628.91248.stgit@bob.kio>
In-Reply-To: <20080923163753.12628.98683.stgit@bob.kio>
References: <20080923163753.12628.98683.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI core now manages slot names on behalf of slot detection
and slot hotplug drivers, including the handling of duplicate
slot names.

We can use the fakephp driver to help test the new functionality.
Add a 'dup_slots' module param to force fakephp to create multiple
slots with the same name. We can then verify that the PCI core
correctly renamed the slots.

	sapphire:/sys/bus/pci/slots # modprobe fakephp dup_slots
	sapphire:/sys/bus/pci/slots # ls
	fake    fake-10  fake-3  fake-5  fake-7  fake-9
	fake-1  fake-2   fake-4  fake-6  fake-8

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: matthew@wil.cx
Cc: kaneshige.kenji@jp.fujitsu.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/fakephp.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index 16ec767..71670a4 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -69,6 +69,7 @@ struct dummy_slot {
 };
 
 static int debug;
+static int dup_slots;
 static LIST_HEAD(slot_list);
 static struct workqueue_struct *dummyphp_wq;
 
@@ -121,7 +122,10 @@ static int add_slot(struct pci_dev *dev)
 	if (!dslot)
 		goto error_info;
 
-	snprintf(name, SLOT_NAME_SIZE, "fake%d", count++);
+	if (dup_slots)
+		snprintf(name, SLOT_NAME_SIZE, "fake");
+	else
+		snprintf(name, SLOT_NAME_SIZE, "fake%d", count++);
 	dbg("slot->name = %s\n", name);
 	slot->ops = &dummy_hotplug_slot_ops;
 	slot->release = &dummy_release;
@@ -375,4 +379,5 @@ MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 module_param(debug, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debugging mode enabled or not");
-
+module_param(dup_slots, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(dup_slots, "Force duplicate slot names for debugging");


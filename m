Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYLCUF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYLCUF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYLCTwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:52:44 -0500
Received: from kroah.org ([198.145.64.141]:59997 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751426AbYLCTwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:52:43 -0500
Date: Wed, 3 Dec 2008 11:51:10 -0800
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
       alan@lxorguk.ukuu.org.uk, kristen.c.accardi@intel.com, jpk@sgi.com,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 040/104] PCI: SGI Hotplug: stop managing
	bss_hotplug_slot->name
Message-ID: <20081203195110.GO8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-sgi-hotplug-stop-managing-bss_hotplug_slot-name.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alex Chiang <achiang@hp.com>

commit 85234ce86dfa62b779faa19a70364a06e3f7fc32 upstream.

We no longer need to manage our version of hotplug_slot->name
since the PCI and hotplug core manage it on our behalf.

Update the sn_hp_slot_private_alloc() interface to fill in
the correct name for us, as that function already has all
the parameters needed to determine the name.

Cc: kristen.c.accardi@intel.com
Cc: jpk@sgi.com
Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/hotplug/sgi_hotplug.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/drivers/pci/hotplug/sgi_hotplug.c
+++ b/drivers/pci/hotplug/sgi_hotplug.c
@@ -161,7 +161,8 @@ static int sn_pci_bus_valid(struct pci_b
 }
 
 static int sn_hp_slot_private_alloc(struct hotplug_slot *bss_hotplug_slot,
-				    struct pci_bus *pci_bus, int device)
+				    struct pci_bus *pci_bus, int device,
+				    char *name)
 {
 	struct pcibus_info *pcibus_info;
 	struct slot *slot;
@@ -173,15 +174,9 @@ static int sn_hp_slot_private_alloc(stru
 		return -ENOMEM;
 	bss_hotplug_slot->private = slot;
 
-	bss_hotplug_slot->name = kmalloc(SN_SLOT_NAME_SIZE, GFP_KERNEL);
-	if (!bss_hotplug_slot->name) {
-		kfree(bss_hotplug_slot->private);
-		return -ENOMEM;
-	}
-
 	slot->device_num = device;
 	slot->pci_bus = pci_bus;
-	sprintf(bss_hotplug_slot->name, "%04x:%02x:%02x",
+	sprintf(name, "%04x:%02x:%02x",
 		pci_domain_nr(pci_bus),
 		((u16)pcibus_info->pbi_buscommon.bs_persist_busnum),
 		device + 1);
@@ -608,7 +603,6 @@ static inline int get_power_status(struc
 static void sn_release_slot(struct hotplug_slot *bss_hotplug_slot)
 {
 	kfree(bss_hotplug_slot->info);
-	kfree(bss_hotplug_slot->name);
 	kfree(bss_hotplug_slot->private);
 	kfree(bss_hotplug_slot);
 }
@@ -618,6 +612,7 @@ static int sn_hotplug_slot_register(stru
 	int device;
 	struct pci_slot *pci_slot;
 	struct hotplug_slot *bss_hotplug_slot;
+	char name[SN_SLOT_NAME_SIZE];
 	int rc = 0;
 
 	/*
@@ -645,16 +640,14 @@ static int sn_hotplug_slot_register(stru
 		}
 
 		if (sn_hp_slot_private_alloc(bss_hotplug_slot,
-					     pci_bus, device)) {
+					     pci_bus, device, name)) {
 			rc = -ENOMEM;
 			goto alloc_err;
 		}
-
 		bss_hotplug_slot->ops = &sn_hotplug_slot_ops;
 		bss_hotplug_slot->release = &sn_release_slot;
 
-		rc = pci_hp_register(bss_hotplug_slot, pci_bus, device,
-				     bss_hotplug_slot->name);
+		rc = pci_hp_register(bss_hotplug_slot, pci_bus, device, name);
 		if (rc)
 			goto register_err;
 


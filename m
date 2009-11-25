Return-Path: <linux-kernel-owner+w=401wt.eu-S934943AbZKYUBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934943AbZKYUBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759748AbZKYUBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:01:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:56944 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759735AbZKYUBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:01:00 -0500
Message-ID: <4B0D8CB8.1070404@kernel.org>
Date: Wed, 25 Nov 2009 11:59:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH 9/9] pci: pciehp second try to get big range for pcie devices
References: <4ADEB601.8020200@kernel.org>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit! su.com> <4B0C69AD.3030106@kernel. org> <4B0D13EB.9010403@jp.fujitsu.com> <4B0D88A4.5050904@kerne!
 l.org>
In-Reply-To: <4B0D88A4.5050904@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


handle the case the slot bridge that doesn't get pre-allocated big enough res
from FW.
for example pcie devices need 256M, but the bridge only get preallocated 2M...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -970,13 +970,52 @@ void pci_assign_unassigned_bridge_resour
 {
 	struct pci_bus *bus;
 	struct pci_bus *parent = bridge->subordinate;
+	bool second_tried = false;
+	struct resource_list head, *list, *tmp;
 	int retval;
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
+
+again:
+	head.next = NULL;
 
 	pci_bus_size_bridges(parent);
 	pci_clear_master(bridge);
-	__pci_bridge_assign_resources(bridge, NULL);
+	__pci_bridge_assign_resources(bridge, &head);
 	retval = pci_reenable_device(bridge);
 	pci_set_master(bridge);
 	pci_enable_bridges(parent);
+
+	/* any device complain? */
+	if (!head.next)
+		return;
+
+	if (second_tried) {
+		/* still fail, don't want to try more */
+		free_failed_list(&head);
+		return;
+	}
+
+	second_tried = true;
+	printk(KERN_DEBUG "PCI: second try to assign unassigned res\n");
+
+	/*
+	 * Try to release leaf bridge's resources that doesn't fit resource of
+	 * child device under that bridge
+	 */
+	for (list = head.next; list;) {
+		unsigned long flags = list->res->flags;
+
+		bus = list->dev->bus;
+		if (list->dev->subordinate)
+			list->res->flags = 0;
+		pci_bus_release_unused_bridge_res(bus, flags & type_mask, 0);
+
+		tmp = list;
+		list = list->next;
+		kfree(tmp);
+	}
+
+	goto again;
 }
 EXPORT_SYMBOL_GPL(pci_assign_unassigned_bridge_resources);


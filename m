Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYDGXnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYDGXnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 19:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYDGXm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 19:42:57 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:5310 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYDGXm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:42:56 -0400
Date: Mon, 7 Apr 2008 17:42:55 -0600
From: Alex Chiang <achiang@hp.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linas@austin.ibm.com
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
Message-ID: <20080407234255.GA22514@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Badari Pulavarty <pbadari@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>, linas@austin.ibm.com
References: <1207331616.5916.15.camel@badari-desktop> <20080404180518.GA12642@ldl.fc.hp.com> <1207340371.5916.23.camel@badari-desktop> <20080404224227.GA31436@ldl.fc.hp.com> <1207352128.5916.26.camel@badari-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207352128.5916.26.camel@badari-desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Badari,

> > > pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> > > rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
> > > rpaphp_register_slot registering slot:path[/pci@800000020000003/pci@2,4] index[22010003], name[U787E.001.AAA3015-P2-C1] pdomain[22010003] type[16]
> > > Unable to handle kernel paging request for data at address 0x00000070
> > 
> > Hrm, this is a little more information, but still not quite
> > enough. I'm going to take a stab in the dark and say I'm probably
> > doing something wrong on this line, maybe dereferencing a pointer
> > incorrectly:
> > 
> >         retval = pci_hp_register(php_slot, slot->bus,
> > 				 PCI_SLOT(PCI_DN(slot->dn->child)->devfn));
> 
> Sorry. I thought you knew this already. Disassembly clearly showed
> that slot->dn->child is NULL. 
> 
> I confirmed it by adding printk also.

This patch is a complete guess on my part (since I've not been
able to understand pseries architecture) but I think it should
fix your issue.

Can you give it a try and let me know? It applies on top of the
-mm tree that includes my physical pci_slot series.

Also, I'm hoping Linas will speak up and let me know what the
real answer might be. ;)

Thanks.

/ac

From: Alex Chiang <achiang@hp.com>
Subject: rpaphp: correctly call pci_hp_register for empty PCI slots

Unpopulated device_node slots do not have children, and
attempting to dereference them will result in a panic.

Instead, attempt to derive the PCI slot number from the bus
itself, and failing that, default to 0.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
diff --git a/drivers/pci/hotplug/rpaphp_slot.c b/drivers/pci/hotplug/rpaphp_slot.c
index 0d4cfc7..91ce6a6 100644
--- a/drivers/pci/hotplug/rpaphp_slot.c
+++ b/drivers/pci/hotplug/rpaphp_slot.c
@@ -121,6 +121,7 @@ int rpaphp_register_slot(struct slot *slot)
 {
 	struct hotplug_slot *php_slot = slot->hotplug_slot;
 	int retval;
+	int slot_nr;
 
 	dbg("%s registering slot:path[%s] index[%x], name[%s] pdomain[%x] type[%d]\n", 
 		__FUNCTION__, slot->dn->full_name, slot->index, slot->name, 
@@ -132,8 +133,11 @@ int rpaphp_register_slot(struct slot *slot)
 		return -EAGAIN;
 	}	
 
-	retval = pci_hp_register(php_slot, slot->bus,
-				 PCI_SLOT(PCI_DN(slot->dn->child)->devfn));
+	if (slot->bus->self)
+		slot_nr = PCI_SLOT(slot->bus->self->devfn);
+	else
+		slot_nr = 0;
+	retval = pci_hp_register(php_slot, slot->bus, slot_nr);
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
 		return retval;

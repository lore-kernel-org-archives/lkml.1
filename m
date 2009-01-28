Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbZA1Lt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbZA1Lt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 06:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZA1LtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 06:49:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60282 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZA1LtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 06:49:15 -0500
Message-ID: <4980462A.7080507@jp.fujitsu.com>
Date: Wed, 28 Jan 2009 20:48:58 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-pci@vger.kernel.org, "Barnes, Jesse" <jesse.barnes@intel.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, shaohua.li@intel.com,
       Grant Grundler <grundler@parisc-linux.org>
Subject: [PATCH 1/8] PCI/ACPI: fix wrong assumption in acpi_pci_get_bridge_handle
References: <1231604250.3642.33.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901121604380.5859@localhost.localdomain>	 <1231807693.27151.21.camel@localhost.localdomain>	 <1232046108.5966.57.camel@localhost.localdomain>	 <alpine.LFD.2.00.0901151421110.4737@localhost.localdomain>	 <1232049269.5966.64.camel@localhost.localdomain>	 <1232050347.5966.66.camel@localhost.localdomain>	 <4970242C.4010404@jp.fujitsu.com>	 <1232115546.3224.5.camel@localhost.localdomain>	 <4973D2EE.3060203@jp.fujitsu.com>	 <1232328216.3247.68.camel@localhost.localdomain>	 <4973EF64.2050404@jp.fujitsu.com> <1232558780.736.24.camel@localhost.localdomain> <497D1BD7.9000609@jp.fujitsu.com> <498045D1.60005@jp.fujitsu.com>
In-Reply-To: <498045D1.60005@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current acpi_pci_get_bridge_handle() has an assumption that
pci_bus->self is NULL on the root pci bus. But it might not true on
some platforms. Because of this wrong assumption, current
acpi_pci_get_bridge_handle() might return improper ACPI handle. We
must check pci_bus->parent instead.

This bug is the root cause of the following kernel panic reported by
James Bottomley. This problem was introduced by the commit
e8c331e963c58b83db24b7d0e39e8c07f687dbc6. The immediate cause was
acpi_pci_get_bridge_handle() returned NULL unexpectedly and it was
passed as the second argument of acpi_walk_namespace().

pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
IP: [<ffffffff8039646f>] acpi_ns_get_next_node+0xb/0x3c
PGD 0 
Oops: 0000 [#1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.28 #1
RIP: 0010:[<ffffffff8039646f>]  [<ffffffff8039646f>] acpi_ns_get_next_node+0xb/0x3c
RSP: 0018:ffff88007f87fd30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff8037d260 R09: ffff88007f87fdfc
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff80742040(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000010 CR3: 0000000000201000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88007f87e000, task ffff88007f875040)
Stack:
 0000000000000000 ffffffff803964f5 ffff88007f81b728 0000000000001001
 ffff88007f87fdfc ffffffff8037d260 0000000600000001 0000000000000000
 ffffffff8037d260 0000000000000000 0000000000000001 ffff88007f87fdfc
Call Trace:
 [<ffffffff803964f5>] acpi_ns_walk_namespace+0x55/0x138
 [<ffffffff8037d260>] is_pci_dock_device+0x0/0x20
 [<ffffffff8037d260>] is_pci_dock_device+0x0/0x20
 [<ffffffff80394a9e>] acpi_walk_namespace+0x5f/0x83
 [<ffffffff8037dd33>] detect_ejectable_slots+0x53/0x70
 [<ffffffff8037de38>] add_bridge+0xe8/0x200
 [<ffffffff80394aaa>] acpi_walk_namespace+0x6b/0x83
 [<ffffffff803a4ad1>] acpi_pci_register_driver+0x48/0x61
 [<ffffffff806fc5df>] acpiphp_init+0x0/0x58
 [<ffffffff806fc732>] acpiphp_glue_init+0x4c/0x5a
 [<ffffffff806fc616>] acpiphp_init+0x37/0x58
 [<ffffffff8020903b>] _stext+0x3b/0x180
 [<ffffffff80312598>] create_proc_entry+0x58/0xa0
 [<ffffffff802815d1>] register_irq_proc+0xc1/0xe0
 [<ffffffff806db64b>] kernel_init+0x152/0x1ac
 [<ffffffff8023d970>] finish_task_switch+0x0/0x110
 [<ffffffff8020ca7a>] child_rip+0xa/0x20
 [<ffffffff8020c47c>] restore_args+0x0/0x30
 [<ffffffff806db4f9>] kernel_init+0x0/0x1ac
 [<ffffffff8020ca70>] child_rip+0x0/0x20
Code: 89 c2 48 8b 00 48 85 c0 75 f5 48 8b 45 00 48 89 02 44 88 65 09 48 89 5d 00 31 c0 5b 5d 41 5c c3 53 48 85 d2 89 fb 48 89 d7 75 06 <48> 8b 56 10 eb 08 e8 73 f1 ff ff 48 89 c2 85 db 74 1a eb 13 0f 
RIP  [<ffffffff8039646f>] acpi_ns_get_next_node+0xb/0x3c
 RSP <ffff88007f87fd30>
CR2: 0000000000000010
---[ end trace a7919e7f17c0a725 ]---

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 include/linux/pci-acpi.h |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6.29-rc2/include/linux/pci-acpi.h
===================================================================
--- linux-2.6.29-rc2.orig/include/linux/pci-acpi.h
+++ linux-2.6.29-rc2/include/linux/pci-acpi.h
@@ -63,11 +63,10 @@ static inline acpi_handle acpi_find_root
 
 static inline acpi_handle acpi_pci_get_bridge_handle(struct pci_bus *pbus)
 {
-	int seg = pci_domain_nr(pbus), busnr = pbus->number;
-	struct pci_dev *bridge = pbus->self;
-	if (bridge)
-		return DEVICE_ACPI_HANDLE(&(bridge->dev));
-	return acpi_get_pci_rootbridge_handle(seg, busnr);
+	if (pbus->parent)
+		return DEVICE_ACPI_HANDLE(&(pbus->self->dev));
+	return acpi_get_pci_rootbridge_handle(pci_domain_nr(pbus),
+					      pbus->number);
 }
 #else
 #if !defined(AE_ERROR)



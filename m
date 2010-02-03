Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab0BCECM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 23:02:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538Ab0BCECH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 23:02:07 -0500
Date: Tue, 2 Feb 2010 19:31:09 -0800
From: Brandon Philips <bphilips@suse.de>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       YinghaiLu@suse.de, yinghai@kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: x86: fix race in create_irq_nr on irq_desc
Message-ID: <20100203033109.GA17985@jenkins.home.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Race in create_irq_nr():

- Thread 1 loops through and calls irq_to_desc_alloc_node with new=0x66.

- Thread 2 has exited the loop with irq=0x66 and calls dynamic_irq_init(0x66)
  setting desc->chip_data = NULL

- Thread 1 then dereferences NULL via desc_new->chip_data->vector

Fix by moving holding vector_lock until after the dynamic_irq_init().

BUG: unable to handle kernel NULL pointer dereference at 0000000000000088
IP: [<ffffffff8101df32>] create_irq_nr+0x62/0x100
PGD 23dc24067 PUD 23dc72067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:08:00.0/net/eth2/type
CPU 12
Modules linked in: i2c_i801 igb(+) iTCO_wdt ixgbe(+) ioatdma(+) e1000e mptctl mdio usb_storage iTCO_vendor_support dca ses button sg pcspkr enclosure container ac usbhid uhci_hcd ehci_hcd usbcore sd_mod edd fan processor ide_pci_generic ide_core ata_generic ata_piix libata lpfc scsi_transport_fc scsi_tgt mptsas mptscsih mptbase scsi_transport_sas megaraid_sas scsi_mod thermal thermal_sys
Supported: Yes
Pid: 1684, comm: modprobe Not tainted 2.6.32.3-0.3-default #1 PRIMERGY RX300 S5
RIP: 0010:[<ffffffff8101df32>]  [<ffffffff8101df32>] create_irq_nr+0x62/0x100
RSP: 0018:ffff88013ce0fc18  EFLAGS: 00010086
RAX: ffff88023e11ee00 RBX: 0000000000000066 RCX: 00000000000000c2
RDX: 00000000000000c2 RSI: 00000000ffffffff RDI: 0000000000000066
RBP: 0000000000000000 R08: ffffffff81767a85 R09: 000000000000000a
R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffffff
R13: 0000000000000206 R14: ffff88013f381000 R15: 0000000000000080
FS:  00007f16d181e700(0000) GS:ffff880143d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000088 CR3: 000000023d26c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 1684, threadinfo ffff88013ce0e000, task ffff88013d080340)
Stack:
 0000000000000001 0000000000000000 ffff88023d2d8740 0000000000000064
<0> 0000000000000007 ffffffff8101f2ce 0000000900000009 ffff88013f381810
<0> ffffffff3f381000 0000000000000048 0000000000000009 ffff88013f381000
Call Trace:
 [<ffffffff8101f2ce>] arch_setup_msi_irqs+0xce/0x190
 [<ffffffff812574b9>] msix_capability_init+0x189/0x2f0
 [<ffffffffa032b4a4>] igb_set_interrupt_capability+0xe4/0x1e0 [igb]
 [<ffffffffa033634e>] igb_probe+0x3de/0xd15 [igb]
 [<ffffffff8124d212>] local_pci_probe+0x12/0x20
 [<ffffffff8124d4c0>] __pci_device_probe+0xe0/0xf0
 [<ffffffff8124e3d3>] pci_device_probe+0x33/0x60
 [<ffffffff812e72f7>] really_probe+0x77/0x230
 [<ffffffff812e751a>] driver_probe_device+0x6a/0xc0
 [<ffffffff812e7603>] __driver_attach+0x93/0xa0
 [<ffffffff812e6928>] bus_for_each_dev+0x58/0x80
 [<ffffffff812e6115>] bus_add_driver+0x195/0x2f0
 [<ffffffff812e7919>] driver_register+0x79/0x170
 [<ffffffff8124e648>] __pci_register_driver+0x58/0xe0
 [<ffffffff810001e5>] do_one_initcall+0x35/0x190
 [<ffffffff8108af34>] sys_init_module+0xe4/0x270
 [<ffffffff81002f7b>] system_call_fastpath+0x16/0x1b
 [<00007f16d13b234a>] 0x7f16d13b234a
Code: 2e 0f 1f 84 00 00 00 00 00 83 c3 01 39 1d e7 e2 9f 00 76 7d 44 89 e6 89 df e8 2b 2a 3d 00 48 85 c0 0f 84 8a 00 00 00 48 8b 68 40 <80> bd 88 00 00 00 00 75 d5 44 89 e6 48 89 c7 e8 6a 5c 09 00 49
RIP  [<ffffffff8101df32>] create_irq_nr+0x62/0x100
 RSP <ffff88013ce0fc18>
CR2: 0000000000000088

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 arch/x86/kernel/apic/io_apic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.32-SLE11-SP1/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.32-SLE11-SP1.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.32-SLE11-SP1/arch/x86/kernel/apic/io_apic.c
@@ -3212,7 +3212,6 @@ unsigned int create_irq_nr(unsigned int
 			irq = new;
 		break;
 	}
-	spin_unlock_irqrestore(&vector_lock, flags);
 
 	if (irq > 0) {
 		dynamic_irq_init(irq);
@@ -3220,6 +3219,8 @@ unsigned int create_irq_nr(unsigned int
 		if (desc_new)
 			desc_new->chip_data = cfg_new;
 	}
+	spin_unlock_irqrestore(&vector_lock, flags);
+
 	return irq;
 }
 

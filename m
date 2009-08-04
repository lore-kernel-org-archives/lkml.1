Return-Path: <linux-kernel-owner+w=401wt.eu-S932490AbZHDUe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbZHDUe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932399AbZHDUez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:34:55 -0400
Received: from brmea-mail-4.Sun.COM ([192.18.98.36]:52159 "EHLO
	brmea-mail-4.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbZHDUey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:34:54 -0400
X-Greylist: delayed 1480 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Aug 2009 16:34:54 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Date: Tue, 04 Aug 2009 16:10:05 -0400
From: james puthukattukaran - Sun Microsystems - Burlington
	 United States <James.Puthukattukaran@sun.com>
Subject: [PATCH] ACPI: uninitialized static variable causes system to fault
 when loading acpiphp driver
To: linux-kernel@vger.kernel.org
Message-id: <4A78959D.6020300@sun.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize the static variable sub_driver to NULL.  This causes 
acp_pci_register_driver to take a page fault when this routine is called 
as part of loading the acpiphp driver. This patch applies to 2.6.30.


acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
Unable to handle kernel paging request at ffffffff886cd330 RIP:  
[<ffffffff80192d7b>] acpi_pci_register_driver+0x13/0x58
PGD 203067 PUD 205063 PMD 276f9b067 PTE 0
Oops: 0000 [1] SMP
last sysfs file: /block/ram0/dev
CPU 9
Modules linked in: acpiphp ipt_REJECT xt_tcpudp x_tables bridge autofs4 
ipmi_devintf ipmi_si ipmi_msghandler hidp rfcomm l2cap bluetooth lockd 
sunrpc ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr 
iscsi_tcp bnx2i cnic ipv6 xfrm_nalgo crypto_api uio cxgb3i cxgb3 
libiscsi_tcp libiscsi2 scsi_transport_iscsi2 scsi_transport_iscsi 
cpufreq_ondemand acpi_cpufreq freq_table dm_mirror dm_multipath scsi_dh 
video hwmon backlight sbs i2c_ec button battery asus_acpi 
acpi_memhotplug ac parport_pc lp parport joydev igb shpchp i2c_i801 
8021q i2c_core sg pcspkr dm_raid45 dm_message dm_region_hash dm_log 
dm_mod dm_mem_cache usb_storage mptsas mptscsih scsi_transport_sas 
mptbase ahci libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
Pid: 15674, comm: modprobe Not tainted 2.6.18-160.el5 #1
RIP: 0010:[<ffffffff80192d7b>]  [<ffffffff80192d7b>] 
acpi_pci_register_driver+0x13/0x58
RSP: 0018:ffff81037f98bf08  EFLAGS: 00010286
RAX: ffffffff886cd330 RBX: ffffffff8864f380 RCX: ffff81027fbc5c40
RDX: ffffffff886cd330 RSI: 0000000000000001 RDI: ffffffff8864f330
RBP: ffffffff8864f330 R08: 0000000000000000 R09: ffffffffffffffff
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000012c20
R13: 00002b5effbc7010 R14: 00000000191ef388 R15: 00002b5effbc7010
FS:  00002b5effbc6240(0000) GS:ffff810283bca440(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff886cd330 CR3: 000000027ffba000 CR4: 00000000000006e0
Process modprobe (pid: 15674, threadinfo ffff81037f98a000, task 
ffff81037fb36040)
Stack:  ffffffff8864f380 00000000191ef0e0 0000000000012c20 ffffffff881fd088
 ffffffff8864f380 00000000191ef0e0 0000000200012c20 ffffffff881fd027
 ffffffff8864f380 ffffffff800a5a04 00002b5effbc7010 0000000000000000
Call Trace:
 [<ffffffff881fd088>] :acpiphp:acpiphp_glue_init+0x42/0x49
 [<ffffffff881fd027>] :acpiphp:acpiphp_init+0x27/0x46
 [<ffffffff800a5a04>] sys_init_module+0xaf/0x1f2
 [<ffffffff8005d28d>] tracesys+0xd5/0xe0



Signed-off-by: James Puthukattukaran <james.puthukattukaran@sun.com>

--- drivers/acpi/pci_root.c.orig      2009-08-04 15:36:20.000000000 -0400
+++ drivers/acpi/pci_root.c   2009-08-04 15:36:09.000000000 -0400
@@ -76,7 +76,7 @@ struct acpi_pci_root {
 
 static LIST_HEAD(acpi_pci_roots);
 
-static struct acpi_pci_driver *sub_driver;
+static struct acpi_pci_driver *sub_driver = NULL;
 static DEFINE_MUTEX(osc_lock);
 
 int acpi_pci_register_driver(struct acpi_pci_driver *driver)
--


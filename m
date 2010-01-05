Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172Ab0AEAem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0AEAem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094Ab0AEAeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:34:37 -0500
Received: from kroah.org ([198.145.64.141]:34064 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab0AEAeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:36 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Michael Reed <mdr@sgi.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/97] SCSI: qla2xxx: dpc thread can execute before scsi host has been added
Date: Mon,  4 Jan 2010 16:32:15 -0800
Message-Id: <1262651630-7354-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Reed <mdr@sgi.com>

commit 1486400f7edd009d49550da968d5744e246dc7f8 upstream.

Fix crash in qla2x00_fdmi_register() due to the dpc
thread executing before the scsi host has been fully
added.

Unable to handle kernel NULL pointer dereference (address 00000000000001d0)
qla2xxx_7_dpc[4140]: Oops 8813272891392 [1]

Call Trace:
 [<a000000100016910>] show_stack+0x50/0xa0
                                sp=e00000b07c59f930 bsp=e00000b07c591400
 [<a000000100017180>] show_regs+0x820/0x860
                                sp=e00000b07c59fb00 bsp=e00000b07c5913a0
 [<a00000010003bd60>] die+0x1a0/0x2e0
                                sp=e00000b07c59fb00 bsp=e00000b07c591360
 [<a0000001000681a0>] ia64_do_page_fault+0x8c0/0x9e0
                                sp=e00000b07c59fb00 bsp=e00000b07c591310
 [<a00000010000c8e0>] ia64_native_leave_kernel+0x0/0x270
                                sp=e00000b07c59fb90 bsp=e00000b07c591310
 [<a000000207197350>] qla2x00_fdmi_register+0x850/0xbe0 [qla2xxx]
                                sp=e00000b07c59fd60 bsp=e00000b07c591290
 [<a000000207171570>] qla2x00_configure_loop+0x1930/0x34c0 [qla2xxx]
                                sp=e00000b07c59fd60 bsp=e00000b07c591128
 [<a0000002071732b0>] qla2x00_loop_resync+0x1b0/0x2e0 [qla2xxx]
                                sp=e00000b07c59fdf0 bsp=e00000b07c5910c0
 [<a000000207166d40>] qla2x00_do_dpc+0x9a0/0xce0 [qla2xxx]
                                sp=e00000b07c59fdf0 bsp=e00000b07c590fa0
 [<a0000001000d5bb0>] kthread+0x110/0x140
                                sp=e00000b07c59fe00 bsp=e00000b07c590f68
 [<a000000100014a30>] kernel_thread_helper+0xd0/0x100
                                sp=e00000b07c59fe30 bsp=e00000b07c590f40
 [<a00000010000a4c0>] start_kernel_thread+0x20/0x40
                                sp=e00000b07c59fe30 bsp=e00000b07c590f40

crash> dis a000000207197350
0xa000000207197350 <qla2x00_fdmi_register+2128>:        [MMI]       ld1 r45=[r14];;
crash> scsi_qla_host.host 0xe00000b058c73ff8
  host = 0xe00000b058c73be0,
crash> Scsi_Host.shost_data 0xe00000b058c73be0
  shost_data = 0x0,  <<<<<<<<<<<

The fc_transport fc_* workqueue threads have yet to be created.

crash> ps | grep _7
   3891      2   2  e00000b075c80000  IN   0.0       0      0  [scsi_eh_7]
   4140      2   3  e00000b07c590000  RU   0.0       0      0  [qla2xxx_7_dpc]

The thread creating adding the Scsi_Host is blocked due to other
activity in sysfs.

crash> bt 3762
PID: 3762   TASK: e00000b071e70000  CPU: 3   COMMAND: "modprobe"
 #0 [BSP:e00000b071e71548] schedule at a000000100727e00
 #1 [BSP:e00000b071e714c8] __mutex_lock_slowpath at a0000001007295a0
 #2 [BSP:e00000b071e714a8] mutex_lock at a000000100729830
 #3 [BSP:e00000b071e71478] sysfs_addrm_start at a0000001002584f0
 #4 [BSP:e00000b071e71440] create_dir at a000000100259350
 #5 [BSP:e00000b071e71410] sysfs_create_subdir at a000000100259510
 #6 [BSP:e00000b071e713b0] internal_create_group at a00000010025c880
 #7 [BSP:e00000b071e71388] sysfs_create_group at a00000010025cc50
 #8 [BSP:e00000b071e71368] dpm_sysfs_add at a000000100425050
 #9 [BSP:e00000b071e71310] device_add at a000000100417d90
#10 [BSP:e00000b071e712d8] scsi_add_host at a00000010045a380
#11 [BSP:e00000b071e71268] qla2x00_probe_one at a0000002071be950
#12 [BSP:e00000b071e71248] local_pci_probe at a00000010032e490
#13 [BSP:e00000b071e71218] pci_device_probe at a00000010032ecd0
#14 [BSP:e00000b071e711d8] driver_probe_device at a00000010041d480
#15 [BSP:e00000b071e711a8] __driver_attach at a00000010041d6e0
#16 [BSP:e00000b071e71170] bus_for_each_dev at a00000010041c240
#17 [BSP:e00000b071e71150] driver_attach at a00000010041d0a0
#18 [BSP:e00000b071e71108] bus_add_driver at a00000010041b080
#19 [BSP:e00000b071e710c0] driver_register at a00000010041dea0
#20 [BSP:e00000b071e71088] __pci_register_driver at a00000010032f610
#21 [BSP:e00000b071e71058] (unknown) at a000000207200270
#22 [BSP:e00000b071e71018] do_one_initcall at a00000010000a9c0
#23 [BSP:e00000b071e70f98] sys_init_module at a0000001000fef00
#24 [BSP:e00000b071e70f98] ia64_ret_from_syscall at a00000010000c740

So, it appears that qla2xxx dpc thread is moving forward before the
scsi host has been completely added.

This patch moves the setting of the init_done (and online) flag to
after the call to scsi_add_host() to hold off the dpc thread.

Found via large lun count testing using 2.6.31.

Signed-off-by: Michael Reed <mdr@sgi.com>
Acked-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/qla2xxx/qla_os.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b79fca7..06bbe0d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2016,13 +2016,13 @@ skip_dpc:
 	DEBUG2(printk("DEBUG: detect hba %ld at address = %p\n",
 	    base_vha->host_no, ha));
 
-	base_vha->flags.init_done = 1;
-	base_vha->flags.online = 1;
-
 	ret = scsi_add_host(host, &pdev->dev);
 	if (ret)
 		goto probe_failed;
 
+	base_vha->flags.init_done = 1;
+	base_vha->flags.online = 1;
+
 	ha->isp_ops->enable_intrs(ha);
 
 	scsi_scan_host(host);
-- 
1.6.6


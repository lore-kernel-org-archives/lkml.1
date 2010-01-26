Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411Ab0AZXxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0AZXxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510Ab0AZXxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:53:13 -0500
Received: from kroah.org ([198.145.64.141]:35380 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab0AZXnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:51 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:28 2010
Message-Id: <20100126233928.631394402@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Song Youquan <youquan.song@intel.com>,
       Huang Ying <ying.huang@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Renninger <trenn@suse.de>
Subject: [59/98] PCI: AER: fix aer inject result in kernel oops
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Song Youquan <youquan.song@linux.intel.com>

commit 46256f83d0d066f99ffde547f27473dfd2a78009 upstream.

If the BIOS does not export _OSC to allow OS take over the PCIe AER, the
pcie aer driver will not initialize the aer service. However, the
aer_inject driver does not check this scenario, which results in a kernel
oops when injecting an aer error into OS.  For example:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000350
IP: [<ffffffff812e08f7>] _spin_lock_irqsave+0xc/0x23
PGD 155c41067 PUD 157fe0067 PMD 0
Oops: 0002 [#1] SMP
Pid: 5119, comm: aer-inject Not tainted 2.6.32-rc8-mce #2
RIP: 0010:[<ffffffff812e08f7>]  [<ffffffff812e08f7>] _spin_lock_irqsave+0xc/0x23
RSP: 0018:ffff880157f81e28  EFLAGS: 00010096
RAX: 0000000000000296 RBX: 0000000000000000 RCX: 0000000000000100
RDX: 0000000000010000 RSI: 0000000000000246 RDI: 0000000000000350
RBP: ffff880157f81e28 R08: 0000000000000004 R09: ffff880157f81dac
R10: ffff88015a666f60 R11: ffff88015a666f40 R12: ffff88015758cc00
R13: 0000000000000350 R14: 0000000000000000 R15: 0000000000000100
FS:  00007f4d4a66e6f0(0000) GS:ffff8800282e0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000350 CR3: 000000015661a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process aer-inject (pid: 5119, threadinfo ffff880157f80000, task ffff8801585f4340)
Stack:
 ffff880157f81e78 ffffffff811b1615 ffff880157f81e78 ffffffff81222823
Call Trace:
 [<ffffffff811b1615>] aer_irq+0x38/0x117
 [<ffffffff81222823>] ? device_for_each_child+0x5f/0x6f
 [<ffffffffa00967bf>] aer_inject_write+0x409/0x45e [aer_inject]
 [<ffffffff810eb80e>] vfs_write+0xae/0x16a
 [<ffffffff810eb98e>] sys_write+0x47/0x6e
 [<ffffffff8100ba2b>] system_call_fastpath+0x16/0x1b
RIP  [<ffffffff812e08f7>] _spin_lock_irqsave+0xc/0x23
 RSP <ffff880157f81e28>
CR2: 0000000000000350

So check the _OSC before assuming that AER is available to the OS.

Signed-off-by: Song Youquan <youquan.song@intel.com>
Acked-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pcie/aer/aer_inject.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -392,8 +392,14 @@ static int aer_inject(struct aer_error_i
 	if (ret)
 		goto out_put;
 
-	if (find_aer_device(rpdev, &edev))
+	if (find_aer_device(rpdev, &edev)) {
+		if (!get_service_data(edev)) {
+			printk(KERN_WARNING "AER service is not initialized\n");
+			ret = -EINVAL;
+			goto out_put;
+		}
 		aer_irq(-1, edev);
+	}
 	else
 		ret = -EINVAL;
 out_put:



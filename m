Return-Path: <linux-kernel-owner+w=401wt.eu-S1765973AbXHDVtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765973AbXHDVtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 17:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761515AbXHDVsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 17:48:55 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:41406 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761291AbXHDVsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 17:48:55 -0400
Message-ID: <46B4F432.4020408@interia.pl>
Date: Sat, 04 Aug 2007 23:48:34 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.5 (X11/20070720)
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove bdput from do_open() in fs/block_dev.c
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: 3a5ecacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I mistyped
# echo /dev/hdc1 >/sys/module/block2mtd/parameters/block2mt
instead of sdc1. There is no /dev/hdc1. I have DVD-ROM as /dev/hdc.
# dmesg
block2mtd: version $Revision: 1.30 $
block2mtd: error: cannot open device /dev/hdc1
Looks right, but tray is locked. And it doesn't want to get out.
# eject
hdc: irq timeout: status=0xd0 { Busy }
ide: failed opcode was: unknown
WARNING: at kernel/irq/resend.c:70 check_irq_resend()
 [<c013444b>] check_irq_resend+0xab/0xc0
 [<c0133e2a>] enable_irq+0x4a/0xa0
 [<c02c26e7>] ide_error+0x47/0xa0
 [<c02d1e60>] cdrom_newpc_intr+0x0/0x300
 [<c02c2bc0>] ide_timer_expiry+0x1e0/0x2d0
 [<c02c29e0>] ide_timer_expiry+0x0/0x2d0
 [<c011b986>] run_timer_softirq+0x116/0x160
 [<c0127e75>] hrtimer_interrupt+0x165/0x1a0
 [<c0118772>] __do_softirq+0x42/0x90
 [<c01187e6>] do_softirq+0x26/0x30
 [<c0118aaa>] irq_exit+0x5a/0x60
 [<c0104817>] do_IRQ+0x47/0x80
 [<c0102c23>] common_interrupt+0x23/0x30
 [<c0281a46>] acpi_processor_idle+0x162/0x380
 [<c0100d0e>] cpu_idle+0x4e/0x70
 [<c0524ac5>] start_kernel+0x1f5/0x240
 [<c05243a0>] unknown_bootoption+0x0/0x1e0
 =======================

Removing bdput from do_open() in fs/block_dev.c seems 
to be a cure for irq timeout.

Signed-off-by: Rafa³ Bilski <rafalbilski@interia.pl>
--- 
diff --git a/fs/block_dev.c b/fs/block_dev.c 
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1120,7 +1120,6 @@ static int do_open(struct block_device *
 	disk = get_gendisk(bdev->bd_dev, &part);
 	if (!disk) {
 		unlock_kernel();
-		bdput(bdev);
 		return ret;
 	}
 	owner = disk->fops->owner;

----------------------------------------------------------------------
Wszystko czego potrzebujesz latem: kremy do opalania, 
stroje kapielowe, maly romans 

>>>http://link.interia.pl/f1b15


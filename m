Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbZIIVUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbZIIVUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbZIIVUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:20:41 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:34826 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZIIVUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:20:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=D4q3x0F21t/iNtVwQlj1+/uhqZdgOAjI+wKyCQAmaSxz5YH7+MrlYbH+Er1jra+i47
         ni6aRYMSfTQMJ2PKyyLBeXKlncigKAHPHg1Z1hUYYbry8eWtfTsriOLR+mAr/IWAr/22
         2cEJVGmFx7GCP+TNPsaXikPNN9fTW51/f/mK0=
MIME-Version: 1.0
Date: Wed, 9 Sep 2009 22:20:42 +0100
Message-ID: <6278d2220909091420g688bd11fybc33be4e472757b1@mail.gmail.com>
Subject: [2.6.31-rc9] hotplug SATA vs lockdep: false positive?
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hot-plugging my SATA DVD drive into my laptop, I see a lockdep
warning [1]. On closer inspection, both flush_workqueue() and
worker_thread() do tricks with lockdep maps. False positive?

Daniel

--- [1]

$ dmesg
ata2: exception Emask 0x10 SAct 0x0 SErr 0x4040000 action 0xe frozen
ata2: irq_stat 0x00000040, connection status changed
ata2: SError: { CommWake DevExch }
ata2: hard resetting link
=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.31-rc9-290cd #1
-------------------------------------------------------
kacpi_hotplug/198 is trying to acquire lock:
 (kacpid){+.+.+.}, at: [<ffffffff81073a70>] flush_workqueue+0x0/0xf0
(workqueue.c:292)

but task is already holding lock:
 (&dpc->work){+.+.+.}, at: [<ffffffff81072a42>]
worker_thread+0x1f2/0x3c0 (bitops.h:101)
which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&dpc->work){+.+.+.}:
       [<ffffffff8108eb19>] __lock_acquire+0xe29/0x1240
       [<ffffffff8108f04e>] lock_acquire+0x11e/0x170
       [<ffffffff81072a92>] worker_thread+0x242/0x3c0 (workqueue.c:291)
       [<ffffffff81077456>] kthread+0xa6/0xc0
       [<ffffffff8100d29a>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (kacpid){+.+.+.}:
       [<ffffffff8108ebe1>] __lock_acquire+0xef1/0x1240
       [<ffffffff8108f04e>] lock_acquire+0x11e/0x170
       [<ffffffff81073acc>] flush_workqueue+0x5c/0xf0 (workqueue.c:403)
       [<ffffffff812f6eaf>] acpi_os_wait_events_complete+0x10/0x1e
       [<ffffffff812f6ee7>] acpi_os_execute_hp_deferred+0x2a/0x3e
       [<ffffffff81072a98>] worker_thread+0x248/0x3c0 (workqueue.c:292)
       [<ffffffff81077456>] kthread+0xa6/0xc0
       [<ffffffff8100d29a>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by kacpi_hotplug/198:
 #0:  (kacpi_hotplug){+.+...}, at: [<ffffffff81072a42>]
worker_thread+0x1f2/0x3c0
 #1:  (&dpc->work){+.+.+.}, at: [<ffffffff81072a42>] worker_thread+0x1f2/0x3c0

stack backtrace:
Pid: 198, comm: kacpi_hotplug Tainted: G         C 2.6.31-rc9-290cd #1

Call Trace:
 [<ffffffff8108c8a7>] print_circular_bug_tail+0xa7/0x100
 [<ffffffff8108ebe1>] __lock_acquire+0xef1/0x1240
 [<ffffffff8108a808>] ? add_lock_to_list+0x58/0xf0
 [<ffffffff8108f04e>] lock_acquire+0x11e/0x170
 [<ffffffff81073a70>] ? flush_workqueue+0x0/0xf0 (workqueue.c:397)
 [<ffffffff812f6ebd>] ? acpi_os_execute_hp_deferred+0x0/0x3e
 [<ffffffff81073acc>] flush_workqueue+0x5c/0xf0 (workqueue.c:403)
 [<ffffffff81073a70>] ? flush_workqueue+0x0/0xf0 (workqueue.c:397)
 [<ffffffff812f6eaf>] acpi_os_wait_events_complete+0x10/0x1e drivers/acpi/osl.c
 [<ffffffff812f6ee7>] acpi_os_execute_hp_deferred+0x2a/0x3e
 [<ffffffff81072a98>] worker_thread+0x248/0x3c0 (workqueue.c:292)
 [<ffffffff81072a42>] ? worker_thread+0x1f2/0x3c0
 [<ffffffff81077900>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81072850>] ? worker_thread+0x0/0x3c0
 [<ffffffff81077456>] kthread+0xa6/0xc0
 [<ffffffff8100d29a>] child_rip+0xa/0x20
 [<ffffffff8100cbd4>] ? restore_args+0x0/0x30
 [<ffffffff810773b0>] ? kthread+0x0/0xc0
 [<ffffffff8100d290>] ? child_rip+0x0/0x20

ACPI: \_SB_.PCI0.SATA.PRT1 - docking
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ACPI cmd e3/00:10:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:03:00:00:00:a0 succeeded
ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HX12, max UDMA/133
ata2.00: ACPI cmd e3/00:10:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:03:00:00:00:a0 succeeded
ata2.00: configured for UDMA/133
ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xf t4
ata2: irq_stat 0x40000001
ata2: hard resetting link
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ACPI cmd e3/00:10:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:03:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:10:00:00:00:a0 succeeded
ata2.00: ACPI cmd e3/00:03:00:00:00:a0 succeeded
ata2.00: configured for UDMA/133
ata2: EH complete
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HX12 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
-- 
Daniel J Blueman

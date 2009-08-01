Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbZHAOHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbZHAOHi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 10:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZHAOHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 10:07:38 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48823 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZHAOHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 10:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=CZhoB/gqpl9izi6B3X9D8UgeIJx+ykHKD1XZlWptWCjCCZ2USbZ4qhcRR+Twn7NkI9
         fjO42llyqkZp3xXg99ZEZIqrIFqV3/PQkE6Yt0Gq96qV7gUMSUP1WHme7h69XYTtYXzK
         cWo6njIXysi+mhyWUZX2CTvMHaNcuBhtDOt/c=
Message-ID: <4A744C2A.6040009@gmail.com>
Date: Sat, 01 Aug 2009 16:07:38 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: memory-controller patch fails to boot in qemu [mmotm]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in mmotm-2009-07-30-05-01, the patch named
memory-controller-soft-limit-organize-cgroups-v9.patch
causes qemu fail to boot with tons of:
BUG: scheduling while atomic: async/2/480/0x10000002
Modules linked in:
Pid: 480, comm: async/2 Tainted: G       AW  2.6.31-rc4-mm1-bh #13
Call Trace:
 [<ffffffff81036b6c>] __schedule_bug+0x5c/0x70
 [<ffffffff8140491b>] thread_return+0x5c1/0x786
 [<ffffffff8103dd30>] __cond_resched+0x20/0x50
 [<ffffffff81404b9d>] _cond_resched+0x2d/0x40
 [<ffffffff81096694>] truncate_inode_pages_range+0x224/0x450
 [<ffffffff8106dfa1>] ? smp_call_function_many+0x1e1/0x210
 [<ffffffff810e50d0>] ? invalidate_bh_lru+0x0/0x90
 [<ffffffff810e514b>] ? invalidate_bh_lru+0x7b/0x90
 [<ffffffff810e50d0>] ? invalidate_bh_lru+0x0/0x90
 [<ffffffff810968d0>] truncate_inode_pages+0x10/0x20
 [<ffffffff810ea875>] kill_bdev+0x35/0x40
 [<ffffffff810eba18>] __blkdev_put+0xa8/0x190
 [<ffffffff810ebb0b>] blkdev_put+0xb/0x10
 [<ffffffff81116f62>] register_disk+0x172/0x180
 [<ffffffff8115bca5>] add_disk+0x85/0x150
 [<ffffffff812398cf>] sd_probe_async+0x12f/0x200
 [<ffffffff810616ca>] async_thread+0x10a/0x270
 [<ffffffff8103f7a0>] ? default_wake_function+0x0/0x10
 [<ffffffff810615c0>] ? async_thread+0x0/0x270
 [<ffffffff8105ac66>] kthread+0x96/0xa0
 [<ffffffff8100ceaa>] child_rip+0xa/0x20
 [<ffffffff8105abd0>] ? kthread+0x0/0xa0
 [<ffffffff8100cea0>] ? child_rip+0x0/0x20

Looks like an omitted unlock. I don't see anything suspicious in the
patch though.

The W taint flag is from:
WARNING: at /home/latest/bh/drivers/ata/libata-core.c:4980
ata_qc_complete+0x205/0x220()
Hardware name:
Modules linked in:
Pid: 226, comm: ata/0 Tainted: G       A   2.6.31-rc4-mm1-bh #13
Call Trace:
 [<ffffffff810441d8>] warn_slowpath_common+0x78/0xb0
 [<ffffffff8104421f>] warn_slowpath_null+0xf/0x20
 [<ffffffff8123e975>] ata_qc_complete+0x205/0x220
 [<ffffffff8124ac8b>] ata_do_link_abort+0xeb/0x110
 [<ffffffff8124acbb>] ata_port_abort+0xb/0x10
 [<ffffffff8124acea>] ata_port_freeze+0x2a/0x50
 [<ffffffff8124ea34>] ata_hsm_qc_complete+0x114/0x120
 [<ffffffff8124fbe2>] ata_sff_hsm_move+0x192/0x760
 [<ffffffff81250567>] ata_pio_task+0x37/0x130
 [<ffffffff81250530>] ? ata_pio_task+0x0/0x130
 [<ffffffff81056651>] worker_thread+0x151/0x250
 [<ffffffff8105afe0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81056500>] ? worker_thread+0x0/0x250
 [<ffffffff8105ac66>] kthread+0x96/0xa0
 [<ffffffff8100ceaa>] child_rip+0xa/0x20
 [<ffffffff8105abd0>] ? kthread+0x0/0xa0
 [<ffffffff8100cea0>] ? child_rip+0x0/0x20
---[ end trace 4afa694ee13ac545 ]---
and is unrelated (it was always there).

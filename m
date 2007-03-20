Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbXCTKxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbXCTKxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 06:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbXCTKx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 06:53:29 -0400
Received: from smtp.nokia.com ([131.228.20.172]:24053 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbXCTKxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 06:53:18 -0400
Message-ID: <45FFBCC6.8010800@nokia.com>
Date: Tue, 20 Mar 2007 12:51:50 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: linux-mtd@lists.infradead.org
CC: linux-kernel@vger.kernel.org
Subject: JFFS2: BUG: sleeping function called from invalid context
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Mar 2007 10:52:54.0091 (UTC) FILETIME=[E97C69B0:01C76ADD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When testing how JFFS2 handles write errors, the following message appears:

BUG: sleeping function called from invalid context at include/linux/writeback.h:76

Here is the terminal output:



# uname -a
Linux ahunter-desktop 2.6.20ded11 #13 SMP PREEMPT Mon Mar 19 16:20:42 EET 2007 i686 GNU/Linux
# insmod $NANDSIM weakpages=444
NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 8MiB 1,8V 8-bit)
flash size: 8 MiB
page size: 512 bytes
OOB area size: 16 bytes
sector size: 8 KiB
pages number: 16384
pages per sector: 16
bus width: 8
bits in sector size: 13
bits in page size: 9
bits in OOB size: 4
flash size with OOB: 8448 KiB
page address bytes: 3
sector address bytes: 2
options: 0x62
Scanning device for bad blocks
Creating 1 MTD partitions on "NAND 8MiB 1,8V 8-bit":
0x00000000-0x00800000 : "NAND simulator partition 0"
# mount -t jffs2 mtd0 /mnt/test_file_system
JFFS2 version 2.2. (NAND) (SUMMARY)  (C) 2001-2006 Red Hat, Inc.
# pwd
/home/git/fs-tests/integrity
# ./integck -n0
[nandsim] warning: simulating write failure in page 444
jffs2_flush_wbuf(): Write failed with -5
In jffs2_wbuf_recover
Skipping node at 0x00036000(3)-0x000361c0 which is either before 0x00037800 or obsolete
Skipping node at 0x000361c0(3)-0x00036204 which is either before 0x00037800 or obsolete
Skipping node at 0x00036204(3)-0x00036f14 which is either before 0x00037800 or obsolete
First node to be recovered is at 0x00036f14(3)-0x00037828
wbuf recover 00036f14-000378fc (2536 bytes in 3 nodes)
Write 0x800 bytes at 0x007a2000 in wbuf recover
Recovery of wbuf succeeded to 007a2000
Refiling block of 00000914 at 00036f14(3) to 007a2000
calling jffs2_gc_fetch_inode
BUG: sleeping function called from invalid context at include/linux/writeback.h:76
in_atomic():1, irqs_disabled():0
2 locks held by jffs2_gcd_mtd0/5710:
 #0:  (&c->wbuf_sem){----}, at: [<f8b09814>] jffs2_flash_writev+0x67/0x5c0 [jffs2]
 #1:  (&c->erase_completion_lock){--..}, at: [<f8b085f8>] jffs2_wbuf_recover+0xb03/0x11f1 [jffs2]
 [<c01040df>] show_trace_log_lvl+0x1a/0x30
 [<c0104806>] show_trace+0x12/0x14
 [<c01048aa>] dump_stack+0x16/0x18
 [<c011cee4>] __might_sleep+0xb8/0xcb
 [<c0181ed9>] ifind_fast+0x48/0x86
 [<c01821d9>] iget_locked+0x2a/0x133
 [<f8b06713>] jffs2_gc_fetch_inode+0x18e/0x229 [jffs2]
 [<f8b08853>] jffs2_wbuf_recover+0xd5e/0x11f1 [jffs2]
 [<f8b0909c>] __jffs2_flush_wbuf+0x3b6/0x791 [jffs2]
 [<f8b09b14>] jffs2_flash_writev+0x367/0x5c0 [jffs2]
 [<f8afb59f>] jffs2_write_dnode+0x180/0x403 [jffs2]
 [<f8b02626>] jffs2_garbage_collect_dnode+0x7d3/0x8cd [jffs2]
 [<f8b004b8>] jffs2_garbage_collect_live+0x242/0x31e [jffs2]
 [<f8b00148>] jffs2_garbage_collect_pass+0x99b/0xac9 [jffs2]
 [<f8b04ad7>] jffs2_garbage_collect_thread+0x341/0x396 [jffs2]
 [<c0103d53>] kernel_thread_helper+0x7/0x14
 =======================
Refiling block of 0000008c at 00037828(3) to 007a2914
calling jffs2_gc_fetch_inode
Refiling block of 00000048 at 000378b4(2) to 007a29a0
calling jffs2_gc_fetch_inode
wbuf recovery completed OK. wbuf_ofs 0x007a2800, len 0x1e8

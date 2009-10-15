Return-Path: <linux-kernel-owner+w=401wt.eu-S932832AbZJOCb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbZJOCb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 22:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbZJOCb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 22:31:29 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:62642 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbZJOCb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 22:31:28 -0400
Message-Id: <200910150230.n9F2UKgK090342@www262.sakura.ne.jp>
Subject: Re: [Bug #14258] Memory leak in SCSI initialization
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: James.Bottomley@suse.de, rjw@sisk.pl
Cc: kernel-testers@vger.kernel.org, michael@ellerman.id.au,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 15 Oct 2009 11:30:20 +0900
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.HAD.qzl0KB@chimera>
In-Reply-To: <L6tb-VyKHZK.A.HAD.qzl0KB@chimera>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 15102009 #2761698, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got below messages in 2.6.32-rc4 .

# dmesg | grep kmemleak
[    7.612391] kmemleak: Kernel memory leak detector initialized
[    7.615675] kmemleak: Automatic memory scanning thread started
[   78.641096] kmemleak: 13 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
# cat /sys/kernel/debug/kmemleak
unreferenced object 0xdac2c478 (size 32):
  comm "swapper", pid 1, jiffies 4294894406
  hex dump (first 32 bytes):
    30 3a 30 3a 32 3a 30 00 5a 5a 5a 5a 5a 5a 5a 5a  0:0:2:0.ZZZZZZZZ
    5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a a5  ZZZZZZZZZZZZZZZ.
  backtrace:
    [<c10d3944>] create_object+0xe4/0x220
    [<c1322663>] kmemleak_alloc+0x83/0xd0
    [<c10d01d4>] __kmalloc+0x1b4/0x220
    [<c11ab450>] kvasprintf+0x30/0x60
    [<c11a3131>] kobject_set_name_vargs+0x21/0x60
    [<c11f8cd9>] dev_set_name+0x19/0x20
    [<c122c2b3>] scsi_sysfs_device_initialize+0xc3/0x120
    [<c1228ac4>] scsi_alloc_sdev+0x194/0x230
    [<c1229b50>] scsi_probe_and_add_lun+0x320/0x340
    [<c122a477>] __scsi_scan_target+0xb7/0x100
    [<c122a5f6>] scsi_scan_channel+0x86/0xa0
    [<c122a6f9>] scsi_scan_host_selected+0xe9/0x150
    [<c122aabc>] do_scsi_scan_host+0x7c/0x80
    [<c122ab6d>] scsi_scan_host+0x8d/0x90
    [<c1520c75>] BusLogic_init+0x355/0x420
    [<c100105c>] do_one_initcall+0x2c/0x1d0
(...snipped...)
unreferenced object 0xdac2cc58 (size 32):
  comm "swapper", pid 1, jiffies 4294894414
  hex dump (first 32 bytes):
    30 3a 30 3a 31 35 3a 30 00 5a 5a 5a 5a 5a 5a 5a  0:0:15:0.ZZZZZZZ
    5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a a5  ZZZZZZZZZZZZZZZ.
  backtrace:
    [<c10d3944>] create_object+0xe4/0x220
    [<c1322663>] kmemleak_alloc+0x83/0xd0
    [<c10d01d4>] __kmalloc+0x1b4/0x220
    [<c11ab450>] kvasprintf+0x30/0x60
    [<c11a3131>] kobject_set_name_vargs+0x21/0x60
    [<c11f8cd9>] dev_set_name+0x19/0x20
    [<c122c2b3>] scsi_sysfs_device_initialize+0xc3/0x120
    [<c1228ac4>] scsi_alloc_sdev+0x194/0x230
    [<c1229b50>] scsi_probe_and_add_lun+0x320/0x340
    [<c122a477>] __scsi_scan_target+0xb7/0x100
    [<c122a5f6>] scsi_scan_channel+0x86/0xa0
    [<c122a6f9>] scsi_scan_host_selected+0xe9/0x150
    [<c122aabc>] do_scsi_scan_host+0x7c/0x80
    [<c122ab6d>] scsi_scan_host+0x8d/0x90
    [<c1520c75>] BusLogic_init+0x355/0x420
    [<c100105c>] do_one_initcall+0x2c/0x1d0

In my environment, 0:0:0:0 and 0:0:1:0 are used by SCSI hard disks, 0:0:7:0 is
reserved. 0:0:X:0 (where X = 2-6, 8-15) are unused and reported as memory leak.

After applying http://patchwork.kernel.org/patch/51412/ , above messages
no longer appears. Please apply that patch to 2.6.32-rcX as well as 2.6.31.Y .

Regards.

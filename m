Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZAEDYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZAEDYy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 22:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZAEDYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 22:24:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49553 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbZAEDYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 22:24:32 -0500
Message-ID: <49617D35.4040805@cn.fujitsu.com>
Date: Mon, 05 Jan 2009 11:23:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: [cgroup or VFS ?]  WARNING: at fs/namespace.c:636 mntput_no_expire+0xac/0xf2()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thread 1:
  for ((; ;))
  {
      mount -t cgroup -o cpuset xxx /mnt > /dev/null 2>&1
      mkdir /mnt/0 > /dev/null 2>&1
      rmdir /mnt/0 > /dev/null 2>&1
      umount /mnt > /dev/null 2>&1
  }

Thread 2:
  for ((; ;))
  {
      mount -t cpuset xxx /mnt > /dev/null 2>&1
      umount /mnt > /dev/null 2>&1
  }

(Note: Again it is irrelevant which cgroup subsys is used.)

After a while this showed up:

------------[ cut here ]------------
WARNING: at fs/namespace.c:636 mntput_no_expire+0xac/0xf2()
Hardware name: Aspire SA85
Modules linked in: bridge stp llc autofs4 dm_mirror dm_region_hash dm_log dm_mod r8169 parport_pc mii parport sg button sata_sis pata_sis ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 4745, comm: umount Not tainted 2.6.28 #479
Call Trace:
 [<c042bbe3>] warn_slowpath+0x79/0x8f
 [<c044babf>] ? __lock_acquire+0x69a/0x700
 [<c04ae44e>] ? mntput_no_expire+0x79/0xf2
 [<c04ae481>] mntput_no_expire+0xac/0xf2
 [<c04ae968>] sys_umount+0x26a/0x2b1
 [<c04ae9c1>] sys_oldumount+0x12/0x14
 [<c0403251>] sysenter_do_call+0x12/0x31
---[ end trace 79d0ab4bef01333f ]---

The WARNING is: WARN_ON(atomic_read(&mnt->__mnt_writers));

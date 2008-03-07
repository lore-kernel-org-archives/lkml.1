Return-Path: <linux-kernel-owner+w=401wt.eu-S1764917AbYCGUdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764917AbYCGUdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 15:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761033AbYCGUdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 15:33:04 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:60904 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759645AbYCGUdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:33:03 -0500
Date: Fri, 7 Mar 2008 21:32:57 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: LKML <linux-kernel@vger.kernel.org>
cc: xfs@oss.sgi.com
Subject: INFO: task mount:11202 blocked for more than 120 seconds
Message-ID: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after upgrading from 2.6.24.1 to 2.6.25-rc3, I came across[0]. This 
warning seems to be gone now. With 2.6.25-rc4 (and the fix from [1])
the box was running fine for 20 hours or so (doing its usual jobs plus 
a "make randconfig && make" loop).

After this, I noticed that /bin/sync would not exit anymore and
remains stuck in D state. Looking around I noticed that the rsync
backup jobs (rsync'ing to an xfs partition) from earlier this
morning did not exit either and hung in D state. With sync hung, the 
following messages started to appear:

[75377.756985] INFO: task sync:2697 blocked for more than 120 seconds.
[75377.757579] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[75377.758211] sync          D c013835c     0  2697  16457
[75377.758216]        f59506c0 00000082 f4c34000 c013835c fffeffff f6c1bcb0 f5dd0000 f4c34000 
[75377.758223]        c04405d7 f53f7e98 f6c1bcb4 f6c1bcd0 00000000 f6c1bcb0 00000000 f7ca1090 
[75377.758230]        f4c34000 c044070a f6c1bcd0 f6c1bcd0 f5dd0000 00000001 f6c1bcb0 c044074b 
[75377.758237] Call Trace:
[75377.758253]  [<c013835c>] trace_hardirqs_on+0x9c/0x110
[75377.758269]  [<c04405d7>] rwsem_down_failed_common+0x67/0x150
[75377.758279]  [<c044070a>] rwsem_down_read_failed+0x1a/0x24
[75377.758286]  [<c044074b>] call_rwsem_down_read_failed+0x7/0xc
[75377.758291]  [<c012fd7c>] down_read_nested+0x4c/0x60
[75377.758295]  [<c027a64b>] xfs_ilock+0x5b/0xb0
[75377.758301]  [<c027a64b>] xfs_ilock+0x5b/0xb0
[75377.758306]  [<c029693d>] xfs_sync_inodes+0x3dd/0x6b0
[75377.758314]  [<c0440b14>] _spin_unlock+0x14/0x20
[75377.758325]  [<c0296d9b>] xfs_syncsub+0x18b/0x300
[75377.758330]  [<c0440b14>] _spin_unlock+0x14/0x20
[75377.758335]  [<c02a7c2b>] xfs_fs_sync_super+0x2b/0xd0
[75377.758342]  [<c016a124>] sync_filesystems+0xa4/0x100
[75377.758351]  [<c043fdd8>] down_read+0x38/0x50
[75377.758356]  [<c016a13f>] sync_filesystems+0xbf/0x100
[75377.758361]  [<c01872b3>] do_sync+0x33/0x70
[75377.758366]  [<c0102ed7>] restore_nocheck+0x12/0x15
[75377.758371]  [<c01872fa>] sys_sync+0xa/0x10
[75377.758375]  [<c0102dee>] sysenter_past_esp+0x5f/0xa5
[75377.758402]  =======================
[75377.758405] 3 locks held by sync/2697:
[75377.758407]  #0:  (mutex){--..}, at: [<c016a091>] sync_filesystems+0x11/0x100
[75377.758414]  #1:  (&type->s_umount_key#22){----}, at: [<c016a124>] sync_filesystems+0xa4/0x100
[75377.758422]  #2:  (&(&ip->i_iolock)->mr_lock){----}, at: [<c027a64b>] xfs_ilock+0x5b/0xb0


The box is still up & running, although the load is increasing slightly. 
I've gathered some details here: http://nerdbynature.de/bits/2.6.25-rc4/

I've searched the archives for this error, but the only thing was
   * http://lkml.org/lkml/2008/2/12/44
     [BUG] 2.6.25-rc1-git1 softlockup while bootup on powerpc
     ...however, I don't get "CPU stuck" messages
   * http://lkml.org/lkml/2008/1/29/370
     Re: system hang on latest git
     ...but calltrace looks a lot different.

Since both mailings are not so current, I'd like to got back to -rc3 and 
try to reproduce this one.

Do you have any idea what's going on here?

Thanks,
Christian.

[0] http://lkml.org/lkml/2008/3/2/171
[1] http://lkml.org/lkml/2008/3/4/634
-- 
BOFH excuse #158:

Defunct processes

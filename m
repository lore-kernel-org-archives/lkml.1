Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbXEYFBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbXEYFBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbXEYFBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:01:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:16250 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbXEYFBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:01:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=I3APRl0/oEpQvO8/+YmUezhMVmEeHyPnkiBgnzdvxGAz794KFLjzwtClWwWN5jPAMm/LxocteqT3+gOMTJWwfWXGx19js0UEqc+WWCYHJ298LjzDOvtlKG4RyGzWua+3lUR5qM2C/V+j49NzqzrKWp5KWAcplmDa3zRH3c5wbYI=
Message-ID: <a8e1da0705242201r13a26d92hcb0059f55e15a24a@mail.gmail.com>
Date: Fri, 25 May 2007 05:01:20 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: 2.6.22-rc2-mm1 NTFS & SLUB related fix
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
As I umount a ntfs partition, the kernel report some trace infomation,
I can't call it oops, right?

Andrew, could you tell me who is the right person should I send  to?

I navagated the ntfs inode.c, and found a possible bug, replaced
kmalloc with kzalloc,
because the ntfschar size is 2.  then the kernel doesn't warning
again. and the slub debug info also disappeared.

This patch works for me:

diff -udr linux/fs/ntfs/inode.c linux.new/fs/ntfs/inode.c
--- linux/fs/ntfs/inode.c	2007-05-25 12:46:27.000000000 +0000
+++ linux.new/fs/ntfs/inode.c	2007-05-25 12:45:31.000000000 +0000
@@ -136,11 +136,10 @@

 		BUG_ON(!na->name);
 		i = na->name_len * sizeof(ntfschar);
-		ni->name = kmalloc(i + sizeof(ntfschar), GFP_ATOMIC);
+		ni->name = kzalloc(i + sizeof(ntfschar), GFP_ATOMIC);
 		if (!ni->name)
 			return -ENOMEM;
 		memcpy(ni->name, na->name, i);
-		ni->name[i] = 0;
 	}
 	return 0;
 }



And please look the failed kernel message:

*** SLUB kmalloc-8: Redzone Active@0xc2959e38 slab 0xc1052b20
    offset=3640 flags=0x400000c2 inuse=73 freelist=0x00000000
  Bytes b4 0xc2959e28:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a
5a ........ZZZZZZZZ
    Object 0xc2959e38:  24 00 51 00 00 00 6b a5
 $.Q...k¥
   Redzone 0xc2959e40:  00 00 cc cc
 ..ÌÌ
FreePointer 0xc2959e44 -> 0x00000000
Last alloc: ntfs_init_locked_inode+0x9e/0x110 jiffies_ago=5140 cpu=0 pid=1604
Last free : __vunmap+0xb2/0xe0 jiffies_ago=30727 cpu=0 pid=1491
    Filler 0xc2959e68:  5a 5a 5a 5a 5a 5a 5a 5a
 ZZZZZZZZ
 [<c0163141>] check_object+0x71/0x250
 [<c04432e0>] preempt_schedule+0x50/0x70
 [<c01639a1>] free_debug_processing+0xc1/0x1a0
 [<c011e587>] vprintk+0x227/0x250
 [<c0164419>] __slab_free+0x79/0xe0
 [<c02216da>] __ntfs_clear_inode+0x11a/0x1b0
 [<c0164ee3>] kfree+0x63/0x70
 [<c02216da>] __ntfs_clear_inode+0x11a/0x1b0
 [<c02216da>] __ntfs_clear_inode+0x11a/0x1b0
 [<c0221839>] ntfs_clear_big_inode+0x59/0x120
 [<c019f690>] dquot_drop+0x0/0x50
 [<c017d411>] clear_inode+0xc1/0x150
 [<c017e3c7>] generic_forget_inode+0x107/0x180
 [<c017e4b3>] iput+0x53/0x60
 [<c0230b85>] ntfs_put_super+0x6c5/0x8e0
 [<c016a61a>] generic_shutdown_super+0xea/0x100
 [<c016b11c>] kill_block_super+0xc/0x20
 [<c016a35e>] deactivate_super+0x4e/0xa0
 [<c0180de5>] sys_umount+0x35/0x80
 [<c0115274>] do_page_fault+0x434/0x5c0
 [<c0180e45>] sys_oldumount+0x15/0x20
 [<c0104098>] syscall_call+0x7/0xb
 =======================
@@@ SLUB kmalloc-8: Restoring redzone (0xcc) from 0xc2959e40-0xc2959e43

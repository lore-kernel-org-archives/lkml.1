Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbXFZFC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbXFZFC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 01:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756580AbXFZFBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 01:01:51 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:43281 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbXFZFBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 01:01:47 -0400
Date: Tue, 26 Jun 2007 10:30:11 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: menage@google.com
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, svaidy@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       bharata@linux.vnet.ibm.com
Subject: [PATCH] Fix for bad lock balance in Containers
Message-ID: <20070626050011.GA12584@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been going through the containers code and trying it out. I tried
mounting the same hierarchy at two different points and I got a bad
locking balance warning.

=====================================
[ BUG: bad unlock balance detected! ]
-------------------------------------
mount/4467 is trying to release lock (&type->s_umount_key) at:
[<c017de3b>] vfs_kern_mount+0x5b/0x70
but there are no more locks to release!

other info that might help us debug this:
no locks held by mount/4467.

stack backtrace:
 [<c0105b9f>] show_trace_log_lvl+0x19/0x2e
 [<c0105bc6>] show_trace+0x12/0x14
 [<c0105cb1>] dump_stack+0x14/0x16
 [<c0142c1a>] print_unlock_inbalance_bug+0xcc/0xd6
 [<c0142c93>] check_unlock+0x6f/0x75
 [<c0142ee0>] __lock_release+0x1e/0x51
 [<c014312c>] lock_release+0x4c/0x64
 [<c013bd9d>] up_write+0x16/0x2b
 [<c017de3b>] vfs_kern_mount+0x5b/0x70
 [<c018fae7>] do_new_mount+0x85/0xe6
 [<c019013f>] do_mount+0x185/0x199
 [<c01903ab>] sys_mount+0x71/0xa6
 [<c0104d6a>] sysenter_past_esp+0x5f/0x99
 =======================

Going through the code, I realised this is because when the container is
already mounted at one point, when being remounted, it just does a
simple_set_mnt which does not update s_umount which causes the warning
to come. This also cause umount to hang the second time.

The correct method would be allocate the superblock using sget (or a
variant) which would call grab_super correctly and set these locks.
Seeing the code which is there, some part of grab_super is already done
in container_get_sb where the root->sb->s_active is updated. So I have
called down_write there as well to get the locking balance. However I
believe that this is not the correct approach.

There are a few questions I had with respect to the current code,

Why is the increment of s_active dependent on the return value of
simple_set_mnt? All the other functions which I have seen (fs ones),
grab_super (which increments s_active) is called followed by a
simple_set_mnt.

What should be the correct approach to get the locking balance? As far
as I can see, the correct method would be to call sget which would then
correctly handle everything. But that would require a test function. I
saw functionality similar to a test function in the beginning of
container_get_sb(). Should that be seperated and put in a seperate test
function so that sget can be called?

Another possible approach would be to call grab_super directly (since we
know the test function is going to return true), but this cannot be done
since grab_super is static right now. Or maybe we could duplicate
grab_super's functionality.

In the meantime a temporary fix.

Thanks and regards
Dhaval

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>


--- linux-2.6.22-rc4/kernel/container.c	2007-06-13 15:38:32.000000000 +0530
+++ old/kernel/container.c	2007-06-25 00:55:03.000000000 +0530
@@ -995,6 +995,7 @@ static int container_get_sb(struct file_
 		BUG_ON(ret);
 	} else {
 		/* Reuse the existing superblock */
+		down_write(&(root->sb->umount));
 		ret = simple_set_mnt(mnt, root->sb);
 		if (!ret)
 			atomic_inc(&root->sb->s_active);

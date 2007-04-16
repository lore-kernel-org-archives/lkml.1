Return-Path: <linux-kernel-owner+w=401wt.eu-S1750940AbXDPIWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbXDPIWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 04:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXDPIWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 04:22:11 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:32837 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbXDPIWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 04:22:09 -0400
Date: Mon, 16 Apr 2007 13:52:12 +0530
From: Maneesh Soni <maneesh@in.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, James.Bottomley@SteelEye.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET #master] sysfs: make sysfs disconnect immediately on deletion, take 2
Message-ID: <20070416082212.GC31874@in.ibm.com>
Reply-To: maneesh@in.ibm.com
References: <11760923261269-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11760923261269-git-send-email-htejun@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 01:18:46PM +0900, Tejun Heo wrote:
> Hello, all.
> 
> This is the second take of sysfs-immediate-disconnct patchset.
> 
> In the last take, rwsem was added to s_elem.dir to protect kobj only.
> This wasn't enough because attr and bin_attr need to hold onto not
> only the kobject of their parents but also the module backing
> themselves and ops too, so the first set still needed separate and
> duplicate attribute file orphaning mechanism.
> 
> In this take, the rwsem is generalized to become active reference
> count.  Now each sysfs_dirent has two reference counts - s_count and
> s_active.  s_count is a regular reference count which guarantees that
> the containing sysfs_dirent is accessible.  As long as s_count
> reference is held, all sysfs internal fields in sysfs_dirent are
> accessible including s_parent and s_name.
> 
> The newly added s_active is active reference count.  This is acquired
> by invoking sysfs_get_active() and it's the caller's responsibility to
> ensure sysfs_dirent itself is accessible (should be holding s_count
> one way or the other).  Dereferencing sysfs_dirent to access objects
> out of sysfs proper requires active reference.  This includes access
> to the associated kobjects, attributes and ops.
> 
> Because attr/bin_attr ops access both the node itself and its parent
> for kobject, they need to hold active references to both.
> sysfs_get/put_active_two() helpers are provided to help grabbing both
> references.  Parent's is acquired first and released last.
> 
> Basically, s_count provides the reference counted objects to the upper
> layer while s_active guards low level access such that low level
> objects can just go away when they want to, and the same mechanism is
> applied to all types of sysfs nodes.  I think it's conceptually
> cleaner and thus easier to understand this way.
> 
> With all the patches applied, the same test used in the last take ran
> 9+hrs without any problem.
> 
> Change from the last take are...
> 
> * Patch 3 now doesn't move sysfs_get_kobject() as the it's replaced by
>   active references later.
> 
> * Patch 12 updated such that sdir->rwsem is generalized into active
>   reference count.
> 
> Please read the original lifetime rules discussion[1] and description
> of the last take[2] for more info.
> 
> Thanks.

Hi Tejun,

I started looking at these patches and parallely also did some testing on a 
8 CPU system. I am using the patches from Greg's tree at
http://www.kernel.org/pub/scm/linux/kernel/git/gregkh/patches.git/

I ran following loops parallelly

# while true; do insmod drivers/net/dummy.ko; sleep 1;rmmod dummy; done
# while true; do find /sys/class/net/dummy0 | xargs cat; sleep 1; done
# while true; do umount /sys; sleep 1; mount -t sysfs none /sys; done
# while true; do find /sys | xargs cat > /dev/null; sleep 1; done

and got the following oops

Unable to handle kernel NULL pointer dereference at 000000000000004c RIP:
 [<ffffffff802935b4>] simple_unlink+0x14/0x5c
PGD 21955c067 PUD 215b52067 PMD 0
Oops: 0002 [1] SMP
CPU 6
Modules linked in: dummy i2c_dev i2c_core
Pid: 21161, comm: rmmod Not tainted 2.6.21-rc6 #3
RIP: 0010:[<ffffffff802935b4>]  [<ffffffff802935b4>] simple_unlink+0x14/0x5c
RSP: 0000:ffff81021b38be28  EFLAGS: 00010292
RAX: 0000000046232944 RBX: ffff8102173528b0 RCX: 0000000046232944
RDX: 00000000256a534c RSI: 00000000256a534c RDI: ffff8102173528b0
RBP: ffff81021be04a38 R08: ffff81021b38a000 R09: ffff81021b38bdc8
R10: ffffffff8085d1a0 R11: ffff8102150c5480 R12: 0000000000000000
R13: ffff81021487f8a0 R14: ffff81021be043f8 R15: ffffffff80632f68
FS:  00002b3f92906240(0000) GS:ffff8102284b14c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000000004c CR3: 0000000218573000 CR4: 00000000000006e0
Process rmmod (pid: 21161, threadinfo ffff81021b38a000, task ffff81022730d8b0)
Stack:  ffff81021be04a10 ffff81021be04f60 ffff81021d361150 ffffffff802b31ee
 0000000000200200 ffff81022505c000 ffff81022505c3e0 ffff81022505c4d0
 0000000000000000 00007fff181c4160 0000000000000880 ffffffff803a0c1a
Call Trace:
 [<ffffffff802b31ee>] sysfs_hash_and_remove+0x7c/0xef
 [<ffffffff803a0c1a>] device_del+0x66/0x20a
 [<ffffffff804d2d7e>] netdev_run_todo+0xc6/0x225
 [<ffffffff8800d025>] :dummy:dummy_free_one+0x1c/0x2d
 [<ffffffff8800d0a2>] :dummy:dummy_cleanup_module+0xe/0x23
 [<ffffffff8024ceed>] sys_delete_module+0x1b1/0x1e0
 [<ffffffff803437e7>] __up_write+0x21/0x10e
 [<ffffffff80209bbe>] system_call+0x7e/0x83


Code: 41 ff 4c 24 4c 48 89 83 90 00 00 00 4c 89 ef 48 89 93 98 00
RIP  [<ffffffff802935b4>] simple_unlink+0x14/0x5c
 RSP <ffff81021b38be28>
CR2: 000000000000004c

Thanks
Maneesh

-- 
Maneesh Soni
Linux Technology Center,
IBM India Systems and Technology Lab, 
Bangalore, India

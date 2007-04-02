Return-Path: <linux-kernel-owner+w=401wt.eu-S1751473AbXDBHpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbXDBHpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbXDBHpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:45:16 -0400
Received: from gum.itee.uq.edu.au ([130.102.66.1]:48360 "EHLO
	gum.itee.uq.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbXDBHpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:45:14 -0400
X-Greylist: delayed 3820 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2007 03:45:13 EDT
Message-ID: <4610A598.4050206@itee.uq.edu.au>
Date: Mon, 02 Apr 2007 16:41:28 +1000
From: John Williams <jwilliams@itee.uq.edu.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060418 Red Hat/1.7.13-1.1.3.1.centos3
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ENOENT creating /dev/root on MTD RAM partition
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm working on the 2.6 kernel port for MicroBlaze (embedded, NOMMU) 
arch. Like some other nommu archs, we typically mount root on an MTD RAM
partition (either CRAMFS or ROMFS).

All of this is working fine on 2.6.19 plus SnapGear 2.6.19-uc0-bigpatch 
NOMMU patchset.

However, since coming forward to 2.6.20 (plus equiv. SnapGear patchset) 
mount_root is failing.

Details follow, but basically create_dev(/dev/root, ROOT_DEV) is 
returning -ENOENT.  ROOT_DEV points to a valid MTD RAM partition, with a 
valid ROMFS (or CRAMFS, doesn't matter which) image. I've dumped the 
memory, the image is good.

Googling the various archives finds one or two past references to 
create_dev or do_mount_root returning -ENOENT on MTD RAM partitions, but 
I found no followups or solutions posted.

 From my bootlog:

uclinux[mtd]: RAM probe address=0x22182cc8 size=0x21d000
Creating 1 MTD partitions on "RAM":
0x00000000-0x0021d000 : "ROMfs"
mtd: Giving out device 5 to ROMfs
uclinux[mtd]: set ROMfs to be root filesystem index=5

...

((my debug output in namei.c))
hello from __link_path_walk(/dev/root)
__link_path_walk says -ENOENT
next:0x23ff4694
next.dentry:0x23e12d08

...

Kernel panic - not syncing: VFS: Unable to mount root fs on
unknown-block(31,5)
  <0>Rebooting in 120 seconds..Machine restart...

I traced down into fs/namei.c - it's a fragment in
__link_path_walk("/dev/root"):

line 892:
                 /* This does the actual lookups.. */
                 err = do_lookup(nd, &this, &next);
                 if (err)
                         break;



                 err = -ENOENT;
                 inode = next.dentry->d_inode;
                 if (!inode) {
---> we are hitting this error path
                         goto out_dput;

                 }

So, it seems that do_lookup is returning a dentry with no inode.

I've tried this with both ROMFS and CRAMFS types, with the same result.
If it was a random memory corruption event I'd expect to see
different failure modes for the two filesystem types.

Any comments or suggestions on a possible cause or approach to track it
down would be greatly appreciated.

Thanks,

John


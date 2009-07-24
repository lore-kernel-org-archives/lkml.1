Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbZGXUYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbZGXUYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 16:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbZGXUYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 16:24:19 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:25132 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZGXUYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 16:24:18 -0400
Subject: Regression in 2.6.31-rc3 (and presumably 2.6.31-rc4?)
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: linux-kernel@vger.kernel.org
Cc: martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com,
       nicholas.dokos@hp.com
Content-Type: text/plain
Date: Fri, 24 Jul 2009 16:24:15 -0400
Message-Id: <1248467055.7964.12.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did a diffstat between 2.6.31-rc3 and -rc4 and didn't see anything in
the MD space, so...

I am unable to create multi-disk LVM striped-volumes with this commit in
place - Nick Dokos @ HP did the bisecting and found that removing this
commit fixes the same problem for him:

754c5fc7ebb417b23601a6222a6005cc2e7f2913 is first bad commit
commit 754c5fc7ebb417b23601a6222a6005cc2e7f2913
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Mon Jun 22 10:12:34 2009 +0100

    dm: calculate queue limits during resume not load

I am able to create a single-disk volume correctly. I haven't had much
time to trace everything, but I think what happens is that the check at
line 363 in drivers/md/dm-table.c:

        if ((start >= dev_size) || (start + ti->len > dev_size)) {
                DMWARN("%s: %s too small for target",
                       dm_device_name(ti->table->md), bdevname(bdev,
b));
                return 0;
        }

is looking at the wrong size for ti->len - it is checking device sizes,
but ti->len appears to be the total size of the volume. (Which is why it
works for single-disk volumes, but fails for multiple disks - as each
dev will have a smaller dev_size than the total size of the volume.)

I added an WARN_ON and found that the stack trace looks like at the
failure point:

 [<ffffffff8103d3ba>] ? print_oops_end_marker+0x9/0x1f
 [<ffffffffa01a3f53>] ? device_area_is_valid+0x55/0x151 [dm_mod]
 [<ffffffff8103d572>] ? warn_slowpath_common+0x77/0x8e
 [<ffffffffa01a3f53>] ? device_area_is_valid+0x55/0x151 [dm_mod]
 [<ffffffffa01a4b61>] ? dm_set_device_limits+0x69/0xd8 [dm_mod]
 [<ffffffffa01a3efe>] ? device_area_is_valid+0x0/0x151 [dm_mod]
 [<ffffffffa01a5529>] ? stripe_iterate_devices+0x31/0x45 [dm_mod]
 [<ffffffffa01a4ea4>] ? dm_calculate_queue_limits+0x79/0x1d1 [dm_mod]
 [<ffffffffa01a25cc>] ? dm_get_table+0x35/0x3d [dm_mod]
 [<ffffffffa01a16e2>] ? dm_swap_table+0x48/0x244 [dm_mod]
 [<ffffffffa01a3aad>] ? dm_suspend+0x2aa/0x2ba [dm_mod]
 [<ffffffffa01a68f6>] ? dev_suspend+0x0/0x194 [dm_mod]
 [<ffffffffa01a69ff>] ? dev_suspend+0x109/0x194 [dm_mod]
 [<ffffffffa01a730d>] ? dm_ctl_ioctl+0x223/0x26f [dm_mod]
 [<ffffffff810c1a2a>] ? vfs_ioctl+0x21/0x6b
 [<ffffffff810c1f5d>] ? do_vfs_ioctl+0x476/0x4cb
 [<ffffffff810b9112>] ? sys_newstat+0x20/0x29
 [<ffffffff810c2003>] ? sys_ioctl+0x51/0x70
 [<ffffffff8100b92b>] ? system_call_fastpath+0x16/0x1b

As noted above, I haven't had much time to go any further, but am more
than willing to check out any patches.

I am using a RHEL5.3 w/ the 2.6.31-rc3 kernel - tools are at:

  LVM version:     2.02.40-RHEL5 (2008-10-24)
  Library version: 1.02.28 (2008-09-18)
  Driver version:  4.15.0

So, if I need new tools, let me know... :-)

Regards,
Alan D. Brunelle
Hewlett-Packard


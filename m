Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbXDAKHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbXDAKHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 06:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932388AbXDAKHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 06:07:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386AbXDAKHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 06:07:52 -0400
From: Neil Brown <neilb@suse.de>
To: "Florian D." <flockmock@gmx.at>
Date: Sun, 1 Apr 2007 20:07:45 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17935.33905.934360.22271@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: cannot add device to partitioned raid6 array
In-Reply-To: message from Florian D. on Sunday April 1
References: <460EF263.7020505@gmx.at>
	<17935.8101.815473.709581@notabene.brown>
	<460F7A87.3030201@gmx.at>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday April 1, flockmock@gmx.at wrote:
> Neil Brown wrote:
> > On Saturday March 31, flockmock@gmx.at wrote:
> >> hi list!
> >>
> >> in short:
> >> I created a partitioned raid6 array with 2 missing drives. Now, I want to add a device. It fails with:
> >> flockmock ~ # mdadm -a /dev/md_d4 /dev/sdb2
> >> mdadm: add new device failed for /dev/sdb2 as 4: Invalid argument
> > 
> > Thanks for the detailed problem report.
> > 
> > I think the cause of the error is that /dev/sdb2 is too small.
> > It needs to be at least 490030594 sectors. How big is it?
                                      ^^^^^^^
I should have said 490030594 sectors or 245015297 KB, which would have
made it clearer, sorry.

> 
> but the *device* size should be only ~250GB, so the array size is ~500GB, no?
> 
> flockmock ~ # mdadm --detail /dev/md_d4
> /dev/md_d4:
>          Version : 00.90.03
>    Creation Time : Sat Mar 31 19:48:58 2007
>       Raid Level : raid6
>       Array Size : 490030464 (467.33 GiB 501.79 GB)
>    Used Dev Size : 245015232 (233.66 GiB 250.90 GB)
>                    ^^^^^^^^^^
> 
> these disks are all 250 GB harddisks, formatted in the same way -- but they are from different 
> vendors! The block sizes from the partitions vary a little bit (taken from /sbin/fdisk):
> 
> /dev/sda2: 245015347
> /dev/sdc2: 245015347
> /dev/sdb2: 244099642  -> different vendor
> 
> do you think that may be the cause?

Definitely the cause.  If you really need to add this array, you may
be able to reduce the usage of the array, then reduce the size of the
array, then add the drive.
Depending on how you have partitioned the array, and how you are using
the partitions, you may just need to reduce the filesystem in the last
partition, then use *fdisk to resize the partition.  Then something
like:

   mdadm --grow --size=243000000 /dev/md_d4

Is is generally safer to reduce the filesystem too much, resize the
device, then grow the filesystem up to the size of the device.  That
way avoids fiddly arithmetic and so reduces the chance of failure.

NeilBrown


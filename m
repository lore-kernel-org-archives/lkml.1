Return-Path: <linux-kernel-owner+w=401wt.eu-S1763007AbXFKGNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763007AbXFKGNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 02:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXFKGM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 02:12:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55892 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbXFKGMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 02:12:55 -0400
Date: Sun, 10 Jun 2007 23:12:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, cebbert@redhat.com,
       sandeen@redhat.com, maneesh@in.ibm.com, cs@tequila.co.jp
Subject: Re: [PATCHSET 2.6.22-rc4] sysfs: fix race conditions
Message-Id: <20070610231203.730d0aba.akpm@linux-foundation.org>
In-Reply-To: <20070611050107.GJ29122@htj.dyndns.org>
References: <20070611050107.GJ29122@htj.dyndns.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007 14:01:07 +0900 Tejun Heo <htejun@gmail.com> wrote:

> Currently, there are several race conditions around dentry/inode
> reclamation.
> 
> a. sysfs_dirent->s_dentry dereferencing in sysfs_readdir()
> 
> b. sysfs_dirent->s_dentry dereferencing in sysfs_drop_dentry()
> 
> c. sysfs_dirent->s_dentry clearing in sysfs_d_iput()
> 
> All aboves are done without synchronization and can cause oops if the
> timing is right (or wrong).
> 
> These race conditions are difficult to trigger but with the attached
> patch (sysfs-races.patch) and the following commands running
> parallelly, all three are reliably reproducible (you may have to
> change timings or disable others to trigger specific one).
> 
> 1. while true; do insmod drivers/ata/libata.ko; insmod drivers/ata/ata_piix.ko; sleep 1; rmmod ata_piix; rmmod libata; sleep 1; echo -n . ; done
> 2. while true; do find /sys -type f | xargs cat > /dev/null; echo -n .; sleep 1; done
> 3. while true; do find /sys/class/scsi_disk -type f | sort | xargs cat > /dev/null; echo -n .; sleep 1; done
> 4. while true; do umount /sys; sleep 1; mount /sys; sleep 1; echo -n .; done
> 
> #1 assumes there are several devices attached to ata_piix controller.
> Change #1 to any module or command which creates and removes sysfs
> nodes repeatedly and adjust #3 to cat those sysfs nodes.
> 
> All known race conditions are fixed in the current -mm.  #a is
> replaced by adding sd->s_ino and allocating unique ino with ida.  #b
> and #c are fixed during sysfs_drop_dentry() rewrite.  However, those
> changes were too big to apply to 2.6.22-rcX or any stable branches.
> 
> This patchset contains three minimal backports of fixes in -mm.  With
> all patches in the patchset and sysfs-races.patch applied, kernel
> survived ~20 hours of stress test without any problem.

So these are being proposed for 2.6.22?

I do wonder about Rafael's bug which he bisected down to
gregkh-driver-sysfs-use-singly-linked-list-for-sysfs_dirent-tree.patch.

If that won't be a problem in this patchset then I spose it's probably best
to go ahead with a 2.6.22 merge, but it's more a Greg thing than a me
thing.

I don't have a tree to merge these patches into, unless I drop all the
patches which are in Greg's tree.

Greg, can I leave it up to you to decide how we are to proceed here?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab0CHT7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:59:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab0CHT7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:59:40 -0500
Date: Mon, 8 Mar 2010 20:58:47 +0100
From: Karel Zak <kzak@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Jim Meyering <jim@meyering.net>
Subject: Re: ATA 4 KiB sector issues.
Message-ID: <20100308195847.GC18077@nb.net.home>
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1zl2ic058.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 10:18:27AM -0500, Martin K. Petersen wrote:
> >>>>> "Tejun" == Tejun Heo <tj@kernel.org> writes:
> Tejun> Partitioners maybe should only align partitions which will be
> Tejun> used by Linux and default to the traditional layout for others
> Tejun> while allowing explicit override.
> 
> I don't think we take the partition type into account.  Karel?

Yes, you're right. 

(IMHO our goal should be to minimize number of places where anything
depends on partition type.)

> Tejun> Reportedly, commonly used partitioners aren't ready to handle
> Tejun> drives larger than 2 TiB in any configuration and alignment isn't

The limit is specific for DOS partition table (with 512-byte log.
sectors), but for example GPT uses 64-bit LBA. I believe that our
partitioning tools don't introduce any other restriction.

> Tejun> done properly for drives with 4 KiB physical sectors.  4 KiB
> Tejun> logical sector support is broken in both the kernel 
> 
> Huh, what?  My homedir is on a 4KiB LBS/PBS drive and has been for ~2
> years.
> 
> 
> Tejun> (need more details and probably a whole section on partitioner
> Tejun> behaviors)
> 
> I'm Cc:'ing Karel Zak and Jim Meyering who have been doing all the
> alignment work for fdisk and parted respectively.  Karel, Jim: The full
> writeup is here:
> 
> 	http://ata.wiki.kernel.org/index.php/ATA_4_KiB_sector_issues
> 
> It'd be great if you guys could share what you have been doing to the
> tooling.

 small summary:

 - libblkid provides unified API to topology information, it supports:
    - ioctls (kernel >= 2.6.32)
    - sysfs (kernel >= 2.6.31)
    - stripe chunk size and stripe width for DM, MD. LVM and evms on
      old kernels
 - libparted and fdisk are linked against libblkid

 - fdisk supports 4KiB logical sector size (util-linux-ng >= 2.15
 - fdisk supports 4KiB physical sector size (util-linux-ng >= 2.17)
 - fdisk uses 1MiB alignment (or more if optimal I/O size is bigger)
   and alignment_offset for all partitions in non-DOS mode
   (util-linux-ng >= 2.17.1)

 - parted supports 4KiB physical sector size
 - parted uses 1MiB alignment for disks with unknown topology, disks
   with topology information are aligned to optimal (or minimum) I/O
   size (parted >= 2.1)
 
 - EFI GPT code in the kernel has been updated to works properly with 
   4KiB sectors (kernel >= 2.6.33)

 - mkfs.{ext,xfs,gfs2,ocfs2} have been update to work properly with
   topology information, mkfs.{ext,xfs} are linked against libblkid
   for compatibility with old kernel (for stripe chunk size / width)

 - Fedora-13/RHEL6 installer uses libparted with 4KiB support

 - alignment_offset & 4KiB support is planned for LUKS (cryptsetup)

> Tejun> Unfortunately, the transition to 4 KiB sector size, physical only
> Tejun> or logical too, is looking fairly ugly.  Hopefully, a reasonable
> Tejun> solution can be reached in not too distant future but even with
> Tejun> all the software side updated, it looks like it's gonna cause
> Tejun> significant amount of confusion and frustration.
> 
> With regards to XP compatibility I don't think we should go too much out
> of our way to accommodate it.  XP has been disowned by its master and I
> think virtualization will take care of the rest.
> 
> FWIW, recent fdisk has a command line flag that will enable/disable DOS
> compatible layout.

 yes, util-linux-ng 2.17.1, fdisk -c
 
 Note that non-DOS mode will be default in the next major
 util-linux-ng release.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>

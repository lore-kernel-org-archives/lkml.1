Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab0CIDsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 22:48:31 -0500
Received: from wdscspam2.wdc.com ([129.253.170.131]:48766 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab0CIDs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 22:48:26 -0500
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 22:48:26 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: ATA 4 KiB sector issues.
Date: Mon, 8 Mar 2010 19:38:53 -0800
Message-ID: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD78@wdscexbe01.sc.wdc.com>
In-Reply-To: <4B95B39C.70402@kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ATA 4 KiB sector issues.
Thread-Index: Acq/MULgjdXNM2lITimoTkuO9HwuEgAAI7Rg
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net> <20100308195847.GC18077@nb.net.home> <4B95B39C.70402@kernel.org>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: "Tejun Heo" <tj@kernel.org>, "Karel Zak" <kzak@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       <linux-ide@vger.kernel.org>, "lkml" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Mark Lord" <kernel@teksavvy.com>,
       <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       <hirofumi@mail.parknet.co.jp>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <irtiger@gmail.com>,
       "Matthew Wilcox" <matthew@wil.cx>, <aschnell@suse.de>,
       <knikanth@suse.de>, <jdelvare@suse.de>,
       "Jim Meyering" <jim@meyering.net>
X-OriginalArrivalTime: 09 Mar 2010 03:38:54.0581 (UTC) FILETIME=[0AED4250:01CABF3A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

-----Original Message-----
From: Tejun Heo [mailto:tj@kernel.org] 
Sent: Monday, March 08, 2010 6:34 PM
To: Karel Zak
Cc: Martin K. Petersen; linux-ide@vger.kernel.org; lkml; Daniel Taylor; Jeff
Garzik; Mark Lord; tytso@mit.edu; H. Peter Anvin;
hirofumi@mail.parknet.co.jp; Andrew Morton; Alan Cox; irtiger@gmail.com;
Matthew Wilcox; aschnell@suse.de; knikanth@suse.de; jdelvare@suse.de; Jim
Meyering
Subject: Re: ATA 4 KiB sector issues.

Hello,

On 03/09/2010 04:58 AM, Karel Zak wrote:
>> Tejun> Reportedly, commonly used partitioners aren't ready to handle 
>> Tejun> drives larger than 2 TiB in any configuration and alignment 
>> Tejun> isn't
> 
> The limit is specific for DOS partition table (with 512-byte log.
> sectors), but for example GPT uses 64-bit LBA. I believe that our 
> partitioning tools don't introduce any other restriction.

Hmmm... the 'reportedly' was from Daniel Taylor or maybe I just
misinterpreted the conversation.  Daniel, can you please fill in?

DLT> The problem that I see is that the installers and upper level
applications do not make good choices for partition layout.
DLT> "parted", itself, seems to work OK in the latest version.  One of the
things I've heard since I started this process is that
DLT> there are some libraries associated with the process of
partitioning/formatting.  Perhaps the upper layers and those
DLT> libraries aren't synced up?

>> Tejun> done properly for drives with 4 KiB physical sectors.  4 KiB 
>> Tejun> logical sector support is broken in both the kernel
>>
>> Huh, what?  My homedir is on a 4KiB LBS/PBS drive and has been for ~2 
>> years.

By default, they aren't aligned properly, are they?

>> Tejun> (need more details and probably a whole section on partitioner
>> Tejun> behaviors)
>>
>> I'm Cc:'ing Karel Zak and Jim Meyering who have been doing all the 
>> alignment work for fdisk and parted respectively.  Karel, Jim: The 
>> full writeup is here:
>>
>> 	http://ata.wiki.kernel.org/index.php/ATA_4_KiB_sector_issues
>>
>> It'd be great if you guys could share what you have been doing to the 
>> tooling.
> 
>  small summary:
> 
>  - libblkid provides unified API to topology information, it supports:
>     - ioctls (kernel >= 2.6.32)
>     - sysfs (kernel >= 2.6.31)
>     - stripe chunk size and stripe width for DM, MD. LVM and evms on
>       old kernels
>  - libparted and fdisk are linked against libblkid
> 
>  - fdisk supports 4KiB logical sector size (util-linux-ng >= 2.15
>  - fdisk supports 4KiB physical sector size (util-linux-ng >= 2.17)
>  - fdisk uses 1MiB alignment (or more if optimal I/O size is bigger)
>    and alignment_offset for all partitions in non-DOS mode
>    (util-linux-ng >= 2.17.1)

That's great.  Daniel, maybe you were testing older versions?  Or maybe
those failures were manifested from libata mishandling 4KiB r/w requets.

DLT> As I said, above, it could be libraries.  I was not aware that so much
of the implementation was embedded there.

>  - parted supports 4KiB physical sector size
>  - parted uses 1MiB alignment for disks with unknown topology, disks
>    with topology information are aligned to optimal (or minimum) I/O
>    size (parted >= 2.1)

This will result in incorrect alignment for drives which lie about the
physical sector size to work around BIOS/drivers issues (C-1).  It would
probably be best to align to at least 1MiB.

DLT> Please.

>  - EFI GPT code in the kernel has been updated to works properly with 
>    4KiB sectors (kernel >= 2.6.33)

libata is broken for logical 4KiB ATA devices tho.  I'll fix it up.

>  - mkfs.{ext,xfs,gfs2,ocfs2} have been update to work properly with
>    topology information, mkfs.{ext,xfs} are linked against libblkid
>    for compatibility with old kernel (for stripe chunk size / width)
> 
>  - Fedora-13/RHEL6 installer uses libparted with 4KiB support
> 
>  - alignment_offset & 4KiB support is planned for LUKS (cryptsetup)
> 
>> Tejun> Unfortunately, the transition to 4 KiB sector size, physical 
>> Tejun> only or logical too, is looking fairly ugly.  Hopefully, a 
>> Tejun> reasonable solution can be reached in not too distant future 
>> Tejun> but even with all the software side updated, it looks like 
>> Tejun> it's gonna cause significant amount of confusion and frustration.
>>
>> With regards to XP compatibility I don't think we should go too much 
>> out of our way to accommodate it.  XP has been disowned by its master 
>> and I think virtualization will take care of the rest.

Yeah, good point.  I'm just a bit worried that it might generate a lot of
frustrated bug reports.  Well, maybe we should just advise users to install
windows first and then install Linux.

DLT> Simple reality is that XP is "forever".  Drives >2TiB, which may be
USB-attached, used with XP will be MBR-partitioned
DLT> and use 4096-byte sectors.  We need to be able to read/write those
disks on Linux systems.

>> FWIW, recent fdisk has a command line flag that will enable/disable 
>> DOS compatible layout.
> 
>  yes, util-linux-ng 2.17.1, fdisk -c
>  
>  Note that non-DOS mode will be default in the next major  
> util-linux-ng release.

I'll try to merge these information into the ata-4k doc.

Thank you very much.

DLT> One last comment: I just tried to partition and format a >2TiB drive on
fully updated Ubuntu 9.10 with GParted.
DLT> I selected not to cylinder align, use GPT and ext3, and to put 1 MiB
preceeding and following.  libparted failed
DLT> with "unable to satisfy all constraints of the partition".  Using
"parted", I created the partition, and then
DLT> GParted was able to apply the ext3 file system.
--
tejun

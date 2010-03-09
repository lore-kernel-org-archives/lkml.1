Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab0CICgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:36:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:48732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495Ab0CICgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:36:01 -0500
Message-ID: <4B95B39C.70402@kernel.org>
Date: Tue, 09 Mar 2010 11:34:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
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
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net> <20100308195847.GC18077@nb.net.home>
In-Reply-To: <20100308195847.GC18077@nb.net.home>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Mar 2010 02:34:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/09/2010 04:58 AM, Karel Zak wrote:
>> Tejun> Reportedly, commonly used partitioners aren't ready to handle
>> Tejun> drives larger than 2 TiB in any configuration and alignment isn't
> 
> The limit is specific for DOS partition table (with 512-byte log.
> sectors), but for example GPT uses 64-bit LBA. I believe that our
> partitioning tools don't introduce any other restriction.

Hmmm... the 'reportedly' was from Daniel Taylor or maybe I just
misinterpreted the conversation.  Daniel, can you please fill in?

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
>> alignment work for fdisk and parted respectively.  Karel, Jim: The full
>> writeup is here:
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

That's great.  Daniel, maybe you were testing older versions?  Or
maybe those failures were manifested from libata mishandling 4KiB r/w
requets.

>  - parted supports 4KiB physical sector size
>  - parted uses 1MiB alignment for disks with unknown topology, disks
>    with topology information are aligned to optimal (or minimum) I/O
>    size (parted >= 2.1)

This will result in incorrect alignment for drives which lie about the
physical sector size to work around BIOS/drivers issues (C-1).  It
would probably be best to align to at least 1MiB.

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
>> Tejun> Unfortunately, the transition to 4 KiB sector size, physical only
>> Tejun> or logical too, is looking fairly ugly.  Hopefully, a reasonable
>> Tejun> solution can be reached in not too distant future but even with
>> Tejun> all the software side updated, it looks like it's gonna cause
>> Tejun> significant amount of confusion and frustration.
>>
>> With regards to XP compatibility I don't think we should go too much out
>> of our way to accommodate it.  XP has been disowned by its master and I
>> think virtualization will take care of the rest.

Yeah, good point.  I'm just a bit worried that it might generate a lot
of frustrated bug reports.  Well, maybe we should just advise users to
install windows first and then install Linux.

>> FWIW, recent fdisk has a command line flag that will enable/disable DOS
>> compatible layout.
> 
>  yes, util-linux-ng 2.17.1, fdisk -c
>  
>  Note that non-DOS mode will be default in the next major
>  util-linux-ng release.

I'll try to merge these information into the ata-4k doc.

Thank you very much.

-- 
tejun

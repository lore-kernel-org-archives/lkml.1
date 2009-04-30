Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbZD3BqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbZD3BqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 21:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbZD3Bp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 21:45:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38791 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbZD3Bpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 21:45:55 -0400
Message-ID: <49F902CF.7080307@garzik.org>
Date: Wed, 29 Apr 2009 21:45:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.com,
       dm-devel@RedHat.com
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
References: <1233456951-992-1-git-send-email-tj@kernel.org>
In-Reply-To: <1233456951-992-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> This patchset implements alt_size, which is a size hint to the users
> of a block device.  It's primarily to communicate the BIOS (HPA) size
> on ATA devices to userland, so that dmraid can consider it when trying
> to figure out BIOS raid layout.  This is critical as dmraid can be
> tricked into assemblying the wrong raid when fed with the unlocked
> size and if the disk content is right (or, rather, wrong) and good
> number of distros are shipping with ignore_hpa=1 as default.
> 
> This patch contains the following three patches.
> 
>   0001-block-add-alt_size.patch
>   0002-scsi-add-scsi_device-alt_capacity.patch
>   0003-libata-export-HPA-size-as-alt_size.patch
> 
> Without the above three patches, I get the following on my nv RAID-0
> if HPA unlocking is turned on.
> 
>   # ~/work/dmraid/tools/dmraid -a y
>   RAID set "nvidia_djgdjigi" was activated
>   # mount /dev/dm-0 /mnt/tmp
>   mount: wrong fs type, bad option, bad superblock on /dev/dm-0,
> 	 missing codepage or helper program, or other error
> 	 In some cases useful info is found in syslog - try
> 	 dmesg | tail  or so
> 
> With the above three patches and modified dmraid,
> 
>   ck804:~/os/work/build # ~/work/dmraid/tools/dmraid -a y -v -v -v
>   ...
>   NOTICE: /dev/sdb: using BIOS sectors 234439535
>   RAID set "nvidia_djgdjigi" was activated
>   ...
>   ck804:~/os/work/build # mount /dev/dm-0 /mnt/tmp
>   ck804:~/os/work/build # umount /dev/dm-0
> 
> Any ideas on through which tree this should be pushed?  I'll post
> dmraid patches as a reply to this thread for reference.
> 
> Thanks.
> 
> This patchset is against the current linus#master[1] and contains the
> following changes.
> 
>  block/genhd.c              |   26 ++++++++++++++++++++++++++
>  drivers/ata/libata-core.c  |    2 ++
>  drivers/ata/libata-scsi.c  |    2 ++
>  drivers/scsi/sd.c          |    1 +
>  include/linux/genhd.h      |   13 ++++++++++++-
>  include/linux/libata.h     |    1 +
>  include/scsi/scsi_device.h |    1 +
>  7 files changed, 45 insertions(+), 1 deletion(-)

<shrug>  I suppose...

It just seems like a nasty hack, but unfortunately I don't see anyone 
stepping up to do it properly -- with a DM device automatically layered 
on top that splits the device into separate regions:  one block device 
for the 'regular' area, and one for the HPA.

	Jeff



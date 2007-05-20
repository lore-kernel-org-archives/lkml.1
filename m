Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbXETRSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbXETRSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 13:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbXETRS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 13:18:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:17903 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbXETRS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 13:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CQf1WfbwkiG66uKkpBDL9gGk++Vhf7z7FeYNZPL8EC4wK2OhU0kVXT4QcRkhUdTkQ9JBsQfrAo9kUWKfuPnCyinUKBQ/syNv3hAfM90rDmACbhJaB56EW4cLGtVywy2aycMrfMjhxatGEPUoFwHYhIiaUNVBJxMBrgVggWuYF8o=
Message-ID: <465082BF.2070306@gmail.com>
Date: Sun, 20 May 2007 19:17:51 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Paul Mundt <lethal@linux-sh.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       garyhade@us.ibm.com
Subject: Re: sd_resume redundant?  [was: [PATCH] libata: implement       
    ata_wait_after_reset()]
References: <20070510072005.GA27316@linux-sh.org>    <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com>    <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com>    <20070511005217.GA23186@li <464B3505.20004@gmail.com>    <2229.81.207.0.53.1179592754.squirrel@secure.samage.net>    <464F4548.6020101@gmail.com> <464F4A58.2050607@gmail.com>    <4764.81.207.0.53.1179613997.squirrel@secure.samage.net>    <46501ACF.6020702@gmail.com> <1345.81.207.0.53.1179671262.squirrel@secure.samage.net>
In-Reply-To: <1345.81.207.0.53.1179671262.squirrel@secure.samage.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
>> Can you try to measure with sd_resume in place?
> 
> [    2.173366] sd 0:0:0:0: [sda] Starting disk
> [    2.475422] ata2: SATA link down (SStatus 0 SControl 310)
> [    5.478403] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [    5.481928] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
> [    5.485904] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
> [    5.485913] ata1.00: configured for UDMA/100
> [    5.505109] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
> [    5.505461] sd 0:0:0:0: [sda] Write Protect is off
> [    5.505465] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    5.505612] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or
> FUA
> ...
> [    6.157259] Restarting tasks ... done.
> 
> 
> And with echo 0 > /sys/class/scsi_disk/0\:0\:0\:0/manage_start_stop:
> 
> [    2.476476] ata2: SATA link down (SStatus 0 SControl 310)
> ...
> [    2.825479] Restarting tasks ... done.
> ...
> [    5.022076] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [    5.025605] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
> [    5.028594] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
> [    5.028606] ata1.00: configured for UDMA/100
> [    5.028720] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
> [    5.028767] sd 0:0:0:0: [sda] Write Protect is off
> [    5.028773] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    5.028831] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or
> FUA
> 
> So over all it takes half a second longer to detect the disk, but
> because everything waits on it, it takes more than three seconds
> longer to resume.

Eeeek.  Extra three secs doesn't sound too hot.  :-(

> Setting manage_start_stop to 0 fixes it and is good enough for me, I
> didn't notice anything bad yet because of the unmanaged
> stop. Implementing background spin up will fix it too.

Just commenting out sd_resume() would be a better solution for your
case tho.

>>> Everything seems to work fine without sd_resume(), so why is it needed?
>> Because not all disks spin up without being told to do so and like it or
>> not spinning disks up on resume is the default behavior.  As I wrote in
>> the other reply, it would be worthwhile to make it configurable.
> 
> Not even after they receive a read command? Ugh.

After receiving a command which requires media access, they do.  What
I was saying is that the current default behavior is to spin up all
devices on resume and part of that is achieved by sd_resume().

Hmmm... skipping START_STOP during sd_resume() actually is a pretty
good solution for ATA devices.  I'll think about it.

Thanks.

-- 
tejun

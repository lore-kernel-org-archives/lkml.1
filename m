Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbXETO2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbXETO2G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 10:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbXETO1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 10:27:54 -0400
Received: from neon.samage.net ([85.17.153.66]:45642 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580AbXETO1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 10:27:52 -0400
Message-ID: <1345.81.207.0.53.1179671262.squirrel@secure.samage.net>
In-Reply-To: <46501ACF.6020702@gmail.com>
References: <20070510072005.GA27316@linux-sh.org>
    <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com>
    <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com>
    <20070511005217.GA23186@li <464B3505.20004@gmail.com>
    <2229.81.207.0.53.1179592754.squirrel@secure.samage.net>
    <464F4548.6020101@gmail.com> <464F4A58.2050607@gmail.com>
    <4764.81.207.0.53.1179613997.squirrel@secure.samage.net>
    <46501ACF.6020702@gmail.com>
Date: Sun, 20 May 2007 16:27:42 +0200 (CEST)
Subject: Re: sd_resume redundant?  [was: [PATCH] libata: implement      
     ata_wait_after_reset()]
From: "Indan Zupancic" <indan@nul.nu>
To: "Tejun Heo" <htejun@gmail.com>
Cc: "Paul Mundt" <lethal@linux-sh.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       garyhade@us.ibm.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -0.9
X-Scan-Signature: f0d5e446bfc5bbd6ce781899a390d841
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 11:54, Tejun Heo wrote:
> Indan Zupancic wrote:
>> On Sat, May 19, 2007 21:04, Tejun Heo wrote:
>>> Tejun Heo wrote:
>>>> Yeah, if SCR registers are accessible, 0xff doesn't indicate the device
>>>> isn't there, so the whole skip-0xff logic probably shouldn't apply in
>>>> such cases, but we can also achieve pretty good result by just making
>>>> the first reset tries a bit more aggressive.
>>> So, here's the patch.
>>>
>>> Paul, can you please test this patch without the previous patch?  Indan,
>>> this should reduce the resume delay.  Please test.  But you'll still
>>> feel some added delay compared to 2.6.20 due to the mentioned
>>> suspend/resume change.
>>
>> This removed the COMRESET errors indeed, and with sd_resume()
>> disabled everything is speedy again (2s or so. Still a desktop pc).
>> I didn't try with sd_resume enabled.
>
> Can you try to measure with sd_resume in place?

[    2.173366] sd 0:0:0:0: [sda] Starting disk
[    2.475422] ata2: SATA link down (SStatus 0 SControl 310)
[    5.478403] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    5.481928] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
[    5.485904] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
[    5.485913] ata1.00: configured for UDMA/100
[    5.505109] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[    5.505461] sd 0:0:0:0: [sda] Write Protect is off
[    5.505465] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.505612] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or
FUA
...
[    6.157259] Restarting tasks ... done.


And with echo 0 > /sys/class/scsi_disk/0\:0\:0\:0/manage_start_stop:

[    2.476476] ata2: SATA link down (SStatus 0 SControl 310)
...
[    2.825479] Restarting tasks ... done.
...
[    5.022076] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    5.025605] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
[    5.028594] ata1.00: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 234441648
[    5.028606] ata1.00: configured for UDMA/100
[    5.028720] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[    5.028767] sd 0:0:0:0: [sda] Write Protect is off
[    5.028773] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.028831] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or
FUA

So over all it takes half a second longer to detect the disk, but because everything waits on it,
it takes more than three seconds longer to resume.

Setting manage_start_stop to 0 fixes it and is good enough for me, I didn't notice anything bad yet
because of the unmanaged stop. Implementing background spin up will fix it too.


>> Everything seems to work fine without sd_resume(), so why is it needed?
>
> Because not all disks spin up without being told to do so and like it or
> not spinning disks up on resume is the default behavior.  As I wrote in
> the other reply, it would be worthwhile to make it configurable.

Not even after they receive a read command? Ugh.

Greeting,

Indan



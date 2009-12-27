Return-Path: <linux-kernel-owner+w=401wt.eu-S1751746AbZL0Vwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbZL0Vwt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbZL0Vws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:52:48 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:38695 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZL0Vwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:52:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ow4Ylw29N9YT/iOgsdB553fMYX1Y1LcBgHaCdVuiPABlra1eDJmPcMk48LB6HUlH3F
         d2JwseC7hKF8yHVmwwH+YQqTgQ7W+/LZMmGdzIcm8pjG02f4m78UF4TCw/YIrfWFLNtw
         ccioHCCtdBGMd+Rf++owKh94vAp78Yj/8oeNI=
MIME-Version: 1.0
In-Reply-To: <7c8826910912191437k4e1d93bap12874a6d6e0046d3@mail.gmail.com>
References: <7c8826910912182213o2e0e8af7ic305f150c52e0618@mail.gmail.com>
	 <4B2C80DD.9080005@garzik.org> <4B2D1CF3.4070106@gmail.com>
	 <7c8826910912191437k4e1d93bap12874a6d6e0046d3@mail.gmail.com>
Date: Sun, 27 Dec 2009 15:52:46 -0600
Message-ID: <51f3faa70912271352g2784edc8oc899bd6def7b7275@mail.gmail.com>
Subject: Re: 2.6.32 seemed to have broken nVidia MCP7A sata controller
From: Robert Hancock <hancockrwd@gmail.com>
To: Mike Cui <cuicui@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 19, 2009 at 4:37 PM, Mike Cui <cuicui@gmail.com> wrote:
> Thanks, changing that one line fixed it. I can try to find an intel
> motherboard sometime next week to see if it's the drive or the
> controller.

Hi Mike, did you ever get a chance to try this test?

>
> On Sat, Dec 19, 2009 at 10:35 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
>> On 12/19/2009 01:29 AM, Jeff Garzik wrote:
>>>
>>> On 12/19/2009 01:13 AM, Mike Cui wrote:
>>>>
>>>> I have an nVidia MCP7A AHCI controller. I upgraded to 2.6.32.2 and my
>>>> system deterministically freezes trying to mount file systems. Once in
>>>> a while it will come back and finish booting after freezing for 1
>>>> minute or 2. dmesg indicates that there were NCQ errors, but 2.6.31
>>>> anb before has always worked flawlessly for me. What changed in
>>>> 2.6.32? I will be more than happy to help track down this issue.
>>>
>>>> ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
>>>> ata1.00: cmd 61/08:00:4f:ad:03/00:00:00:00:00/40 tag 0 ncq 4096 out
>>>> res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>>> ata1: hard resetting link
>>>> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>>> ata1.00: configured for UDMA/133
>>>> ata1.00: device reported invalid CHS sector 0
>>>
>>> Looks like things are timing out, and then go downhill from there. This
>>> explanation of timeout gives some hints on possible causes:
>>> http://ata.wiki.kernel.org/index.php/Libata_error_messages#Error_classes
>>>
>>> The ideal would be if you could bisect between 2.6.31 and 2.6.32, to see
>>> if it's a software change that is the cause.
>>>
>>> Looking at drivers/ata/ahci.c history, the only thing that -might- cause
>>> problems is 388539f3ff0cf1de926b03f94e1eec112358f74d ('git show $commit'
>>> for full commit info and diff).
>>
>> I suspect that as well (it's the commit that adds FPDMA auto-activate on DMA
>> setup FIS support). Your drive indicates it's supported but it's possible
>> it's broken on that drive or the controller. If the drive doesn't set the
>> activate bit in the DMA setup FIS properly or the controller doesn't respect
>> it, then FPDMA requests will stall.
>>
>> Mike, can you try and revert that patch, or else just change this line in
>> drivers/ata/ahci.c:
>>
>>                pi.flags |= ATA_FLAG_NCQ | ATA_FLAG_FPDMA_AA;
>>
>> to
>>
>>                pi.flags |= ATA_FLAG_NCQ;
>>
>> and rebuild and see if it works better?
>>
>> I tend to suspect the controller is the problem (I've got WD drives that
>> work fine with AA on Intel AHCI, though it could be model-specific). I guess
>> the only way to verify for sure which one it is would be if someone else had
>> that particular drive model on a different AHCI controller and could verify
>> if it worked with 2.6.32+ or not.
>>
>

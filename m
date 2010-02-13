Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab0BMWjp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 17:39:45 -0500
Received: from mail-yw0-f179.google.com ([209.85.211.179]:46321 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0BMWjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 17:39:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SEl2XI0PwxspaybBLJRWqz51zFATWtcG2mF4Ffcga5XRSCZ4e45/pwUBivRMi1Nu/+
         9tu/NXmaayksHjBuMwfw1+mZeb4mQh6rXwJ9sBe33qfA5m3WKsaqnA2wAV9kg75gQW1b
         tw2aj3Pr11O7w/77nzHrRbL97VP+NUSllS6iA=
Message-ID: <4B772A2C.4050009@garzik.org>
Date: Sat, 13 Feb 2010 17:39:40 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 1/3] pata_pdc202xx_old: fix UDMA mode for Promise UDMA33
 cards
References: <20100213133538.11564.94218.sendpatchset@localhost> <20100213133553.11564.95723.sendpatchset@localhost>
In-Reply-To: <20100213133553.11564.95723.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 08:35 AM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] pata_pdc202xx_old: fix UDMA mode for Promise UDMA33 cards
>
> On Monday 04 January 2010 02:30:24 pm Russell King wrote:
>
>> Found the problem - getting rid of the read of the alt status register
>> after the command has been written fixes the UDMA CRC errors on write:
>>
>> @@ -676,7 +676,8 @@ void ata_sff_exec_command(struct ata_port *ap, const struct
>> ata_taskfile *tf)
>>          DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
>>
>>          iowrite8(tf->command, ap->ioaddr.command_addr);
>> -       ata_sff_pause(ap);
>> +       ndelay(400);
>> +//     ata_sff_pause(ap);
>>   }
>>   EXPORT_SYMBOL_GPL(ata_sff_exec_command);
>>
>>
>> This rather makes sense.  The PDC20247 handles the UDMA part of the
>> protocol.  It has no way to tell the PDC20246 to wait while it suspends
>> UDMA, so that a normal register access can take place - the 246 ploughs
>> on with the register access without any regard to the state of the 247.
>>
>> If the drive immediately starts the UDMA protocol after a write to the
>> command register (as it probably will for the DMA WRITE command), then
>> we'll be accessing the taskfile in the middle of the UDMA setup, which
>> can't be good.  It's certainly a violation of the ATA specs.
>
> Fix it by adding custom ->sff_exec_command method for UDMA33 chipsets.
>
> Debugged-by: Russell King<rmk@arm.linux.org.uk>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/pata_pdc202xx_old.c |   13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)

applied



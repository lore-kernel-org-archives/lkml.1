Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZBKNhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZBKNhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZBKNhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:37:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:53851 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbZBKNhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:37:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=JSaBgNb7EJHTrW4Cas9LfVcrVZkZlbF1WLhw5kvM2i5yKMCQ1g7JPr6GQJG4MdcVV5
         izzTDNu+utkB6NuQcOUjfN01JaDuGTzmKeiP9MtQDbMG4wZp9us/ZjHasnmHcp0nBq66
         lFyS87/9l+vtBY+gGdVAaY5fjCqRgy+g7tag0=
MIME-Version: 1.0
Reply-To: petkovbb@gmail.com
In-Reply-To: <4992D108.2070709@ru.mvista.com>
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain>
	 <20090209232019.32406.98822.sendpatchset@localhost.localdomain>
	 <20090211065535.GC937@gollum.tnic> <4992D108.2070709@ru.mvista.com>
Date: Wed, 11 Feb 2009 14:37:40 +0100
Message-ID: <9ea470500902110537g4d6c67a3o35d1d8a4dcca0927@mail.gmail.com>
Subject: Re: [PATCH 5/6] ide: remove ide_execute_pkt_cmd()
From: Borislav Petkov <petkovbb@googlemail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Feb 11, 2009 at 2:22 PM, Sergei Shtylyov
<sshtylyov@ru.mvista.com> wrote:
> Hello.
>
> Borislav Petkov wrote:
>
>>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> Subject: [PATCH] ide: remove ide_execute_pkt_cmd()
>>>
>>> * Pass command structure to ide_execute_command() and skip
>>>  __ide_set_handler() for ATAPI protocols.
>>>
>>> * Convert ide_issue_pc() to always use ide_execute_command()
>>>  and remove no longer needed ide_execute_pkt_cmd().
>>>
>>> There should be no functional changes caused by this patch.
>>>
>>> Cc: Borislav Petkov <petkovbb@gmail.com>
>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>> ---
>>>  drivers/ide/ide-atapi.c    |   15 +++++++--------
>>>  drivers/ide/ide-iops.c     |   23 ++++++-----------------
>>>  drivers/ide/ide-taskfile.c |    6 ++----
>>>  include/linux/ide.h        |    5 ++---
>>>  4 files changed, 17 insertions(+), 32 deletions(-)
>>>
>>> Index: b/drivers/ide/ide-atapi.c
>>> ===================================================================
>>> --- a/drivers/ide/ide-atapi.c
>>> +++ b/drivers/ide/ide-atapi.c
>>> @@ -481,6 +481,7 @@ static void ide_init_packet_cmd(struct i
>>>        cmd->protocol  = dma ? ATAPI_PROT_DMA : ATAPI_PROT_PIO;
>>>        cmd->tf_flags |= IDE_TFLAG_OUT_LBAH | IDE_TFLAG_OUT_LBAM |
>>>                         IDE_TFLAG_OUT_FEATURE | tf_flags;
>>> +       cmd->tf.command = ATA_CMD_PACKET;
>>>        cmd->tf.feature = dma;          /* Use PIO/DMA */
>>>        cmd->tf.lbam    = bcount & 0xff;
>>>        cmd->tf.lbah    = (bcount >> 8) & 0xff;
>>> @@ -626,6 +627,7 @@ ide_startstop_t ide_issue_pc(ide_drive_t
>>>        unsigned int timeout;
>>>        u32 tf_flags;
>>>        u16 bcount;
>>> +       u8 drq_int = !!(drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT);
>>>
>>
>> How about we finally add those check macros in block layer fashion like
>> blk_pc_request et al and do
>>
>> #define drv_can_drq_interrupt(drive)    ((drive)->atapi_flags &
>> IDE_AFLAG_DRQ_INTERRUPT)
>>
>
>  I suppose it's for the devices that interrupt on packet DRQ? Then it's
> hardly a good name because it's not like this is some optional capability.

No, I was alluding to the command packet DRQ type used by the device as it is
put in SFF8020i, 7.1.7.1 General Conﬁguration Word.

>> or similar instead of wasting stack space?
>
>  It doesn't necessarily waste stack space. Haven't you heard about compiler
> putting local vairables into registers?

Yes, have you heard of unnecessary register spilling?

>> It'll also read better in the if() check:
>>
>> if (drv_can_irq_interrupt(drive)) { ...
>>
>
>  It's faster to checj a local variable than to dereference drv several times
> -- unless gcc optimizes that away (by creating an implicit local variable
> :-).

I hope gcc is smart enough to do that.

>> If it's ok with you, I'll whip up patch(es) later.
>>
>
>>>        if (dev_is_idecd(drive)) {
>>>                tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
>>> @@ -675,17 +677,14 @@ ide_startstop_t ide_issue_pc(ide_drive_t
>>>
>
>  Don't leave uncommented fragment behind please.
>
> MBR, Sergei
>
>

[..]


-- 
Regards/Gruss,
Boris

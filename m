Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZBOXST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZBOXST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 18:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZBOXSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 18:18:09 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:37690 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753720AbZBOXSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 18:18:08 -0500
Message-ID: <4998A2A9.2060607@ru.mvista.com>
Date: Mon, 16 Feb 2009 02:18:01 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: petkovbb@gmail.com, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] ide: remove ide_execute_pkt_cmd()
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain> <20090209232019.32406.98822.sendpatchset@localhost.localdomain> <20090211065535.GC937@gollum.tnic> <4992D108.2070709@ru.mvista.com> <9ea470500902110537g4d6c67a3o35d1d8a4dcca0927@mail.gmail.com> <4992D77F.3090802@ru.mvista.com> <9ea470500902110832p58cf6b6at38a20f9ea7557017@mail.gmail.com> <49980979.6090305@ru.mvista.com> <20090215173901.GA5156@gollum.tnic>
In-Reply-To: <20090215173901.GA5156@gollum.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Borislav Petkov wrote:

>>  I still don't undestand why you assume that such variable will be  
>> alloceted on stack -- gcc has 3 registers available for local variables  
>> (which doesn't have to save across function calls). However, the  
>> register variables have to take stack space indeed as they need to be  
>> saved on funciton entry... though I'm not sure that gcc will necessary  
>> put such variable in one of those 3 registers if it figures out that  
>> there are no function calls going to happen during its life time.
>>     
>>> and the code is more readable. A win-win situation, I'd say :).  
>>>       
>>  You haven't presented the code which gets generated when the local  
>> variable is used, so it's impossible to compare.
>>     
>
> Here's another example from ide-disk.c where you have stack variables cashing
> those flags checks:
>   

   They are caching the result of !! in 'u8' variables -- which is not 
the same as cahing the flags. I suspect gcc avoid putting byte-sized 
variables into registers...

> <ide-disk.c>
> static ide_startstop_t __ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
>                                         sector_t block)
> {
>         ide_hwif_t *hwif        = drive->hwif;
>         u16 nsectors            = (u16)rq->nr_sectors;
>         u8 lba48                = !!(drive->dev_flags & IDE_DFLAG_LBA48);
>         u8 dma                  = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
>         ide_task_t              task;
>         struct ide_taskfile     *tf = &task.tf;
>         ide_startstop_t         rc;
>
>         if ((hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) && lba48 && dma) {
>                 if (block + rq->nr_sectors > 1ULL << 28)
>                         dma = 0;
>                 else
>                         lba48 = 0;
>         }
> </ide-disk.c>
>
> Corresponding asm (this time i386 but I don't think it matters since we
> need at least one arch to prove my point).
>
> <ide-disk.s>
> .LVL48:
>         .loc 1 94 0
>         movl    %eax, %edx      # D.32119, tmp93
>         .loc 1 95 0
>         shrl    %eax    # D.32119
>   

   Where's the shift count I wonder?

>         andb    $1, %al #,
>         movb    %al, -58(%ebp)  #, dma
> .LVL49:
>         .loc 1 100 0
>         movl    -52(%ebp), %eax # hwif,
>         .loc 1 94 0
>         shrl    $21, %edx       #, tmp93
>         andb    $1, %dl #,
>         movb    %dl, -57(%ebp)  #, lba48
> .LVL50:
>         .loc 1 100 0
>         testb   $4, 90(%eax)    #, <variable>.host_flags
>         je      .L37    #,
>         testb   %dl, %dl        #
>         je      .L37    #,
>         cmpb    $0, -58(%ebp)   # dma
>         movb    $1, -57(%ebp)   #, lba48
> .LVL51:
> </ide-disk.s>
>
> Now look at the last lines at labels .LVL48 and .LVL49 - they both save
> those 1-byte u8's called dma and lba48 on the stack at -57(%ebp) and
> -58(%ebp), respectively. And guess what, later on label LVL50 they get
> accessed in the check.

   If you look better, you'll see that the copy of  'lba48' in the %dl 
register gets used.

> And several times more later, which in most sane
> architectures still means cache accesses but when you have registers its
> even faster :).

  Didn't quite get that statement.
  Well, this example wasn't very convincing...

MBR. Sergei



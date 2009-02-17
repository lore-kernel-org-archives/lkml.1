Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZBQBE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZBQBE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 20:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZBQBES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 20:04:18 -0500
Received: from h155.mvista.com ([63.81.120.155]:4539 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751170AbZBQBER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 20:04:17 -0500
Message-ID: <499A0D0B.7070007@ru.mvista.com>
Date: Tue, 17 Feb 2009 04:04:11 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/18] ide: use ->tf_load in SELECT_DRIVE()
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <4998AE87.3020502@ru.mvista.com> <49995300.7030102@ru.mvista.com> <200902162251.49271.bzolnier@gmail.com>
In-Reply-To: <200902162251.49271.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:
> On Monday 16 February 2009, Sergei Shtylyov wrote:
>   
>> Hello, I wrote:
>>
>>     
>>>>> There should be no functional changes caused by this patch.
>>>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>>>> Index: b/drivers/ide/ide-iops.c
>>>>> ===================================================================
>>>>> --- a/drivers/ide/ide-iops.c
>>>>> +++ b/drivers/ide/ide-iops.c
>>>>> @@ -88,11 +88,15 @@ void SELECT_DRIVE (ide_drive_t *drive)
>>>>>  {
>>>>>      ide_hwif_t *hwif = drive->hwif;
>>>>>      const struct ide_port_ops *port_ops = hwif->port_ops;
>>>>> +    ide_task_t task;
>>>>>  
>>>>>      if (port_ops && port_ops->selectproc)
>>>>>          port_ops->selectproc(drive);
>>>>>  
>>>>> -    hwif->OUTB(drive->select.all, hwif->io_ports.device_addr);
>>>>> +    memset(&task, 0, sizeof(task));
>>>>> +    task.tf_flags = IDE_TFLAG_OUT_DEVICE;
>>>>> +
>>>>> +    drive->hwif->tf_load(drive, &task);
>>>>>           
>>>>    This actually doesn't seem like a bright idea to me, considering 
>>>> that this gets called when starting every request. How will you look 
>>>> at me adding the transport method for writing this register? :-)
>>>>         
>
> Please check profiles first -- it might not be worth it. [1]
>
>   
>>> Convert SELECT_DRIVE() to use ->tf_load instead of ->OUTB.
>>>
>>>   OTOH, adding such a "backdoor" to the taskfile doesn't seem very 
>>> consistent... well, I'm not excited about the whole idea conversion to 
>>> tf_{load|read}() -- it's not clear what exactly this bought us.
>>>       
>
> This was explained some months ago already, so just to recall -- it was
> a part of a bigger work removing duplicated code and allowing abstraction
> of the ATA logic.
>
> Anyway this is not set in a stone so if you have proposal of a better
> approach please come forward with it.
>   

   Er... I think that the previous IN()/OUT() methods were better. Note 
that we ended up using the local version of them in the dafault 
ide_tf_{load}read}() anyway -- as Alan has pointed out it might be worth 
splitting those into I/O and memory space versions... although given 
general slowness of the I/O accesses, this is probably not going to win 
much speed-wise.

>>    We at least could have saved on memset() -- tf_load() method ignores 
>> fields other than tf_flags anyway...
>>     
>
> Unless it is huge performance win (unlikely) this is not a good idea as it would be a maintainance nightmare.
>   
> ->tf_load does only use cmd->tf_flags today but it might change one day
> and nobody will remember to audit all users that they pass a valid cmd...
>   

   It's just quite unbearable to see (especially for a long time 
assembly coder) how a single register write is turning into *that*.
So, it still seems worth risking... :-)

> Thanks,
> Bart
>   

MBR, Sergei



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZBQPby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZBQPby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbZBQPbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:31:42 -0500
Received: from h155.mvista.com ([63.81.120.155]:26142 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750921AbZBQPbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:31:41 -0500
Message-ID: <499AD872.2060605@ru.mvista.com>
Date: Tue, 17 Feb 2009 18:32:02 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/18] ide: use ->tf_load in SELECT_DRIVE()
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <200902162251.49271.bzolnier@gmail.com> <499A0D0B.7070007@ru.mvista.com> <200902171543.21892.bzolnier@gmail.com>
In-Reply-To: <200902171543.21892.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

>>>>>>>There should be no functional changes caused by this patch.
>>>>>>>Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>>>>>>Index: b/drivers/ide/ide-iops.c
>>>>>>>===================================================================
>>>>>>>--- a/drivers/ide/ide-iops.c
>>>>>>>+++ b/drivers/ide/ide-iops.c
>>>>>>>@@ -88,11 +88,15 @@ void SELECT_DRIVE (ide_drive_t *drive)
>>>>>>> {
>>>>>>>     ide_hwif_t *hwif = drive->hwif;
>>>>>>>     const struct ide_port_ops *port_ops = hwif->port_ops;
>>>>>>>+    ide_task_t task;
>>>>>>> 
>>>>>>>     if (port_ops && port_ops->selectproc)
>>>>>>>         port_ops->selectproc(drive);
>>>>>>> 
>>>>>>>-    hwif->OUTB(drive->select.all, hwif->io_ports.device_addr);
>>>>>>>+    memset(&task, 0, sizeof(task));
>>>>>>>+    task.tf_flags = IDE_TFLAG_OUT_DEVICE;
>>>>>>>+
>>>>>>>+    drive->hwif->tf_load(drive, &task);

>>>>>>   This actually doesn't seem like a bright idea to me, considering 
>>>>>>that this gets called when starting every request. How will you look 
>>>>>>at me adding the transport method for writing this register? :-)

>>>Please check profiles first -- it might not be worth it. [1]

>>>>>Convert SELECT_DRIVE() to use ->tf_load instead of ->OUTB.

>>>>>  OTOH, adding such a "backdoor" to the taskfile doesn't seem very 
>>>>>consistent... well, I'm not excited about the whole idea conversion to 
>>>>>tf_{load|read}() -- it's not clear what exactly this bought us.

>>>This was explained some months ago already, so just to recall -- it was
>>>a part of a bigger work removing duplicated code and allowing abstraction
>>>of the ATA logic.

>>>Anyway this is not set in a stone so if you have proposal of a better
>>>approach please come forward with it.

>>   Er... I think that the previous IN()/OUT() methods were better. Note 
>>that we ended up using the local version of them in the dafault 
>>ide_tf_{load}read}() anyway -- as Alan has pointed out it might be worth 

> During ide_tf_{load,read}() addition I was a bit too optimistic about
> the possibility of the quick io{read,write}* conversion later...

>>splitting those into I/O and memory space versions... although given 
>>general slowness of the I/O accesses, this is probably not going to win 
>>much speed-wise.

> Maybe it would be worth to add ->tf_{inb,outb} to struct ide_tp_ops
> and convert default tp_ops to use them...  OTOH we should reinvestigate
> the io{read,write}*() way first (maybe things have improved there)...

    Yes, let's not be hasty here...

>>>>   We at least could have saved on memset() -- tf_load() method ignores 
>>>>fields other than tf_flags anyway...

>>>Unless it is huge performance win (unlikely) this is not a good idea as it would be a maintainance nightmare.

>>>->tf_load does only use cmd->tf_flags today but it might change one day
>>>and nobody will remember to audit all users that they pass a valid cmd...

>>   It's just quite unbearable to see (especially for a long time 
>>assembly coder) how a single register write is turning into *that*.
>>So, it still seems worth risking... :-)

> I see your point here.  If SELECT_DRIVE() is performance sensitive we
> may just add another struct ide_tp_ops method for it...

    Or we may finally teach selectproc() to also do that, turning it into 
analog of libata's dev_select() method.

> Thanks,
> Bart

MBR, Sergei

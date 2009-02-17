Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZBQPM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZBQPM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZBQPMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:12:42 -0500
Received: from h155.mvista.com ([63.81.120.155]:25888 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752247AbZBQPMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:12:41 -0500
Message-ID: <499AD3FD.6040109@ru.mvista.com>
Date: Tue, 17 Feb 2009 18:13:01 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/18] ide: use ->tf_load in SELECT_DRIVE()
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <20080620213451.13202.12671.sendpatchset@localhost.localdomain> <49987A37.9000300@ru.mvista.com> <4998AE87.3020502@ru.mvista.com> <499AAC24.70200@ru.mvista.com>
In-Reply-To: <499AAC24.70200@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>> There should be no functional changes caused by this patch.
>>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>>> Index: b/drivers/ide/ide-iops.c
>>>> ===================================================================
>>>> --- a/drivers/ide/ide-iops.c
>>>> +++ b/drivers/ide/ide-iops.c
>>>> @@ -88,11 +88,15 @@ void SELECT_DRIVE (ide_drive_t *drive)
>>>>  {
>>>>      ide_hwif_t *hwif = drive->hwif;
>>>>      const struct ide_port_ops *port_ops = hwif->port_ops;
>>>> +    ide_task_t task;
>>>>  
>>>>      if (port_ops && port_ops->selectproc)
>>>>          port_ops->selectproc(drive);
>>>>  
>>>> -    hwif->OUTB(drive->select.all, hwif->io_ports.device_addr);
>>>> +    memset(&task, 0, sizeof(task));
>>>> +    task.tf_flags = IDE_TFLAG_OUT_DEVICE;
>>>> +
>>>> +    drive->hwif->tf_load(drive, &task);

>>>    This actually doesn't seem like a bright idea to me, considering 
>>> that this gets called when starting every request. How will you look 
>>> at me adding the transport method for writing this register? :-)

>> Convert SELECT_DRIVE() to use ->tf_load instead of ->OUTB.

>>   OTOH, adding such a "backdoor" to the taskfile doesn't seem very 
>> consistent...

>   ... which didn't prevent libata from having such backdoor though, in 
> the form of dev_select() method.

    Oh, and I forgot about the IDE core's infamous selectproc() method which 
could easily be taught to also write the device/head register and moved to 
'struct ide_tp_ops'.

MBR, Sergei

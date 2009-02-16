Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbZBPVz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbZBPVz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbZBPVyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:54:11 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:13270 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbZBPVyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:54:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=x3cpoddeT/rvSqh6UWhaPQhJTfLRUAe/latXOLRXjuSoHTrR2QOTDNHMxT6Rh/TjYa
         8duiqB3X5UIj2XEkE97oyglYp8kw2/awPeoeKWd4T29DtXArHTLuBLOQu5FExOSzK4TD
         QQ9Z7H66U0oPfa+UvcjP0fHaXgxRKCL8T++hU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 13/18] ide: use ->tf_load in SELECT_DRIVE()
Date: Mon, 16 Feb 2009 22:51:49 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-next-20090213; KDE/4.2.0; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <4998AE87.3020502@ru.mvista.com> <49995300.7030102@ru.mvista.com>
In-Reply-To: <49995300.7030102@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902162251.49271.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 16 February 2009, Sergei Shtylyov wrote:
> Hello, I wrote:
> 
> >>> There should be no functional changes caused by this patch.
> >>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >>> Index: b/drivers/ide/ide-iops.c
> >>> ===================================================================
> >>> --- a/drivers/ide/ide-iops.c
> >>> +++ b/drivers/ide/ide-iops.c
> >>> @@ -88,11 +88,15 @@ void SELECT_DRIVE (ide_drive_t *drive)
> >>>  {
> >>>      ide_hwif_t *hwif = drive->hwif;
> >>>      const struct ide_port_ops *port_ops = hwif->port_ops;
> >>> +    ide_task_t task;
> >>>  
> >>>      if (port_ops && port_ops->selectproc)
> >>>          port_ops->selectproc(drive);
> >>>  
> >>> -    hwif->OUTB(drive->select.all, hwif->io_ports.device_addr);
> >>> +    memset(&task, 0, sizeof(task));
> >>> +    task.tf_flags = IDE_TFLAG_OUT_DEVICE;
> >>> +
> >>> +    drive->hwif->tf_load(drive, &task);
> >>
> >>    This actually doesn't seem like a bright idea to me, considering 
> >> that this gets called when starting every request. How will you look 
> >> at me adding the transport method for writing this register? :-)

Please check profiles first -- it might not be worth it. [1]

> > Convert SELECT_DRIVE() to use ->tf_load instead of ->OUTB.
> >
> >   OTOH, adding such a "backdoor" to the taskfile doesn't seem very 
> > consistent... well, I'm not excited about the whole idea conversion to 
> > tf_{load|read}() -- it's not clear what exactly this bought us.

This was explained some months ago already, so just to recall -- it was
a part of a bigger work removing duplicated code and allowing abstraction
of the ATA logic.

Anyway this is not set in a stone so if you have proposal of a better
approach please come forward with it.

>    We at least could have saved on memset() -- tf_load() method ignores 
> fields other than tf_flags anyway...

Unless it is huge performance win (unlikely) this is not a good idea
as it would be a maintainance nightmare.

->tf_load does only use cmd->tf_flags today but it might change one day
and nobody will remember to audit all users that they pass a valid cmd...

Thanks,
Bart

[1] coincidentally on the past Saturday I woke up with a bright idea
of doing some profiling of IDE code... I thought this would be a fun...

# readprofile -m System.map | grep ide_
    30 ide_intr                                   0.0714
     1 ide_map_sg                                 0.0112
     1 ide_complete_rq                            0.0152
    78 do_ide_request                             0.0643
     1 __ide_wait_stat                            0.0059
    51 ide_execute_command                        0.5100
     4 ide_set_handler                            0.0635
     7 ide_outb                                   1.1667
   308 ide_mm_inb                                44.0000
...

This was on ICH4 PATA controller...  Fun indeed, ain't it?

[ For non-ATA folks: it is _impossible_ for ide_mm_inb to be used
  on the above controller. ]

I still have to check what will happen if I would change the order
of following assignments in ide_tf_read():

...
        if (mmio) {
                tf_outb = ide_mm_outb;
                tf_inb  = ide_mm_inb;
        } else {
                tf_outb = ide_outb;
                tf_inb  = ide_inb;
        }
...

However I instead I went ahead and tried to run oprofile to get me some
more trushworthy results:

# opreport -l vmlinux
CPU: Pentium M (P6 core), speed 600 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted, and not in a thermal trip) with a unit mask of 0x00 (No unit mask) count 100000
Segmentation fault

After this, testing some older kernel versions and assuring that user-space
packages are at their latest distro versions I had enough of fun...

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765550AbYDQOtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765550AbYDQOtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 10:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbYDQOtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 10:49:10 -0400
Received: from mr1.bfh.ch ([147.87.250.50]:38397 "EHLO mr1.bfh.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250AbYDQOtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 10:49:08 -0400
Message-ID: <4807635E.9060101@bfh.ch>
Date: Thu, 17 Apr 2008 16:49:02 +0200
From: Seewer Philippe <philippe.seewer@bfh.ch>
Organization: BFH
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>	 <480354C9.1050600@bfh.ch>	 <38b2ab8a0804150040i14840a9fudc3b95ba80d52ac1@mail.gmail.com>	 <4805AF93.90209@bfh.ch> <38b2ab8a0804170709m58830adagcba46f059ed10809@mail.gmail.com>
In-Reply-To: <38b2ab8a0804170709m58830adagcba46f059ed10809@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Apr 2008 14:49:02.0249 (UTC) FILETIME=[2D1F4190:01C8A09A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Francis Moreau wrote:
> Hello Seewer,
> 
> On Wed, Apr 16, 2008 at 9:49 AM, Seewer Philippe <philippe.seewer@bfh.ch> wrote:
>>  Correct. Though be really careful which geometry you are requesting:
>>
>>  root@local:/# sfdisk -g /dev/sda
>>  /dev/sda: 7296 cylinders, 255 heads, 63 sectors/track
>>  root@local:/# sfdisk -G /dev/sda
>>  /dev/sda: 116280 cylinders, 16 heads, 63 sectors/track
>>
>>  The first one is the kernels idea of a disks geometry which is probably as
>> often correct as it's just plain wrong,
> 
> Sorry but I don't understand, what do you mean ?
Take the example above. A disk with 255 heads? Not impossible but improbable. Where's the value from?

-The physical disks behind the example is an older laptop IDE disk. 'hdparm -I' shows 16 heads and 63 sectors, which is already an approximated value anyway. See Dick Johnson's post about that.

-The module handling the drive is 'ata_piix', the newer Driver from the SATA/PATA tree, which presents all drives (*ATA) to the rest of the system through the scsi sublayer.

-The final "getter" geometry code in the scsi sublayer (scsicam_bios_param in scsicam.c):

        /* if something went wrong, then apparently we have to return
           a geometry with more than 1024 cylinders */
        if (ret || ip[0] > 255 || ip[1] > 63) {
                if ((capacity >> 11) > 65534) {
                        ip[0] = 255;
                        ip[1] = 63;
                } else {
                        ip[0] = 64;
                        ip[1] = 32;
                }

                if (capacity > 65535*63*255)
                        ip[2] = 65535;
                else
                        ip[2] = (unsigned long)capacity / (ip[0] * ip[1]);
        }
Read this as ip[0] is heads, ip[1] is sectors and ip[2] is cylinders. Make sense of course, since C/H/S values don't really matter to scsi anyway. So the default return value for the disks we use today is 255/63 for heads and sectors. A fixed constant which most of the time makes sense and works for most bios and bootloaders, but is wrong in the sense that it doesn't represent the actual values printed on the disks back. 

>>  versus the second one which tries to
>> guess a disks geometry by looking at the current partition table. Which
>> might be just as wrong since its only necessary for bios and/or bootloader.
> 
> But what happens if you want to guess the geometry of a disk with no
> partition table ? You need to trust the kernel guess but from what I understood
> it's just wrong.
Assuming H/S as 255/63 and calculating C from the disks capaticy is quite safe. Except for a few weird use cases like using old OS's and os-installers that still trust the BIOS.
Depending on the type of disks you work with 'hdparm -I' works well too. Otherwise there's always CONFIG_EDD ('BIOS Enhanced Disk Drive calls determine boot disk') which exports BIOS geometry values to sysfs for the current default boot disk.

Hope this helps
Philippe

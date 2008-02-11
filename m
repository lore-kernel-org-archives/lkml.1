Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbYBKHyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbYBKHyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 02:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYBKHyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 02:54:31 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:35158 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbYBKHy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 02:54:29 -0500
Message-ID: <47AFFF30.6070808@linux.vnet.ibm.com>
Date: Mon, 11 Feb 2008 13:24:24 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Nish Aravamudan <nish.aravamudan@gmail.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, ananth@in.ibm.com
Subject: Re: 2.6.26-git0: IDE oops during boot
References: <20080206105334.GA3664@elf.ucw.cz> <200802062105.42929.bzolnier@gmail.com> <47AAD0CB.3090305@linux.vnet.ibm.com> <200802071501.09318.bzolnier@gmail.com> <29495f1d0802101332p6b39b331ye2f6fb488b63e228@mail.gmail.com>
In-Reply-To: <29495f1d0802101332p6b39b331ye2f6fb488b63e228@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nish Aravamudan wrote:
> On 2/7/08, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>> On Thursday 07 February 2008, Kamalesh Babulal wrote:
>>> Bartlomiej Zolnierkiewicz wrote:
>>>> Hi,
>>>>
>>>> On Wednesday 06 February 2008, Pavel Machek wrote:
>>>>> On Wed 2008-02-06 11:53:34, Pavel Machek wrote:
>>>>>> Hi!
>>>>>>
>>>>>> Trying to boot 2.6.25-git0 (few days old), I get
>>>>>>
>>>>>> BUG: unable to handle kernel paging request at ffff..ffb0
>>>>>> IP at init_irq+0x42e
>>>> init_irq? hmm...
>>>>
>>>>>> Call trace:
>>>>>> ide_device_add_all
>>>> this comes from ide-generic
>>>> (Generic IDE host driver)
>>>>
>>>>>> ide_generic_init
>>>>>> kernel_init
>>>>>> child_rip
>>>>>> vgacon_cursor
>>>>>> kernel_init
>>>>>> child_rip
>>>>>>
>>>>>> Excerpt from config:
>>>>>>
>>>>>> CONFIG_IDE=y
>>>>>> CONFIG_BLK_DEV_IDE=y
>>>>> Disabling CONFIG_IDE made my machine boot, as it was using libata
>>>>> anyway.
>>>> Kamalesh/Pavel:
>>>>
>>>> Could you try latest git and see if the OOPS is still there?
>>>>
>>>> [ Yeah, I'm unable to reproduce it. :( ]
>>>>
>>>> Thanks,
>>>> Bart
>>> Hi Bart,
>>>
>>> The panic is reproducible with the 2.6.24-git16 kernel, the call trace is
>>> similar to the previous one
>> Thanks, I again reviewed ide-probe.c changes but nothing seems wrong...
>>
>> Could you please bisect it down to the guilty commit?
> 
> Kamalesh, were you able to bisect this down? I just got hit by the
> same panic on a 4-way x86_64, with 2.6.24-git22.
> 
> Thanks,
> Nish

Hi Nish,

I tried bisecting and the guilty patch seems to be 

36501650ec45b1db308c3b51886044863be2d762 is first bad commit
commit 36501650ec45b1db308c3b51886044863be2d762
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Fri Feb 1 23:09:31 2008 +0100

    ide: keep pointer to struct device instead of struct pci_dev in ide_hwif_t


the gdb output, also points to the changes made by the guilty patch

(gdb) p ide_device_add_all
$1 = {int (u8 *, const struct ide_port_info *)} 0xffffffff804176ac <ide_device_add_all>
(gdb) p/x 0xffffffff804176ac+0xb60
$2 = 0xffffffff8041820c
(gdb) l *0xffffffff8041820c
0xffffffff8041820c is in ide_device_add_all (drivers/ide/ide-probe.c:1249).
1244                    goto out;
1245            }
1246
1247            sg_init_table(hwif->sg_table, hwif->sg_max_nents);
1248
1249            if (init_irq(hwif) == 0)
1250                    goto done;
1251
1252            old_irq = hwif->irq;
1253            /*
(gdb) 


(gdb) p init_irq
$1 = {int (ide_hwif_t *)} 0xffffffff8041721f <init_irq>
(gdb) p/x 0xffffffff8041721f+0x1a4
$2 = 0xffffffff804173c3
(gdb) l *0xffffffff804173c3
0xffffffff804173c3 is in init_irq (include/asm/pci.h:101).
96      /* Returns the node based on pci bus */
97      static inline int __pcibus_to_node(struct pci_bus *bus)
98      {
99              struct pci_sysdata *sd = bus->sysdata;
100
101             return sd->node;
102     }
103
104     static inline cpumask_t __pcibus_to_cpumask(struct pci_bus *bus)
105     {
(gdb) 


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

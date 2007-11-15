Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbXKOIvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbXKOIvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 03:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbXKOIuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 03:50:50 -0500
Received: from proxy1.bredband.net ([195.54.101.71]:64128 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbXKOIut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 03:50:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAM+WO0dV4pmXRmdsb2JhbAAMjmkBAQE3gR0
Message-ID: <473C08B2.1030004@purplescout.se>
Date: Thu, 15 Nov 2007 09:52:02 +0100
From: Jonas Stare <jonas.stare@purplescout.se>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] drivers/ide/ide-probe.c, kernel 2.6.23.1
References: <473434F1.50509@purplescout.se> <20071112132448.0facce12.akpm@linux-foundation.org> <200711132303.28424.bzolnier@gmail.com>
In-Reply-To: <200711132303.28424.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, thanks for the reply. :)

Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> On Monday 12 November 2007, Andrew Morton wrote:
>> On Fri, 09 Nov 2007 11:22:41 +0100 Jonas Stare <jonas.stare@purplescout.se> wrote:
>>
>>> Hi.
>>>
>>> This week I ran into a strange hardware problem. During boot I got a 35 
>>> second delay while waiting for IDE-disks that weren't there to report 
> 
> With what chipset and host driver does this happen?

I am not sure about the chip-set but I think it was vt82c686b. It used 
the via82cxxx-driver, but only _after_ using the generic ide-code to 
probe/wait (a long time) for the disks. (This was in Suse 10.1 SP 1.)

>>> that they were not in a BSY state. The problem was most likely in the 
>>> hardware but this patch enables you to ignore waiting for disks by 
>>> setting hdX=noprobe (and not setting the geometry by hand) as a kernel 
>>> option.
>>>
>>> If no noprobe-option is set the code will work (more or less) as the 
>>> original but if set the code will skip the ide_wait_not_busy() for that 
>>> drive. Even if there would be a drive there and it is still BSY 
>>> afterwards it should not matter since it isn't probed for later.
>>>
>>> There are other ways to get around the "35-seconds-of-waiting-in-vain", 
>>> like actually fix the hardware, insert a second drive that works or 
>>> recompile the kernel with edd-support builtin (atleast I've seen that 
>>> solution on a forum) and possibly others. But this patch would allow 
>>> people to get Linux to boot quickly on wonky hardware without having to 
>>> recompile anything.
>>> (The code also honors the MAX_DRIVES variable instead of assuming that 
>>> ther will be 2 drives on the bus.)
>> I keep on hearing about problems with boot-time IDE probing.  It's public
>> enemy #1 with the embedded guys.
> 
> The problem is that we are not hearing about them.
> 
> Please forward the reports to linux-ide@vger.kernel.org.
> 
>> It does seem that operator intervention is needed in some fashion.
>>
>>> I will be happy for all the comments I can get. :) But be gentle, this 
>>> is my first patch...
> 
> Jonas, could you also put printk() dumping content of 'stat' in
> ide-iops.c::ide_wait_not_busy() so we can verify that it is not
> some problem with ide_wait_not_busy() itself.
> 

Sorry. :( I don't have access to the hardware anymore (which is a 
"home-made" embedded machine). But from what I could get from poking 
around was that the BSY-bit on the slave (that never has or ever will 
exists) was set, probably because those who built the thing wanted to 
save money and/or space on that "billionth of a cent"-resistor that Alan 
Cox talked about.

>>>    Best regards
>>>    Jonas Stare
>>>
>>> Signed-off-by: Jonas Stare <jonas.stare@purplescout.se>
>>> --
>>> diff -u linux-2.6.23.1-orig/drivers/ide/ide-probe.c 
>>> linux-2.6.23.1/drivers/ide/ide-probe.c
>>> --- linux-2.6.23.1-orig/drivers/ide/ide-probe.c 2007-10-12 
>>> 18:43:44.000000000 +0200
>>> +++ linux-2.6.23.1/drivers/ide/ide-probe.c      2007-11-09 
>>> 10:43:16.000000000 +0100
>>> @@ -643,6 +643,7 @@
>>>   static int wait_hwif_ready(ide_hwif_t *hwif)
>>>   {
>>>          int rc;
>>> +       int unit;
>>>
>>>          printk(KERN_DEBUG "Probing IDE interface %s...\n", hwif->name);
>>>
>>> @@ -659,20 +660,24 @@
>>>                  return rc;
>>>
> 
> Hmm, so the first ide_wait_not_busy() (for the currently
> selected device) is OK and doesn't stall?
> 

It didn't stall for me... But even if it had, probe_hwif() will ignore 
the entire controller if you set "idex=noprobe".

(From drivers/ide/ide-probe.c)

static void probe_hwif(ide_hwif_t *hwif, void (*fixup)(ide_hwif_t *hwif))
{
         unsigned int unit;
         unsigned long flags;
         unsigned int irqd;

         if (hwif->noprobe)
                 return;


>>>          /* Now make sure both master & slave are ready */
>>> -       SELECT_DRIVE(&hwif->drives[0]);
>>> -       hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
>>> -       mdelay(2);
>>> -       rc = ide_wait_not_busy(hwif, 35000);
>>> -       if (rc)
>>> -               return rc;
>>> -       SELECT_DRIVE(&hwif->drives[1]);
>>> -       hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
>>> -       mdelay(2);
>>> -       rc = ide_wait_not_busy(hwif, 35000);
>>> +       for (unit = 0; unit < MAX_DRIVES; ++unit) {
>>> +               /* Ignore disks that we will not probe for later. */
>>> +               if (!hwif->drives[unit].noprobe ||
>>> +                   hwif->drives[unit].forced_geom) {
> 
> It is better to check for ->present
> (->forced_geom implies that ->present is set).
> 

Great comment. :) I'll change that right away...

>>> +                       SELECT_DRIVE(&hwif->drives[unit]);
>>> +                       hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
>>> +                       mdelay(2);
>>> +                       rc = ide_wait_not_busy(hwif, 35000);
>>> +                       /* Exit function with master selected (let's be 
>>> sane) */
>>> +                       SELECT_DRIVE(&hwif->drives[0]);
> 
> This changes the previous behavior adding an extra SELECT_DRIVE()
> before trying the slave drive.
> 

Mmmm, yes, I know. But I couldn't come up with a clean and nice way to 
be sure that the first drive is selected. Maybe I could move it inside 
the if-statement below?

>>> +                       if (rc)
>>> +                               return rc;
>>> +               } else {
>>> +                       printk(KERN_DEBUG "Skip ide_wait_not_busy for 
>>> %s:%d\n",
>>> +                         hwif->name, unit);
>>> +               }
>>> +       }
>>>
>>> -       /* Exit function with master reselected (let's be sane) */
>>> -       SELECT_DRIVE(&hwif->drives[0]);
>>> -
>>>          return rc;
>>>   }
>> Maybe that's the fix, maybe not - I'll defer to others on that (please).
>>
>> Your email client is wordwrapping the text, and replaces tabs with spaces. 
>> Most of them seem to do this nowadays.  For thunderbird, please see
>> http://mbligh.org/linuxdocs/Email/Clients/Thunderbird
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbZJZVW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbZJZVW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZJZVW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:22:28 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55494 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbZJZVW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:22:26 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2009 17:22:26 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AtoChPlFzXV7jWrBpwWpD8qNf1e9LwXlw6IknwTXUHDzBNIvtbeXaCaBxPyDTb99aQ
         XNH/3ULnQ51fnf44ZCsM7MzCbXfuNoObSwcpsSz/seT6SNbVF/aTEmwGIsyAmyJPCz0R
         lgFSqpNpFl17SXxrttyHPomuW9zmpZn2z0/Y8=
Message-ID: <4AE611B2.1030409@gmail.com>
Date: Mon, 26 Oct 2009 14:16:34 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Bernhard Kaindl <bk@suse.de>
Subject: Re: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2
 0
References: <4AE24009.4090408@gmail.com>            <dd18b0c30910261134s76274dbbj9c1904e78c2b5a38@mail.gmail.com> <21504.1256588976@turing-police.cc.vt.edu>
In-Reply-To: <21504.1256588976@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Mon, 26 Oct 2009 11:34:20 PDT, Justin Mattock said:
>
>    
>> I can't seem to locate a right mailing list
>> for ieee1394 for Linux. Anyways here is a
>> url to flickr which has the image of the PANIC:
>> http://www.flickr.com/photos/44066293@N08/4046711653/
>> (hopefully you don't need to sign up to view)
>>
>> As for the problem, interesting thing here is if I add
>> a printk to:
>>
>> if ((class == 0xffffffff))
>> printk(KERN_BUG "init_ohci1394_dma: finished initializing OHCI DMA\n");
>> continue; /* No device at this func */
>>
>> the system will boot-up, and the PANIC will not occur.
>>      
>
> Note that just sticking a printk in there without a { } pair enclosing
> the printk and continue will change the semantics drastically - if the
> conditional is true, it will do the printk instead of continuing. And
> possibly more important, the continue just became unconditional.
>
> What *exactly* does your code look like now?
>    
as of now in init_ohci1394_dma.c
I did:



void __init init_ohci1394_dma_on_all_controllers(void)
{
     int num, slot, func;

     if (!early_pci_allowed())
         return;

     /* Poor man's PCI discovery, the only thing we can do at early boot */
     for (num = 0; num < 32; num++) {
         for (slot = 0; slot < 32; slot++) {
             for (func = 0; func < 8; func++) {
                 u32 class = read_pci_config(num,slot,func,
                             PCI_CLASS_REVISION);
                 if ((class == 0xffffffff))
+                    printk(KERN_DEBUG "putting a printk here keeps the 
machine from a panic\n");
                     continue; /* No device at this func */

                 if (class>>8 != PCI_CLASS_SERIAL_FIREWIRE_OHCI)
                     continue; /* Not an OHCI-1394 device */

                 init_ohci1394_controller(num, slot, func);
                 break; /* Assume one controller per device */
             }
         }
     }
     printk(KERN_INFO "init_ohci1394_dma: finished initializing OHCI 
DMA\n");
}


interesting thing here, is I just was wanting to see were this thing was
crashing. when adding this in(above) Ill see a long string during boot
for a few seconds and then the machine boots up.
  Now if I add a printk(example below) to here:



void __init init_ohci1394_dma_on_all_controllers(void)
{
     int num, slot, func;

     if (!early_pci_allowed())
         return;

     /* Poor man's PCI discovery, the only thing we can do at early boot */
     for (num = 0; num < 32; num++) {
         for (slot = 0; slot < 32; slot++) {
             for (func = 0; func < 8; func++) {
                 u32 class = read_pci_config(num,slot,func,
                             PCI_CLASS_REVISION);
                 if ((class == 0xffffffff))
                     continue; /* No device at this func */

                 if (class>>8 != PCI_CLASS_SERIAL_FIREWIRE_OHCI)
+                    printk(KERN_DEBUG "putting a printk here keeps the 
machine from a panic\n");
                     continue; /* Not an OHCI-1394 device */

                 init_ohci1394_controller(num, slot, func);
                 break; /* Assume one controller per device */
             }
         }
     }
     printk(KERN_INFO "init_ohci1394_dma: finished initializing OHCI 
DMA\n");
}



In dmesg I will see maybe 5 to 10 debug messages and then
onto init_ohci1394_initialize.
keep in mind I'm not familiar with any of this, but just looking
at the code I see 0xffffffff and searching(google) tells me
that that's something with 32bit, should maybe there be something
with 0xffffffffffffffffff 64bit?

Justin P. Mattock



Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbXKWDQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbXKWDQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 22:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbXKWDQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 22:16:14 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:35191 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbXKWDQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 22:16:13 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: niessner@jpl.nasa.gov
Subject: Re: Where is the interrupt going?
Date: Fri, 23 Nov 2007 05:18:01 +0200
User-Agent: KMail/1.9.7
References: <1195693710.5544.240.camel@morte.jpl.nasa.gov> <20071122022004.GB9265@fattire.cabal.ca> <20071122164853.cfdplzj5o744sw40@webmail.jpl.nasa.gov>
In-Reply-To: <20071122164853.cfdplzj5o744sw40@webmail.jpl.nasa.gov>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711230518.01401.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 23 November 2007 02:48:53 am you wrote:
> I tried the hammer and the problem persists.
> observer@bbb:~$ cat /proc/cmdline
> root=UUID=8b3c3666-22c3-4c04-b399-ece266f2ef30 ro noapic quiet splash
>
> However, I reserve the right to try the hammer again in the future.
> When I look at /proc/interrupts without the APIC:
> observer@bbb:~$ cat /proc/interrupts
>             CPU0
>    0:        144    XT-PIC-XT        timer
>    1:         10    XT-PIC-XT        i8042
>    2:          0    XT-PIC-XT        cascade
>    5:     100000    XT-PIC-XT        ohci_hcd:usb5, mxser
>    6:          5    XT-PIC-XT        floppy
>    7:          1    XT-PIC-XT        parport0
>    8:          3    XT-PIC-XT        rtc
>    9:          1    XT-PIC-XT        acpi, uhci_hcd:usb2
>   10:     100000    XT-PIC-XT        ohci_hcd:usb4, ehci_hcd:usb6,
> r128@pci:0000:01:00.0
>   11:       2231    XT-PIC-XT        uhci_hcd:usb1, ohci_hcd:usb3, eth0
>   12:        130    XT-PIC-XT        i8042
>   14:       4362    XT-PIC-XT        libata
>   15:      15315    XT-PIC-XT        libata
> NMI:          0
> LOC:     130125
> ERR:          0
> MIS:          0
>
> I do not even see the device that I registered unless it is that
> r128... line. However the code printed out in /var/log/messages:

No, this is your radeon 128 board (on AGP I suppose). Could be integrated
on the mobo if it is a server mobo.

> Nov 22 16:05:27 bbb kernel: [  104.712473] apc8620: VID = 0x10B5
> Nov 22 16:05:27 bbb kernel: [  104.712486] apc8620: mapped addr = e0bd4000
> Nov 22 16:05:27 bbb kernel: [  104.713022] apc8620: registered carrier 0
> Nov 22 16:05:27 bbb kernel: [  104.713028] apc8620: interrupt data
> (0xe1083e40) on irq (10) and status (0x10)

Here is the problem (I suppose): 
if status (0x10 hex or 16 decimal) is the value returned by request_irq:
status = request_irq (apcsi[i].board_irq,
                                      apc8620_handler,
                                      IRQF_DISABLED,
                                      DEVICE_NAME,
                                      (void*)&apcsi[i]);
(from your first post), that means the irq is NOT registered, because
according to the LDD v.3 book:
<cite>
The value returned from request_irq to the requesting function is either 0 
to indicate success or a negative error code, as usual. It’s not uncommon 
for the function to return -EBUSY to signal that another driver is already 
using the requested interrupt line. 
</cite>
If you grep the kernels's include directory for EBUSY you will find:
#define        EBUSY           16      /* Device or resource busy */
in include/asm-generic/errno-base.h

So I think your mobo has shared (with other devices) irq line on the 
PCI/PCIe slot you use for your hardware and these other devices have
already registered shered irq handlers for the same irq (10), so the 
attempt to register nonshared irq fails.

Either try to register the irq as shared, or put the hardware on
another slot whose irq line is not shared with other devises 
(if such one exists). This info should be available from the mobo
manual book.
>
> which indicates it successfully registered without being shared. 

No, as I already explained. 
The only problem :-) in my explanation is:
request_irq returns EBUSY (not -EBUSY as should be)

Marin Mitov

> When 
> I have more time, I will changed the code to be a shared IRQ and try
> the noapic again.
>
> However, without the noapic /proc/interrupts looks like:
> observer@bbb:~$ cat /proc/interrupts
>             CPU0
>    0:        154   IO-APIC-edge      timer
>    1:         10   IO-APIC-edge      i8042
>    6:          5   IO-APIC-edge      floppy
>    7:          0   IO-APIC-edge      parport0
>    8:          3   IO-APIC-edge      rtc
>    9:          1   IO-APIC-fasteoi   acpi
>   10:          0   IO-APIC-edge      apc8620
>   12:        130   IO-APIC-edge      i8042
>   14:       2861   IO-APIC-edge      libata
>   15:       1049   IO-APIC-edge      libata
>   16:     100001   IO-APIC-fasteoi   ohci_hcd:usb5, mxser
>   17:          0   IO-APIC-fasteoi   uhci_hcd:usb1, ohci_hcd:usb3
>   18:          0   IO-APIC-fasteoi   uhci_hcd:usb2
>   19:        187   IO-APIC-fasteoi   eth0
>   20:          0   IO-APIC-fasteoi   ohci_hcd:usb4, r128@pci:0000:01:00.0
>   21:          0   IO-APIC-fasteoi   ehci_hcd:usb6
> NMI:          0
> LOC:       8820
> ERR:          0
> MIS:          0
>
>
> I have attached the kernel module. The apc8620 is an IndustryPack
> carrier card. I can therefore open up N (in this specific case 5) sub
> memory windows in the memory mapped PCI address. The kernel module
> keeps track of the slot offsets from the memory mapped address so that
> the user can simply use read and write instead of a zillion ugly ioctl
> calls. Because the kernel module tracks the slot offsets, I place acp
> state into the private data of the file pointer. There can also be
> multiple carriers on the bus. So, the array in the kernel module keeps
> track of the card specific details with the file pointer the slot
> specific information. Both are the same structure (bad on my part I
> know but I never intended to show my dirty underwear). To get data
> from interrupts (asynchronous IO) I was using readv. Now I am using
> aio_read and had to make some minor changes that you will see comments
> about to accomidate the change.
>
> Just noticed that r128 is not the carrier card...
>
> Thanks for all of the help so far and I hope this information is helpful.
>
> I almost forgot. I also attached the dmesg output and will try the
> irqpoll as it suggests. It is just the IRQ 16 is not the one I am
> looking for, but is probably related to my mxser problems that I will
> get to later.
>
> Quoting Kyle McMartin <kyle@mcmartin.ca>, on Wed 21 Nov 2007 06:20:04 PM 
PST:
> > On Wed, Nov 21, 2007 at 05:08:30PM -0800, Al Niessner wrote:
> >> On with the detailed technical information. I developed a kernel module
> >> for an PCI card back in 2.4, moved it to 2.6.3, then 2.6.11 or so and
> >> now I am trying to move it to 2.6.22. When I began the to move to
> >> 2.6.22, I changed all of the deprecated calls for finding the card on
> >> the PCI bus, modified the interrupt handler prototype, and changed my
> >> readvv/writev to aio_read/aio_write following
> >> http://lwn.net/Articles/202449/. So initialization looks like this:
> >
> > Hi Al,
> >
> > From the sounds of it, you might have an interrupt routing problem. Can
> > you describe the machine you have this plugged into? Possibly attaching
> > a copy of "dmesg" and "/proc/interrupts"?
> >
> > Feel free to attach the driver source to your email if the size is
> > reasonable (which it sounds like it is.)
> >
> > As a "big hammer" in case it is an APIC problem, please try booting the
> > kernel with the "noapic" parameter.
> >
> > cheers,
> > 	Kyle



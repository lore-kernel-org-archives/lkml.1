Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbYCLLje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbYCLLje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 07:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYCLLjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 07:39:25 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:44376 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbYCLLjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 07:39:24 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: net: tx timeouts with skge, 8139too, dmfe drivers/NICs
Date: Wed, 12 Mar 2008 13:41:53 +0200
User-Agent: KMail/1.9.7
References: <200802252237.12326.mitov@issp.bas.bg> <47C32AAD.8040000@garzik.org>
In-Reply-To: <47C32AAD.8040000@garzik.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121341.54096.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2008 10:53:01 pm you wrote:
> > As far as this happens with 3 different NICs/drivers could it be
> > a problem in the (common for all of them) networking subsystem?
> 
> A TX timeout (like hardware timeouts, in general) is a very generic 
> behavior, with many causes.
> 
> In general, when you see timeouts with varied hardware and drivers, 
> you're almost always dealing with a problem with interrupt delivery, or 
> a generic system problem, rather than bugs in the network stack or all 
> three drivers.

Well, this gave me a direction of research. 

Using printk in various parts of  skge driver, as well as modifying it to
collect different statistics (used via ethtool -S eth0), the following observations
had been made when it freezes:

1. interrupts are generated (status register shows there are pending
interrupts and they are NOT masked), but irq_handler is NOT invoked.

2. Looking on the cat /proc/interrups shows that when skge is working
both CPUs receive any IRQs. When skge freezes NO CPU receives skge's
interrupts, CPU[0] receives any others IRQs, but skge's, CPU[1] do not
receive any IRQ above the line (see bellow), but receives LOC: and RES:
below the line.
#cat /proc/interrups
           CPU0       CPU1
  0:         85          1   IO-APIC-edge      timer
  1:      34078          9   IO-APIC-edge      i8042
  6:          1          4   IO-APIC-edge      floppy
  7:        216          1   IO-APIC-edge      parport0
  8:          0          1   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:     893003    1390080   IO-APIC-edge      i8042
 14:      59682     286628   IO-APIC-edge      ide0
 15:    5458527         12   IO-APIC-edge      ide1
 16:   60547054          1   IO-APIC-fasteoi   mga@pci:0000:01:00.0
 17:    1634623     914447   IO-APIC-fasteoi   sata_via
 18:       7768          7   IO-APIC-fasteoi   sata_promise
 19:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2, uhci_hcd:usb3, uhci_hcd:usb4, uhci_hcd:usb5
 20:     535380          1   IO-APIC-fasteoi   VIA8237
 21:   30780380   31448992   IO-APIC-fasteoi   eth0
---------line added by me----------------------------------
NMI:          0          0   Non-maskable interrupts
LOC:  154311126  154736178   Local timer interrupts
RES:    1325239    2423719   Rescheduling interrupts
CAL:      40893        456   function call interrupts
TLB:      52651      29184   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0

That looks like IRQs are somehow disabled (at IO-APIC/LAPIC?)
at some priority and bellow.

Here is the place to say that after freezing, ifconfig down/up (+routing info)
does NOT solve the problem, while rmmod/modprobe the driver, makes it work 
again.

So, I moved the functions request_irq()/free_irq() from driver's probe()/release() 
methods to open()/stop() methods. Thus modified, when skge freezes, 
ifconfig down/up makes it work again (no need to rmmod/modprobe).

That makes me think that somehow skge's IRQ is disabled OUT of the driver
and free_irq()/request_irq() clears the problem. Am I wrong?

Could it be possible? How could this happen?

Any comments/suggestions/patches wellcome.

Regards

Marin Mitov


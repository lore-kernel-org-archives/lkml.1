Return-Path: <linux-kernel-owner+w=401wt.eu-S1763601AbXJSNRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763601AbXJSNRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 09:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbXJSNR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 09:17:26 -0400
Received: from bay0-omc1-s15.bay0.hotmail.com ([65.54.246.87]:28177 "EHLO
	bay0-omc1-s15.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755277AbXJSNRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 09:17:25 -0400
Message-ID: <BLU112-W5125F6D8BEB3DF6359D53E29F0@phx.gbl>
X-Originating-IP: [218.80.174.211]
From: Shane Huang <chunhao.huang@hotmail.com>
To: <davem@davemloft.net>, <gregkh@suse.de>, <htejun@gmail.com>,
       <brice.goglin@gmail.com>, <david.gaarenstroom@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@atrey.karlin.mff.cuni.cz>,
       <shane.huang@amd.com>, <chunhao.huang@hotmail.com>
Subject: RE: [patch] PCI: disable MSI on more ATI NorthBridges
Date: Fri, 19 Oct 2007 21:17:23 +0800
Importance: Normal
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-OriginalArrivalTime: 19 Oct 2007 13:17:25.0345 (UTC) FILETIME=[63F18510:01C81252]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Guys:

> This logic seems backwards, to me.  "shoot first, ask questions later"
> To me this it not how to approach this problem.
>
> Once you turn MSI off, there is next to no incentive to fix the
> problem because users aren't running into it any longer.
>
> The only two devices in that bug report which should be using MSI
> would be the SATA controller and the broadcom ethernet NIC.  And by
> the failed bootup logs provided by the user the problem is clearly
> with the SATA controller.
>
> One common problem we're finding is that some devices have a hardware
> bug where setting INTX_DISABLE in the PCI COMMAND register masks MSI
> interrupts too.
>
> I mention this because the user in that report mentions that the
> kernel upgrade causes the failure, and one thing we started doing not
> too long ago was to set the INTX_DISABLE bit when MSI is enabled for a
> device.

Yes, you are right, to find out the root cause is better. Thank you
for all your suggestion and information to us.
Since we have little experience on PCI and MSI here, we had to try to
disable MSI  before we find a better solution. But as you are giving
us help now on this case, it's great! Then let's go...

> So maybe this SATA controller has this problem too.  It is easy to
> test, simply comment out all of the pci_intx() function calls in
> drivers/pci/msi.c and perform a test boot with MSI enabled.
>
> I would rather you approach analysis of these kinds of MSI bugs in
> this manner, instead of disabling MSI wholesale.  Because with the
> latter approach it is nearly guarenteed that the real reason will only
> be discovered with an extremely low priority.

I'm using kernel 2.6.23-rc5 to debug this MSI problem, which can NOT
boot on our Trevally board(RS690+SB700) without any kernel modification.

But if I comment out all the pci_intx() function calls in
drivers/pci/msi.c, it can boot now with MSI enabled as you expected!

# cat /proc/interrupts 
           CPU0       CPU1       
  0:        318     174060   IO-APIC-edge      timer
  8:          0          1   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 16:          0        204   IO-APIC-fasteoi   HDA Intel
 17:          0        479   IO-APIC-fasteoi   ohci_hcd:usb1, ohci_hcd:usb2, ehci_hcd:usb6
 18:          1          2   IO-APIC-fasteoi   ohci_hcd:usb3, ohci_hcd:usb4, ohci_hcd:usb5
 19:          0          0   IO-APIC-fasteoi   ehci_hcd:usb7
 22:          4          1   IO-APIC-fasteoi   yenta
8412:          0       1315   PCI-MSI-edge      eth0
8413:        381       4858   PCI-MSI-edge      ahci
NMI:          0          0 
LOC:     174285     174210 
ERR:          0

Also if I keep the pci_intx() calls in drivers/pci/msi.c and ONLY
comment out the pci_intx() call in drivers/ata/ahci.c
My system can boot up too with MSI enabled!

So does it mean that the root cause is our SB700 SATA controller
has a hardware bug where setting INTX_DISABLE in the PCI COMMAND
register masks MSI interrupts too? 
And what is the software solution or workaround?

I will continue debug this MSI problem next week. Any suggestions,
please don't hesitate to tell us.


Thanks
Best Regards

Shane

_________________________________________________________________
News, entertainment and everything you care about at Live.com. Get it now!
http://www.live.com/getstarted.aspx

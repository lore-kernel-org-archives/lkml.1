Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbXC1DqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbXC1DqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 23:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbXC1DqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 23:46:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:52946 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbXC1DqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 23:46:18 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: tglx@linutronix.de
Subject: Re: [PATCH] i386: disable local apic timer via command line or dmi quirk
Date: Tue, 27 Mar 2007 23:38:26 -0400
User-Agent: KMail/1.9.5
Cc: Stefan Prechtel <stefan.prechtel@googlemail.com>, Andi Kleen <ak@suse.de>,
       Grzegorz Chwesewicz <grzegorz.chwesewicz@chilan.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Arjan van de Ven <arjan@infradead.org>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com> <1174486483.10840.89.camel@localhost.localdomain> <200703272328.34685.lenb@kernel.org>
In-Reply-To: <200703272328.34685.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703272338.27471.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 March 2007 23:28, Len Brown wrote:
> Thomas,
> 
> Is this failure specific to NO_HZ, and that is why the "nolapic_timer" fix is i386 only?
> I'm running 2.6.21-rc5 an nx6325 here in 64-bit mode and I don't see the dramatic
> boot failure described earlier in this thread.
> 
> However, I have observed that when running on battery,
> the LOC falls behind the irq0 timer to the tune of about
> 2 interrupt/minute.  eg. when i booted my machine, LOC was
> behind irq0 by 50, and now about a 20 minutes later it is behind
> irq0 by 99.  However, the LOC for each processor remain at
> a constant offset with respect to each other.
> 
> I do not see these this drift when running on AC.

Correction.
I double-checked and the same drift is present between irq0
and LOC when on AC:

lenb@nx6325:/tmp/sut> uname -a; cat /proc/interrupts; sleep 100; cat /proc/interrupts
Linux nx6325 2.6.21-rc5 #37 SMP Tue Mar 27 22:26:00 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux
           CPU0       CPU1
  0:    1000442          0    <NULL>-edge      timer
  1:        724          0   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc
 12:      36299          0   IO-APIC-edge      i8042
 14:      33661          0   IO-APIC-edge      ide0
 16:      20676          0   IO-APIC-fasteoi   libata
 19:         21          0   IO-APIC-fasteoi   ehci_hcd:usb1, ohci_hcd:usb2, ohci_hcd:usb3
 20:          1          0   IO-APIC-fasteoi   ohci1394
 21:       9388          0   IO-APIC-fasteoi   acpi
 23:      43794          0   IO-APIC-fasteoi   eth0
NMI:          0          0
LOC:    1000271    1000247
ERR:          0
           CPU0       CPU1
  0:    1025442          0    <NULL>-edge      timer
  1:        724          0   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc
 12:      39539          0   IO-APIC-edge      i8042
 14:      34506          0   IO-APIC-edge      ide0
 16:      22172          0   IO-APIC-fasteoi   libata
 19:         21          0   IO-APIC-fasteoi   ehci_hcd:usb1, ohci_hcd:usb2, ohci_hcd:usb3
 20:          1          0   IO-APIC-fasteoi   ohci1394
 21:       9630          0   IO-APIC-fasteoi   acpi
 23:      44826          0   IO-APIC-fasteoi   eth0
NMI:          0          0
LOC:    1025269    1025245
ERR:          0
lenb@nx6325:/tmp/sut> bc -l
bc 1.06
Copyright 1991-1994, 1997, 1998, 2000 Free Software Foundation, Inc.
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'.
1025442-1000442
25000
1025269-1000271
24998
lenb@nx6325:/tmp/sut> cat /proc/acpi/ac_adapter/C1BD/state
state:                   on-line

-Len

> Yes, the system exports just C1 in both cases.
> 
> Other oddities is the IRQ name on irq0 is garbled:
> 
> lenb@nx6325:~> uname -a; cat /proc/interrupts; sleep 100; cat /proc/interrupts
> Linux nx6325 2.6.21-rc5 #37 SMP Tue Mar 27 22:26:00 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux
>            CPU0       CPU1
>   0:     723812          0    <NULL>-edge      timer
>   1:        716          0   IO-APIC-edge      i8042
>   8:          0          0   IO-APIC-edge      rtc
>  12:      30719          0   IO-APIC-edge      i8042
>  14:      24318          0   IO-APIC-edge      ide0
>  16:      18316          0   IO-APIC-fasteoi   libata
>  19:         21          0   IO-APIC-fasteoi   ehci_hcd:usb1, ohci_hcd:usb2, ohci_hcd:usb3
>  20:          1          0   IO-APIC-fasteoi   ohci1394
>  21:       6736          0   IO-APIC-fasteoi   acpi
>  23:      30358          0   IO-APIC-fasteoi   eth0
> NMI:          0          0
> LOC:     723675     723651
> ERR:          0
>            CPU0       CPU1
>   0:     748812          0    <NULL>-edge      timer
>   1:        716          0   IO-APIC-edge      i8042
>   8:          0          0   IO-APIC-edge      rtc
>  12:      30719          0   IO-APIC-edge      i8042
>  14:      25164          0   IO-APIC-edge      ide0
>  16:      18361          0   IO-APIC-fasteoi   libata
>  19:         21          0   IO-APIC-fasteoi   ehci_hcd:usb1, ohci_hcd:usb2, ohci_hcd:usb3
>  20:          1          0   IO-APIC-fasteoi   ohci1394
>  21:       6960          0   IO-APIC-fasteoi   acpi
>  23:      31385          0   IO-APIC-fasteoi   eth0
> NMI:          0          0
> LOC:     748673     748649
> ERR:          0
> lenb@nx6325:~> bc -l
> bc 1.06
> Copyright 1991-1994, 1997, 1998, 2000 Free Software Foundation, Inc.
> This is free software with ABSOLUTELY NO WARRANTY.
> For details type `warranty'.
> 748812-723812
> 25000
> 748673-723675
> 24998
> 723812-723675
> 137
> 748812-748673
> 139
> lenb@nx6325:~> 
> 
> Further, in dmesg:
> ATI board detected. Disabling timer routing over 8254.
> 
> ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> 
> -Len
> 
> 
> 

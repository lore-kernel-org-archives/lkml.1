Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbXIYTxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbXIYTxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 15:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbXIYTxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 15:53:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36136 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbXIYTxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 15:53:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325, related to clockevents
Date: Tue, 25 Sep 2007 22:07:01 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200709231257.12213.rjw@sisk.pl> <200709251516.58405.rjw@sisk.pl> <1190726273.4035.331.camel@chaos>
In-Reply-To: <1190726273.4035.331.camel@chaos>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_mpW+GOClj4sOEy5"
Message-Id: <200709252207.02532.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_mpW+GOClj4sOEy5
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday, 25 September 2007 15:17, Thomas Gleixner wrote:
> On Tue, 2007-09-25 at 15:16 +0200, Rafael J. Wysocki wrote:
[--snip--]
> 
> I start to get desperate. Below is a patch, which moves the apic timer
> disable check after the calibration routine. Can you please apply on top
> of -hrt and add "noapictimer" to the command line ? Does it boot ?

2.6.23-rc7 with patch-2.6.23-rc7-hrt1.patch and the patch below applied boots
with noapictimer and doesn't boot without it.

Also, attached is the output of

# cat /proc/interrupts; sleep 10; cat /proc/interrupts

from the current mainline.

Greetings,
Rafael


> Index: linux-2.6.23-rc7/arch/x86_64/kernel/apic.c
> ===================================================================
> --- linux-2.6.23-rc7.orig/arch/x86_64/kernel/apic.c	2007-09-24 20:30:00.000000000 +0200
> +++ linux-2.6.23-rc7/arch/x86_64/kernel/apic.c	2007-09-25 15:05:32.000000000 +0200
> @@ -927,6 +927,7 @@ static void __init calibrate_APIC_clock(
>  
>  void __init setup_boot_APIC_clock (void)
>  {
> +#if 0
>  	/*
>  	 * The local apic timer can be disabled via the kernel commandline.
>  	 * Register the lapic timer as a dummy clock event source on SMP
> @@ -940,7 +941,7 @@ void __init setup_boot_APIC_clock (void)
>  			setup_APIC_timer();
>  		return;
>  	}
> -
> +#endif
>  	printk(KERN_INFO "Using local APIC timer interrupts.\n");
>  	calibrate_APIC_clock();
>  
> @@ -949,11 +950,13 @@ void __init setup_boot_APIC_clock (void)
>  	 * PIT/HPET going.  Otherwise register lapic as a dummy
>  	 * device.
>  	 */
> -	if (nmi_watchdog != NMI_IO_APIC)
> +	if (!disable_apic_timer && nmi_watchdog != NMI_IO_APIC)
>  		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
> +#if 0
>  	else
>  		printk(KERN_WARNING "APIC timer registered as dummy,"
>  		       " due to nmi_watchdog=1!\n");
> +#endif
>  
>  	setup_APIC_timer();
>  }
> 
> 
> 
> 

-- 
"Premature optimization is the root of all evil." - Donald Knuth

--Boundary-00=_mpW+GOClj4sOEy5
Content-Type: text/x-log;
  charset="iso-8859-15";
  name="interrupts.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="interrupts.txt"

albercik:~ # cat /proc/interrupts; sleep 10; cat /proc/interrupts
           CPU0       CPU1
  0:      62489          0  local-APIC-edge      timer
  1:          3        232   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc
 12:          1        147   IO-APIC-edge      i8042
 14:         15       1947   IO-APIC-edge      ide0
 16:        193      14151   IO-APIC-fasteoi   sata_sil, HDA Intel
 19:         76      43153   IO-APIC-fasteoi   ohci_hcd:usb1, ehci_hcd:usb2, ohci_hcd:usb3
 20:          0          4   IO-APIC-fasteoi   ohci1394, tifm_7xx1, yenta, sdhci:slot0
 21:          7        172   IO-APIC-fasteoi   acpi
NMI:          0          0
LOC:      62454      62082
ERR:          0
           CPU0       CPU1
  0:      64993          0  local-APIC-edge      timer
  1:          3        233   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc
 12:          1        147   IO-APIC-edge      i8042
 14:         15       2037   IO-APIC-edge      ide0
 16:        194      14265   IO-APIC-fasteoi   sata_sil, HDA Intel
 19:         77      45155   IO-APIC-fasteoi   ohci_hcd:usb1, ehci_hcd:usb2, ohci_hcd:usb3
 20:          0          4   IO-APIC-fasteoi   ohci1394, tifm_7xx1, yenta, sdhci:slot0
 21:          7        176   IO-APIC-fasteoi   acpi
NMI:          0          0
LOC:      64958      64586
ERR:          0
albercik:~ #

--Boundary-00=_mpW+GOClj4sOEy5--

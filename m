Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbXH0J2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbXH0J2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 05:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbXH0J2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 05:28:17 -0400
Received: from cando-ltd.com ([62.253.227.66]:2267 "EHLO
	sideshow-bob.tisolutions.biz" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752245AbXH0J2Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 05:28:16 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.0.6487.1
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: "exception Emask: 0x42" errors with 2.6.22.x and SATA drives
Date: Mon, 27 Aug 2007 10:28:09 +0100
Message-ID: <94439DDF32D7464A916B5068EFF76B3B0225E6FB@bart.tisolutions.biz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: "exception Emask: 0x42" errors with 2.6.22.x and SATA drives
Thread-Index: Acfn2L5QBZPZlcUGTcKfGhlhbXpvKgAsaq0w
From: "Dermot Bradley" <dermot.bradley@sla-mobile.com>
To: "Alistair John Strachan" <alistair@devzero.co.uk>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> FWIW, I've got the HDMI version of this board and I have exactly the
same
> problem (even with the newest BIOS) if nmi_watchdog is not set to
zero.
> Try booting with nmi_watchdog=0 (default on x86-64, I think) and see
if
> these go away.
>
> I guess the APIC has some difficulties handling NMIs.

On Friday I had rebooted the box (remotely) after adding "noapic" to the
boot options and the machine didn't come back up - came in this morning
to see a kernel panic after the reboot to do with nmi_watchdog.

This morning I've removed the "noapic" option and instead set
"nmi_watchdog=0" and its booted and been up and running for 30 minutes
with no APCI whereas these happened every thing previously during boot.

So nmi_watch does indeed seem to related to the root cause of the
problem. 

Thanks for the help Alistair! One other point you may be able to help
with - this is the first time I've used a dual core processor and I
expected that /proc/interrupts would should interrupts distributed
between both cores whereas they actually seem to be mainly handled by
the 1st core:

           CPU0       CPU1
  0:        251          0   IO-APIC-edge      timer
  1:       2208         11   IO-APIC-edge      i8042
  8:          0          1   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 16:       5291          3   IO-APIC-fasteoi   ehci_hcd:usb1, eth0
 17:     223026         13   IO-APIC-fasteoi   ahci
 18:          0          1   IO-APIC-fasteoi   ohci_hcd:usb2
 19:          0        126   IO-APIC-fasteoi   ohci_hcd:usb3,
ohci_hcd:usb5
 20:          0          2   IO-APIC-fasteoi   ohci_hcd:usb4,
ohci_hcd:usb6
 21:     188591          1   IO-APIC-fasteoi   HFC-multi
NMI:          0          0
LOC:    3036393    1527288
ERR:          0
MIS:          0

Is this to be expected for dual core systems?

> I get the feeling this problem is independent of the APIC errors, and
I
> don't see it here

Yeah, I thought as much. After disabling NMI Watchdog I didn't see these
NCQ messages initially but after running a few bonnie runs to load the
disks I'm now getting them again.

> As Alan said, it's very possibly just the drive not properly
supporting
> NCQ.

Yeah that seems the case - last Friday these errors seemed to be
occurring every 1-2 hours or so even when I wasn't using the machine.

I'm currently rebuilding the kernel with the following patch to disable
NCQ for these drives:

--- linux-2.6.22.5/drivers/ata/libata-core.c    2007-08-23
00:23:54.000000000 +0100
+++ linux-2.6.22.5.new/drivers/ata/libata-core.c        2007-08-27
10:25:16.000000000 +0100
@@ -3788,6 +3788,7 @@
        /* NCQ is broken */
        { "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ },
        { "Maxtor 6B200M0",     "BANC1B10",     ATA_HORKAGE_NONCQ },
+        { "WDC WD800BEVS-07",   NULL,          ATA_HORKAGE_NONCQ },
        /* NCQ hard hangs device under heavier load, needs hard power
cycle */
        { "Maxtor 6B250S0",     "BANC1B70",     ATA_HORKAGE_NONCQ },
        /* Blacklist entries taken from Silicon Image 3124/3132




Stirk, Lamont & Associates Ltd.
Registered Address: Thomas Andrews House, Queens Road, Belfast,  BT3 9DU
Registered in Northern Ireland, Number: NI 47983. VAT Number: 832 2778 22


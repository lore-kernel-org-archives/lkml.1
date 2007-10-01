Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbXJAQhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbXJAQhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbXJAQhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:37:14 -0400
Received: from rtr.ca ([76.10.145.34]:2456 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbXJAQhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:37:12 -0400
Message-ID: <4701223A.6050200@rtr.ca>
Date: Mon, 01 Oct 2007 12:37:14 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Santiago Garcia Mantinan <manty@manty.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 32-bit Athlon X2 won't poweroff 
References: <46FD05B8.2040302@rtr.ca> <46FD0724.5060009@rtr.ca> <1190991316.18681.38.camel@chaos> <46FD5BAF.8040304@rtr.ca> <20070930090032.GA2405@pul.manty.net> <46FFDB29.9040400@rtr.ca> <20070930175446.GA2472@pul.manty.net> <46FFEF41.8010104@rtr.ca> <20070930200336.GA2441@pul.manty.net> <470028C5.7020501@rtr.ca> <20071001161911.GA2419@pul.manty.net>
In-Reply-To: <20071001161911.GA2419@pul.manty.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Santiago Garcia Mantinan wrote:
>> So for this to work, I believe that either ACPI or APM has to have been
>> configured into the kernel (and the modules loaded).  Your kernel .config
>> from earlier shows ACPI built-in to the kernel core, so it should be 
>> present.
> 
> Yes, and it is indeed, the acpid is running and it detects my power button
> and starts the poweroff when I hit it.
> 
>> Unless you booted with noacpi or some such parameter..
>> So let's have a look at the kernel boot logs,
> 
> I believe this is normal, I have done a grep -i acpi on the dmesg, here is
> the result, if you want the full dmesg tell me:
..
> ACPI: Interpreter enabled
> ACPI: Using IOAPIC for interrupt routing
..

The output is missing a line like this, which should have been between the two above:

   ACPI: (supports S0 S3 S4 S5)

The ACPI power-off function only gets bound into pm_power_off()
when that line shows S5 on it.

The only way that line can be missing, is if something disabled ACPI
after boot.

This patch (below) should find the culprit for you:

---


--- old/include/asm-i386/acpi.h	2007-09-28 18:09:14.000000000 -0400
+++ linux/include/asm-i386/acpi.h	2007-10-01 12:35:23.000000000 -0400
@@ -97,6 +97,7 @@
 extern int acpi_pci_disabled;
 static inline void disable_acpi(void)
 {
+	WARN_ON(1);
 	acpi_disabled = 1;
 	acpi_ht = 0;
 	acpi_pci_disabled = 1;

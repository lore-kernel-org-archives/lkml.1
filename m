Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbYCJRF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbYCJRF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYCJRFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:05:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50726 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbYCJRFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:05:19 -0400
Date: Mon, 10 Mar 2008 18:04:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Subject: [patch] fix ACPI boot regression (was: Re: Linux 2.6.25-rc5)
Message-ID: <20080310170434.GA22430@elte.hu>
References: <alpine.LFD.1.00.0803092231580.5896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803092231580.5896@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'd like developers and testers alike to take a good look at the 
> regression email that Rafael sends out, and please help him keep the 
> entries up-to-date.

figured out another ACPI related regression today.

randconfig testing triggered an early boot-time hang on a laptop of mine 
(32-bit x86, config attached) - the screen was scrolling ACPI AML 
exceptions [with no serial port and no early debugging available].
 
v2.6.24 works fine on that laptop with the same .config, so after a few 
hours of bisection (had to restart it 3 times - other regressions 
interacted), it honed in on this commit:

| 10270d4838bdc493781f5a1cf2e90e9c34c9142f is first bad commit
|
| Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
| Date:   Wed Feb 13 09:56:14 2008 -0800
|
|     acpi: fix acpi_os_read_pci_configuration() misuse of raw_pci_read()

reverting this commit ontop of -rc5 gave a correctly booting kernel.

but this commit fixes a real bug so the real question is, why did it 
break the bootup?

after quite some head-scratching, the following change stood out:

-                               pci_id->bus = tu8;
+                               pci_id->bus = val;

pci_id->bus is defined as u16:

   struct acpi_pci_id {
           u16 segment;
           u16 bus;
   ...

and 'tu8' changed from u8 to u32. So previously we'd unconditionally 
mask the return value of acpi_os_read_pci_configuration() 
(raw_pci_read()) to 8 bits, but now we just trust whatever comes back 
from the PCI access routines and only crop it to 16 bits.

But if the high 8 bits of that result contains any noise then we'll 
write that into ACPI's PCI ID descriptor and confuse the heck out of the 
rest of ACPI.

So lets check the PCI-BIOS code on that theory. We have this codepath 
for 8-bit accesses (arch/x86/pci/pcbios.c:pci_bios_read()):

        switch (len) {
        case 1:
                __asm__("lcall *(%%esi); cld\n\t"
                        "jc 1f\n\t"
                        "xor %%ah, %%ah\n"
                        "1:"
                        : "=c" (*value),
                          "=a" (result)
                        : "1" (PCIBIOS_READ_CONFIG_BYTE),
                          "b" (bx),
                          "D" ((long)reg),
                          "S" (&pci_indirect));

aha! The "=a" output constraint puts the full 32 bits of EAX into 
*value. But if the BIOS's routines set any of the high bits to nonzero, 
we'll return a value with more set in it than intended.

the other, more common PCI access methods (v1 and v2 PCI reads) clear 
out the high bits already, for example pci_conf1_read() does:

        switch (len) {
        case 1:
                *value = inb(0xCFC + (reg & 3));

which explicitly converts the return byte up to 32 bits and zero-extends 
it.

so zero-extending the result in the PCI-BIOS read routine fixes the 
regression on my laptop. ( It might fix some other long-standing issues 
we had with PCI-BIOS during the past decade ... ) Both 8-bit and 16-bit 
accesses were buggy.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/pci/pcbios.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux/arch/x86/pci/pcbios.c
===================================================================
--- linux.orig/arch/x86/pci/pcbios.c
+++ linux/arch/x86/pci/pcbios.c
@@ -198,6 +198,11 @@ static int pci_bios_read(unsigned int se
 			  "b" (bx),
 			  "D" ((long)reg),
 			  "S" (&pci_indirect));
+		/*
+		 * Zero-extend the result beyond 8 bits, do not trust the
+		 * BIOS having done it:
+		 */
+		*value &= 0xff;
 		break;
 	case 2:
 		__asm__("lcall *(%%esi); cld\n\t"
@@ -210,6 +215,11 @@ static int pci_bios_read(unsigned int se
 			  "b" (bx),
 			  "D" ((long)reg),
 			  "S" (&pci_indirect));
+		/*
+		 * Zero-extend the result beyond 16 bits, do not trust the
+		 * BIOS having done it:
+		 */
+		*value &= 0xffff;
 		break;
 	case 4:
 		__asm__("lcall *(%%esi); cld\n\t"

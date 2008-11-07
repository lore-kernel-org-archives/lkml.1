Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYKGJvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYKGJvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYKGJvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:51:37 -0500
Received: from hpsmtp-eml15.KPNXCHANGE.COM ([213.75.38.115]:59929 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456AbYKGJvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:51:35 -0500
From: Frans Pop <elendil@planet.nl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [bisected][resend] pnp: Huge number of "io resource overlap" messages
Date: Fri, 7 Nov 2008 10:51:31 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Rene Herman <rene.herman@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <200809091250.08620.elendil@planet.nl> <200809091826.18876.elendil@planet.nl> <200809091140.25597.bjorn.helgaas@hp.com>
In-Reply-To: <200809091140.25597.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811071051.32830.elendil@planet.nl>
X-OriginalArrivalTime: 07 Nov 2008 09:51:33.0199 (UTC) FILETIME=[6A875DF0:01C940BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Info below was also posted in reply to the announcement mail for .28-rc3 
(http://lkml.org/lkml/2008/11/3/201); reposting to the original thread as
there was no response yet.)

On Tuesday 09 September 2008, Bjorn Helgaas wrote:
> On Tuesday 09 September 2008 10:26:17 am Frans Pop wrote:
> Yup, this all looks reasonable to me, too.  But these regions must be
> different than they were when the PNP quirk ran.  I wonder if the BIOS
> left them unprogrammed, we ran the PNP quirk and discovered all these
> "conflicts," then PCI came along and assigned resources.
>
> Your dmesg shows power state changes for the PCI devices.  Maybe
> the BIOS left them in D3 and unprogrammed:
>
>   Intel ICH Modem 0000:00:1f.6: power state changed by ACPI to D0
>   Intel ICH 0000:00:1f.5: power state changed by ACPI to D0
>   Intel ICH 0000:00:1f.5: enabling device (0000 -> 0003)
>
> If the PCI device isn't fully initialized, it doesn't seem right to
> check it for resource conflicts.  But I don't know how to tell that.

It appears there's been a fundamental change between .28-rc2 and .28-rc3
that fixes this issue. I no longer get the "io resource overlap" messages
when the BIOS is set to let PCI devices be "Set up by OS".

I now get the exact same /proc/io{mem,ports} as with the BIOS set to
"initialize all PCI devices". It very much looks as if the two devices that
caused the messages now get activated much earlier.

This shows best in a diff between the dmesgs for .28-rc2 and .28-rc3. Here are
the relevant bits for the two devices:
# I now immediately get good resources assigned:
-pci 0000:00:1f.5: reg 10 io port: [0x00-0xff]
-pci 0000:00:1f.5: reg 14 io port: [0x00-0x3f]
-pci 0000:00:1f.5: reg 18 32bit mmio: [0x000000-0x0001ff]
-pci 0000:00:1f.5: reg 1c 32bit mmio: [0x000000-0x0000ff]
+pci 0000:00:1f.5: reg 10 io port: [0xbe00-0xbeff]
+pci 0000:00:1f.5: reg 14 io port: [0xbdc0-0xbdff]
+pci 0000:00:1f.5: reg 18 32bit mmio: [0xcfdffe00-0xcfdfffff]
+pci 0000:00:1f.5: reg 1c 32bit mmio: [0xcfdffd00-0xcfdffdff]
 pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
 pci 0000:00:1f.5: PME# disabled
-pci 0000:00:1f.6: reg 10 io port: [0x00-0xff]
-pci 0000:00:1f.6: reg 14 io port: [0x00-0x7f]
+pci 0000:00:1f.6: reg 10 io port: [0xba00-0xbaff]
+pci 0000:00:1f.6: reg 14 io port: [0xb980-0xb9ff]
 pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
 pci 0000:00:1f.6: PME# disabled
[...]
# The block of 78 "io resource overlap" messages are now gone:
-pnp 00:08: io resource (0x2e-0x2f) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
-pnp 00:08: io resource (0x62-0x62) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
[75 similar messages omitted]
-pnp 00:08: io resource (0x72-0x77) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
[... much later]
# Apparently there is no longer any need to enable the device later on:
 Intel ICH 0000:00:1f.5: power state changed by ACPI to D0
-Intel ICH 0000:00:1f.5: enabling device (0000 -> 0003)
 Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 Intel ICH 0000:00:1f.5: setting latency timer to 64
 Intel ICH Modem 0000:00:1f.6: power state changed by ACPI to D0
 Intel ICH Modem 0000:00:1f.6: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 Intel ICH Modem 0000:00:1f.6: setting latency timer to 64

The most likely cause of this change is the following commit from Linus:
commit 1f98757776eafe31065be9118db6051afcf8643c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Nov 1 10:17:22 2008 -0700
    x86: Clean up late e820 resource allocation

But I'm not 100% sure of that. Anyway, it looks as if #11550 can be closed.

Cheers,
FJP

Return-Path: <linux-kernel-owner+w=401wt.eu-S933365AbXLNNFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbXLNNFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 08:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765624AbXLNNEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 08:04:53 -0500
Received: from [194.117.236.238] ([194.117.236.238]:35785 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1765468AbXLNNEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 08:04:52 -0500
Date: Fri, 14 Dec 2007 18:01:19 +0200
From: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071214180119.4c492f6c@linux360.ro>
In-Reply-To: <20071214122048.GA12550@one.firstfloor.org>
References: <20071214004442.5f9eba88@linux360.ro>
	<p737ijigr8c.fsf@bingen.suse.de>
	<20071214143941.2c7dcfb4@linux360.ro>
	<20071214101720.GA10981@one.firstfloor.org>
	<20071214154106.4f0b2d8c@linux360.ro>
	<20071214122048.GA12550@one.firstfloor.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 13:20:48 +0100
Andi Kleen <andi@firstfloor.org> wrote:
 
> AMD doesn't support states deeper than C1 on multi core currently, so 
> in general they don't matter much right now.
 
Thanks for the info, I wasn't aware of this.

> The better solution there is to use HPET instead. Newer systems
> generally have HPET already enabled in the BIOS and for older systems
> hpet=force gains more and more support. So try that.

Dynticks won't use the HPET, even if enabled. IIRC, HPET is enabled on
my system (NVIDIA MCP51) even without "hpet=force". Here's dmesg's
output on Linux 2.6.24-rc5: 

$ dmesg | grep -Ei "(lapic|hpet|disabling)"Command line: ro hpet=force
ACPI: HPET 3FFA9730, 0038 (r1 A M I  OEMHPET0  2000727 MSFT       97)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: HPET id: 0x10de8201 base: 0xfed00000
Kernel command line: ro hpet=force
hpet clockevent registered
TSC calibrated against HPET
Disabling APIC timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
Time: hpet clocksource has been installed.
Clockevents: could not switch to one-shot mode: lapic is not functional.
Clockevents: could not switch to one-shot mode: lapic is not functional.
Unpacking initramfs...<6>Clockevents: could not switch to one-shot mode:<6>Clockevents: could not switch to one-shot mode: lapic is not functional.
 lapic is not functional.
hpet_resources: 0xfed00000 is busy

LAPIC is seemingly disabled (C1E detection code does this), but
clockevents still tries to use it, instead of relying on HPET. I'll
look into this, but please give me a heads up if you know more about
what's happening. Looks like fixing this is better than using LAPIC for
dynticks (and disabling C1E) on such systems.

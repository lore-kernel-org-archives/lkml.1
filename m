Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYKDVba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYKDVba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbYKDVbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:31:16 -0500
Received: from smarthost01.mail.zen.net.uk ([212.23.3.140]:44435 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012AbYKDVbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:31:15 -0500
Subject: Re: [PATCH] x86: Don't allow nr_irqs > NR_IRQS
From: Ben Hutchings <bhutchings@solarflare.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
In-Reply-To: <20081104194606.GJ21470@localhost>
References: <1225819102.3074.15.camel@achroite>
	 <20081104180012.GG21470@localhost> <1225823807.3074.24.camel@achroite>
	 <20081104190108.GH21470@localhost> <1225825559.3074.26.camel@achroite>
	 <20081104194606.GJ21470@localhost>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Tue, 04 Nov 2008 21:31:07 +0000
Message-Id: <1225834267.3074.44.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-04 at 22:46 +0300, Cyrill Gorcunov wrote:
[...]
> Ben, I'll take a look on ACPI code tomorrow. If I understand you
> correctly your Xeon machine has a few cores and only one IO-APIC
> (on physical side)? Am I right?

It has 2 single-core processors (family 15 model 4).  Here's the lspci
output:

00:00.0 Host bridge: Intel Corporation E7520 Memory Controller Hub (rev 0c)
00:00.1 Class ff00: Intel Corporation E7525/E7520 Error Reporting Registers (rev 0c)
00:02.0 PCI bridge: Intel Corporation E7525/E7520/E7320 PCI Express Port A (rev 0c)
00:03.0 PCI bridge: Intel Corporation E7525/E7520/E7320 PCI Express Port A1 (rev 0c)
00:04.0 PCI bridge: Intel Corporation E7525/E7520 PCI Express Port B (rev 0c)
00:06.0 PCI bridge: Intel Corporation E7520 PCI Express Port C (rev 0c)
00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus Controller (rev 02)
02:00.0 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge A (rev 09)
02:00.1 PIC: Intel Corporation 6700/6702PXH I/OxAPIC Interrupt Controller A (rev 09)
02:00.2 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge B (rev 09)
02:00.3 PIC: Intel Corporation 6700PXH I/OxAPIC Interrupt Controller B (rev 09)
04:02.0 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
04:02.1 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
05:00.0 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge A (rev 09)
05:00.1 PIC: Intel Corporation 6700/6702PXH I/OxAPIC Interrupt Controller A (rev 09)
05:00.2 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge B (rev 09)
05:00.3 PIC: Intel Corporation 6700PXH I/OxAPIC Interrupt Controller B (rev 09)
07:02.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23 IEEE-1394a-2000 Controller (PHY/Link)
08:00.0 Ethernet controller: Solarflare Communications SFC4000 rev B [Solarstorm] (rev 02)
09:01.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)

I see 4 PICs there; no idea where the 5th is hiding.

I switched to an RHEL 5 (2.6.18-53) kernel and found that that also
detects 5 IOAPICs, so there's no recent change in that.

This is the commit that made nr_irqs dynamic:

commit 71f521bbaf375b685aeea20c6b0ed8600cd6edfe
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Tue Aug 19 20:50:03 2008 -0700

    x86, irq: get nr_irqs from madt
    
    Until now, NR_IRQS was derived from black magic defines that had to
    be "large enough" to both accomodate NR_CPUS and MAX_NR_IO_APICs.
    
    This resulted in a way too large irq_desc[] array on most x86 systems.
    Especially with larger CPU masks, the size of irq_desc can spiral out
    of control quickly.
    
    So be smarter about it and use precise allocation instead: determine the
    default maximum possible IRQ number from the ACPI MADT. Use a minimum limit
    of at least 32 IRQs for broken BIOSes.
    
    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

That was fine at the time because the irq_desc array was allocated
dynamically.  But now that irq_desc has been reverted to a static array,
the probe function needs to apply the upper limit.  Alternately nr_irqs
could be set to NR_IRQS unconditionally; the probing for nr_irqs is
fairly pointless if it isn't used for dynamic allocation.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


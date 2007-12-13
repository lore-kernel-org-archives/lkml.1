Return-Path: <linux-kernel-owner+w=401wt.eu-S1762120AbXLMQRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762120AbXLMQRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbXLMQRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:17:23 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:1687 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbXLMQRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:17:22 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: bbpetkov@yahoo.de
Subject: Re: 2.6.24-rc4-mm1: acpi reboots machine... solved
Date: Thu, 13 Dec 2007 09:17:18 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, len.brown@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, trenn@suse.de
References: <20071209075001.GA4686@gollum.tnic> <200712120921.42430.bjorn.helgaas@hp.com> <20071213070923.GA3951@gollum.tnic>
In-Reply-To: <20071213070923.GA3951@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712130917.18723.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 December 2007 12:09:23 am Borislav Petkov wrote:
> On Wed, Dec 12, 2007 at 09:21:41AM -0700, Bjorn Helgaas wrote:
> > On Wednesday 12 December 2007 03:11:23 am Borislav Petkov wrote:
> > > On Tue, Dec 11, 2007 at 05:08:59PM -0700, Bjorn Helgaas wrote:
> > > > On Tuesday 11 December 2007 01:52:55 pm Borislav Petkov wrote:
> > > > > From what i can roughly tell so far it seems like an resource conflict between acpi and
> > > > > the pnp requested regions in your patch which result in the acpi_thermal code
> > > > > to read the wrong (0xff) temperature value and halt the machine, but i might be
> > > > > wrong on the details since acpi is such a big code chunk to swallow.
> > > > 
> > I think Alexey is on the right track with the PCI resource allocation
> > failure.
> 
> Then it should be the SMBus controller, PCI id 00:1f:3, which is having problems
> registering its io ports region 4, AFAICT.

Yes, it looks like the ioport region 0x540-0x55f is described both in
PNP and ACPI:

  /sys/devices/pnp0/00:0d/resources:state = active
  /sys/devices/pnp0/00:0d/resources:io 0x540-0x55f
  /sys/devices/pnp0/00:0d/resources:io 0x400-0x47f

  00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 03)
        Subsystem: ASUSTeK Computer Inc. Unknown device 1869
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 0
        Region 4: I/O ports at 0540 [size=32]

The PCI SMBus device was enabled by a quirk, asus_hides_smbus_lpc().

This quirk seems dangerous to me, and the comments above asus_hides_smbus
allude to problems similar to what you're seeing.  It's obvious that a
lot of blood, sweat, and tears have gone into this quirk, so I'm not
suggesting that it's time to revert it, but I would be interested in
knowing whether the critical temperature problem goes away if we leave
the PCI device hidden, e.g., with the following patch:

Index: linux-mm/drivers/pci/quirks.c
===================================================================
--- linux-mm.orig/drivers/pci/quirks.c	2007-12-13 09:11:31.000000000 -0700
+++ linux-mm/drivers/pci/quirks.c	2007-12-13 09:12:27.000000000 -0700
@@ -1073,12 +1073,7 @@
 
 	pci_read_config_word(dev, 0xF2, &val);
 	if (val & 0x8) {
-		pci_write_config_word(dev, 0xF2, val & (~0x8));
-		pci_read_config_word(dev, 0xF2, &val);
-		if (val & 0x8)
-			printk(KERN_INFO "PCI: i801 SMBus device continues to play 'hide and seek'! 0x%x\n", val);
-		else
-			printk(KERN_INFO "PCI: Enabled i801 SMBus device\n");
+		printk(KERN_INFO "PCI: Leaving i801 SMBus device hidden\n");
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801AA_0,	asus_hides_smbus_lpc);

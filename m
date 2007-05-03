Return-Path: <linux-kernel-owner+w=401wt.eu-S1767474AbXECXST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767474AbXECXST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 19:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767468AbXECXST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 19:18:19 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:2073 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767466AbXECXSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 19:18:18 -0400
Date: Fri, 4 May 2007 03:18:54 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: regression on quad Xeon: no SCSI-disks
Message-ID: <20070504031854.B28085@jurassic.park.msu.ru>
References: <20070501142431.GA11667@erig.dyndns.org> <46376474.8090505@redhat.com> <20070502144716.GA11061@erig.dyndns.org> <20070502211215.A19444@jurassic.park.msu.ru> <20070503084141.GA22742@erig.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <20070503084141.GA22742@erig.dyndns.org>; from Wolfgang.Erig@gmx.de on Thu, May 03, 2007 at 10:41:41AM +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 10:41:41AM +0200, Wolfgang Erig wrote:
> I am prepared to do tweaks to your small patch, but I need your help.
> My own blindly experiments failed miserably.

I don't think that patch did anything wrong, most likely it just
triggered a bug elsewhere. These two lines from your dmesg look
very suspicious:

> PCI: Cannot allocate resource region 0 of device 0000:00:04.0
> PCI: Error while updating region 0000:00:04.0/0 (a8008000 != fec08000)

Note that the BAR seems to have high address bits hardwired to fec00000.
And device 0000:00:04.0 is
> 00:04.0 System peripheral: Siemens Nixdorf AG FSC Multiprocessor Interrupt Controller (rev 02)

I'd guess that when we try to reassign this resource, PCI interrupts might
just stop working. This could explain SCSI timeouts and other weird things.

Maybe this patch helps?

Ivan.

--- 2.6.21/arch/i386/pci/fixup.c	2007-02-04 21:44:54.000000000 +0300
+++ linux/arch/i386/pci/fixup.c	2007-05-04 01:58:32.629654275 +0400
@@ -436,3 +436,14 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_CY
 			pci_early_fixup_cyrix_5530);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY,
 			pci_early_fixup_cyrix_5530);
+
+/*
+ * Siemens Nixdorf AG FSC Multiprocessor Interrupt Controller:
+ * prevent update of the BAR0, which doesn't look like a normal BAR.
+ */
+static void __devinit pci_siemens_interrupt_controller(struct pci_dev *dev)
+{
+	dev->resource[0].flags |= IORESOURCE_PCI_FIXED;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SIEMENS, 0x0015,
+			  pci_siemens_interrupt_controller);

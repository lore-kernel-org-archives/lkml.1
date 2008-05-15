Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbYEOOGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbYEOOGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 10:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbYEOOGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 10:06:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38675 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758902AbYEOOGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 10:06:01 -0400
Date: Thu, 15 May 2008 07:05:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       len.brown@intel.com
Subject: Suspend/Resume bug in PCI layer wrt quirks
Message-ID: <20080515070546.6ea9c681@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following is a bug in the PCI layer wrt suspend/resume and quirks:

pci_device_resume_early does the following:

static int pci_device_resume_early(struct device * dev)
{
        int error = 0;
        struct pci_dev * pci_dev = to_pci_dev(dev);
        struct pci_driver * drv = pci_dev->driver; 

        pci_fixup_device(pci_fixup_resume, pci_dev);

eg it calls the resume quirks.

However, one of these quirks is 
DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,     asus_hides_smbus_lpc_ich6);

and asus_hides_smbus_lpc_ich6 does

        base = ioremap_nocache(rcba & 0xFFFFC000, 0x4000); /* use bits 31:14, 16 kB aligned */
        if (base == NULL) return;
        val=readl(base + 0x3418); /* read the Function Disable register, dword mode only */
        writel(val & 0xFFFFFFF7, base + 0x3418); /* enable the SMBus device */
        iounmap(base);

internally. ioremap()/iounmap() does a global tlb flush of course, which includes doing an IPI to other cpus.
However, during early resume, interrupts are disabled, and it's not allowed to do a IPI/global tlbflush with interrupts
off...

This is hitting quite a few people now:
http://www.kerneloops.org/searchweek.php?search=smp_call_function

do we need a DECLARE_PCI_FIXUP_RESUME_LATE() and use that for this one?



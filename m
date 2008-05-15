Return-Path: <linux-kernel-owner+w=401wt.eu-S1761687AbYEOQH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761687AbYEOQH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726AbYEOQHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:07:14 -0400
Received: from outbound-mail-102.bluehost.com ([69.89.22.12]:34687 "HELO
	outbound-mail-102.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754551AbYEOQHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:07:13 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Suspend/Resume bug in PCI layer wrt quirks
Date: Thu, 15 May 2008 09:07:06 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       len.brown@intel.com, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20080515070546.6ea9c681@infradead.org>
In-Reply-To: <20080515070546.6ea9c681@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805150907.06930.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 15, 2008 7:05 am Arjan van de Ven wrote:
> Hi,
>
> the following is a bug in the PCI layer wrt suspend/resume and quirks:
>
> pci_device_resume_early does the following:
>
> static int pci_device_resume_early(struct device * dev)
> {
>         int error = 0;
>         struct pci_dev * pci_dev = to_pci_dev(dev);
>         struct pci_driver * drv = pci_dev->driver;
>
>         pci_fixup_device(pci_fixup_resume, pci_dev);
>
> eg it calls the resume quirks.
>
> However, one of these quirks is
> DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,  
>   asus_hides_smbus_lpc_ich6);
>
> and asus_hides_smbus_lpc_ich6 does
>
>         base = ioremap_nocache(rcba & 0xFFFFC000, 0x4000); /* use bits
> 31:14, 16 kB aligned */ if (base == NULL) return;
>         val=readl(base + 0x3418); /* read the Function Disable register,
> dword mode only */ writel(val & 0xFFFFFFF7, base + 0x3418); /* enable the
> SMBus device */ iounmap(base);
>
> internally. ioremap()/iounmap() does a global tlb flush of course, which
> includes doing an IPI to other cpus. However, during early resume,
> interrupts are disabled, and it's not allowed to do a IPI/global tlbflush
> with interrupts off...

Yeah I just got a similar report for quirk_vialatency().  But why are we only 
seeing these issues now?  Is our interrupt disabled check catching more stuff 
these days?

Rafael said he's looking at the VIA issue, and iirc we had talked about 
changing this stuff around a few weeks ago anyway.  So yeah we may need 
either a new fixup phase or maybe we can just move the resume fixups to occur 
a little later, when interrupts are enabled.

Jesse

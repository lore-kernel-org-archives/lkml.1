Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbYGDBs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbYGDBs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 21:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYGDBsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 21:48:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:39232 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047AbYGDBsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 21:48:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,300,1212390000"; 
   d="scan'208";a="584966890"
Subject: Re: [RFC PATCH] AHCI: speed up resume
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, tj@kernel.org
In-Reply-To: <200807040123.50337.rjw@sisk.pl>
References: <1215074882.3214.15.camel@rzhang-dt.sh.intel.com>
	 <200807040123.50337.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 04 Jul 2008 09:48:07 +0800
Message-Id: <1215136087.3068.7.camel@rzhang-dt.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-07-04 at 07:23 +0800, Rafael J. Wysocki wrote:
> On Thursday, 3 of July 2008, Zhang Rui wrote:
> > During S3 resume, AHCI driver sleeps 1 second to wait for the HBA
> reset
> > to finish. This is luxurious, :)
> >
> > According to the AHCI 1.2 spec, We should poll the HOST_CTL
> register,
> > and return error if the host reset is not finished within 1 second.
> >
> > Test results show that the HBA reset can be done quickly(in usecs).
> > And this patch may save nearly 1 second during resume.
> 
> That's a lot.
> 
> How heavily has it been tested?

I only tested it on a SantaRosa laptop.

w/o the patch,
[  469.923186] ahci_pci_device_resume
[  469.936105] PM: Writing back config space on device 0000:00:1f.2 at
offset f (was 200, writing 20a)
[  469.936145] PM: Writing back config space on device 0000:00:1f.2 at
offset 1 (was 2b00007, writing 2b00407)
[  469.936220] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[  470.092053] ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[  470.092053] ata4.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
[  470.107675] ata4.00: configured for UDMA/33
[  470.942195] ahci_pci_device_resume done

w/ the patch applied, run S3 for more than ten times in a row,
[  571.150339] ahci_pci_device_resume
[  571.163193] ahci_pci_device_resume done
[  578.560382] ahci_pci_device_resume
[  578.576410] ahci_pci_device_resume done
[  586.065037] ahci_pci_device_resume
[  586.080806] ahci_pci_device_resume done
[  770.231756] ahci_pci_device_resume
[  770.244431] ahci_pci_device_resume done
[  777.537985] ahci_pci_device_resume
[  777.553709] ahci_pci_device_resume done
[  784.805554] ahci_pci_device_resume
[  784.819660] ahci_pci_device_resume done
[  791.888451] ahci_pci_device_resume
[  791.905222] ahci_pci_device_resume done
[  798.943719] ahci_pci_device_resume
[  798.959437] ahci_pci_device_resume done
[  806.438784] ahci_pci_device_resume
[  806.452070] ahci_pci_device_resume done
[  813.890609] ahci_pci_device_resume
[  813.903247] ahci_pci_device_resume done
[  821.265956] ahci_pci_device_resume
[  821.278714] ahci_pci_device_resume done
[  828.609051] ahci_pci_device_resume
[  828.621795] ahci_pci_device_resume done
[  835.731528] ahci_pci_device_resume
[  835.744210] ahci_pci_device_resume done

I don't know if this ssleep(1) is required for some platform specific
problems, but this patch does work well for me. :)
Hmm, we'd better get some comments from Tejun Heo first.

thanks,
rui
> 
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > --
> >  drivers/ata/ahci.c |   17 ++++++++++++++---
> >  1 file changed, 14 insertions(+), 3 deletions(-)
> >
> > Index: linux-2.6/drivers/ata/ahci.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/ata/ahci.c 2007-05-03 11:06:33.000000000
> +0800
> > +++ linux-2.6/drivers/ata/ahci.c      2008-07-02 16:25:54.000000000
> +0800
> > @@ -1073,18 +1073,29 @@
> > 
> >       /* global controller reset */
> >       if (!ahci_skip_host_reset) {
> > +             int delay = msecs_to_jiffies(1000);
> > +             int timeout;
> > +
> >               tmp = readl(mmio + HOST_CTL);
> >               if ((tmp & HOST_RESET) == 0) {
> >                       writel(tmp | HOST_RESET, mmio + HOST_CTL);
> >                       readl(mmio + HOST_CTL); /* flush */
> >               }
> > 
> > -             /* reset must complete within 1 second, or
> > +             /*
> > +              * to perform host reset, OS should set HOST_RESET
> > +              * and poll until this bit is read to be "0"
> > +              * reset must complete within 1 second, or
> >                * the hardware should be considered fried.
> >                */
> > -             ssleep(1);
> > +             timeout = jiffies + delay;
> > +             while (jiffies < timeout) {
> > +                     tmp = readl(mmio + HOST_CTL);
> > +                     if (!(tmp & HOST_RESET))
> > +                             break;
> > +                     cpu_relax();
> > +             }
> > 
> > -             tmp = readl(mmio + HOST_CTL);
> >               if (tmp & HOST_RESET) {
> >                       dev_printk(KERN_ERR, host->dev,
> >                                  "controller reset failed (0x%x)\n",
> tmp);
> >
> >
> >
> >
> 
> 
> 
> --
> "Premature optimization is the root of all evil." - Donald Knuth
> 
> 


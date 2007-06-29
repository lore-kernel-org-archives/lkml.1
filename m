Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbXF2Vvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbXF2Vvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757800AbXF2VuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:50:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60799 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757671AbXF2VuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:50:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Subject: Re: 2.6.22-rc6-mm1 Intel DMAR crash on AMD x86_64
Date: Fri, 29 Jun 2007 23:56:48 +0200
User-Agent: KMail/1.9.5
Cc: "Li, Shaohua" <shaohua.li@intel.com>, Robert Hancock <hancockr@shaw.ca>,
       Zan Lynx <zlynx@acm.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>
References: <46845943.7050005@shaw.ca> <FC1D1B23302A22499C60C967336B2AE0016F7529@pdsmsx411.ccr.corp.intel.com> <20070629152858.GA27995@linux-os.sc.intel.com>
In-Reply-To: <20070629152858.GA27995@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706292356.49825.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 29 June 2007 17:28, Keshavamurthy, Anil S wrote:
> On Thu, Jun 28, 2007 at 06:14:27PM -0700, Li, Shaohua wrote:
> > 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-
> > >rc6/2.6.22-rc6-mm1/
> > >>
> > >>> +intel-iommu-dmar-detection-and-parsing-logic.patch
> [..]
> > >
> > >I took a picture of it, looks like the backtrace is:
> > >
> > >NULL pointer dereference at 024
> > >EIP:dmar_table_init+0x11
> > >intel_iommu_init+0x30
> > >pci_iommu_init+0xe
> > >kernel_init+0x16e
> > >
> > >Presumably something is NULL in dmar_table_init that wasn't expected to
> > >be.. I would guess it likely crashes on any system without an Intel
> > >IOMMU in it.
> Yup, that is correct.
> 
> > How about something like below?
> > 
> > 
> > int __init dmar_table_init(void)
> > {
> > +	if (!dmar_tbl)
> > +		return -ENODEV;
> > 	parse_dmar_table();
> why not check for NULL in the function where it touched?
> Also when there are no DMAR devices we need the below
> printk on the console.
> 
> > 	if (list_empty(&dmar_drhd_units)) {
> > 		printk(KERN_ERR PREFIX "No DMAR devices found\n");
> > 		return -ENODEV;
> > 	}
> > 	return 0;
> > }
> 
> Here is the revised patch of the above.
> Andrew, please add this fix to
> +intel-iommu-dmar-detection-and-parsing-logic.patch
> ------------------------------------------------
> 
> Check for dmar_tbl pointer as this can be NULL on 
> systems with no Intel VT-d support.
> 
> Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

For the record, this patch fixes the boot crash on my AMD64-based test box.

Thanks,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

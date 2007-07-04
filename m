Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbXGDKFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbXGDKFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbXGDKFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:05:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36122 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757266AbXGDKFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:05:06 -0400
Date: Wed, 4 Jul 2007 03:04:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, suresh.b.siddha@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 01/10] DMAR detection and parsing logic
Message-Id: <20070704030440.3f863ecd.akpm@linux-foundation.org>
In-Reply-To: <1183540736.7054.7.camel@twins>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
	<20070619213808.398170000@askeshav-devel.jf.intel.com>
	<1183540736.7054.7.camel@twins>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jul 2007 11:18:56 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2007-06-19 at 14:37 -0700, Keshavamurthy, Anil S wrote:
> > plain text document attachment (dmar_detection.patch)
> 
> > +/**
> > + * parse_dmar_table - parses the DMA reporting table
> > + */
> > +static int __init
> > +parse_dmar_table(void)
> > +{
> > +	struct acpi_table_dmar *dmar;
> > +	struct acpi_dmar_header *entry_header;
> > +	int ret = 0;
> > +
> > +	dmar = (struct acpi_table_dmar *)dmar_tbl;
> > +
> > +	if (!dmar->width) {
>           ^^^^^^^^^^^^^^^^^^^
> 
> That goes *splat* on my opteron box.

This?

From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

Check for dmar_tbl pointer as this can be NULL on systems with no Intel
VT-d support.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/dmar.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/pci/dmar.c~intel-iommu-dmar-detection-and-parsing-logic-fix-intel-dmar-crash-on-amd-x86_64 drivers/pci/dmar.c
--- a/drivers/pci/dmar.c~intel-iommu-dmar-detection-and-parsing-logic-fix-intel-dmar-crash-on-amd-x86_64
+++ a/drivers/pci/dmar.c
@@ -260,6 +260,8 @@ parse_dmar_table(void)
 	int ret = 0;
 
 	dmar = (struct acpi_table_dmar *)dmar_tbl;
+	if (!dmar)
+		return -ENODEV;
 
 	if (!dmar->width) {
 		printk (KERN_WARNING PREFIX "Zero: Invalid DMAR haw\n");
@@ -301,7 +303,7 @@ int __init dmar_table_init(void)
 
 	parse_dmar_table();
 	if (list_empty(&dmar_drhd_units)) {
-		printk(KERN_ERR PREFIX "No DMAR devices found\n");
+		printk(KERN_INFO PREFIX "No DMAR devices found\n");
 		return -ENODEV;
 	}
 	return 0;
_


Return-Path: <linux-kernel-owner+w=401wt.eu-S932918AbYGQVb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918AbYGQVb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760598AbYGQVbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:31:17 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:49102 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757762AbYGQVbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:31:15 -0400
Subject: Re: acpi based pci gap calculation  - v3
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Brown, Len" <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       TJ <linux@tjworld.net>
In-Reply-To: <200807161703.11572.jbarnes@virtuousgeek.org>
References: <1216148382.6135.21.camel@alok-dev1>
	 <200807160906.43632.jbarnes@virtuousgeek.org>
	 <487E22EA.8030005@linux.intel.com>
	 <200807161703.11572.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 17 Jul 2008 14:31:12 -0700
Message-Id: <1216330272.32324.26.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

On Wed, 2008-07-16 at 17:03 -0700, Jesse Barnes wrote:
> On Wednesday, July 16, 2008 9:33 am Andi Kleen wrote:
> > > The only problem there is that linux-next doesn't get nearly the sort of
> > > testing coverage we need for this kind of change.
> >
> > Normally I tend to wait for one -mm release, which seems to be tested
> > by a reasonable number of people. If it survives that it is good
> > to be tested in Linus' tree.
> >
> > Just stuffing this in in literally the last minute doesn't seem
> > like a good idea.
> 
> Well it's hardly last minute given that the merge window only opened a couple
> of days ago...
> 
> But beyond that, now that I've thought about it a bit more I'm not even sure
> the patch is really correct (though it works on my test machines).  Shouldn't
> we be looking at _PRS not _CRS? 

IMO, the current resource allocations will give us a better idea of
which region is free.
Besides, from what i read PRS is optional and not all BIOS's may export
that.

>  And ideally we should try to find even more
> space, not less.  This patch made one of my machines lose quite a bit of
> space:
> 
> ...
> Allocating PCI resources starting at c0000000 (gap: bf000000:40f00000)
> ...
> ACPI: PCI resources should start at c0000000 (gap: bf000000:31000000)
> ...
> 

Yep, we should try to find more space but we should also make sure that
this space doesn't clash with any other resource.
As explained in my first mail while posting v1 of these patches, the
kernel ignores the memory hotplug range while calculating this gap for
PCI, and consequently these regions collide. 
With this patch we have put some constraints like looking only in the
producer regions rather than all regions which are right now not
reserved/used by the e820 map.

However, looking back again i think we can improve this further in some
cases.
I have made some more changes in the e820_search_gap algorithm to find
the *biggest* un-utilized gap in the 32bit address range, and have added
some debug print messages.
Can you please try this patch on your system and mail me your full
dmesg.

Thanks,
Alok

---

 arch/x86/kernel/e820.c |   19 +++++++++++++++++++
 arch/x86/pci/acpi.c    |    4 ++++
 2 files changed, 23 insertions(+), 0 deletions(-)


diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index a5383ae..298aeec 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -539,6 +539,8 @@ __init int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
 
 	last = (end_addr && end_addr < MAX_GAP_END) ? end_addr : MAX_GAP_END;
 
+	printk("E820_DEBUG: Searching for gap between (0x%08lx - 0x%08llx)\n",
+							 start_addr, end_addr);
 	while (--i >= 0) {
 		unsigned long long start = e820.map[i].addr;
 		unsigned long long end = start + e820.map[i].size;
@@ -556,9 +558,26 @@ __init int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
 			if (gap >= *gapsize) {
 				*gapsize = gap;
 				*gapstart = end;
+				printk("E820_DEBUG: Found gap starting at "
+					"0x%08llx size 0x%08llx\n", end, gap);
 				found = 1;
 			}
 		}
+		if (start > start_addr) {
+			unsigned long gap, prev_end;
+			prev_end = e820.map[i-1].addr + e820.map[i-1].size;
+			if (start_addr > prev_end) {
+				gap = start - start_addr;
+				if (gap >=*gapsize) {
+					*gapsize = gap;
+                                *gapstart = start_addr;
+                                printk("E820_DEBUG: Found gap at start starting at "
+                                        "0x%08llx size 0x%08llx\n", end, gap);
+                                found = 1;
+				start = start_addr;
+                        	}
+			}
+		}
 		if (start < last)
 			last = start;
 	}
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index fff2c42..1a88149 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -131,8 +131,12 @@ static acpi_status search_gap(struct acpi_resource *resource, void *data)
 		/*
 		 * We want space only in the 32bit address range
 		 */
+		printk("ACPI_DEBUG start_addr 0x%08lx gapsize 0x%08lx "
+			"address_length 0x%08lx\n", start_addr, gap->gapsize,
+			addr.address_length);
 		if (start_addr < UINT_MAX) {
 			end_addr = start_addr + addr.address_length;
+			printk("\t\tend_addr is 0x%08lx\n", end_addr);
 			e820_search_gap(&gap->gapstart, &gap->gapsize,
 					start_addr, end_addr);
 		}



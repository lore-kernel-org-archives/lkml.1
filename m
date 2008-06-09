Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYFIUZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYFIUZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYFIUZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:25:10 -0400
Received: from usea-naimss1.unisys.com ([192.61.61.103]:2817 "EHLO
	usea-naimss1.unisys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYFIUZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:25:08 -0400
X-Greylist: delayed 1803 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2008 16:25:08 EDT
Subject: Re: [patch 2/3] Add flags parameter to reserve_bootmem_generic()
From: Amul Shah <amul.shah@unisys.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Bernhard Walle <bwalle@suse.de>, Vivek Goyal <vgoyal@redhat.com>,
       Johannes Weiner <hannes@saeurebad.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, anderson@redhat.com,
       "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
In-Reply-To: <484D5CCB.5020709@firstfloor.org>
References: <20080608134628.757299158@halley.suse.de>
	 <20080608134629.743220 278@halley.suse.de>	<87bq2bmvro.fsf@saeurebad.de>
	 <20080609132207.GC3542@re dhat.com>
	 <20080609182341.00d6e746@halley.suse.de>  <484D5CCB.5020709@firstfloor.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 09 Jun 2008 15:50:41 -0400
Message-Id: <1213041041.19111.68.camel@ustr-shaha1-linux-dev.na.uis.unisys.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 09 Jun 2008 19:50:32.0869 (UTC) FILETIME=[13DD8D50:01C8CA6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-09 at 18:39 +0200, Andi Kleen wrote:
> Bernhard Walle wrote:
> > * Vivek Goyal [2008-06-09 09:22]:
> >> Kdump first kernel always tries to reserve just physical RAM and nothing
> >> else. So I am not sure what does above code do. Try to reserve a memory
> >> which is not RAM but is in the region less than highest mapped entity and
> >> in that case return silently without any warning. In what case do we
> >> exercise this path?
> > 
> > I don't know. That code has been introduced in 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5e58a02a8f6a7a1c9ae41f39286bcd3aea0d6f24
> > 
> > Ccing Andi.
> > 
> > IMO we should not print any warning in that function, leaving the error
> > handling to the caller.
> 
> Don't remember the details. Perhaps Amul does (cc'ed)
> 
> -Andi
> 

The short story is that the kexec kernel was panicking when trying to
reserve the MP tables.  The panic occurs because the MP tables resided
in a reserved memory area above the highest address (80MB phys at that
time) in the user defined E820 map used by the kexec kernel.

I had placed my code to affect only MP table reservation (see patch
below) because it is unique to just that code path.  Andi decided a
generalized approach would be better in case other vendors had similar
issues.

Vivek asked if I was using a user defined memory map for the kexec
kernel.  I was using one, but the top of memory was being defined as
80MB physical (end_pfn).  The "exactmap" option parsing is clobbering
the variable end_pfn_map.  I suggested using the saved_pfn_map variable.

In the end Andi's patch was the best, so it stuck.

I took a quick look at the current code base and it would still panic
when reserving the MP table.  The function smp_scan_config does the
reservation.  I did not track down how the BUG_ON in
reserve_bootmem_core corresponds to end_pfn.

thanks,
Amul

Here is my original email (http://lkml.org/lkml/2006/11/2/285):

The kdump crash kernel panics when it tries to reserve the MP Config
tables on an ES7000.

The MP Config table is located above 1MB of physical memory in a
reserved memory area.  It is located outside the first 1MB area because
the tables are too large, 240k.

The crash kernel is given a user defined memory map with E820 reserved
and ACPI areas passed in by kexec tools and a usable area from 16MB
physical to 80MB physical.  This user defined map causes the top of
memory to be set as 80MB.

The ACPI tables and MP Tables reside higher in memory.  When reserving
memory with reserve_bootmem_generic, the function has a BUG panic if the
memory location to reserve is above the top of memory.  The MP table is
above the top of memory in a user defined memory map.

This patch will ignore reserving the MP tables if the MP table resides
in an area already reserved in the E820.

I have two alternate patches that accomplish the same effect if this
patch is not acceptable.
1. avoid reserving the MP tables if a user defined memory map or if a
user defined memory limit ("mem=") is used.
2. avoid reserving the MP tables if a kernel parameter is passed in to
ignore MP table reservation.

diff -Naur linux-2.6.19-rc4/arch/x86_64/kernel/e820.c linux-2.6.19-rc4-az/arch/x86_64/kernel/e820.c
--- linux-2.6.19-rc4/arch/x86_64/kernel/e820.c  2006-10-31 17:38:41.000000000 -0500
+++ linux-2.6.19-rc4-az/arch/x86_64/kernel/e820.c       2006-11-02 17:56:01.000000000 -0500
@@ -351,6 +351,53 @@
        }
 }
 
+int __init e820_reserved(unsigned long target_phys)
+{
+       int i;
+       unsigned long section_begin_phys, section_end_phys;
+
+       for (i = 0; i < e820.nr_map; i++) {
+               // if it is usable memory, ignore it
+               if (e820.map[i].type == E820_RAM )
+                       continue;
+
+               section_begin_phys = e820.map[i].addr;
+               section_end_phys = e820.map[i].addr + e820.map[i].size;
+
+               // if its NOT within the memory range, ignore it
+               if (!(section_begin_phys < target_phys &&
+                     target_phys < section_end_phys))
+                       continue;
+
+               printk(KERN_DEBUG "MP Tables at %lx in %016lx - %016lx",
+                      target_phys, section_begin_phys, section_end_phys);
+               
+               switch (e820.map[i].type) {
+               case E820_RESERVED:
+                       printk(KERN_DEBUG "(reserved)\n");
+                       break;
+               case E820_ACPI:
+                       printk(KERN_DEBUG "(ACPI data)\n");
+                       printk(KERN_DEBUG "WARNING: MP Tables located in");
+                       printk(KERN_DEBUG "ACPI Data Area\n");
+                       break;
+               case E820_NVS:
+                       printk(KERN_DEBUG "(ACPI NVS)\n");
+                       printk(KERN_DEBUG "WARNING: MP Tables located in");
+                       printk(KERN_DEBUG "ACPI NVS Area\n");
+                       break;
+               default:        
+                       printk(KERN_DEBUG "(type %u)\n", e820.map[i].type);
+                       printk(KERN_ERR "WARNING: MP Tables located in");
+                       printk(KERN_ERR "Unkown Memory Area!\n");
+                       printk(KERN_ERR "Reservations are disallowed.\n");
+                       return 0;
+               }
+               return 1;
+       }
+       return 0;
+}
+
 /*
  * Sanitize the BIOS e820 map.
  *
diff -Naur linux-2.6.19-rc4/arch/x86_64/kernel/mpparse.c linux-2.6.19-rc4-az/arch/x86_64/kernel/mpparse.c
--- linux-2.6.19-rc4/arch/x86_64/kernel/mpparse.c       2006-10-31 17:38:41.000000000 -0500
+++ linux-2.6.19-rc4-az/arch/x86_64/kernel/mpparse.c    2006-11-02 17:25:10.000000000 -0500
@@ -23,6 +23,7 @@
 #include <linux/acpi.h>
 #include <linux/module.h>
 
+#include <asm/e820.h>
 #include <asm/smp.h>
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
@@ -543,7 +544,7 @@
 
                        smp_found_config = 1;
                        reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE);
-                       if (mpf->mpf_physptr)
+                       if (mpf->mpf_physptr && e820_reserved(mpf->mpf_physptr))
                                reserve_bootmem_generic(mpf->mpf_physptr, PAGE_SIZE);
                        mpf_found = mpf;
                        return 1;
diff -Naur linux-2.6.19-rc4/include/asm-x86_64/e820.h linux-2.6.19-rc4-az/include/asm-x86_64/e820.h
--- linux-2.6.19-rc4/include/asm-x86_64/e820.h  2006-10-31 17:39:24.000000000 -0500
+++ linux-2.6.19-rc4-az/include/asm-x86_64/e820.h       2006-11-02 17:25:10.000000000 -0500
@@ -44,6 +44,7 @@
 extern void e820_reserve_resources(void);
 extern void e820_mark_nosave_regions(void);
 extern void e820_print_map(char *who);
+extern int e820_reserved(unsigned long target_phys);
 extern int e820_any_mapped(unsigned long start, unsigned long end, unsigned type);
 extern int e820_all_mapped(unsigned long start, unsigned long end, unsigned type);
 



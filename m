Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbYFYSEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbYFYSEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 14:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYFYSEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 14:04:35 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:35421 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124AbYFYSEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 14:04:34 -0400
Subject: Re: [PATCH 1/2] cleanup e820_setup_gap v2
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: "lenb@kernel.org" <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>
In-Reply-To: <20080625160817.GC24967@elte.hu>
References: <1214333310.27577.26.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080625160817.GC24967@elte.hu>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 25 Jun 2008 11:02:42 -0700
Message-Id: <1214416962.27577.74.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-25 at 09:08 -0700, Ingo Molnar wrote:
> * Alok Kataria <akataria@vmware.com> wrote:
> 
> > This is a preparatory patch for the next patch in series.
> > Moves some code from e820_setup_gap to a new function e820_search_gap.
> > This patch is a part of a bug fix where we walk the ACPI table to calculate
> > a gap for PCI optional devices.
> >
> > v1->v2: Patch on top of tip/master.
> >       Fixes a bug introduced in the last patch about the typeof "last".
> >       Also the new function e820_search_gap now returns if we found a gap in
> >       e820_map.
> 
> applied to tip/x86/setup-memory - thanks Alok.

Hi Ingo,

As mentioned in this mail,
http://marc.info/?l=linux-kernel&m=121441312409978&w=2

I have also added a end_addr parameter to e820_search_gap to search only
till the CRS objects end_addr instead of 2^32. In the normal case via
e820_setup_gap we search till 2^32.

Please apply this too.
Patch on top of tip/master
--

e820_search_gap also take a end_addr parameter to limit search from
start_addr to end_addr.

Signed-off-by: AloK N Kataria <akataria@vmware.com>

Index: linux-x86-tree.git/arch/x86/kernel/e820.c
===================================================================
--- linux-x86-tree.git.orig/arch/x86/kernel/e820.c	2008-06-25 10:05:21.000000000 -0700
+++ linux-x86-tree.git/arch/x86/kernel/e820.c	2008-06-25 10:07:30.000000000 -0700
@@ -486,17 +486,19 @@
 	printk(KERN_INFO "modified physical RAM map:\n");
 	e820_print_map("modified");
 }
-
+#define MAX_GAP_END 0x100000000ull
 /*
- * Search for a gap in the e820 memory space from start_addr to 2^32.
+ * Search for a gap in the e820 memory space from start_addr to end_addr.
  */
 __init int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
-		unsigned long start_addr)
+		unsigned long start_addr, unsigned long long end_addr)
 {
-	unsigned long long last = 0x100000000ull;
+	unsigned long long last;
 	int i = e820.nr_map;
 	int found = 0;
 
+	last = (end_addr && end_addr < MAX_GAP_END) ? end_addr : MAX_GAP_END;
+
 	while (--i >= 0) {
 		unsigned long long start = e820.map[i].addr;
 		unsigned long long end = start + e820.map[i].size;
@@ -536,7 +538,7 @@
 
 	gapstart = 0x10000000;
 	gapsize = 0x400000;
-	found  = e820_search_gap(&gapstart, &gapsize, 0);
+	found  = e820_search_gap(&gapstart, &gapsize, 0, MAX_GAP_END);
 
 #ifdef CONFIG_X86_64
 	if (!found) {
Index: linux-x86-tree.git/include/asm-x86/e820.h
===================================================================
--- linux-x86-tree.git.orig/include/asm-x86/e820.h	2008-06-25 10:05:21.000000000 -0700
+++ linux-x86-tree.git/include/asm-x86/e820.h	2008-06-25 10:06:17.000000000 -0700
@@ -72,7 +72,7 @@
 extern void update_e820(void);
 extern void e820_setup_gap(void);
 extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
-				unsigned long start_addr);
+			unsigned long start_addr, unsigned long long end_addr);
 struct setup_data;
 extern void parse_e820_ext(struct setup_data *data, unsigned long pa_data);
 




Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbXJaGLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbXJaGLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbXJaGLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:11:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:39589 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbXJaGLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:11:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,350,1188802800"; 
   d="scan'208";a="192116422"
Subject: Re: 2.6.23 boot failures on x86-64.
From: Zou Nan hai <nanhai.zou@intel.com>
To: Martin Ebourne <martin@zepler.org>
Cc: Dave Jones <davej@redhat.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1193692862.3133.14.camel@avenin.ebourne.me.uk>
References: <20071029175014.GH7793@redhat.com>
	 <200710291918.43869.ak@suse.de> <20071029184747.GB1650@redhat.com>
	 <200710292003.09317.ak@suse.de>  <20071029194311.GE1650@redhat.com>
	 <1193692862.3133.14.camel@avenin.ebourne.me.uk>
Content-Type: text/plain
Organization: 
Message-Id: <1193810651.817.14.camel@linux-znh>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 (1.2.2-4) 
Date: 31 Oct 2007 14:04:12 +0800
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 05:21, Martin Ebourne wrote:
> On Mon, 2007-10-29 at 15:43 -0400, Dave Jones wrote:
> > On Mon, Oct 29, 2007 at 08:03:09PM +0100, Andi Kleen wrote:
> >  > >  > But if allocating bootmem >4G doesn't work on these systems
> >  > >  > most likely they have more problems anyways. It might be better
> >  > >  > to find out what goes wrong exactly.
> >  > > Any ideas on what to instrument ?
> >  > 
> >  > See what address the bootmem_alloc_high returns; check if it overlaps
> >  > with something etc.
> >  > 
> >  > Fill the memory on the system and see if it can access all of its memory.
> > 
> > Martin, as you have one of the affected systems, do you feel up to this?
> 
> Faking a node at 0000000000000000-000000001fff0000
> Bootmem setup node 0 0000000000000000-000000001fff0000
> sparse_early_mem_map_alloc: returned address ffff81000070b000
> 
> My box has 512MB of RAM.
> 
> Cheers,
> 
> Martin.

Oops, sorry,
seem to be a mistake of me.
I forget to exclude the DMA range.

Does the following patch fix the issue?

Thanks
Zou Nan hai

--- a/arch/x86/mm/init_64.c	2007-10-31 11:24:11.000000000 +0800
+++ b/arch/x86/mm/init_64.c	2007-10-31 12:31:02.000000000 +0800
@@ -731,7 +731,7 @@ int in_gate_area_no_task(unsigned long a
 void * __init alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
 {
 	return __alloc_bootmem_core(pgdat->bdata, size,
-			SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
+			SMP_CACHE_BYTES, (4UL*1024*1024*1024), __pa(MAX_DMA_ADDRESS));
 }
 
 const char *arch_vma_name(struct vm_area_struct *vma)



 

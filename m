Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZBLFXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZBLFXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 00:23:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbZBLFWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 00:22:52 -0500
Received: from mga10.intel.com ([192.55.52.92]:63638 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750785AbZBLFWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 00:22:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,195,1233561600"; 
   d="scan'208";a="430331057"
Subject: Re: Mainline kernel OLTP performance update
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, matthew.r.wilcox@intel.com,
       chinang.ma@intel.com, linux-kernel@vger.kernel.org,
       sharad.c.tripathi@intel.com, arjan@linux.intel.com,
       suresh.b.siddha@intel.com, harita.chilukuri@intel.com,
       douglas.w.styner@intel.com, peter.xihong.wang@intel.com,
       hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com,
       linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com,
       anirban.chakraborty@qlogic.com, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <84144f020901232336v71687223y2fb21ee081c7517f@mail.gmail.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <1232616517.11429.129.camel@ymzhang>
	 <1232617672.14549.25.camel@penberg-laptop>
	 <1232679773.11429.155.camel@ymzhang> <4979692B.3050703@cs.helsinki.fi>
	 <1232697998.6094.17.camel@penberg-laptop>
	 <1232699401.11429.163.camel@ymzhang>
	 <1232703989.6094.29.camel@penberg-laptop>
	 <alpine.DEB.1.10.0901231020030.21692@qirst.com>
	 <1232765728.11429.193.camel@ymzhang>
	 <84144f020901232336v71687223y2fb21ee081c7517f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 12 Feb 2009 13:22:33 +0800
Message-Id: <1234416153.2604.387.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-24 at 09:36 +0200, Pekka Enberg wrote:
> On Fri, 2009-01-23 at 10:22 -0500, Christoph Lameter wrote:
> >> No there is another way. Increase the allocator order to 3 for the
> >> kmalloc-8192 slab then multiple 8k blocks can be allocated from one of the
> >> larger chunks of data gotten from the page allocator. That will allow slub
> >> to do fast allocs.
> 
> On Sat, Jan 24, 2009 at 4:55 AM, Zhang, Yanmin
> <yanmin_zhang@linux.intel.com> wrote:
> > After I change kmalloc-8192/order to 3, the result(pinned netperf UDP-U-4k)
> > difference between SLUB and SLQB becomes 1% which can be considered as fluctuation.
> 
> Great. We should fix calculate_order() to be order 3 for kmalloc-8192.
> Are you interested in doing that?
Pekka,

Sorry for the late update.
The default order of ﻿kmalloc-8192 on 2*4 stoakley is really an issue of calculate_order.


slab_size	order		name
-------------------------------------------------
4096            3               sgpool-128
8192            2               kmalloc-8192
16384           3               kmalloc-16384

﻿kmalloc-8192's default order is smaller than ﻿sgpool-128's.

On 4*4 tigerton machine, a similiar issue appears on another kmem_cache.

Function ﻿calculate_order uses 'min_objects /= 2;' to shrink. Plus size calculation/checking
in slab_order, sometimes above issue appear.

Below patch against 2.6.29-rc2 fixes it.

I checked the default orders of all kmem_cache and they don't become smaller than before. So
the patch wouldn't hurt performance.

﻿Signed-off-by Zhang Yanmin <yanmin.zhang@linux.intel.com>

---

diff -Nraup linux-2.6.29-rc2/mm/slub.c linux-2.6.29-rc2_slubcalc_order/mm/slub.c
--- linux-2.6.29-rc2/mm/slub.c	2009-02-11 00:49:48.000000000 -0500
+++ linux-2.6.29-rc2_slubcalc_order/mm/slub.c	2009-02-12 00:08:24.000000000 -0500
@@ -1856,6 +1856,7 @@ static inline int calculate_order(int si
 	min_objects = slub_min_objects;
 	if (!min_objects)
 		min_objects = 4 * (fls(nr_cpu_ids) + 1);
+	min_objects = min(min_objects, (PAGE_SIZE << slub_max_order)/size);
 	while (min_objects > 1) {
 		fraction = 16;
 		while (fraction >= 4) {
@@ -1865,7 +1866,7 @@ static inline int calculate_order(int si
 				return order;
 			fraction /= 2;
 		}
-		min_objects /= 2;
+		min_objects --;
 	}
 
 	/*



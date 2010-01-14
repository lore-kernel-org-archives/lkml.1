Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473Ab0ANIPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab0ANIPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 03:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756257Ab0ANIPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 03:15:06 -0500
Received: from mga14.intel.com ([143.182.124.37]:60518 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab0ANIPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 03:15:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="232610208"
Date: Thu, 14 Jan 2010 16:06:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.33 pagemap endless read loop
Message-ID: <20100114080600.GA4739@localhost>
References: <20100110020955.GB25323@basil.fritz.box> <20100113141648.42eff724.akpm@linux-foundation.org> <1263421562.29868.5000.camel@calx> <20100113143055.7bea30c5.akpm@linux-foundation.org> <1263423916.29868.5009.camel@calx> <20100113151502.fa425247.akpm@linux-foundation.org> <20100114055319.GA17671@localhost> <20100113221013.b1beecb4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113221013.b1beecb4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 02:10:13PM +0800, Andrew Morton wrote:
> On Thu, 14 Jan 2010 13:53:19 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > On Thu, Jan 14, 2010 at 07:15:02AM +0800, Andrew Morton wrote:

> > @@ -740,6 +740,11 @@ static ssize_t pagemap_read(struct file 
> >  	if (!ptrace_may_access(task, PTRACE_MODE_READ))
> >  		goto out_task;
> >  
> > +	/* stop dumb cp/cat */
> > +	ret = -EFAULT;
> > +	if (!*ppos)
> > +		goto out_task;
> > +
> >  	ret = -EINVAL;
> >  	/* file position must be aligned */
> >  	if ((*ppos % PM_ENTRY_BYTES) || (count % PM_ENTRY_BYTES))
> 
> Seems simple.  But is there a usecase for reading at that offset? 
> I think it's possible to map a page at 0 with MAP_FIXED.  I forget..

How about this trick?
Tests show that cp/cat will exit if read nothing :)

---
pagemap: early return on unmapped areas

This helps stop dumb cp/cat early instead of loop for days:

http://bugzilla.kernel.org/show_bug.cgi?id=15041

This also serves as an optimization to normal pagemap users (eg.
page-types).

CC: Andi Kleen <andi@firstfloor.org> 
CC: Matt Mackall <mpm@selenic.com>
CC: <stable@kernel.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/proc/task_mmu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-mm.orig/fs/proc/task_mmu.c	2010-01-14 13:38:44.000000000 +0800
+++ linux-mm/fs/proc/task_mmu.c	2010-01-14 15:54:28.000000000 +0800
@@ -586,6 +586,10 @@ static int pagemap_pte_hole(unsigned lon
 	struct pagemapread *pm = walk->private;
 	unsigned long addr;
 	int err = 0;
+
+	if ((end - start) / PAGE_SIZE > pm->end - pm->out)
+		return PM_END_OF_BUFFER;
+
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		err = add_to_pagemap(addr, PM_NOT_PRESENT, pm);
 		if (err)

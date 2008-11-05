Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbYKEI5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbYKEI5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 03:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYKEI5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 03:57:13 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34582 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYKEI5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 03:57:12 -0500
Date: Wed, 5 Nov 2008 10:57:11 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Christoph Lameter <cl@linux-foundation.org>, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hannes@saeurebad.de
Subject: Re: Broken "cpualloc: the allocator" patch
In-Reply-To: <20081105084254.GA3429@x200.localdomain>
Message-ID: <Pine.LNX.4.64.0811051054430.22835@melkki.cs.Helsinki.FI>
References: <20081104034237.GA15227@x200.localdomain>
 <Pine.LNX.4.64.0811040934180.12886@quilx.com> <20081105084254.GA3429@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On Tue, Nov 04, 2008 at 09:38:40AM -0600, Christoph Lameter wrote:
> > Works fine here.
> >
> > Do we have the right tree? I repulled my tree on top of Linuses and 
> > things work just fine. Tree is at
> >
> > kernel.org/pub/scm/linux/kernel/git/christoph/work.git cpu_alloc

On Wed, 5 Nov 2008, Alexey Dobriyan wrote:
> Same thing. For reference f622b9e43c8ba1902d4423bef9ae9d89b0254b45 aka
> "cpualloc: the allocator".
> 
> It's BUG_ON(!size) at mm/bootmem.c:438. At cpu_alloc_init():
> 
> __per_cpu_start = ff...80555000
> __per_cpu_end   = ff...8055d3e0
> UNIT_SIZE = 4
> base_percpu_in_units = 8440
> PERCPU_AREA_SIZE = 33760
> nr_units = 0 (bang!)
> 
> MODULES are off.

Yup, makes sense. PERCPU_MODULE_RESERVE is set to zero if !CONFIG_MODULES. 
Is there a reason we don't do something like this in bootmem allocator? 
Hannes?
		Pekka

diff --git a/mm/bootmem.c b/mm/bootmem.c
index ac5a891..ee6431f 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -435,7 +435,9 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 	unsigned long fallback = 0;
 	unsigned long min, max, start, sidx, midx, step;
 
-	BUG_ON(!size);
+	if (!size)
+		return NULL;
+
 	BUG_ON(align & (align - 1));
 	BUG_ON(limit && goal + size > limit);
 

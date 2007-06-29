Return-Path: <linux-kernel-owner+w=401wt.eu-S1765612AbXF2Guj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765612AbXF2Guj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 02:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbXF2Gua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 02:50:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46268 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750732AbXF2Gu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 02:50:29 -0400
Date: Thu, 28 Jun 2007 23:50:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, hugh@veritas.com, James.Bottomley@steeleye.com,
       rmk+lkml@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter gather
 lists
In-Reply-To: <20070628.223734.21928089.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0706282346560.12146@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com>
 <20070628.220606.112621271.davem@davemloft.net> <20070628222424.4cbae90c.akpm@linux-foundation.org>
 <20070628.223734.21928089.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, David Miller wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Thu, 28 Jun 2007 22:24:24 -0700
> 
> > So what happens when two quite different threads of control are doing
> > IO against two hunks of kmalloced memory which happen to come from the same
> > page?  Either some (kernel-wide) locking is needed, or that pageframe needs
> > to be treated as readonly?
> 
> Or you put an atomic_t at the beginning or tail of every SLAB
> object.  It's a space cost not a runtime cost for the common
> case which is:

Hmmm... We could do something like

kmem_cache_get(slab, object)

and

kmem_cache_put(slab, object)

kmem_cache_get would disable allocations from the slab and increment a 
refcount.

kmem_cache_put would enable allocations again if the refcount reaches 
one.

The problem is that freeing an object may cause writes to the object. F.e.
poisoning will overwrite the object on free. SLUB will put its free 
pointer in the first words etc.




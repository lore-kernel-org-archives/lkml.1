Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbZAEQat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbZAEQat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZAEQaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:30:39 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:53831 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZAEQaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:30:39 -0500
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Chandru <chandru@in.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <200901051919.52327.chandru@in.ibm.com>
References: <200812241325.49404.chandru@in.ibm.com>
	 <18772.11376.339295.42622@cargo.ozlabs.ibm.com>
	 <1230586567.19452.100.camel@nimitz> <200901051919.52327.chandru@in.ibm.com>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 08:30:33 -0800
Message-Id: <1231173033.19452.190.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 19:19 +0530, Chandru wrote:
> On Tuesday 30 December 2008 03:06:07 Dave Hansen wrote:
> When booted with crashkernel=224M@32M or any memory size less than
> this, the system boots properly. The system comes up with two nodes
> (0-256M and 256M-4GB). The crashkernel memory reservation spans across
> these two nodes. The mark_reserved_regions_for_nid() in
> arch/powerpc/numa.c resizes the reserved part of the memory within it
> as... 
> 
> 	 if (end_pfn > node_ar.end_pfn)
> 		reserve_size = (node_ar.end_pfn << PAGE_SHIFT)
> 				- (start_pfn << PAGE_SHIFT);
> 
> but the reserve_bootmem_node() in mm/bootmem.c raises the pfn value of
> end
> 
> 	end = PFN_UP(physaddr + size);
> 
> This causes end to get a value past the last page in the 0-256M node.
> The following change restricts the value of end if it exceeds the last
> pfn in a given node.

OK, I had to think about this for a good, long time.  That's bad. :)

There are two things that we're dealing with here: "active regions" and
the NODE_DATA's.  The if() you've pasted above resizes the reservation
so that it fits into the current active region.  However, as you noted,
we haven't resized it so that it fits into the NODE_DATA() that we're
looking at.  We call into the bootmem code, and BUG_ON().

The thing I don't like about this is that it might hide bugs in other
callers.  This really is a ppc-specific thing and, although what you
wrote will fix the bug on ppc, it will probably cause someone in the
future to call reserve_bootmem_node() with too large a reservation and
get a silent failure (not reserving the requested size) back.  

We really do need to go take a hard look at the whole interaction
between lmb's, node active regions, and the NUMA code some day.  It has
kinda grown to be a bit ungainly.

How about we just consult the NODE_DATA() in
mark_reserved_regions_for_nid() instead of reserve_bootmem_node()?

> --- linux-2.6.28/mm/bootmem.c.orig	2009-01-05 20:42:12.000000000 +0530
> +++ linux-2.6.28/mm/bootmem.c	2009-01-05 20:43:53.000000000 +0530
> @@ -375,10 +375,14 @@ int __init reserve_bootmem_node(pg_data_
>  				 unsigned long size, int flags)
>  {
>  	unsigned long start, end;
> +	bootmem_data_t *bdata = pgdat->bdata;
> 
>  	start = PFN_DOWN(physaddr);
>  	end = PFN_UP(physaddr + size);
> 
> +	if (end > bdata->node_low_pfn)
> +		end = bdata->node_low_pfn;
> +
>  	return mark_bootmem_node(pgdat->bdata, start, end, 1, flags);
>  }
-- Dave


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZAENuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZAENuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZAENt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:49:58 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:47146 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbZAENt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:49:58 -0500
From: Chandru <chandru@in.ibm.com>
Organization: ibm
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
Date: Mon, 5 Jan 2009 19:19:52 +0530
User-Agent: KMail/1.9.10
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <200812241325.49404.chandru@in.ibm.com> <18772.11376.339295.42622@cargo.ozlabs.ibm.com> <1230586567.19452.100.camel@nimitz>
In-Reply-To: <1230586567.19452.100.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051919.52327.chandru@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 December 2008 03:06:07 Dave Hansen wrote:
> On Fri, 2008-12-26 at 11:59 +1100, Paul Mackerras wrote:
> > > +     }
> > > +
> > > +     for_each_online_node(nid) {
> > >               /*
> > > -              * Be very careful about moving this around.  Future
> > > -              * calls to careful_allocation() depend on this getting
> > > -              * done correctly.
> > > +              * Be very careful about moving this around.
> > >                */
> > >               mark_reserved_regions_for_nid(nid);
> > >               sparse_memory_present_with_active_regions(nid);
>
> I think this reintroduces one of the bugs that I squashed.  You *have*
> to call mark_reserved_regions_for_nid() right after you do
> free_bootmem_with_active_regions().  Otherwise, someone else can
> bootmem_alloc() a reserved region from that node.

Thanks for the review comments Dave. With the commit:a4c74ddd5ea3db53fc73d29c222b22656a7d05be, I see this has been taken care in mark_reserved_regions_for_nid(). In that case we may only need the change made in reserve_bootmem_node(). 

Hello Andrew, 
Could you please consider the following patch instead of the original patch in this thread. 
Thanks, 


When booted with crashkernel=224M@32M or any memory size less than this, the system boots properly. The system comes up with two nodes (0-256M and 256M-4GB). The crashkernel memory reservation spans across these two nodes. The mark_reserved_regions_for_nid() in arch/powerpc/numa.c resizes the reserved part of the memory within it as... 

	 if (end_pfn > node_ar.end_pfn)
		reserve_size = (node_ar.end_pfn << PAGE_SHIFT)
				- (start_pfn << PAGE_SHIFT);

but the reserve_bootmem_node() in mm/bootmem.c raises the pfn value of end

	end = PFN_UP(physaddr + size);

This causes end to get a value past the last page in the 0-256M node. The following change restricts the value of end if it exceeds the last pfn in a given node.

Signed-off-by: Chandru S <chandru@linux.vnet.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
---

 mm/bootmem.c |    4 ++++
 1 file changed, 4 insertions(+)


--- linux-2.6.28/mm/bootmem.c.orig	2009-01-05 20:42:12.000000000 +0530
+++ linux-2.6.28/mm/bootmem.c	2009-01-05 20:43:53.000000000 +0530
@@ -375,10 +375,14 @@ int __init reserve_bootmem_node(pg_data_
 				 unsigned long size, int flags)
 {
 	unsigned long start, end;
+	bootmem_data_t *bdata = pgdat->bdata;
 
 	start = PFN_DOWN(physaddr);
 	end = PFN_UP(physaddr + size);
 
+	if (end > bdata->node_low_pfn)
+		end = bdata->node_low_pfn;
+
 	return mark_bootmem_node(pgdat->bdata, start, end, 1, flags);
 }
 

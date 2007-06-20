Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbXFTSPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbXFTSPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXFTSPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:15:15 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:54209 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbXFTSPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:15:13 -0400
Date: Wed, 20 Jun 2007 14:14:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@redhat.com,
       mbligh@google.com
Subject: Re: Problem with global_flush_tlb() on i386 (x86_64? too) in 2.6.22-rc4-mm2
Message-ID: <20070620181433.GA16050@Krystal>
References: <20070619170914.GA30623@Krystal> <200706201101.20673.ak@suse.de> <20070620164614.GA8916@Krystal> <200706201953.54322.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200706201953.54322.ak@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:10:04 up 23 days,  2:48,  4 users,  load average: 0.10, 0.47, 0.59
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@suse.de) wrote:
> On Wednesday 20 June 2007 18:46, Mathieu Desnoyers wrote:
> > * Andi Kleen (ak@suse.de) wrote:
> > > On Tuesday 19 June 2007 22:01:36 Mathieu Desnoyers wrote:
> > > > Looking more closely into the code to find the cause of the
> > > > change_page_addr()/global_flush_tlb() inconsistency, I see where the
> > > > problem could be:
> > >
> > > Yes it's a known problem. I have a hack queued for .22 and there
> > > are proposed patches for .23 too.
> > >
> > > ftp://ftp.firstfloor.org/pub/ak/x86_64/late-merge/patches/cpa-flush
> > >
> > > -ANdi
> >
> > Hi Andi,
> >
> > Although I cannot find it at the specified URL, I suspect it is already
> > in Andrew's tree, in 2.6.22-rc4-mm2, under the name
> 
> Try again
> 
> > "x86_64-mm-cpa-cache-flush.patch"
> 
> No, that's a different patch with also at least one known bug.
> 
> -Andi

Yeah, I guess disabling clflush and calling wbinvd and a full TLB flush
on every CPU is the safe way to go.

However, digging in your previous patch (in Andrew's tree), I think I
found a potential cause for the problem:

__change_page_attr does a list_add of &kpte_page->lru. If I am not
mistaken, there can be more than one consecutive struct page *page
having their PTE in the same kpte_page. Therefore, it would generate
many list_add of the same kpte_page, which would cause a loop in the
linked list, and therefore a system hang.

Does it make sense ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

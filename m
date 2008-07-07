Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYGGOjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYGGOjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbYGGOjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:39:36 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45729 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753626AbYGGOje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:39:34 -0400
Date: Mon, 7 Jul 2008 09:39:16 -0500
From: Jack Steiner <steiner@sgi.com>
To: Christoph Hellwig <hch@infradead.org>, cl@linux-foundation.org,
       hugh@veritas.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com,
       linux-mm@kvack.org
Subject: Re: [patch 12/13] GRU Driver V3 -  export is_uv_system(), zap_page_range() & follow_page()
Message-ID: <20080707143916.GA5209@sgi.com>
References: <20080703213348.489120321@attica.americas.sgi.com> <20080703213633.890647632@attica.americas.sgi.com> <20080704073926.GA1449@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080704073926.GA1449@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jul 03, 2008 at 04:34:00PM -0500, steiner@sgi.com wrote:
> > +EXPORT_SYMBOL_GPL(zap_page_range);

Investigating.... More later


> >  
> >  /*
> >   * Do a quick page-table lookup for a single page.
> > @@ -1089,6 +1090,7 @@ no_page_table:
> >  	}
> >  	return page;
> >  }
> > +EXPORT_SYMBOL_GPL(follow_page);
> 
> NACK.
> 
> These should never be called by a driver and suggest you need to rething
> your VM integration in this driver.

Can you provide some additional details on the type of kernel API
that could be exported to provide a pte lookup in atomic context?

There has been significant work to add kernel support for
drivers with externel TLBs. The GRU is one of these drivers.
In order to efficiently support the GRU, the driver needs to do
virt->physical translations in atomic context.


Some background.

The GRU is a hardware resource located in the system chipset. The GRU
contains memory that is mmaped into the user address space. This memory is
used to communicate with the GRU to perform functions such as load/store,
scatter/gather, bcopy, AMOs, etc.  The GRU is directly accessed by user
instructions using user virtual addresses. GRU instructions (ex., bcopy) use
user virtual addresses for operands.

The GRU contains a large TLB that is functionally very similar to processor TLBs.
If a user references a page and no GRU TLB entry exists, the GRU sends
an interrupt to the processor.

Currently, the driver calls follow_page() in interrupt context. If the
lookup is successful, a new TLB entry is dropped into the GRU and
the fault is resolved. If follow_page() fails, the fault is converted
into a different type of fault that will later be seen by the user. The
driver is later called in user context where sleeping is allowed.
The driver then calls get_user_pages() in user context. 

Most users of the GRU will be HPC apps that are primarily cpu bound
in user code. The call to follow_page() should normally be successful
and processing the fault in interrupt context is MUCH lower overhead than
handling it in user context.

I'll gladly make whatever changes are needed but need some pointers on
the direction I should take....


--- jack

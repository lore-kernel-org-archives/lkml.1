Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbZDVQNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbZDVQNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 12:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZDVQNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 12:13:31 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37388 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZDVQNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 12:13:30 -0400
Subject: Re: [PATCH 02/22] Do not sanity check order in the fast path
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240408407-21848-3-git-send-email-mel@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
	 <1240408407-21848-3-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 09:13:11 -0700
Message-Id: <1240416791.10627.78.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-22 at 14:53 +0100, Mel Gorman wrote:
> No user of the allocator API should be passing in an order >= MAX_ORDER
> but we check for it on each and every allocation. Delete this check and
> make it a VM_BUG_ON check further down the call path.

Should we get the check re-added to some of the upper-level functions,
then?  Perhaps __get_free_pages() or things like alloc_pages_exact()? 

I'm selfishly thinking of what I did in profile_init().  Can I slab
alloc it?  Nope.  Page allocator?  Nope.  Oh, well, try vmalloc():

        prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL);
        if (prof_buffer)
                return 0;

        prof_buffer = alloc_pages_exact(buffer_bytes, GFP_KERNEL|__GFP_ZERO);
        if (prof_buffer)
                return 0;

        prof_buffer = vmalloc(buffer_bytes);
        if (prof_buffer)
                return 0;

        free_cpumask_var(prof_cpu_mask);
        return -ENOMEM;

Same thing in __kmalloc_section_memmap():

        page = alloc_pages(GFP_KERNEL|__GFP_NOWARN, get_order(memmap_size));
        if (page)
                goto got_map_page;

        ret = vmalloc(memmap_size);
        if (ret)
                goto got_map_ptr;

I depend on the allocator to tell me when I've fed it too high of an
order.  If we really need this, perhaps we should do an audit and then
add a WARN_ON() for a few releases to catch the stragglers.

-- Dave


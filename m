Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbZAVJQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbZAVJQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbZAVJPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:15:13 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35726 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540AbZAVJPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:15:10 -0500
Subject: Re: Mainline kernel OLTP performance update
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       sfr@canb.auug.org.au, matthew.r.wilcox@intel.com, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       andrew.vasquez@qlogic.com, anirban.chakraborty@qlogic.com
In-Reply-To: <1232613395.11429.122.camel@ymzhang>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <200901161503.13730.nickpiggin@yahoo.com.au>
	 <20090115201210.ca1a9542.akpm@linux-foundation.org>
	 <200901161746.25205.nickpiggin@yahoo.com.au>
	 <20090116065546.GJ31013@parisc-linux.org>
	 <1232092430.11429.52.camel@ymzhang>  <87sknjeemn.fsf@basil.nowhere.org>
	 <1232428583.11429.83.camel@ymzhang>
	 <alpine.DEB.1.10.0901211852060.18367@qirst.com>
	 <1232613395.11429.122.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 22 Jan 2009 11:15:07 +0200
Message-Id: <1232615707.14549.6.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 16:36 +0800, Zhang, Yanmin wrote:
> On Wed, 2009-01-21 at 18:58 -0500, Christoph Lameter wrote:
> > On Tue, 20 Jan 2009, Zhang, Yanmin wrote:
> > 
> > > kmem_cache ﻿skbuff_head_cache's object size is just 256, so it shares the kmem_cache
> > > with ﻿:0000256. Their order is 1 which means every slab consists of 2 physical pages.
> > 
> > That order can be changed. Try specifying slub_max_order=0 on the kernel
> > command line to force an order 0 alloc.
> I tried ﻿slub_max_order=0 and there is no improvement on this UDP-U-4k issue.
> Both get_page_from_freelist and __free_pages_ok's cpu time are still very high.
> 
> I checked my instrumentation in kernel and found it's caused by large object allocation/free
> whose size is more than PAGE_SIZE. Here its order is 1.
> 
> The right free callchain is __kfree_skb => skb_release_all => skb_release_data.
> 
> So this case isn't the issue that batch of allocation/free might erase partial page
> functionality.

So is this the kfree(skb->head) in skb_release_data() or the put_page()
calls in the same function in a loop?

If it's the former, with big enough size passed to __alloc_skb(), the
networking code might be taking a hit from the SLUB page allocator
pass-through.

		Pekka


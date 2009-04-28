Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbZD1G4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbZD1G4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 02:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757375AbZD1G4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 02:56:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297AbZD1G4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 02:56:08 -0400
Date: Tue, 28 Apr 2009 08:55:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wu Fengguang <fengguang.wu@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Message-ID: <20090428065507.GA2024@elte.hu>
References: <20090428010907.912554629@intel.com> <20090428014920.769723618@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428014920.769723618@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wu Fengguang <fengguang.wu@intel.com> wrote:

> Export 9 page flags in /proc/kpageflags, and 8 more for kernel developers.
> 
> 1) for kernel hackers (on CONFIG_DEBUG_KERNEL)
>    - all available page flags are exported, and
>    - exported as is
> 2) for admins and end users
>    - only the more `well known' flags are exported:
> 	11. KPF_MMAP		(pseudo flag) memory mapped page
> 	12. KPF_ANON		(pseudo flag) memory mapped page (anonymous)
> 	13. KPF_SWAPCACHE	page is in swap cache
> 	14. KPF_SWAPBACKED	page is swap/RAM backed
> 	15. KPF_COMPOUND_HEAD	(*)
> 	16. KPF_COMPOUND_TAIL	(*)
> 	17. KPF_UNEVICTABLE	page is in the unevictable LRU list
> 	18. KPF_HWPOISON	hardware detected corruption
> 	19. KPF_NOPAGE		(pseudo flag) no page frame at the address
> 
> 	(*) For compound pages, exporting _both_ head/tail info enables
> 	    users to tell where a compound page starts/ends, and its order.
> 
>    - limit flags to their typical usage scenario, as indicated by KOSAKI:
> 	- LRU pages: only export relevant flags
> 		- PG_lru
> 		- PG_unevictable
> 		- PG_active
> 		- PG_referenced
> 		- page_mapped()
> 		- PageAnon()
> 		- PG_swapcache
> 		- PG_swapbacked
> 		- PG_reclaim
> 	- no-IO pages: mask out irrelevant flags
> 		- PG_dirty
> 		- PG_uptodate
> 		- PG_writeback
> 	- SLAB pages: mask out overloaded flags:
> 		- PG_error
> 		- PG_active
> 		- PG_private
> 	- PG_reclaim: mask out the overloaded PG_readahead
> 	- compound flags: only export huge/gigantic pages
> 
> Here are the admin/linus views of all page flags on a newly booted nfs-root system:
> 
> # ./page-types # for admin
>          flags  page-count       MB  symbolic-flags                     long-symbolic-flags
> 0x000000000000      491174     1918  ____________________________                
> 0x000000000020           1        0  _____l______________________       lru      
> 0x000000000028        2543        9  ___U_l______________________       uptodate,lru
> 0x00000000002c        5288       20  __RU_l______________________       referenced,uptodate,lru
> 0x000000004060           1        0  _____lA_______b_____________       lru,active,swapbacked

I think i have to NAK this kind of ad-hoc instrumentation of kernel 
internals and statistics until we clear up why such instrumentation 
measures are being accepted into the MM while other, more dynamic 
and more flexible MM instrumentation are being resisted by Andrew.

The above type of condensed information can be built out of dynamic 
trace data too - and much more. Being able to track page state 
transitions is very valuable when debugging VM problems. One such 
'view' of trace data would be a summary histogram like above.

( done after a "echo 3 > /proc/sys/vm/drop_caches" to make sure all 
  interesting pages have been re-established and their state is 
  present in the trace. )

The SLAB code already has such a facility, kmemtrace: it's very 
useful and successful in visualizing complex SLAB details, both 
dynamically and statically.

I think the same general approach should be used for the page 
allocator too (and for the page cache and some other struct page 
based caches): the life-time of an object should be followed. If we 
capture the important details we capture the big picture too. Pekka 
already sent an RFC patch to extend kmemtrace in such a fashion. Why 
is that more useful method not being pursued?

By extending upon the (existing) /proc/kpageflags hack a usecase is 
taken away from the tracing based solution and a needless overlap is 
created - and that's not particularly helpful IMHO. We now have all 
the facilities upstream that allow us to do intelligent 
instrumentation - we should make use of them.

	Ingo

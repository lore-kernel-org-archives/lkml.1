Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbXEUJbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbXEUJbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbXEUJbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:31:42 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:58791 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbXEUJbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:31:42 -0400
Date: Mon, 21 May 2007 11:31:39 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-Id: <20070521113140.1e9e77d2.dada1@cosmosbay.com>
In-Reply-To: <20070521080813.GQ31925@holomorphy.com>
References: <20070518040854.GA15654@wotan.suse.de>
	<Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com>
	<20070519012530.GB15569@wotan.suse.de>
	<20070519181501.GC19966@holomorphy.com>
	<20070520052229.GA9372@wotan.suse.de>
	<20070520084647.GF19966@holomorphy.com>
	<20070520092552.GA7318@wotan.suse.de>
	<20070521080813.GQ31925@holomorphy.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 01:08:13 -0700
William Lee Irwin III <wli@holomorphy.com> wrote:

> Now that I've been informed of the ->_count and ->_mapcount issues,
> I'd say that they're grave and should be corrected even at the cost
> of sizeof(struct page).


As long we handle 4 KB pages, adding 64 bits per page means 0.2 % of overhead. Ouch...

We currently have an overhead of 1.36 % for mem_map

Maybe we can still use 32 bits counters, and make sure non root users cannot
make these counters exceed 2^30. (I believe high order bit has already a meaning, 
check page_mapped() definition)

We could use a special atomic_inc_if_not_huge() function, that could revert to
 normal atomic_inc() on machines with less than 32 GB (using alternative_() variant)

On small setups (or 32 bits arches), atomic_inc_if_not_huge() would unconditionnally 
increment the counter.

#if !defined(BIG_MACHINES)
static int inline atomic_inc_if_not_huge(atomic_t *v)
{
atomic_inc(v);
return 1;
}
#else
extern int atomic_inc_if_not_huge(atomic_t *v);

#endif


/* in a .c file */
/* could be patched at boot time if available memory < 32GB (or other limit) */
#if defined(BIG_MACHINES)
#define MAP_LIMIT_COUNT (2<<30)
int atomic_inc_if_not_huge(atomic_t *v);
{
/* lazy test, we dont care enough to do a real atomic read-modify-write */
if (unlikely(atomic_read(v) >= MAP_LIMIT_COUNT)) {
	if (non_root_user())
		return 0;
	}
atomic_inc(v);
return 1;
}
#endif

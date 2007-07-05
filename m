Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbXGECqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbXGECqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 22:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbXGECqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 22:46:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47892 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbXGECqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 22:46:34 -0400
Date: Thu, 5 Jul 2007 11:47:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Christoph Lameter <clameter@sgi.com>, Mike.stroya@hp.com,
       GOTO <y-goto@jp.fujitsu.com>, dmosberger@gmail.com, hugh@veritas.com
Subject: Re: [BUGFIX][PATCH] DO flush icache before set_pte() on ia64.
Message-Id: <20070705114726.2449f270.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <468C51A7.3070505@yahoo.com.au>
References: <20070704150504.423f6c54.kamezawa.hiroyu@jp.fujitsu.com>
	<468B3EAA.9070905@yahoo.com.au>
	<20070704163826.d0b7465b.kamezawa.hiroyu@jp.fujitsu.com>
	<468C51A7.3070505@yahoo.com.au>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jul 2007 12:04:23 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > In my understanding :
> > PG_arch_1 is used for showing "there is no inconsistent data on any level of
> > cache". PG_uptodate is used for showing "this page includes the newest data
> > and contents are valid."
> > ...maybe not used for the same purpose.
> 
> I think that's right, but why is set_pte-time the critical point for the
> flush? It is actually possible to write into an executable page via the
> dcache *after* it has ptes pointing to it.
yes. I think there are 2 cases.
- copy-on-write case..... OS handles this.
- page is writable and app just rewrites it ...... the app should handle this.

> 
>  From what I can work out, it is something like "at this point the page
> should be uptodate, so at least the icache won't contain *inconsistent*
> data, just old data which userspace should take care of flushing if it
> modifies". Is that always true?
 
I think it's true. But, in this case, i-cache doesn't contain *incositent* data.
There are inconsistency between L2-Dcache and L3-mixed-cache. At L2-icache-miss,
a cpu fetches data from L3 cache.
This case seems defficult to be generalized...


> Could the page get modified by means
> other than a direct write(2)? And even in the case of a write(2) writer,
> how do they know if another process is mapping that particular page for
> exec at that time? Should they always flush? Flushing would require they
> have a virtual address on the page to begin with anyway, doesn't it? So
> they'd have to mmap it... phew.
> 
> I guess it is mostly safe because it is probably very uncommon to do
> such a thing, and chances are no non-write(2) write activity happens to
> a page after it is brought uptodate. But I don't know if that has been
> audited. I would really like to see the kernel always manage all aspects
> of its pagecache though. I realise performance considerations may make
> this not always possible... but it might be possible to do efficiently
> using mapcount these days?

generic_file_write() does flush_dcahe_page() but no flush_icache_page()...

Then..maybe this will be necessary...
==
	flush_dcache_page(page);
	if (page_mapcount(page) > 0 && page_is_mapped_as_text(page))
		flush_icache_page(page);
==
But I don't know whether write(2) to mapped text file is expected to work well.

> > BTW, a page filled by DMA should have PG_arch_1 :(
> 
> The consequences of not are superfluous flushes?
> 
Yes, DMA flushes all levels of cache.

Thanks,
-Kame




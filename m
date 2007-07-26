Return-Path: <linux-kernel-owner+w=401wt.eu-S1765773AbXGZP4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765773AbXGZP4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759799AbXGZP4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:56:38 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:33609 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758975AbXGZP4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:56:37 -0400
Message-ID: <46A8C43D.8050302@bull.net>
Date: Thu, 26 Jul 2007 17:56:45 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Race condition around flush_cache_page() ?
References: <20070726171323.a9c17eda.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070726171323.a9c17eda.kamezawa.hiroyu@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/07/2007 18:01:19,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/07/2007 18:01:19,
	Serialize complete at 26/07/2007 18:01:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/cachetlb.txt says:

"In general, when Linux is changing an existing virtual-->physical
mapping to a new value, the sequence will be ...:

           flush_cache_page(vma, addr, pfn);
           set_pte(pte_pointer, new_pte_val);
           flush_tlb_page(vma, addr);

The cache level flush will always be first, because this allows
us to properly handle systems whose caches are strict and require
a virtual-->physical translation to exist for a virtual address
when that virtual address is flushed from the cache."

Let's assume we've got a multi threaded application, with 2 threads,
each of them bound to its own CPU.
Let's assume the CPU caches are tagged by virtual address and the 
virtual-->physical translation must remain valid while we flush the
cache.

CPU #1 is in a loop that accesses the stuff on a given virtual page.

CPU #2 executes the sequence above, trying to tear down the mapping
of the same page. Once CPU#2 has completed flush_cache_page()
(that is not a NO-OP), there is no valid stuff of the page any more
in any of the the CPU caches. CPU #2 will continue somewhat later
to invalidate the PTE due to some HW delays.

In the mean time, CPU #1 detects a cache miss. It has the valid
translation in its TLB, it can re-fetch the cache line from the page.

Now CPU #2 can really invalidate the PTE and flush the TLB-s.

We can end up a cache line of the CPU #1 that has no more valid
virtual-->physical translation.

As far as I can understand, there is a contradiction:
- either we keep the valid translation while flushing, and
  the other CPU can re-fetch the data
- or we nuke the PTE first, and the flush wont work

Can someone please explain me how it is assumed to work?

Thanks,

Zoltan Menyhart


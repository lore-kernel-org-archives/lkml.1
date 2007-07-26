Return-Path: <linux-kernel-owner+w=401wt.eu-S932934AbXGZPNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbXGZPNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbXGZPNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:13:46 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:54489 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508AbXGZPNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:13:45 -0400
Message-ID: <46A8BA30.7000508@bull.net>
Date: Thu, 26 Jul 2007 17:13:52 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "tony.luck@intel.com" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] flush icache before set_pte on ia64 take3
References: <20070726171323.a9c17eda.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070726171323.a9c17eda.kamezawa.hiroyu@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/07/2007 17:18:26,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/07/2007 17:18:27,
	Serialize complete at 26/07/2007 17:18:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I do not think changing the semantics of flush_cache_page()
is a good idea. Please have a look at Documentation/cachetlb.txt.
This is for virtual address tagged caches.

The doc. does not say much about flush_icache_page().
It is used in:

install_page(): can release any previously existing mapping
		(similarly: for virtual address tagged I-cache)

On the other hand, I do not see why it is used in these two
cases, I think the virtual address tagged I-cache must have been
flushed when the old PTE of the page was removed:

do_no_page():
	if (pte_none(*page_table)) {
		flush_icache_page(vma, new_page);

do_swap_page():
	flush_icache_page(vma, page);

Anyway, it is a NO-OP on the machines with physical address
tagged caches.

Sure, the names could have been chosen more carefully.

Unless you have a very strong reason, do not change their
semantics (would require updates for the other architectures).

I can agree:
- lazy_mmu_prot_update() is not the right place for a flush
- to flush I-cache before inserting PTE (at least for the
  machines with physical address tagged caches)

Can we have a separate, specific exec_flush_phtag_icache_page()
that is to be called before inserting a PTE with the exec bit on
for physical address tagged I-caches) ?
It is defined in asm-generic/cacheflush.h as NO-OP.

Or exec_flush_icache_page_before_set_pte() ?

Thanks,

Zoltan


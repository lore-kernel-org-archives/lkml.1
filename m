Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229Ab0ASC1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0ASC1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 21:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447Ab0ASC1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 21:27:13 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37378 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab0ASC1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 21:27:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 19 Jan 2010 11:23:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 5/8] vmalloc: simplify vread()/vwrite()
Message-Id: <20100119112343.04f4eff5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100119013303.GA12513@localhost>
References: <20100113135305.013124116@intel.com>
	<20100113135957.833222772@intel.com>
	<20100114124526.GB7518@laptop>
	<20100118133512.GC721@localhost>
	<20100118142359.GA14472@laptop>
	<20100119013303.GA12513@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jan 2010 09:33:03 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:
> > The whole thing looks stupid though, apparently kmap is used to avoid "the
> > lock". But the lock is already held. We should just use the vmap
> > address.
> 
> Yes. I wonder why Kame introduced kmap_atomic() in d0107eb07 -- given
> that he at the same time fixed the order of removing vm_struct and
> vmap in dd32c279983b.
> 
Hmm...I must check my thinking again before answering..

vmalloc/vmap is constructed by 2 layer.
	- vmalloc layer....guarded by vmlist_lock.
	- vmap layer   ....gurderd by purge_lock. etc.

Now, let's see how vmalloc() works. It does job in 2 steps.
vmalloc():
  - allocate vmalloc area to the list under vmlist_lock.
	- map pages.
vfree()
  - free vmalloc area from the list under vmlist_lock.
	- unmap pages under purge_lock.

Now. vread(), vwrite() just take vmlist_lock, doesn't take purge_lock().
It walks page table and find pte entry, page, kmap and access it.

Oh, yes. It seems it's safe without kmap. But My concern is percpu allocator.

It uses get_vm_area() and controls mapped pages by themselves and
map/unmap pages by with their own logic. vmalloc.c is just used for
alloc/free virtual address. 

Now, vread()/vwrite() just holds vmlist_lock() and walk page table
without no guarantee that the found page is stably mapped. So, I used kmap.

If I miss something, I'm very sorry to add such kmap.

Thanks,
-Kame


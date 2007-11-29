Return-Path: <linux-kernel-owner+w=401wt.eu-S932895AbXK2UBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbXK2UBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbXK2UBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:01:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55856 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756222AbXK2UBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:01:45 -0500
Date: Thu, 29 Nov 2007 12:00:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
       allan.stephens@windriver.com, jon.maloy@ericsson.com, mpm@selenic.com
Subject: Re: [bug] SLOB, tipc_init(), WARNING: at
 arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
Message-Id: <20071129120044.079f117a.akpm@linux-foundation.org>
In-Reply-To: <20071129143920.GA32146@elte.hu>
References: <20071129142546.GA27719@elte.hu>
	<20071129143920.GA32146@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 15:39:20 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > i'm getting this on 32-bit (with the kmap-atomic debugging patch 
> > applied):
> > 
> >  ---------------->
> >  Calling initcall 0x78b67c00: tipc_init+0x0/0xc0()
> >  TIPC: Activated (version 1.6.2 compiled Nov 29 2007 15:04:36)
> >  WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> >  Pid: 1, comm: swapper Not tainted 2.6.24-rc3-cfs-v24 #45
> >   [<78107272>] show_trace_log_lvl+0x12/0x40
> >   [<781072ad>] show_trace+0xd/0x20
> >   [<781086f8>] dump_stack+0x58/0x60
> >   [<7811541f>] kmap_atomic_prot+0x1bf/0x240
> >   [<781154ae>] kmap_atomic+0xe/0x20
> >   [<78157be5>] get_page_from_freelist+0x225/0x420
> >   [<78157e4d>] __alloc_pages+0x6d/0x3a0
> >   [<78169a7b>] slob_new_page+0x1b/0x60
> >   [<78169be4>] slob_alloc+0x124/0x1e0
> >   [<78169e0f>] __kmalloc_node+0x6f/0xa0
> >   [<7884f7c2>] reg_init+0x42/0x80
> >   [<7884f80a>] tipc_reg_start+0xa/0x40
> >   [<7883e6c6>] tipc_core_start+0x66/0xc0
> >   [<78b67c81>] tipc_init+0x81/0xc0
> 
> this is due to the kzalloc() here:
> 
> 0x7884f1d0 is in reg_init (net/tipc/user_reg.c:88).
> 83              spin_lock_bh(&reg_lock);
> 84              if (!users) {
> 85                      users = kzalloc(USER_LIST_SIZE, GFP_ATOMIC);
> 86                      if (users) {
> 87                              for (i = 1; i <= MAX_USERID; i++) {
> 88                                      users[i].next = i - 1;
> 
> which does a:
> 
> 120     static inline void clear_highpage(struct page *page)
> 121     {
> 122             void *kaddr = kmap_atomic(page, KM_USER0);
> 123             clear_page(kaddr);
> 124             kunmap_atomic(kaddr, KM_USER0);
> 125     }
> 
> but ... why does the debug code think it's in softirq context?
> 
> plus, and this is a slob question i guess, how come we drop into 
> clear_highpage() for a kzalloc()??
> 

It looks like local_bh_disable() will cause in_interrupt() to return
true, hence this warning.



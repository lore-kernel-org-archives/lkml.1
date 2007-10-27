Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbXJ0KSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbXJ0KSE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 06:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXJ0KRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 06:17:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:34888 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750884AbXJ0KRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 06:17:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19bLQRQurNbKeC2R+ipBYGjWlrnLi6M/r/FeaYciN
	EtUk0qGsci/F2P
Subject: Re: [2.6.23-rt3] NMI watchdog trace of deadlock
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20071027094407.GA12047@elte.hu>
References: <1193245634.20679.8.camel@localhost.localdomain>
	 <1193462494.25330.7.camel@Homer.simpson.net>
	 <200710271915.42363.nickpiggin@yahoo.com.au>
	 <20071027094407.GA12047@elte.hu>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 12:17:49 +0200
Message-Id: <1193480269.8374.3.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-27 at 11:44 +0200, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > > [10138.175796]  [<c0105de3>] show_trace+0x12/0x14
> > > [10138.180291]  [<c0105dfb>] dump_stack+0x16/0x18
> > > [10138.184769]  [<c011609f>] native_smp_call_function_mask+0x138/0x13d
> > > [10138.191117]  [<c0117606>] smp_call_function+0x1e/0x24
> > > [10138.196210]  [<c012f85c>] on_each_cpu+0x25/0x50
> > > [10138.200807]  [<c0115c74>] flush_tlb_all+0x1e/0x20
> > > [10138.205553]  [<c016caaf>] kmap_high+0x1b6/0x417
> > > [10138.210118]  [<c011ec88>] kmap+0x4d/0x4f
> > > [10138.214102]  [<c026a9d8>] ntfs_end_buffer_async_read+0x228/0x2f9
> > > [10138.220163]  [<c01a0e9e>] end_bio_bh_io_sync+0x26/0x3f
> > > [10138.225352]  [<c01a2b09>] bio_endio+0x42/0x6d
> > > [10138.229769]  [<c02c2a08>] __end_that_request_first+0x115/0x4ac
> > > [10138.235682]  [<c02c2da7>] end_that_request_chunk+0x8/0xa
> > > [10138.241052]  [<c0365943>] ide_end_request+0x55/0x10a
> > > [10138.246058]  [<c036dae3>] ide_dma_intr+0x6f/0xac
> > > [10138.250727]  [<c0366d83>] ide_intr+0x93/0x1e0
> > > [10138.255125]  [<c015afb4>] handle_IRQ_event+0x5c/0xc9
> > 
> > Looks like ntfs is kmap()ing from interrupt context. Should be using 
> > kmap_atomic instead, I think.
> 
> it's not atomic interrupt context but irq thread context - and -rt 
> remaps kmap_atomic() to kmap() internally.

Hm.  Looking at the change to mm/bounce.c, perhaps I should do this
instead?

--- ./fs/ntfs/aops.c.org	2007-10-27 10:16:40.000000000 +0200
+++ ./fs/ntfs/aops.c	2007-10-27 12:11:07.000000000 +0200
@@ -139,13 +139,13 @@ static void ntfs_end_buffer_async_read(s
 		recs = PAGE_CACHE_SIZE / rec_size;
 		/* Should have been verified before we got here... */
 		BUG_ON(!recs);
-		local_irq_save(flags);
+		local_irq_save_nort(flags);
 		kaddr = kmap_atomic(page, KM_BIO_SRC_IRQ);
 		for (i = 0; i < recs; i++)
 			post_read_mst_fixup((NTFS_RECORD*)(kaddr +
 					i * rec_size), rec_size);
 		kunmap_atomic(kaddr, KM_BIO_SRC_IRQ);
-		local_irq_restore(flags);
+		local_irq_restore_nort(flags);
 		flush_dcache_page(page);
 		if (likely(page_uptodate && !PageError(page)))
 			SetPageUptodate(page);



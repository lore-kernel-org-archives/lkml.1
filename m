Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbXJ0Jo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbXJ0Jo1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 05:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbXJ0JoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 05:44:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50856 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbXJ0JoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 05:44:18 -0400
Date: Sat, 27 Oct 2007 11:44:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.23-rt3] NMI watchdog trace of deadlock
Message-ID: <20071027094407.GA12047@elte.hu>
References: <1193245634.20679.8.camel@localhost.localdomain> <1193462494.25330.7.camel@Homer.simpson.net> <200710271915.42363.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710271915.42363.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > [10138.175796]  [<c0105de3>] show_trace+0x12/0x14
> > [10138.180291]  [<c0105dfb>] dump_stack+0x16/0x18
> > [10138.184769]  [<c011609f>] native_smp_call_function_mask+0x138/0x13d
> > [10138.191117]  [<c0117606>] smp_call_function+0x1e/0x24
> > [10138.196210]  [<c012f85c>] on_each_cpu+0x25/0x50
> > [10138.200807]  [<c0115c74>] flush_tlb_all+0x1e/0x20
> > [10138.205553]  [<c016caaf>] kmap_high+0x1b6/0x417
> > [10138.210118]  [<c011ec88>] kmap+0x4d/0x4f
> > [10138.214102]  [<c026a9d8>] ntfs_end_buffer_async_read+0x228/0x2f9
> > [10138.220163]  [<c01a0e9e>] end_bio_bh_io_sync+0x26/0x3f
> > [10138.225352]  [<c01a2b09>] bio_endio+0x42/0x6d
> > [10138.229769]  [<c02c2a08>] __end_that_request_first+0x115/0x4ac
> > [10138.235682]  [<c02c2da7>] end_that_request_chunk+0x8/0xa
> > [10138.241052]  [<c0365943>] ide_end_request+0x55/0x10a
> > [10138.246058]  [<c036dae3>] ide_dma_intr+0x6f/0xac
> > [10138.250727]  [<c0366d83>] ide_intr+0x93/0x1e0
> > [10138.255125]  [<c015afb4>] handle_IRQ_event+0x5c/0xc9
> 
> Looks like ntfs is kmap()ing from interrupt context. Should be using 
> kmap_atomic instead, I think.

it's not atomic interrupt context but irq thread context - and -rt 
remaps kmap_atomic() to kmap() internally.

the problem seems to be what Mike's patch works around: fiddling with 
irq flags in the ntfs code. That fiddling seems quite unnecessary at 
first sight.

	Ingo

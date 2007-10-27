Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbXJ0JkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbXJ0JkY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 05:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbXJ0JkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 05:40:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:36221 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752110AbXJ0JkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 05:40:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19eFawzAtNe0fYlpx1SgElW/9aIUrstMz3UzVbJrO
	9oIyKhm0AUlfsg
Subject: Re: [2.6.23-rt3] NMI watchdog trace of deadlock
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1193462494.25330.7.camel@Homer.simpson.net>
References: <1193245634.20679.8.camel@localhost.localdomain>
	 <1193462494.25330.7.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 11:40:04 +0200
Message-Id: <1193478004.7496.21.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-27 at 07:21 +0200, Mike Galbraith wrote:
> Greetings,
> 
> For quite a while now, RT kernels have been locking up on me
> occasionally while my back is turned.  Yesterday, the little bugger
> finally pounced while my serial console box was up and waiting.
> 
> [10138.162953] WARNING: at arch/i386/kernel/smp.c:581 native_smp_call_function_mask()
> [10138.170583]  [<c01051da>] show_trace_log_lvl+0x1a/0x30
> [10138.175796]  [<c0105de3>] show_trace+0x12/0x14
> [10138.180291]  [<c0105dfb>] dump_stack+0x16/0x18
> [10138.184769]  [<c011609f>] native_smp_call_function_mask+0x138/0x13d
> [10138.191117]  [<c0117606>] smp_call_function+0x1e/0x24
> [10138.196210]  [<c012f85c>] on_each_cpu+0x25/0x50
> [10138.200807]  [<c0115c74>] flush_tlb_all+0x1e/0x20
> [10138.205553]  [<c016caaf>] kmap_high+0x1b6/0x417
> [10138.210118]  [<c011ec88>] kmap+0x4d/0x4f
> [10138.214102]  [<c026a9d8>] ntfs_end_buffer_async_read+0x228/0x2f9
> [10138.220163]  [<c01a0e9e>] end_bio_bh_io_sync+0x26/0x3f
> [10138.225352]  [<c01a2b09>] bio_endio+0x42/0x6d
> [10138.229769]  [<c02c2a08>] __end_that_request_first+0x115/0x4ac
> [10138.235682]  [<c02c2da7>] end_that_request_chunk+0x8/0xa
> [10138.241052]  [<c0365943>] ide_end_request+0x55/0x10a
> [10138.246058]  [<c036dae3>] ide_dma_intr+0x6f/0xac
> [10138.250727]  [<c0366d83>] ide_intr+0x93/0x1e0
> [10138.255125]  [<c015afb4>] handle_IRQ_event+0x5c/0xc9
> [10138.260113]  [<c015bcfd>] do_irqd+0x1fc/0x2ef
> [10138.264514]  [<c013cdb2>] kthread+0x39/0x5b
> [10138.268740]  [<c0104e33>] kernel_thread_helper+0x7/0x14
> [10138.274006]  =======================

(box may recommend that i go figure out why interrupts are disabled
instead;)

--- ./fs/ntfs/aops.c.org	2007-10-27 10:16:40.000000000 +0200
+++ ./fs/ntfs/aops.c	2007-10-27 10:30:52.000000000 +0200
@@ -140,6 +140,7 @@ static void ntfs_end_buffer_async_read(s
 		/* Should have been verified before we got here... */
 		BUG_ON(!recs);
 		local_irq_save(flags);
+		local_irq_enable();
 		kaddr = kmap_atomic(page, KM_BIO_SRC_IRQ);
 		for (i = 0; i < recs; i++)
 			post_read_mst_fixup((NTFS_RECORD*)(kaddr +



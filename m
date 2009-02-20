Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbZBTHtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbZBTHtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 02:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZBTHtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 02:49:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:53755 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbZBTHto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 02:49:44 -0500
Subject: Re: [Announce] 2.6.29-rc4-rt2
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       "jens.axboe" <jens.axboe@oracle.com>, Tejun Heo <tj@kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1235111568.3363.3.camel@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <1235111568.3363.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 08:49:11 +0100
Message-Id: <1235116151.4736.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-20 at 07:32 +0100, Thomas Meyer wrote:
> Are you interested in these BUG reports?

Yes we are, thanks!

> Without CONFIG_HIGHPTE kernel boots and seems to work correct, but I'm
> hitting these two BUGs:

They appear to be identical, so I'll consider them two instances of one
bug :-)

> [   19.840100] BUG: sleeping function called from invalid context at arch/x86/mm/highmem_32.c:8
> [   19.840105] in_atomic(): 0, irqs_disabled(): 1, pid: 718, name: IRQ-14
> [   19.840110] Pid: 718, comm: IRQ-14 Tainted: G        W  2.6.29-rc4-rt2-tip #55
> [   19.840113] Call Trace:
> [   19.840123]  [<c0444cbd>] __might_sleep+0xda/0xf0
> [   19.840128]  [<c043ee31>] kmap+0x50/0x77
> [   19.840133]  [<c0663e35>] sg_miter_next+0xc1/0xdf
> [   19.840137]  [<c0663ee8>] sg_copy_buffer+0x95/0xc5
> [   19.840141]  [<c0663f35>] sg_copy_to_buffer+0x1d/0x33
> [   19.840149]  [<c0774ab1>] atapi_qc_complete+0x25a/0x2c5
> [   19.840153]  [<c076dece>] __ata_qc_complete+0xb4/0xcd
> [   19.840157]  [<c076f844>] ata_qc_complete+0x1be/0x1d7
> [   19.840162]  [<c077c812>] ata_hsm_qc_complete+0xa9/0xd3
> [   19.840166]  [<c077ceb7>] ata_sff_hsm_move+0x67b/0x6da
> [   19.840171]  [<c077d19b>] ata_sff_interrupt+0x15d/0x205
> [   19.840176]  [<c049440a>] handle_IRQ_event+0x4b/0xce
> [   19.840180]  [<c0494ac7>] do_irqd+0x141/0x271
> [   19.840184]  [<c0494986>] ? do_irqd+0x0/0x271
> [   19.840189]  [<c0467022>] kthread+0x4a/0x82
> [   19.840192]  [<c0466fd8>] ? kthread+0x0/0x82
> [   19.840197]  [<c0420b67>] kernel_thread_helper+0x7/0x10

sg_copy_buffer() seems to disable IRQs, however since on -rt everything
is a irq-thread and kmap is preemptible, we don't appear to have that
need.

CC'd everybody who ever touched the file.

---
 lib/scatterlist.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index b7b449d..4c6510d 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -426,7 +426,7 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
 
 	sg_miter_start(&miter, sgl, nents, SG_MITER_ATOMIC);
 
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 
 	while (sg_miter_next(&miter) && offset < buflen) {
 		unsigned int len;
@@ -445,7 +445,7 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
 
 	sg_miter_stop(&miter);
 
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 	return offset;
 }
 



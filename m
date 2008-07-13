Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbYGMNe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbYGMNe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 09:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbYGMNeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 09:34:16 -0400
Received: from mail4.aster.pl ([212.76.33.58]:16000 "EHLO mail4.aster.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbYGMNeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 09:34:11 -0400
From: "Jakub W. Jozwicki" <jozwicki@aster.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.25.10 1/2] libata: fix locking for kmap_atomic
Date: Sun, 13 Jul 2008 15:17:51 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@timesys.com
References: <200807130127.36706.jozwicki@aster.pl> <20080713012630.d5e522f7.akpm@linux-foundation.org>
In-Reply-To: <20080713012630.d5e522f7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807131517.51795.jozwicki@aster.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sunday, 13 of July 2008 10:26:30 Andrew Morton napisał(a):
> On Sun, 13 Jul 2008 01:27:36 +0200 "Jakub W. Jozwicki" <jozwicki@aster.pl> 
wrote:
> > Change locking surrounding kmap_atomic from local_irqsave to
> > local_irqsave_nort. This fixes issues with PREEMPT_RT.
>
> I assume this is a -rt kernel patch.
>
> > --- linux-2.6.25.10/drivers/ata/libata-core.c	2008-07-03
> > 05:46:47.000000000 +0200
> > +++ linux-2.6.25.10-rt7/drivers/ata/libata-core.c	2008-07-12
> > 23:59:33.132140258 +0200
> > @@ -5157,14 +5157,14 @@
> >  		unsigned long flags;
> >
> >  		/* FIXME: use a bounce buffer */
> > -		local_irq_save(flags);
> > +		local_irq_save_nort(flags);
>
> eww.  If we're going to have to do stuff like this in mainline then
> there might be a revolt.

Sorry, this was for -rt only.

[   17.012011] BUG: sleeping function called from invalid context IRQ-14(5732) 
at arch/x86/mm/highmem_32.c:8
[   17.012011] in_atomic():0 [00000000], irqs_disabled():1
[   17.012011] Pid: 5732, comm: IRQ-14 Not tainted 2.6.25.10-rtXXX #11
[   17.012011]  [<c0120fc4>] __might_sleep+0xf1/0xf8
[   17.012011]  [<c011c035>] kmap+0x47/0x5a
[   17.012011]  [<c033e728>] ata_hsm_move+0x3d7/0x657
[   17.012011]  [<c0342fd6>] ata_interrupt+0x14e/0x1cb
[   17.012011]  [<c015c72c>] handle_IRQ_event+0x4e/0xd1
[   17.012011]  [<c015d266>] do_irqd+0x126/0x224
[   17.012011]  [<c015d140>] ? do_irqd+0x0/0x224
[   17.012011]  [<c013ae9d>] kthread+0x3b/0x62
[   17.012011]  [<c013ae62>] ? kthread+0x0/0x62
[   17.012011]  [<c0108287>] kernel_thread_helper+0x7/0x10
[   17.012011]  =======================


Return-Path: <linux-kernel-owner+w=401wt.eu-S1764240AbYBZSX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764240AbYBZSX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760383AbYBZSXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:23:16 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759031AbYBZSXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:23:15 -0500
Date: Tue, 26 Feb 2008 10:19:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git: kmap_atomic() WARN_ON()
Message-Id: <20080226101928.f6c16c66.akpm@linux-foundation.org>
In-Reply-To: <47C43F18.6060207@pobox.com>
References: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de>
	<20080225195924.GA23176@atjola.homenet>
	<47C32043.6090809@pobox.com>
	<20080225124054.9b69e9f0.akpm@linux-foundation.org>
	<alpine.LFD.1.00.0802252242290.7583@apollo.tec.linutronix.de>
	<47C34CEA.7060307@pobox.com>
	<20080226083904.GC9857@elte.hu>
	<47C43F18.6060207@pobox.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 11:32:24 -0500 Jeff Garzik <jgarzik@pobox.com> wrote:

> Ingo Molnar wrote:
> > * Jeff Garzik <jgarzik@pobox.com> wrote:
> > 
> >> +	unsigned long flags;
> >> +
> >> +	local_irq_save(flags);
> > 
> > hm, couldnt we attach the irq disabling to some spinlock, in a natural 
> > way? Explicit flags fiddling is a PITA once we do things like threaded 
> > irq handlers, -rt, etc.
> 
> Attaching the irq disabling to some spinlock is what would be 
> artificial...  See the ahci.c patch earlier in this thread.  It is taken 
> without spin_lock_irqsave() in the interrupt handler, and there is no 
> reason to disable interrupts for the entirety of the interrupt handler 
> run -- only the part where we call kmap.
> 
> This is only being done to satisfy kmap_atomic's requirements, not libata's.
> 
> I could add a "kmap lock" but that just seems silly.
> 

It's a bit sad to disable interupts across a memset (how big is it?) just
for the small proportion of cases which are accessing a highmem page.

What you could do is to add an `unsigned long *flags' arg to
ata_scsi_rbuf_get() and ata_scsi_rbuf_put(), and then, in
ata_scsi_rbuf_get() do

	if (PageHighmem(page))
		local_irq_disable(*flags);



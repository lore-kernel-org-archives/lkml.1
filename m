Return-Path: <linux-kernel-owner+w=401wt.eu-S932210AbYBZVty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbYBZVty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764301AbYBZVtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:49:42 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763197AbYBZVtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:49:41 -0500
Date: Tue, 26 Feb 2008 13:37:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Garzik <jgarzik@pobox.com>, Thomas Gleixner <tglx@linutronix.de>,
       =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git: kmap_atomic() WARN_ON()
Message-Id: <20080226133715.d9cd32e7.akpm@linux-foundation.org>
In-Reply-To: <20080226204943.GD14350@elte.hu>
References: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de>
	<20080225195924.GA23176@atjola.homenet>
	<47C32043.6090809@pobox.com>
	<20080225124054.9b69e9f0.akpm@linux-foundation.org>
	<alpine.LFD.1.00.0802252242290.7583@apollo.tec.linutronix.de>
	<47C34CEA.7060307@pobox.com>
	<20080226083904.GC9857@elte.hu>
	<47C43F18.6060207@pobox.com>
	<20080226101928.f6c16c66.akpm@linux-foundation.org>
	<20080226204943.GD14350@elte.hu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 21:49:43 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > This is only being done to satisfy kmap_atomic's requirements, not 
> > > libata's.
> > > 
> > > I could add a "kmap lock" but that just seems silly.
> > > 
> > 
> > It's a bit sad to disable interupts across a memset (how big is it?) 
> > just for the small proportion of cases which are accessing a highmem 
> > page.
> > 
> > What you could do is to add an `unsigned long *flags' arg to 
> > ata_scsi_rbuf_get() and ata_scsi_rbuf_put(), and then, in 
> > ata_scsi_rbuf_get() do
> > 
> > 	if (PageHighmem(page))
> > 		local_irq_disable(*flags);
> 
> it would be much nicer to attach the irq disabling to the object, not to 
> some arbitrary place in the code.
> 
> i.e. to introduce a kmap_atomic_irqsave(...,flags) and 
> kunmap_atomic_irqrestore() API variant. _That_ then could be mapped by 
> -rt to a non-irq disabling thing.
> 

Sure.  But iirc we haven't had a need for this before.  Which is a bit odd.
 

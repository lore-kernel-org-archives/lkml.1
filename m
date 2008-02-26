Return-Path: <linux-kernel-owner+w=401wt.eu-S1765062AbYBZUuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765062AbYBZUuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYBZUuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:50:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34401 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774AbYBZUuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:50:04 -0500
Date: Tue, 26 Feb 2008 21:49:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Thomas Gleixner <tglx@linutronix.de>,
       =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git: kmap_atomic() WARN_ON()
Message-ID: <20080226204943.GD14350@elte.hu>
References: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de> <20080225195924.GA23176@atjola.homenet> <47C32043.6090809@pobox.com> <20080225124054.9b69e9f0.akpm@linux-foundation.org> <alpine.LFD.1.00.0802252242290.7583@apollo.tec.linutronix.de> <47C34CEA.7060307@pobox.com> <20080226083904.GC9857@elte.hu> <47C43F18.6060207@pobox.com> <20080226101928.f6c16c66.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226101928.f6c16c66.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > This is only being done to satisfy kmap_atomic's requirements, not 
> > libata's.
> > 
> > I could add a "kmap lock" but that just seems silly.
> > 
> 
> It's a bit sad to disable interupts across a memset (how big is it?) 
> just for the small proportion of cases which are accessing a highmem 
> page.
> 
> What you could do is to add an `unsigned long *flags' arg to 
> ata_scsi_rbuf_get() and ata_scsi_rbuf_put(), and then, in 
> ata_scsi_rbuf_get() do
> 
> 	if (PageHighmem(page))
> 		local_irq_disable(*flags);

it would be much nicer to attach the irq disabling to the object, not to 
some arbitrary place in the code.

i.e. to introduce a kmap_atomic_irqsave(...,flags) and 
kunmap_atomic_irqrestore() API variant. _That_ then could be mapped by 
-rt to a non-irq disabling thing.

	Ingo

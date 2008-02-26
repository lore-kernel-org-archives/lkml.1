Return-Path: <linux-kernel-owner+w=401wt.eu-S1765449AbYBZXv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765449AbYBZXv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbYBZXuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:50:52 -0500
Received: from n7.bullet.mud.yahoo.com ([216.252.100.58]:45482 "HELO
	n7.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753949AbYBZXuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:50:50 -0500
X-Yahoo-Newman-Id: 489379.78321.bm@omp416.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=w0cSrfMcSqaP/Lwd9exEXqRB3Oek5OXFRtkPkAlUz/VNbhGuHDG7TlkB4AFzhk9RVTxE+75gpVVnqtDsr/+sLMRaXClsmMJAu91SUfbxLNAoXG7RWkjD5MPVa5dUZVIwxJVDvqJdIXpf8L7Z4NdPfqw5k8om1BvJDS7Xmo8RfJQ=  ;
X-YMail-OSG: tLT_aIMVM1mvmytMXRDrSPP2DIzq1baDmJl.R.6F7j2jqBBy8aDDrmO5WZ1pGMqgIayILg7N_Q--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-git: kmap_atomic() WARN_ON()
Date: Wed, 27 Feb 2008 10:49:34 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jgarzik@pobox.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       =?iso-8859-1?q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       LKML <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0802070054220.9204@apollo.tec.linutronix.de> <20080226101928.f6c16c66.akpm@linux-foundation.org> <20080226204943.GD14350@elte.hu>
In-Reply-To: <20080226204943.GD14350@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802271049.35178.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2008 07:49, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > This is only being done to satisfy kmap_atomic's requirements, not
> > > libata's.
> > >
> > > I could add a "kmap lock" but that just seems silly.
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

Yeah that is the right way to fix it, but that name implies that
interrupts are disabled for non-highmem pages too, which we don't
want. Can you think of a better one?

kmap_atomic_irq_safe maybe?


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbZFBN0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbZFBN0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZFBN0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:26:11 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:58248 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZFBN0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:26:10 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: LOCK prefix on uni processor has its use
Date: Tue, 2 Jun 2009 08:26:06 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <20090602124854.GB9823@prithivi.gnumonks.org> <20090602130343.GI1065@one.firstfloor.org>
In-Reply-To: <20090602130343.GI1065@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906020826.09355.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue June 2 2009, Andi Kleen wrote:
> On Tue, Jun 02, 2009 at 02:48:54PM +0200, Harald Welte wrote:
> > On Wed, May 27, 2009 at 08:08:27PM +0200, Andi Kleen wrote:
> > > Harald Welte <HaraldWelte@viatech.com> writes:
> > > > * All X86 instructions except rep-strings are atomic wrt interrupts.
> > > > * The lock prefix has uses on a UP processor: It keeps DMA devices from
> > > >   interfering with a read-modify-write sequence
> > > 
> > > In theory yes, but not in Linux -- normal drivers simply don't use LOCK in
> > > any way on a UP kernel.
> > 
> > well, they might have inadvertedly used LOCK as part of regular spinlocks,
> > until LOCK_PREFIX was removed, right?
> 
> LOCK_PREFIX was always defined away on UP kernels. That dates back
> to the initial Linux 2.0 SMP implementation. 
> 
> On newer SMP kernels they also patch away the lock prefix even
> if they are running UP, so if you only have a single core you'll
> never get lock.
> 

After another week of chasing this - -
My favorite theory is still: "human coding error" - somewhere.

The LOCK_PREFIX is used or not used or mis-used by something.

My second favorite theory (related to the "some sort of timing
problem" suggestion:

Another difference is FSB speed on the two machines -
The "trouble free" case is twice as fast as the "problem" case.

Such a thing should be totally transparent to the kernel, but...
we do have humans writing the code.  ;)

> So I think it's pretty unlikely any driver relied on this.
> 

The kernel assumes I/O coherency, but perhaps something is
breaking that assumption.  Not by intent, but by oversight.

I posed a couple of questions to H.W. off list to pass on to
the silicon grower's department.  Will see what they recommend.

At the moment, I am stuck with brute-force code reading.
Nothing very elegant going on here.

Mike

> There are some special bit functions that always have LOCK, but these
> are only used by the Xen drivers afaik (that is needed when a UP
> kernel talks to a SMP hypervisor over shared memory)
> 
> > I agree.  I was not referring to any real/known driver.  I was just trying to
> > figure out what kind of problem the VIA/Centaur CPU guys tried to describe when
> > indicating that the LOCK prefix should be used on UP to avoid DMA interfering
> > with read-modify-write CPU instructions.
> 
> It locks the cache line. That's a valid case in the x86 architecture,
> it's just that the Linux driver model doesn't use it.
> 
> -Andi
> 



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZFBM4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZFBM4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 08:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbZFBM4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 08:56:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60978 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbZFBM4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:56:38 -0400
Date: Tue, 2 Jun 2009 15:03:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       lkml@morethan.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: LOCK prefix on uni processor has its use
Message-ID: <20090602130343.GI1065@one.firstfloor.org>
References: <200905221139.26941.lkml@morethan.org> <200905221946.01808.lkml@morethan.org> <4A1748A9.1020306@zytor.com> <200905231304.55973.lkml@morethan.org> <4A188A48.5000208@zytor.com> <20090527170118.GC4024@prithivi.gnumonks.org> <87vdnmmnac.fsf@basil.nowhere.org> <20090602124854.GB9823@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602124854.GB9823@prithivi.gnumonks.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 02:48:54PM +0200, Harald Welte wrote:
> On Wed, May 27, 2009 at 08:08:27PM +0200, Andi Kleen wrote:
> > Harald Welte <HaraldWelte@viatech.com> writes:
> > > * All X86 instructions except rep-strings are atomic wrt interrupts.
> > > * The lock prefix has uses on a UP processor: It keeps DMA devices from
> > >   interfering with a read-modify-write sequence
> > 
> > In theory yes, but not in Linux -- normal drivers simply don't use LOCK in
> > any way on a UP kernel.
> 
> well, they might have inadvertedly used LOCK as part of regular spinlocks,
> until LOCK_PREFIX was removed, right?

LOCK_PREFIX was always defined away on UP kernels. That dates back
to the initial Linux 2.0 SMP implementation. 

On newer SMP kernels they also patch away the lock prefix even
if they are running UP, so if you only have a single core you'll
never get lock.

So I think it's pretty unlikely any driver relied on this.

There are some special bit functions that always have LOCK, but these
are only used by the Xen drivers afaik (that is needed when a UP
kernel talks to a SMP hypervisor over shared memory)

> I agree.  I was not referring to any real/known driver.  I was just trying to
> figure out what kind of problem the VIA/Centaur CPU guys tried to describe when
> indicating that the LOCK prefix should be used on UP to avoid DMA interfering
> with read-modify-write CPU instructions.

It locks the cache line. That's a valid case in the x86 architecture,
it's just that the Linux driver model doesn't use it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

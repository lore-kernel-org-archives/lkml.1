Return-Path: <linux-kernel-owner+w=401wt.eu-S1763628AbZD3QVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763628AbZD3QVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbZD3QVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:21:09 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:46218 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbZD3QVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:21:08 -0400
Date: Thu, 30 Apr 2009 12:11:26 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090430160606.GA5913@elte.hu>
Message-ID: <alpine.DEB.1.10.0904301209140.4028@qirst.com>
References: <20090430133859.GB8329@elte.hu> <alpine.DEB.1.10.0904300938220.22262@qirst.com> <20090430141446.GD14696@elte.hu> <alpine.DEB.1.10.0904301013110.14178@qirst.com> <20090430143819.GF14696@elte.hu> <alpine.DEB.1.10.0904301042170.4028@qirst.com>
 <20090430150142.GC20580@elte.hu> <alpine.DEB.1.10.0904301114440.4028@qirst.com> <20090430154255.GA3714@elte.hu> <alpine.DEB.1.10.0904301142140.4028@qirst.com> <20090430160606.GA5913@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Ingo Molnar wrote:

> > may not care too much about a event counter missing a beat once in
> > a while for platforms not supporting atomic per cpu ops. I know
> > this affects IA64. The cost of an atomic operations for an event
> > counter update (which would have avoided the potential of a
> > concurrent update) was not justifiable.
>
> when you say "atomics", do you mean the classic meaning of atomics?
> Because there are no classic atomics involved. This is the
> before/after disassembly from Eric's commit 4e69489a0:

The fallback for IA64 would be to use full (classic) atomic operations
(fetchadd) instead of fast atomic vs. interrupt as available on x86

> c0436275:   64 83 05 20 5f 6a c0    addl   $0x1,%fs:0xc06a5f20
>
> There's no atomic instructions at all - the counters here are only
> accessed locally. They are local-irq-atomic, but not
> cacheline-atomic.

Right but that is not available on IA64. So one must choose between
manually disabling interrupts and then increment the counter (long code
sequence) and a classic atomic operation for the fallback.

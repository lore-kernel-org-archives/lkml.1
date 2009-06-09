Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbZFIQCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbZFIQCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbZFIQCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:02:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753437AbZFIQCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:02:12 -0400
Date: Tue, 9 Jun 2009 09:00:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
In-Reply-To: <20090609153847.GB9211@wotan.suse.de>
Message-ID: <alpine.LFD.2.01.0906090849080.6847@localhost.localdomain>
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain>
 <20090609093918.GC16940@wotan.suse.de> <alpine.LFD.2.01.0906090749380.6847@localhost.localdomain> <20090609153847.GB9211@wotan.suse.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Jun 2009, Nick Piggin wrote:
> 
> If it's such a problem, it could be made a lot faster without too
> much problem. You could just introduce a FIFO of ptes behind it 
> and flush them all in one go. 4K worth of ptes per CPU might
> hopefully bring your overhead down to < 1%.

We already have that. The regular kmap() does that. It's just not usable 
in atomic context.

We'd need to fix the locking: right now kmap_high() uses non-irq-safe 
locks, and it does that whole cross-cpu flushing thing (which is why 
those locks _have_ to be non-irq-safe.

The way to fix that, though, would be to never do any cross-cpu calls, and 
instead just have a cpumask saying "you need to flush before you do 
anything with kmap".  So you'd just set that cpumask inside the lock, and 
if/when some other CPU does a kmap, they'd flush their local TLB at _that_ 
point instead of having to have an IPI call.

If we can get rid of kmap_atomic(), I'd already like HIGHMEM more. Right 
now I absolutely _hate_ all the different "levels" of kmap_atomic() and 
having to be careful about crazy nesting rules etc.

		Linus

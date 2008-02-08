Return-Path: <linux-kernel-owner+w=401wt.eu-S1759642AbYBHWAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642AbYBHWAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759592AbYBHV7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:59:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48949 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758354AbYBHV7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:59:46 -0500
Date: Fri, 8 Feb 2008 13:58:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Andi Kleen <andi@firstfloor.org>, Maxim Levitsky <maximlevitsky@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [RFC][PATCH] KGDB: remove kgdb-own fault handling (was: Re: [git
 pull] x86 arch updates for v2.6.25)
In-Reply-To: <47ACC97C.3000806@web.de>
Message-ID: <alpine.LFD.1.00.0802081347150.2896@woody.linux-foundation.org>
References: <20080130011550.GA31853@elte.hu> <200802050436.31070.maximlevitsky@gmail.com> <alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org> <p73ejbn2xk2.fsf@bingen.suse.de> <47AC95FC.5090701@siemens.com> <20080208185719.GA11573@one.firstfloor.org>
 <47ACC97C.3000806@web.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Feb 2008, Jan Kiszka wrote:
> 
> Well, let's try it this way: Find below a patch against kgdb.git that
> removes the special fault handling (this wouldn't be the first feature I
> recently removed from kgdb :->). Light testing revealed no obvious
> problems yet.

That is indeed horrible code. No way will I merge anything that has things 
like that even in it's *history* (ie somebody needs to re-generate the 
tree without code like that - some things should not be allowed to exist).

That said, while just using "probe_kernel_addr()" is certainly much 
better, it's still really inefficient. If you actually want to do a "safe 
memory copy", then the right way to do that is basically to do

	pagefault_disable();
	leftover = __copy_from_user_inatomic(dst, src, count);
	pagefault_enable();

	if (leftover)
		handle_the_fact_that_the_copy_didnt_complete();

which should even be reasonably efficient and should work in all contexts 
(hardware interrupts disabled, spinlocks held, you name it).

So all those "kgdb_{get|set}_mem()" things seem bogus (they also have 
insane calling semantics - return NULL or errptr? Why not just return an 
integer error code?

		Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S932413AbXBNSDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbXBNSDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 13:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932417AbXBNSDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 13:03:51 -0500
Received: from kanga.kvack.org ([66.96.29.28]:49610 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413AbXBNSDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 13:03:50 -0500
Date: Wed, 14 Feb 2007 13:03:44 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/11] syslets: core, documentation
Message-ID: <20070214180344.GI32271@kvack.org>
References: <20060529212109.GA2058@elte.hu> <20070213142042.GG638@elte.hu> <20070214103655.GB4241@flint.arm.linux.org.uk> <20070214105039.GC6801@elte.hu> <20070214110419.GC4241@flint.arm.linux.org.uk> <Pine.LNX.4.64.0702140919200.7480@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702140919200.7480@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 09:52:20AM -0800, Davide Libenzi wrote:
> That'd be, instead of passing a chain of atoms, with the kernel 
> interpreting conditions, and parameter lists, etc..., we let gcc 
> do this stuff for us, and we pass the "clet" :) pointer to sys_async_exec, 
> that exec the above under the same schedule-trapped environment, but in 
> userspace. We setup a special userspace ad-hoc frame (ala signal), and we 
> trap underneath task schedule attempt in the same way we do now.
> We setup the frame and when we return from sys_async_exec, we basically 
> enter the "clet", that will return to a ret_from_async, that will return 
> to userspace. Or, maybe we can support both. A simple single-syscall exec 
> in the way we do now, and a clet way for the ones that requires chains and 
> conditions. Hmmm?

Which is just the same as using threads.  My argument is that once you 
look at all the details involved, what you end up arriving at is the 
creation of threads.  Threads are relatively cheap, it's just that the 
hardware currently has several performance bugs with them on x86 (and more 
on x86-64 with the MSR fiddling that hits the hot path).  Architectures 
like powerpc are not going to benefit anywhere near as much from this 
exercise, as the state involved is processed much more sanely.  IA64 as 
usual is simply doomed by way of having too many registers to switch.

If people really want to go down this path, please make an effort to compare 
threads on a properly tuned platform.  This means that things like the kernel 
and userland stacks must take into account the cache alignment (we do some 
of this already, but there are some very definate L1 cache colour collisions 
between commonly hit data structures amongst threads).  The existing AIO 
ringbuffer suffers from this, as important data is always on the beginning 
of the first page.  Yes, these might be microoptimizations, but accumulated 
changes of this nature have been known to buy 100%+ improvements in 
performance.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <dont@kvack.org>.

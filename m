Return-Path: <linux-kernel-owner+w=401wt.eu-S964780AbXBNVoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780AbXBNVoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964779AbXBNVoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:44:19 -0500
Received: from kanga.kvack.org ([66.96.29.28]:52041 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964780AbXBNVoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:44:17 -0500
Date: Wed, 14 Feb 2007 16:44:09 -0500
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
Message-ID: <20070214214409.GM32271@kvack.org>
References: <20070214103655.GB4241@flint.arm.linux.org.uk> <20070214105039.GC6801@elte.hu> <20070214110419.GC4241@flint.arm.linux.org.uk> <Pine.LNX.4.64.0702140919200.7480@alien.or.mcafeemobile.com> <20070214180344.GI32271@kvack.org> <Pine.LNX.4.64.0702141135390.7796@alien.or.mcafeemobile.com> <20070214200347.GK32271@kvack.org> <Pine.LNX.4.64.0702141206190.7796@alien.or.mcafeemobile.com> <20070214203438.GL32271@kvack.org> <Pine.LNX.4.64.0702141241030.7796@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702141241030.7796@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 01:06:59PM -0800, Davide Libenzi wrote:
> Bear with me Ben, and let's follow this up :) If you are in the middle of 
> an MMX copy operation, inside the syscall, you are:
> 
> - Userspace, on task A, calls sys_async_exec
> 
> - Userspace in _not_ doing any MMX stuff before the call

That's an incorrect assumption.  Every task/thread in the system has FPU 
state associated with it, in part due to the fact that glibc has to change 
some of the rounding mode bits, making them different than the default from 
a freshly initialized state.

> - We wake task B that will return to userspace

At which point task B has to touch the FPU in userspace as part of the 
cleanup, which adds back in an expensive operation to the whole process.

The whole context switch mechanism is a zero sum game -- everything that 
occurs does so because it *must* be done.  If you remove something at one 
point, then it has to occur somewhere else.

My opinion of this whole thread is that it implies that our thread creation 
and/or context switch is too slow.  If that is the case, improve those 
elements first.  At least some of those optimizations have to be done in 
hardware on x86, while on other platforms are probably unnecessary.

Fwiw, there are patches floating around that did AIO via kernel threads 
for file descriptors that didn't implement AIO (and remember: kernel thread 
context switches are cheaper than userland thread context switches).  At 
least take a stab at measuring what the performance differences are and 
what optimizations are possible before prematurely introducing a new "fast" 
way of doing things that adds a bunch more to maintain.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <dont@kvack.org>.

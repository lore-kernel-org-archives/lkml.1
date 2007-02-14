Return-Path: <linux-kernel-owner+w=401wt.eu-S1751194AbXBNTp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbXBNTp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932506AbXBNTp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:45:26 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:2597 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbXBNTp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:45:26 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 14 Feb 2007 11:45:23 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Benjamin LaHaise <bcrl@kvack.org>
cc: Russell King <rmk+lkml@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <20070214180344.GI32271@kvack.org>
Message-ID: <Pine.LNX.4.64.0702141135390.7796@alien.or.mcafeemobile.com>
References: <20060529212109.GA2058@elte.hu> <20070213142042.GG638@elte.hu>
 <20070214103655.GB4241@flint.arm.linux.org.uk> <20070214105039.GC6801@elte.hu>
 <20070214110419.GC4241@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0702140919200.7480@alien.or.mcafeemobile.com>
 <20070214180344.GI32271@kvack.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007, Benjamin LaHaise wrote:

> On Wed, Feb 14, 2007 at 09:52:20AM -0800, Davide Libenzi wrote:
> > That'd be, instead of passing a chain of atoms, with the kernel 
> > interpreting conditions, and parameter lists, etc..., we let gcc 
> > do this stuff for us, and we pass the "clet" :) pointer to sys_async_exec, 
> > that exec the above under the same schedule-trapped environment, but in 
> > userspace. We setup a special userspace ad-hoc frame (ala signal), and we 
> > trap underneath task schedule attempt in the same way we do now.
> > We setup the frame and when we return from sys_async_exec, we basically 
> > enter the "clet", that will return to a ret_from_async, that will return 
> > to userspace. Or, maybe we can support both. A simple single-syscall exec 
> > in the way we do now, and a clet way for the ones that requires chains and 
> > conditions. Hmmm?
> 
> Which is just the same as using threads.  My argument is that once you 
> look at all the details involved, what you end up arriving at is the 
> creation of threads.  Threads are relatively cheap, it's just that the 
> hardware currently has several performance bugs with them on x86 (and more 
> on x86-64 with the MSR fiddling that hits the hot path).  Architectures 
> like powerpc are not going to benefit anywhere near as much from this 
> exercise, as the state involved is processed much more sanely.  IA64 as 
> usual is simply doomed by way of having too many registers to switch.

Sort of, except that the whole thing can complete syncronously w/out 
context switches. The real point of the whole fibrils/syslets solution is 
that kind of optimization. The solution is as good as it is now, for 
single syscalls (modulo sys_async_cancel implementation), but for multiple 
chained submission it kinda stinks IMHO. Once you have to build chains, 
and conditions, and new syscalls to implement userspace variable 
increments, and so on..., at that point it's better to have the chain to 
be coded in C ala thread proc. Yes, it requires a frame setup and another 
entry to the kernel, but IMO that will be amortized in the cost of the 
multiple syscalls inside the "clet".



- Davide



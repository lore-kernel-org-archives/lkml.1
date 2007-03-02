Return-Path: <linux-kernel-owner+w=401wt.eu-S965605AbXCBUxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965605AbXCBUxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 15:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965606AbXCBUxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 15:53:32 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3163 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965605AbXCBUxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 15:53:31 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 2 Mar 2007 12:53:28 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070302202931.GA5101@elte.hu>
Message-ID: <Pine.LNX.4.64.0703021246380.2381@alien.or.mcafeemobile.com>
References: <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com>
 <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru>
 <20070301150942.GA26025@elte.hu> <20070301153655.GB8217@2ka.mipt.ru>
 <20070302105713.GB15576@elte.hu> <Pine.LNX.4.64.0703020928580.1977@alien.or.mcafeemobile.com>
 <20070302193941.GB8450@elte.hu> <Pine.LNX.4.64.0703021212140.2381@alien.or.mcafeemobile.com>
 <20070302202931.GA5101@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Ingo Molnar wrote:

> 
> * Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > I think that the "dirty" FPU context must, at least, follow the new 
> > head. That's what the userspace sees, and you don't want an async_exec 
> > to re-emerge with a different FPU context.
> 
> well. I think there's some confusion about terminology, so please let me 
> describe everything in detail. This is how execution goes:
> 
>   outer loop() {
>       call_threadlet();
>   }
> 
> this all runs in the 'head' context. call_threadlet() always switches to 
> the 'threadlet stack'. The 'outer context' runs in the 'head stack'. If, 
> while executing the threadlet function, we block, then the 
> threadlet-thread gets to keep the task (the threadlet stack and also the 
> FPU), and blocks - and we pick a 'new head' from the thread pool and 
> continue executing in that context - right after the call_threadlet() 
> function, in the 'old' head's stack. I.e. it's as if we returned 
> immediately from call_threadlet(), with a return code that signals that 
> the 'threadlet went async'.
> 
> now, the FPU state that was when the threadlet blocked is totally 
> meaningless to the 'new head' - that FPU state is from the middle of the 
> threadlet execution.

For threadlets, it might be. Now think about a task wanting to dispatch N 
parallel AIO requests as N independent syslets.
Think about this task having USEDFPU set, so the FPU context is dirty.
When it returns from async_exec, with one of the requests being become 
sleepy, it needs to have the same FPU context it had when it entered, 
otherwise it won't prolly be happy.
For the same reason a schedule() must preserve/sync the "prev" FPU 
context, to be reloaded at the next FPU fault.




> > So, IMO, if the USEDFPU bit is set, we need to sync the dirty FPU 
> > context with an early unlazy_fpu(), *and* copy the sync'd FPU context 
> > to the new head. This should really be a fork of the dirty FPU context 
> > IMO, and should only happen if the USEDFPU bit is set.
> 
> why? The only effect this will have is a slowdown :) The FPU context 
> from the middle of the threadlet function is totally meaningless to the 
> 'new head'. It might be anything. (although in practice system calls are 
> almost never called with a truly in-use FPU.)

See above ;)



- Davide



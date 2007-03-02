Return-Path: <linux-kernel-owner+w=401wt.eu-S965480AbXCBUSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965480AbXCBUSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 15:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965567AbXCBUSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 15:18:43 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3136 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965480AbXCBUSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 15:18:42 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 2 Mar 2007 12:18:39 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070302193941.GB8450@elte.hu>
Message-ID: <Pine.LNX.4.64.0703021212140.2381@alien.or.mcafeemobile.com>
References: <20070301095402.GA14603@elte.hu> <20070301131118.GA30228@elte.hu>
 <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com>
 <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru>
 <20070301150942.GA26025@elte.hu> <20070301153655.GB8217@2ka.mipt.ru>
 <20070302105713.GB15576@elte.hu> <Pine.LNX.4.64.0703020928580.1977@alien.or.mcafeemobile.com>
 <20070302193941.GB8450@elte.hu>
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
> > [...] We're still missing proper FPU context switch in the 
> > move_user_context(). [...]
> 
> yeah - i'm starting to be of the opinion that the FPU context should 
> stay with the threadlet, exclusively. I.e. when calling a threadlet, the 
> 'outer loop' (the event loop) should not leak FPU context into the 
> threadlet and then expect it to be replicated from whatever random point 
> the threadlet ended up sleeping at. It would be possible, but it just 
> makes no sense. What makes most sense is to just keep the FPU context 
> with the threadlet, and to let the 'new head' use an initial (unused) 
> FPU context. And it's in fact the threadlet that will most likely have 
> an acrive FPU context across a system call, not the outer loop. In other 
> words: no special FPU support needed at all for threadlets (i.e. no 
> flipping needed even) - this behavior just naturally happens in the 
> current implementation. Hm?

I think that the "dirty" FPU context must, at least, follow the new head. 
That's what the userspace sees, and you don't want an async_exec to 
re-emerge with a different FPU context.
I think it should also follow the async thread (old, going-to-sleep, 
thread), since a threadlet might have that dirtied, and as a consequence 
it'll want to find it back when it's re-scheduled.
So, IMO, if the USEDFPU bit is set, we need to sync the dirty  FPU context 
with an early unlazy_fpu(), *and* copy the sync'd FPU context to the new head.
This should really be a fork of the dirty FPU context IMO, and should only 
happen if the USEDFPU bit is set.



- Davide



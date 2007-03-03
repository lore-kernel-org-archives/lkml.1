Return-Path: <linux-kernel-owner+w=401wt.eu-S1751275AbXCCJCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbXCCJCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 04:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbXCCJCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 04:02:30 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:32829 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbXCCJC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 04:02:29 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 3 Mar 2007 01:02:24 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070303071933.GA2241@elte.hu>
Message-ID: <Pine.LNX.4.64.0703030026500.5290@alien.or.mcafeemobile.com>
References: <20070302105713.GB15576@elte.hu> <Pine.LNX.4.64.0703020928580.1977@alien.or.mcafeemobile.com>
 <20070302193941.GB8450@elte.hu> <Pine.LNX.4.64.0703021212140.2381@alien.or.mcafeemobile.com>
 <20070302202931.GA5101@elte.hu> <Pine.LNX.4.64.0703021246380.2381@alien.or.mcafeemobile.com>
 <1172871820.2999.22.camel@entropy> <Pine.LNX.4.64.0703021615140.2381@alien.or.mcafeemobile.com>
 <1172885761.2999.32.camel@entropy> <Pine.LNX.4.64.0703021746060.2381@alien.or.mcafeemobile.com>
 <20070303071933.GA2241@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2007, Ingo Molnar wrote:

> * Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > [...] Status word and control bits should not be changed from 
> > underneath userspace AFAIK. [...]
> 
> Note that the control bits do not just magically change during normal 
> FPU use. It's a bit like sys_setsid()/iopl/etc., it makes little sense 
> to change those per-thread anyway. This is a non-issue anyway - what is 
> important is that the big bulk of 512 (or more) bytes of FPU state /are/ 
> callee-saved (both on 32-bit and on 64-bit), hence there's no need to 
> unlazy anything or to do expensive FPU state saves or other FPU juggling 
> around threadlet (or even syslet) use.

Well, the unlazy/sync happen in any case later when we switch (given 
TS_USEDFPU set). We'd avoid a copy of it given the above conditions true. 
Wouldn't it makes sense to carry over only the status word and the control 
bits eventually?
Also, if the caller saves the whole context, and if we're scheduled while 
inside a system call (not totally unfrequent case), can't we implement a 
smarter unlazy_fpu that avoids fxsave during schedule-out and frstor after 
schedule-in (do not do stts on this condition, so the newly scheduled 
task don't get a fault at all)? If the above conditions are true (no need 
context-copy for new head in async_exec), this should be possible too.


- Davide



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYKQSOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYKQSOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYKQSOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:14:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49901 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYKQSOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:14:04 -0500
Date: Mon, 17 Nov 2008 19:23:40 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@lusi.uni-sb.de>,
       Glauber Costa <gcosta@redhat.com>
Subject: Re: [RFC] x86: save_args out of line
Message-ID: <20081117182340.GN6703@one.firstfloor.org>
References: <1226845741-12470-1-git-send-email-heukelum@fastmail.fm> <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117125317.GK6703@one.firstfloor.org> <1226936257.32609.1285214311@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226936257.32609.1285214311@webmail.messagingengine.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I liked this way of calling an external function, because it
> circumvents exactly most of this ugly setup. For two bytes

It's not too ugly, just one field is swapped. 

> extra per stub, one can make this setup function a completely
> normal one (without relocating the return address on the stack).
> I intended the stubs to fit in one cache line (32 bytes) as it

Cache lines are 64 bytes on pretty much all modern x86 CPUs.

> does not make much sense to make them smaller than that. A
> further advantage is that no indirect call is needed, but maybe
> this is not as slow anymore as it used to be? B.t.w., I intended

It depends on the CPU. But always it requires resources which
someone else might have already swamped.

> to change the exception handler stubs in a similar way to get
> rid of the indirect call.

Ok. Hopefully it's worth the effort. The branch misprediction bubble
should not be too bad, perhaps it'll make up for the other cycles
you're adding. But even if it doesn't decreasing cache line foot print is 
always a good thing.

> The second copy of %rbp is indeed placed at the 'correct' position
> inside the pt_regs struct. However, at this point only a partial
> stack frame is saved: the C argument registers and the scratch
> registers. r12-r15,ebp,and rbx will be saved only later if necessary.
> A problem could arise if some code uses pt_regs.bp of this partial
> stack frame, because it will contain a bogus value. Glauber's patch

Well they shouldn't -- 

> makes pt_regs.bp contain the right value most of the time... Which
> means that if the patch fixed something for him, the problem has only
> been made unlikely to happen. The place where things should be fixed
> are the places where pt_regs.bp is used, but not filled in.

Hmm I first thought it was rather so that backtracing over the exception
stubs with FPs works better. But then it didn't even set up
a correct frame for that so it might have been something else.

The original design was that you should only use these extended
registers in special calls that go through the PTREGS stubs.

But then sysprof/oprofile application profiling was added which
wants to do user space backtracing using FPs (which seemed pointless to me
because most/all of 64bit user space and recently also pretty
much all 32bit user space is compiled without FPs by default)

The only way to make this work though is to always save RBP.
But there is no need to do the strange double saving, you
can just store it always directly.

But I personally have doubts its worth making every interrupt
/syscall slower since it won't work with most apps anyways.
The only sure way to do these backtraces is to do dwarf2 unwinding
in user space too which doesn't need hacks like this.

-Andi

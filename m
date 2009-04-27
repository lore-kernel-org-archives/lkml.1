Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbZD0S3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbZD0S3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbZD0S3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:29:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591AbZD0S3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:29:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
       linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Subject: Re: arch/ && tracehook_report_syscall_xxx()
In-Reply-To: Oleg Nesterov's message of  Monday, 27 April 2009 20:04:55 +0200 <20090427180455.GA32509@redhat.com>
References: <20090427180455.GA32509@redhat.com>
X-Windows: power tools for power fools.
Message-Id: <20090427182919.B923DFC3BF@magilla.sf.frob.com>
Date: Mon, 27 Apr 2009 11:29:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We have a lot of code like arch/alpha/kernel/ptrace.c:syscall_trace()
> in arch/ and I can't see how to convert them to use tracehooks.
> 
> The first problem, we don't know which hook should be called, there is
> no entry/exit argument.

These arch maintainers just need to update their code.  Christoph has
started poking arch folks individually about getting up to speed.

IMHO, it is better anyway to use separate entry/exit calls.  For that
change, it is often easy to see how to do it correctly in the assembly code
without really knowing the arch at all.  (There are separate assembly paths
leading to the calls for entry vs exit cases already, just change the
symbol names.  Adding an argument would require a bit of a clue about
assembly on the arch.)

> Still, I think it is better to change this code right now, and call
> ptrace_report_syscall() directly.

I disagree.  Let the arch code get with the modern style.  
It is just a minute's hack for the arch maintainer.

> But, the second problem, there is no "struct pt_regs *".

They can use task_pt_regs(), it gets the same pointer.  It's passed in as
an argument because usually the arch really does have it handy right there
in a register so it's cheaper than recalculating.  (All the non-ancient
arch code uses it there for audit_syscall_{entry,exit} calls too.)

> However. I can't imagine how ptrace_report_syscall(regs) can actually
> use "regs". Perhaps we can remove this argument?

ptrace_report_syscall doesn't need it, it could be removed.  But that is
not apropos to the arch code, which should use tracehook_* properly.

> Hmm... and I can't understand how to change
> arch/mn10300/kernel/ptrace.c:do_syscall_trace(), it does something
> strange with TIF_SINGLESTEP. (maintainers cc'ed).

We can leave those details to the arch maintainers.  That case looks to me
like old hacks for step-over-syscall behavior, which made the opposite
choice (between |0x80 or not for stepping) from what x86 made.  Probably
they just want to match the new "norms" and not try to do anything
different for single-step in syscall tracing.


Thanks,
Roland

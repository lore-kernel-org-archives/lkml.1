Return-Path: <linux-kernel-owner+w=401wt.eu-S1763950AbYCFMRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763950AbYCFMRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYCFMRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:17:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbYCFMRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:17:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix typo(?) in step.c
In-Reply-To: Ingo Molnar's message of  Thursday, 6 March 2008 12:34:13 +0100 <20080306113413.GD17906@elte.hu>
References: <47CE69B0.76E4.0078.0@novell.com>
	<20080305134150.GA16477@elte.hu>
	<20080306075223.BA28B2700FD@magilla.localdomain>
	<20080306113413.GD17906@elte.hu>
Emacs: because extension languages should come with the editor built in.
Message-Id: <20080306121648.A53FA2700FD@magilla.localdomain>
Date: Thu,  6 Mar 2008 04:16:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> my interpretation of the bug would be that we fail to mask out the 
> block-step MSR bit [because we mask out bit 25 instead of bit 1], and 
> hence the bug would cause that MSR bit to stay enabled in other tasks 
> too.

The wrong bit is in calls to write_debugctlmsr, only used when setting up a
thread to step.  It does not affect context switch, so it would never have
an effect on other tasks as you suggest here.

> So in theory the bug should manifest itself as block-step mode never 
> clearing itself, once activated. 

That doesn't happen in the trivial sense of "never", because in the normal
case an actual block-step exception happens and that makes the hardware
clear BTF from the MSR (as well as TF from eflags).  So it would only come
up in a more obscure case.  That is, you set up for block-step but didn't
actually finish the user-mode instruction block.  e.g. interrupted by a
signal or faulting instruction.  The child stops again but not by SIGTRAP,
and next time you don't block-step it.  Then, the BTF bit stays set in
thread.debugctlmsr and gets switched back in when the child runs again.
If you then resume with single-step instead, it will block-step because
BTF is set, but you wanted instruction-step.  Like I said, I didn't
produce a case that behaved that way.  I may be overlooking something.
But that's the scenario I imagine.

> (but this would never leak into other tasks because we've got the
> thread.debugctlmsr abstraction that protects them)

Correct.


Thanks,
Roland

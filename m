Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYJDOoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYJDOoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 10:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbYJDOoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 10:44:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41217 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbYJDOoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 10:44:37 -0400
Date: Sat, 4 Oct 2008 16:44:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/3] ring-buffer: less locking and only disable
	preemption
Message-ID: <20081004144423.GA14918@elte.hu>
References: <20081004060057.660306328@goodmis.org> <20081004084002.GE27624@elte.hu> <alpine.DEB.1.10.0810041015330.4551@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810041015330.4551@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> The dynamic function tracer is another issue. The problem with NMIs 
> has nothing to do with locking, or corrupting the buffers. It has to 
> do with the dynamic code modification.  Whenever we modify code, we 
> must guarantee that it will not be executed on another CPU.
> 
> Kstop_machine serves this purpose rather well. We can modify code 
> without worrying it will be executed on another CPU, except for NMIs. 
> The problem now comes where an NMI can come in and execute the code 
> being modified. That's why I put in all the notrace, lines. But it 
> gets difficult because of nmi_notifier can call all over the kernel.  
> Perhaps, we can simply disable the nmi-notifier when we are doing the 
> kstop_machine call?

that would definitely be one way to reduce the cross section, but not 
enough i'm afraid. For example in the nmi_watchdog=2 case we call into 
various lapic functions and paravirt lapic handlers which makes it all 
spread to 3-4 paravirtualization flavors ...

sched_clock()'s notrace aspects were pretty manageable, but this in its 
current form is not.

	Ingo

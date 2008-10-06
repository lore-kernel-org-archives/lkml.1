Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYJFNxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYJFNxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 09:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYJFNx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 09:53:27 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:40895 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751366AbYJFNx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 09:53:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUEACC16UhMQWq+/2dsb2JhbACBcblOgWo
Date: Mon, 6 Oct 2008 09:53:24 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/3] ring-buffer: less locking and only disable
	preemption
Message-ID: <20081006135324.GB1808@Krystal>
References: <20081004060057.660306328@goodmis.org> <20081004084002.GE27624@elte.hu> <alpine.DEB.1.10.0810041015330.4551@gandalf.stny.rr.com> <20081004144423.GA14918@elte.hu> <20081004174121.GA1337@elte.hu> <20081004222713.GA1813@Krystal> <20081005101341.GH29909@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081005101341.GH29909@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:46:25 up 123 days, 18:26,  9 users,  load average: 0.50, 0.30,
	0.30
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 
> > explains that code modification on x86 SMP systems is not only a 
> > matter of atomicity, but also a matter of not changing the code 
> > underneath a running CPU which is making assumptions that it won't 
> > change underneath without issuing a synchronizing instruction before 
> > the new code is used by the CPU. The scheme you propose here takes 
> > care of atomicity, but does not take care of the synchronization 
> > problem. A sync_core() would probably be required when such 
> > modification is detected.
> 
> that's wrong, my scheme protects against these cases: before _any_ code 
> is modified we set the redo_pending atomic flag, and make sure that 
> previous NMI handlers have stopped executing. (easy enough)
> 

Hi Ingo,

Hrm, how will this take care of the following race ?

CPU A                                CPU B
- NMI fires
- NMI handler checks for
    redo_pending flag, == 0
- NMI handler runs code              - set redo_pending
    about to be modified
                                     - NMI fires
                                     - NMI handler checks redo_pending,
                                       == 1, executes modify_code_redo()
           -- race : NMI on A executes code modified by B --
- NMI handler finished running
    code about to be modified

Mathieu

> then the atomic update of redo_pending should be a sufficient barrier 
> for another CPU to notice the pending transaction.
> 
> Note that the cross-CPU modification can still be 'half done' when the 
> NMI hits, that's why we execute modify_code_redo() to 'redo' the full 
> modification before executing further NMI code. That is executed _on the 
> CPU_ that triggers an NMI, and the CPU itself is self-consistent.
> 
> ( The modify_code_redo() will have to do a sync_cores() of course, like 
>   all self-modifying code, to flush speculative execution. )
> 
> > Also, speaking of plain atomicity, you scheme does not seem to protect 
> > against NMIs running on a different CPU, because the non-atomic change 
> > could race with such NMI.
> 
> That's wrong too. Another CPU will notice that redo_pending is set and 
> will execute modify_code_redo() from its NMI handler _before_ calling 
> all the notifiers and other 'wide' code paths.
> 
> the only item that needs to be marked 'notrace' is only the highlevel 
> do_nmi() handler itself. (as that executes before we have a chance to 
> execute modify_code_redo())
> 
> So we trade a large, fragile, and unmapped set of NMI-implicated 
> codepaths for a very tight and well controlled an easy to maintain 
> codepath.
> 
> 	Ingo
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

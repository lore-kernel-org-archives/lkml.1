Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbZC0O24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbZC0O24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbZC0O2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:28:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbZC0O2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:28:47 -0400
Date: Fri, 27 Mar 2009 10:28:43 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Maneesh Soni <maneesh@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] tracing/wakeup: move access to wakeup_cpu into
 spinlock
In-Reply-To: <20090327134136.GG5976@nowhere>
Message-ID: <alpine.DEB.2.00.0903270959520.1917@gandalf.stny.rr.com>
References: <20090326122806.GA4188@in.ibm.com> <20090326132739.GB5960@nowhere> <alpine.DEB.2.00.0903260949340.17665@gandalf.stny.rr.com> <alpine.DEB.2.00.0903261032070.17665@gandalf.stny.rr.com> <20090327084144.GA23318@in.ibm.com> <20090327124532.GA9963@in.ibm.com>
 <alpine.DEB.2.00.0903270904260.1917@gandalf.stny.rr.com> <20090327134136.GG5976@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 27 Mar 2009, Frederic Weisbecker wrote:
> > 
> > Hmm, looking back at the call stack:
> > 
> > > >  [<ffffffff806f8264>] schedule+0xd99/0x10f9
> > > >  [<ffffffff806fb61b>] ? trace_hardirqs_on_thunk+0x3a/0x3c
> > > >  [<ffffffff8027d2cb>] ? delayed_work_timer_fn+0x0/0x38
> > > >  [<ffffffff8020d56d>] retint_careful+0x12/0x2e
> > 
> > I wonder if we do not set up a stack frame properly. retint_careful is 
> > called by assembly. I'll have a look at that
> 
> 
> Aah, indeed.
> May be should probe_kernel_address before saving
> the addresses.
> 

Looking at the retint_careful, I'm 90% sure that is the bug.

Unfortunately, the CALLER_ADDR2 is a built in gcc function.

Looks like only the wakeup latency tracer calls it, perhaps we should 
simply pass 0 instead?

-- Steve


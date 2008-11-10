Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbYKJEUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbYKJEUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 23:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbYKJEUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 23:20:09 -0500
Received: from relais.videotron.ca ([24.201.245.36]:33297 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYKJEUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 23:20:07 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 09 Nov 2008 23:20:00 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] clarify usage expectations for cnt32_to_63()
In-reply-to: <20081109162250.GB10181@Krystal>
Message-id: <alpine.LFD.2.00.0811092304300.13034@xanadu.home>
References: <9405.1226101315@redhat.com>
 <20081108001555.GE18378@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.0811080939180.13034@xanadu.home>
 <alpine.LFD.2.00.0811081746060.13034@xanadu.home>
 <20081109022549.GA18508@Krystal>
 <alpine.LFD.2.00.0811082143320.13034@xanadu.home>
 <alpine.LFD.2.00.0811082356090.13034@xanadu.home>
 <alpine.LFD.2.00.0811090015570.13034@xanadu.home>
 <20081109064855.GA23782@Krystal>
 <alpine.LFD.2.00.0811090827160.13034@xanadu.home>
 <20081109162250.GB10181@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008, Mathieu Desnoyers wrote:

> * Nicolas Pitre (nico@cam.org) wrote:
> > Do you really have such instances where multiple call sites are needed?  
> > That sounds even more confusing to me than the current model.  Better 
> > encapsulate the usage of this macro within some function which has a 
> > stronger meaning, such as sched_clock(), and call _that_ from multiple 
> > sites instead.
> 
> I see a few reasons for it :
> 
> - If we want to inline the whole read function so we don't pay the extra
>   runtime cost of a function call, this would become required.

You can inline it as you want as long as it remains in the same .c file.  
The static variable is still shared amongst all call sites in that case.

> - If we want to create a per cpu timer which updates the value
>   periodically without calling the function. We may want to add some
>   WARN_ON or some sanity tests in this periodic update that would not be
>   part of the standard read code. If we don't have access to this
>   variable outside of the macro, this becomes impossible.

I don't see how you could update the variable without calling the 
function somehow or duplicating it.  As to the sanity check argument: 
you can perform such checks on the result rather than the internal 
variable which IMHO would be more logical.

And if you want a per CPU version, then it's better to create a 
per_cpu_cnt32_to_63() variant which could use a relaxed barrier in that 
case.


Nicolas

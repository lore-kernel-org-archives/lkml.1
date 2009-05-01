Return-Path: <linux-kernel-owner+w=401wt.eu-S1762466AbZEARNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762466AbZEARNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764334AbZEARLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:11:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53546 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764310AbZEARLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:11:19 -0400
Date: Fri, 1 May 2009 13:11:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] ring-buffer: make cpu buffer entries counter
 atomic
In-Reply-To: <20090501165258.GA26143@elte.hu>
Message-ID: <alpine.DEB.2.00.0905011302150.20374@gandalf.stny.rr.com>
References: <20090501022210.851418183@goodmis.org> <20090501022403.826182932@goodmis.org> <20090501115047.GA24706@elte.hu> <alpine.DEB.2.00.0905011016560.20374@gandalf.stny.rr.com> <alpine.DEB.2.00.0905011212130.20374@gandalf.stny.rr.com> <20090501162053.GA17915@elte.hu>
 <alpine.DEB.2.00.0905011230350.20374@gandalf.stny.rr.com> <20090501165258.GA26143@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 1 May 2009, Ingo Molnar wrote:
> > The entries keeps track of the number of entries in the buffer. A 
> > writer (producer) adds to the counter and readers (consumers) 
> > subtract from them. A writer can subtract them if it overwrites a 
> > page before the producer consumes it.
> > 
> > Only the writers are pinned to a CPU, the readers happen on any 
> > CPU.
> 
> But that does not require atomicity. It requires careful use of 
> barriers, but otherwise atomicity is not needed. Update of machine 
> word variables (if they are aligned to a machine word) is guaranteed 
> to be atomic, even without atomic_t overhead.

I'm confused :-/ This throws out all that I learned in multi threaded 
programming.

If I have a shared variable used by two threads, the adding and 
subtracting of that variable does not need to be atomic?

        CPU0                 CPU1
        ----                 ----
	load A               load A
	sub  1, A            sub 1, A
	store A              store A

can work??

BTW, how expensive is an LOCK operation on a cache line that is not 
shared by other CPUs?  As long as a reader is not running, the updating of 
the variable is not shared.

Also, if this becomes a problem, I can just nuke the field. I like knowing 
the number of entries in the buffer, as well as the number of overruns. 
But these are more for debugging purposes. The overruns should probably be 
kept, because that is the only way a tracer can know if a overrun 
occurred. The number of entries in the buffer is not as important.

-- Steve

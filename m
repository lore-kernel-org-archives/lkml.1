Return-Path: <linux-kernel-owner+w=401wt.eu-S1762753AbZEARg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762753AbZEARg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbZEARgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:36:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33530 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbZEARgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:36:47 -0400
Date: Fri, 1 May 2009 13:36:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] ring-buffer: make cpu buffer entries counter
 atomic
In-Reply-To: <20090501171437.GA5932@elte.hu>
Message-ID: <alpine.DEB.2.00.0905011335320.20374@gandalf.stny.rr.com>
References: <20090501022210.851418183@goodmis.org> <20090501022403.826182932@goodmis.org> <20090501115047.GA24706@elte.hu> <alpine.DEB.2.00.0905011016560.20374@gandalf.stny.rr.com> <alpine.DEB.2.00.0905011212130.20374@gandalf.stny.rr.com> <20090501162053.GA17915@elte.hu>
 <alpine.DEB.2.00.0905011230350.20374@gandalf.stny.rr.com> <20090501165258.GA26143@elte.hu> <alpine.DEB.2.00.0905011302150.20374@gandalf.stny.rr.com> <20090501171437.GA5932@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 1 May 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Fri, 1 May 2009, Ingo Molnar wrote:
> > > > The entries keeps track of the number of entries in the buffer. A 
> > > > writer (producer) adds to the counter and readers (consumers) 
> > > > subtract from them. A writer can subtract them if it overwrites a 
> > > > page before the producer consumes it.
> > > > 
> > > > Only the writers are pinned to a CPU, the readers happen on any 
> > > > CPU.
> > > 
> > > But that does not require atomicity. It requires careful use of 
> > > barriers, but otherwise atomicity is not needed. Update of machine 
> > > word variables (if they are aligned to a machine word) is guaranteed 
> > > to be atomic, even without atomic_t overhead.
> > 
> > I'm confused :-/ This throws out all that I learned in multi threaded 
> > programming.
> > 
> > If I have a shared variable used by two threads, the adding and 
> > subtracting of that variable does not need to be atomic?
> > 
> >         CPU0                 CPU1
> >         ----                 ----
> > 	load A               load A
> > 	sub  1, A            sub 1, A
> > 	store A              store A
> > 
> > can work??
> 
> no, that wont work. But as long as there's just a single CPU that is 
> a _writer_ (does stores), it can be observed in an atomic/coherent 
> manner, without the use of atomics.

Ah, maybe there's confusion in my explanation. When I talk about writers 
and readers, I'm talking about those writers into the ring buffer and 
readers from the ring buffer. But both writers and readers write to the 
entries counter. Readers subtract and writers add. But writers can also 
subtract on overruns.

-- Steve


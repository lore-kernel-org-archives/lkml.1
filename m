Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbZEAQcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbZEAQcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 12:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZEAQcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 12:32:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60657 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbZEAQb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 12:31:59 -0400
Date: Fri, 1 May 2009 12:31:58 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] ring-buffer: make cpu buffer entries counter
 atomic
In-Reply-To: <20090501162053.GA17915@elte.hu>
Message-ID: <alpine.DEB.2.00.0905011230350.20374@gandalf.stny.rr.com>
References: <20090501022210.851418183@goodmis.org> <20090501022403.826182932@goodmis.org> <20090501115047.GA24706@elte.hu> <alpine.DEB.2.00.0905011016560.20374@gandalf.stny.rr.com> <alpine.DEB.2.00.0905011212130.20374@gandalf.stny.rr.com>
 <20090501162053.GA17915@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 1 May 2009, Ingo Molnar wrote:
> > > > > the counter too. This would cause missing entries to be added.
> > > > 
> > > > > -	unsigned long			entries;
> > > > > +	atomic_t			entries;
> > > > 
> > > > Hm, that's not really good as atomics can be rather expensive and 
> > > > this is the fastpath.
> > > 
> > > Actually, it could be local_t. I used that in a lot of the other places.
> > > The race is with on CPU not other CPUs, and on archs like x86 there
> > > is not cost of the "LOCK".
> > 
> > Ug, it must be atomic_t. It is also modified by the reader. Thus 
> > it is not only a race with a single CPU but also multiple CPUs.
> > 
> > This means that interrupts disabled is not the only proctection it 
> > needs. It must either be an atomic, or protected by a spinlock.
> 
> Trace buffers are rather fundamentally per cpu. Where's the problem?

The entries keeps track of the number of entries in the buffer. A writer 
(producer) adds to the counter and readers (consumers) subtract from them. 
A writer can subtract them if it overwrites a page before the producer 
consumes it.

Only the writers are pinned to a CPU, the readers happen on any CPU.

-- Steve


Return-Path: <linux-kernel-owner+w=401wt.eu-S1764238AbZEARm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764238AbZEARm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbZEARmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:42:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56451 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805AbZEARmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:42:46 -0400
Date: Fri, 1 May 2009 19:42:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] ring-buffer: make cpu buffer entries counter atomic
Message-ID: <20090501174228.GB9565@elte.hu>
References: <20090501022403.826182932@goodmis.org> <20090501115047.GA24706@elte.hu> <alpine.DEB.2.00.0905011016560.20374@gandalf.stny.rr.com> <alpine.DEB.2.00.0905011212130.20374@gandalf.stny.rr.com> <20090501162053.GA17915@elte.hu> <alpine.DEB.2.00.0905011230350.20374@gandalf.stny.rr.com> <20090501165258.GA26143@elte.hu> <alpine.DEB.2.00.0905011302150.20374@gandalf.stny.rr.com> <20090501171437.GA5932@elte.hu> <alpine.DEB.2.00.0905011335320.20374@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905011335320.20374@gandalf.stny.rr.com>
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

> 
> On Fri, 1 May 2009, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Fri, 1 May 2009, Ingo Molnar wrote:
> > > > > The entries keeps track of the number of entries in the buffer. A 
> > > > > writer (producer) adds to the counter and readers (consumers) 
> > > > > subtract from them. A writer can subtract them if it overwrites a 
> > > > > page before the producer consumes it.
> > > > > 
> > > > > Only the writers are pinned to a CPU, the readers happen on any 
> > > > > CPU.
> > > > 
> > > > But that does not require atomicity. It requires careful use of 
> > > > barriers, but otherwise atomicity is not needed. Update of machine 
> > > > word variables (if they are aligned to a machine word) is guaranteed 
> > > > to be atomic, even without atomic_t overhead.
> > > 
> > > I'm confused :-/ This throws out all that I learned in multi threaded 
> > > programming.
> > > 
> > > If I have a shared variable used by two threads, the adding and 
> > > subtracting of that variable does not need to be atomic?
> > > 
> > >         CPU0                 CPU1
> > >         ----                 ----
> > > 	load A               load A
> > > 	sub  1, A            sub 1, A
> > > 	store A              store A
> > > 
> > > can work??
> > 
> > no, that wont work. But as long as there's just a single CPU that is 
> > a _writer_ (does stores), it can be observed in an atomic/coherent 
> > manner, without the use of atomics.
> 
> Ah, maybe there's confusion in my explanation. When I talk about 
> writers and readers, I'm talking about those writers into the ring 
> buffer and readers from the ring buffer. But both writers and 
> readers write to the entries counter. Readers subtract and writers 
> add. But writers can also subtract on overruns.

a solution for that would be to split it into two counts - for both 
sides. Or to eliminate it if possible. We _really_ need to make the 
ring-buffer _much_ cheaper than it is today.
y
	Ingo

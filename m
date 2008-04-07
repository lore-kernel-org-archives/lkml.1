Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbYDGWDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbYDGWDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756278AbYDGWCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:02:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412AbYDGWCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:02:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
X-Fcc: ~/Mail/linus
Cc: frank@exit.com, linux-kernel@vger.kernel.org
Subject: Re: posix-cpu-timers revamp
In-Reply-To: Frank Mayhar's message of  Monday, 7 April 2008 14:31:40 -0700 <1207603900.23968.18.camel@bobble.smo.corp.google.com>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	<20080206165045.89b809cc.akpm@linux-foundation.org>
	<1202345893.8525.33.camel@peace.smo.corp.google.com>
	<alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
	<20080207162203.3e3cf5ab@Varda>
	<alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
	<alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
	<20080207165455.04ec490b@Varda>
	<alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
	<alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
	<1204314904.4850.23.camel@peace.smo.corp.google.com>
	<20080304070016.903E127010A@magilla.localdomain>
	<1204660376.9768.1.camel@bobble.smo.corp.google.com>
	<20080305040826.D0E6127010A@magilla.localdomain>
	<1204830243.20004.31.camel@bobble.smo.corp.google.com>
	<20080311075020.A93DB26F991@magilla.localdomain>
	<1205269507.23124.57.camel@bobble.smo.corp.google.com>
	<20080311213507.5BCDF26F991@magilla.localdomain>
	<1205455050.19551.16.camel@bobble.smo.corp.google.com>
	<20080321071846.1B22B26F9A7@magilla.localdomain>
	<1206122240.14638.31.camel@bobble.smo.corp.google.com>
	<20080322215829.D69D026F9A7@magilla.localdomain>
	<1206380079.21896.20.camel@bobble.smo.corp.google.com>
	<20080331054404.78CDB26F8E9@magilla.localdomain>
	<1206995072.14649.41.camel@bobble.smo.corp.google.com>
	<20080402020707.151E126F8DC@magilla.localdomain>
	<1207158164.11976.32.camel@bobble.smo.corp.google.com>
	<20080402194836.4933026F98A@magilla.localdomain>
	<1207168464.11976.48.camel@bobble.smo.corp.google.com>
	<20080404231739.7E25126F8DC@magilla.localdomain>
	<1207459608.94001.22.camel@jill.exit.com>
	<20080407200804.5541926F992@magilla.localdomain>
	<1207603900.23968.18.camel@bobble.smo.corp.google.com>
Emacs: because idle RAM is the Devil's playground.
Message-Id: <20080407220245.E166126F992@magilla.localdomain>
Date: Mon,  7 Apr 2008 15:02:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is one thing that has been unclear.  The relationship of
> signal_struct to task_struct is, as far as I can tell, an unwritten one.

It's written no less than most of them. ;-)

> While true, that's not the only reason to do it.  The tradeoff here is
> between performance (i.e. having to do checks before dereferencing
> tsk->signal) versus space.  It's really a judgment call.  (Although
> adding 100Kwords does have a bit of weight.)

No, the performance idea there is a myth.  You're talking about one test
and branch-not-taken for a word you're already loading into a register
right there anyway (if testing ->signal).  It's maybe two cycles that were
most likely already idle in a load stall.  The cache effects alone of
pushing parts of task_struct a word further away probably swamp it.

> This isn't exactly how I would state it but yes, this is generally true
> as well.  The problem is that knowing exactly what is "the wrong kinds"
> relies on knowledge possessed by only a few.  Prying that knowledge out
> of you guys can be a chore. :-)

But when it comes out, it's flying at high velocity straight into your face!
Surely that's helpful.

> I guess the key bit of knowledge is that a "task" is really a scheduling
> unit, right?  And, really, from the scheduler's perspective, "task" is
> the same as "thread."  

Yes (and from the general Unix-lingo perspective too).  

> The only thing that makes a set of threads into a multithreaded process
> is that they share a signal struct (well, and their memory map, of
> course).  

There are several other things that are implicitly required to be shared
when signal_struct is shared, too.  But approximately, yes.  Had I been in
charge of the world, task_struct would be 'struct thread' and signal_struct
would be 'struct process'.  (Cue left-field flames from the peanut gallery
about what the words mean and Linux exceptionalism.)

> So a "task" can only be executed on a single cpu at any time, it can't be
> executed on more than one cpu at a time.  Therefore if a "task" is
> executing and is interrupted, the value of "current" at the interrupt
> will be that task, which is entirely suspended for the duration of the
> interrupt.

Correct.

> Unfortunately, these things are often implicit in the code but as far as
> I know aren't written down anywhere.  This whole exercise has been for
> me a process of becoming really familiar with the internals of the Linux
> kernel for the first time.

Everything I know I learned from reading the source.  So I sympathize
with the sense of starting out lost without bearings, but I may be a
little hard-hearted about anyone wanting more than their eyeballs and
full-text searching to find their own bootstraps and pull (in my day,
it was up hill both ways, and all that).


Thanks,
Roland

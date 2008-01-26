Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYAZNIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYAZNIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 08:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYAZNIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 08:08:06 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:62459 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbYAZNIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 08:08:05 -0500
Date: Sat, 26 Jan 2008 08:07:49 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/23 -v6] printk - dont wakeup klogd with interrupts
 disabled
In-Reply-To: <1201341126.27573.20.camel@lappy>
Message-ID: <Pine.LNX.4.58.0801260804230.16244@gandalf.stny.rr.com>
References: <20080126042152.526086719@goodmis.org>  <20080126042801.280369398@goodmis.org>
  <20080126091015.GA1794@elf.ucw.cz> <1201341126.27573.20.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 26 Jan 2008, Peter Zijlstra wrote:
> >
> > I guess you are going to kill me... but
> >
> > CPU0					CPU1
> > if (!runqueue_is_locked()) {
> > 					locks runqueue
> > 	wake_up_klogd
> >
> > ....and we are dead. What is needed here is
> > "wake_up_klogd_if_you_can()" or something, that does trylock (atomic).
> >
> > ....but even this version is better than status quo, I'd say.
>
> Well, if cpu1 holds the lock, and cpu0 wants it, there should only be
> contention, I'm not seeing how this would deadlock.
>
> The deadlock problem was when cpu0 was already holding the rq->lock and
> wants to take it again.

Correct. The only race that this patch has is that there's a slight chance
you wont wake up the klogd when you could.

  CPU0 						CPU1

					locks_runqueue(cpu0)

  if (!runqueue_is_locked())
     [fails and klogd not woken]


But this is rare and pretty harmless. But it can be trivally fixed and
should be. But I'll rename the API to

   current_has_runqueue_lock()

This way we know exactly why it returns what it returns.

-- Steve


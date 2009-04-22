Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZDVNt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZDVNt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZDVNtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:49:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39916 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbZDVNtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:49:16 -0400
Date: Wed, 22 Apr 2009 09:49:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: various bug fixes
In-Reply-To: <20090422114750.GA14202@nowhere>
Message-ID: <alpine.DEB.2.00.0904220943280.24310@gandalf.stny.rr.com>
References: <20090420222257.267399830@goodmis.org> <20090421082354.GC12512@elte.hu> <20090421094616.GA14561@elte.hu> <alpine.DEB.2.00.0904220237330.9714@gandalf.stny.rr.com> <20090422114750.GA14202@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Wed, 22 Apr 2009, Frederic Weisbecker wrote:
> > 
> > I spent the entire day (and half the night) debugging this. I was fighting 
> > a case where the hardirqs_enabled flag in the task struct (lockdep flag) 
> > was mysteriously being set and cleared. I stepped through the entire 
> > kernel thread fork process (that was an exercise) and could not find 
> > anything wrong.
> > 
> > Sometimes it would go away with printk's sometimes it would not. This was 
> > driving me crazy, until I noticed that paravirt was enabled.
> > 
> > Turning off paravirtualization here (so far) makes everything run 
> > smoothly.
> > 
> > Thus my theory is that there's something fishy with the modifying of the 
> > irq enable/disable code when the system detects that it is running on bare 
> > hardware.
> > 
> > I'm too tired to look at this more. Ingo supplied a config to play with. 
> > You can disable VSMP too and it will still trigger the crash.
> > 
> > -- Steve
> > 
> 
> It's indeed a tricky one. I can reproduce it too, I will
> try to manage having an irqsoff trace at this point, hopefully I
> could get the source of this irq disabling...

It doesn't disable interrupts :-/

It is the hardirqs_enabled flag in the task struct that mysteriously turns 
off and back on. I put in printks when it is off in fork, and the next 
printk shows that it turns back on (between the printks!!!).

I printed the output of "irqs_disabled()" on each of these printks and 
interrupts are always enabled. It is only the hardirqs_enabled flag that 
is giving strange outputs.

Do you have CONFIG_PARAVIRT on?  When I disabled it, I have yet to 
reproduce the bug. But I've only rebooted a few times. I'm going to 
continue to reboot to see if I can trigger it.

I'm thinking that the paravirt alternative code may have clobbered a 
register in either the enable or disabling of interrupts. This might cause 
a strange value to go into the hardirqs_enabled flag.

Thanks,

-- Steve


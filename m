Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYAQBka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYAQBka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 20:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYAQBkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 20:40:20 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:34318 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348AbYAQBkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 20:40:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HADZBjkdMROHU/2dsb2JhbACBWJARnE0
Date: Wed, 16 Jan 2008 20:35:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Richard Purdie <rpurdie@rpsys.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
Message-ID: <20080117013511.GA30644@Krystal>
References: <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com> <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com> <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal> <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com> <1200523867.6127.5.camel@localhost.localdomain> <20080116233927.GB23895@Krystal> <alpine.LFD.1.00.0801161649540.2806@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801161649540.2806@woody.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:21:13 up 74 days,  6:26,  5 users,  load average: 0.41, 0.70,
	0.72
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Wed, 16 Jan 2008, Mathieu Desnoyers wrote:
> >
> > > +	int num = !cs->base_num;
> > > +	cycle_t offset = (now - cs->base[!num].cycle_base_last);
> > 
> > !0 is not necessarily 1.
> 
> Incorrect.
> 

Hrm, *digging in my mailbox*, ah, here it is :

http://listserv.shafik.org/pipermail/ltt-dev/2006-June/001548.html

Richard Purdie reviewed my code back in 2006 and made this modification.
Maybe will he have something to add.


> !0 _is_ necessarily 1. It's how all C logical operators work. If you find 
> a compiler that turns !x into anything but 0/1, you found a compiler for 
> another language than C.
> 
> It's true that any non-zero value counts as "true", but the that does not 
> mean that a logical operator can return any non-zero value for true. As a 
> return value of the logical operations in C, true is *always* 1.
> 
> So !, ||, &&, when used as values, will *always* return either 0 or 1 (but 
> when used as part of a conditional, the compiler will often optimize out 
> unnecessary stuff, so the CPU may not actually ever see a 0/1 value, if 
> the value itself was never used, only branched upon).
> 
> So doing "!cs->base_num" to turn 0->1 and 1->0 is perfectly fine.
> 
> That's not to say it's necessarily the *best* way.
> 
> If you *know* that you started with 0/1 in the first place, the best way 
> to flip it tends to be to do (1-x) (or possibly (x^1)).
> 
> And if you can't guarantee that, !x is probably better than x ? 0 : 1, 
> but you might also decide to use ((x+1)&1) for example.
> 
> And obviously, the compiler may sometimes surprise you, and if *it* also 
> knows it's always 0/1 (for something like the source being a single-bit 
> bitfield for example), it may end up doing something else than you coded 
> that is equivalent. And the particular choice of operation the compiler 
> chooses may well depend on the code _around_ that sequence.
> 
> (One reason to potentially prefer (1-x) over (x^1) is that it's often 
> easier to combine a subtraction with other operations, while an xor seldom 
> combines with anything around it)
> 

Ok, I'll adopt (1-x) then. Thanks!

Mathieu

> 		Linus

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

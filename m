Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYAQBGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYAQBGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 20:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYAQBFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 20:05:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49964 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858AbYAQBFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 20:05:53 -0500
Date: Wed, 16 Jan 2008 17:03:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: john stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
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
In-Reply-To: <20080116233927.GB23895@Krystal>
Message-ID: <alpine.LFD.1.00.0801161649540.2806@woody.linux-foundation.org>
References: <20080109233044.777564395@goodmis.org> <20080115214636.GD17439@Krystal> <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com> <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com> <20080116031730.GA2164@Krystal>
 <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal> <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com> <1200523867.6127.5.camel@localhost.localdomain> <20080116233927.GB23895@Krystal>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jan 2008, Mathieu Desnoyers wrote:
>
> > +	int num = !cs->base_num;
> > +	cycle_t offset = (now - cs->base[!num].cycle_base_last);
> 
> !0 is not necessarily 1.

Incorrect.

!0 _is_ necessarily 1. It's how all C logical operators work. If you find 
a compiler that turns !x into anything but 0/1, you found a compiler for 
another language than C.

It's true that any non-zero value counts as "true", but the that does not 
mean that a logical operator can return any non-zero value for true. As a 
return value of the logical operations in C, true is *always* 1.

So !, ||, &&, when used as values, will *always* return either 0 or 1 (but 
when used as part of a conditional, the compiler will often optimize out 
unnecessary stuff, so the CPU may not actually ever see a 0/1 value, if 
the value itself was never used, only branched upon).

So doing "!cs->base_num" to turn 0->1 and 1->0 is perfectly fine.

That's not to say it's necessarily the *best* way.

If you *know* that you started with 0/1 in the first place, the best way 
to flip it tends to be to do (1-x) (or possibly (x^1)).

And if you can't guarantee that, !x is probably better than x ? 0 : 1, 
but you might also decide to use ((x+1)&1) for example.

And obviously, the compiler may sometimes surprise you, and if *it* also 
knows it's always 0/1 (for something like the source being a single-bit 
bitfield for example), it may end up doing something else than you coded 
that is equivalent. And the particular choice of operation the compiler 
chooses may well depend on the code _around_ that sequence.

(One reason to potentially prefer (1-x) over (x^1) is that it's often 
easier to combine a subtraction with other operations, while an xor seldom 
combines with anything around it)

		Linus

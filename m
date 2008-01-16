Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYAPPHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYAPPHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 10:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYAPPGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 10:06:52 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:58880 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbYAPPGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 10:06:50 -0500
Date: Wed, 16 Jan 2008 10:06:40 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
In-Reply-To: <20080116145604.GB31329@Krystal>
Message-ID: <Pine.LNX.4.58.0801161003010.15758@gandalf.stny.rr.com>
References: <20080109232914.676624725@goodmis.org> <20080109233044.777564395@goodmis.org>
 <20080115214636.GD17439@Krystal> <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com>
 <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com>
 <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com>
 <20080116145604.GB31329@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 16 Jan 2008, Mathieu Desnoyers wrote:
> Hrm, I will reply to the rest of this email in a separate mail, but
> there is another concern, simpler than memory ordering, that just hit
> me :
>
> If we have CPU A calling clocksource_accumulate while CPU B is calling
> get_monotonic_cycles, but events happens in the following order (because
> of preemption or interrupts). Here, to make things worse, we would be on
> x86 where cycle_t is not an atomic write (64 bits) :
>
>
> CPU A                  CPU B
>
> clocksource read
> update cycle_mono (1st 32 bits)
>                        read cycle_mono
>                        read cycle_last
>                        clocksource read
>                        read cycle_mono
>                        read cycle_last
> update cycle_mono (2nd 32 bits)
> update cycle_last
> update cycle_acc
>
> Therefore, we have :
> - an inconsistant cycle_monotonic value
> - inconsistant cycle_monotonic and cycle_last values.
>
> Or is there something I have missed ?

No, there's probably issues there too, but no need to worry about it,
since I already showed that allowing for clocksource_accumulate to happen
inside the get_monotonic_cycles loop is already flawed.

>
> If you really want an seqlock free algorithm (I _do_ want this for
> tracing!) :) maybe going in the RCU direction could help (I refer to my
> RCU-based 32-to-64 bits lockless timestamp counter extension, which
> could be turned into the clocksource updater).

I know you pointed me the code, but lets assume that I'm still ignorant
;-)

do you actually use the RCU internals? or do you just reimplement an RCU
algorithm?

-- Steve

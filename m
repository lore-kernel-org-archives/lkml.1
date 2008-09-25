Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbYIYWkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbYIYWkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYIYWj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:39:56 -0400
Received: from gw.goop.org ([64.81.55.164]:51903 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbYIYWjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:39:55 -0400
Message-ID: <48DC1338.6050107@goop.org>
Date: Thu, 25 Sep 2008 15:39:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com> <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com> <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <48DBFC7D.4050208@goop.org> <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> The reason I say "and no" is that it's not technically really possible to 
> atomically give the exact TSC at which the frequency change took place. We 
> just don't have the information, and I doubt we will ever have it.
>   

Well, you don't need the tsc at the precise moment of the frequency
change.  You just need to emit the current tsc+frequency+wallclock time
before you emit any more delta records after the frequency change.  You
can't fetch all those values instantaneously, but you can get close.


> As such, there is no point in trying to make it a low-level special op, 
> because we'd _still_ end up being totally equivalent with just doing as 
> regular trace-event, with a regular TSC field, and then just fill the data 
> field with the new frequency.
>
> But yes, I do think we'd need to have that as a trace packet type. I 
> thought I even said so in my RFC for packet types. Ahh, it was in the 
> follow-up:
>
>   
>> I guess I should perhaps have put the TSC frequency in there in that "case 
>> 2" thing too. Maybe that should be in "data" (in kHz) and tv_sec/tv_nsec 
>> should be in array[0..1], and the time sync packet would be 24 bytes.
>>     
>
> but yes, we obviously need the frequency in order to calculate some kind 
> of wall-clock time (it doesn't _have_ to be in the same packet type as the 
> thing that tries to sync with a real clock, but it makes sense for it to 
> be there.
>   

Yeah.  If you ever mention wallclock time in the event stream, you have
to tie it to your local timebase (tsc+frequency) to make the whole thing
fit together.

> That said, if people think they can do a good job of ns conversion, I'll 
> stop arguing. Quite frankly, I think people are wrong about that, and 
> quite frankly, I think that anybody who looks even for one second at those 
> "alternate" sched_clock() implementations should realize that they aren't 
> suitable, but whatever. I'm not writing the code, I can only try to 
> convince people to not add the insane call-chains we have now.

Yeah.  Unfortunately, in the virtual case - unless you're virtualizing
the tsc itself, which is horrible - you can't really control or measure
how the tsc is going to behave, because its all under the hypervisor's
control.  A "cpu" could be migrated between different physical cpus, the
whole machine could be migrated between hosts, or suspended, etc, making
it very hard to use the naked tsc.  In that case the only real option is
to use a hypervisor-supplied timebase (which for Xen and KVM is a
tsc-based scheme exactly like we've been discussing, except the
hypervisor provides the tsc timing parameters).

asm/x86/kernel/pvclock.c does the tsc to ns conversion with just adds
and multiplies, but unfortunately it can't be expressed in C because it
uses the extra precision the x86 gives for multiplies.

    J

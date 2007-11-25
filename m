Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbXKYKD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbXKYKD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 05:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXKYKDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 05:03:18 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:31111 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752031AbXKYKDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 05:03:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=a9N7du+Y8RB4US/bfySwdRwK/o/zT3Gae+0t/VmG68Jw7Kt3mzP64QcmRczbsXCM7zwDePHKoKh6kM/+BD7Wbl3Lz0m5gUzhwySveXVI2xDOsnQAuTwbMIzeCdKY8YP/FBS021OvApqiaBDY/WxS4xC4FPVrthf5LT30VZ9ruA4=  ;
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Date: Sun, 25 Nov 2007 21:03:08 +1100
User-Agent: KMail/1.9.5
Cc: Arjan van de Ven <arjan@infradead.org>, Mark Lord <lkml@rtr.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <47425EA5.7000607@rtr.ca> <200711221854.15516.nickpiggin@yahoo.com.au> <20071123130952.GA6320@elte.hu>
In-Reply-To: <20071123130952.GA6320@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711252103.09103.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 November 2007 00:09, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > Ahh, hate to get off topic, but let's not perpetuate this myth. It
> > wasn't Con, or CFS, or anything that showed fairness is some great new
> > idea. Actually I was arguing for fairness first, against both Con and
> > Ingo, way back when the old scheduler was having so much problems.
> >
> > Not that I am trying to claim the idea for myself. Fairness is like
> > the most fundamental and obvious behaviour for any sort of resource
> > scheduler that I have to laugh when people get "credited" with this
> > idea.
>
> just out of curiosity (and to get my own sense of history corrected), do
> you remember in which thread you said that? (and even better, could you
> dig out any URLs for that thread?)

No, I have no idea except for the vague talking pictures in my noggin ;)
"nicksched", maybe? Or Con's patches on the old scheduler (around 2.6.0
time, was it?)


> btw., the question was never really whether fairness was a good idea for
> a resource scheduler - the question was whether _strict fairness_ was a
> good idea for a general purpose OS (and the desktop in particular). My
> point back then was that strict fairness is not good enough and that we
> thus need the interactivity estimator - and i still maintain the first
> half of that position while conceding that i was wrong about the second
> part :-)

I'm not sure what you mean by strict fairness. Obviously there are
fundamental points where you have to make some heuristic choice about
priority -- process creation/destruction, and sleep patterns in
particular. So yes, you do need decaying priority.

But if all that is applied consistently, it shouldn't be possible for
a process to get more CPU time than another of the same (or more)
demand, over a given period.


> I dont think anyone was arguing for a scheduler with no fairness at all
> - but "fairness" indeed was more of an after-thought, not the driving
> principle.

And actually it was systemically unfair by design ;) That's where
most the bad behavioural corner cases came in.


> Current CFS uses a modified "sleeper fairness" model (not a strict
> fairness model) via which we in essence replace the effect of the
> interactivity estimator with "sleeper fairness". So in essence we've
> replaced the O(1) scheduler's sleep average code with a deterministic
> sleep average code. This in turn also made the allocation of CPU time
> deterministic throughout. (which in other words can also be called "fair
> allocation of CPU time")

Yeah, it's OK I guess. I think it is quite complex -- you're dealing
with a complete heuristic anyway, so while the equations may look nice,
I don't actually know what justifies the equations themselves (not that
*any* scheduler can be completely justified in that way, but...). But
at least there is fairness and some rationale for it.

Nicksched had what I'd call a deterministic sleep average code too
(though much simpler). The big problem it had was that it also had
to scale timeslices back when there were high priority processes on
the runqueue in order to keep latency down while retaining O(1)
scheduling. It was hard or impossible to do exactly right. It would
have been easy with an O(lgn) data structure, though :P


> _That_ scheme seems to behave rather well in practice and i think i can
> take credit for _that_ bit ;-) [many people have hacked upon that
> concept and code since then so it's nowhere near "my code" anymore, of
> course.]

I found that just doing something relatively sane (eg. a simple, fair,
decaying priority system) that doesn't violate the principle of least
surprise (ie. that unix apps and programmers have expected over the
years) has resulted in good behaviour.

I don't really know about taking credit for ideas. Probably your exact
algorithm is unique, but there is a lot of research on CPU schedulers
I have never reviewed, so I can't say. Still, if you came up with it
independently, I guess that is the main thing for one's ego ;)

Still, what I can say with at least one counterexample is that fairness
is not a new concept (curious: wasn't the 2.4 scheduler fair?).

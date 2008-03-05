Return-Path: <linux-kernel-owner+w=401wt.eu-S1762671AbYCENGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762671AbYCENGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764353AbYCENGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:06:09 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:23273 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757907AbYCENGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:06:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=isny6OTXODx47Cuvg1lOKenGFWcX3emLfHLmqH7KCcEFv+MrQkmE2uuWnhg2gsKV7qGtkNhRsbxs9uEaxyNliKgptQ4z/ofOsr+oiEzsxKnV5Zn/gQbSNWUqW9lKdKGrT/Re0fghPMHRnUvrTZbCQYQLSLnr5NIxqgOcnWAN0wY=  ;
X-YMail-OSG: Q8yo.RcVM1kaC2CpWICLIDeCGujU3DQHTGvnzxtP9kslU7n0b5OkMsXT1IH6p9V65DNm6iwiww--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Remy Bohmer" <linux@bohmer.net>
Subject: Re: [PATCH] atmel_tc clocksource/clockevent code
Date: Wed, 5 Mar 2008 05:06:03 -0800
User-Agent: KMail/1.9.6
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>, akpm@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Nicolas Ferre" <nicolas.ferre@rfo.atmel.com>,
       "Andrew Victor" <linux@maxim.org.za>,
       "john stultz" <johnstul@us.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <1204636061-6275-1-git-send-email-hskinnemoen@atmel.com> <200803041247.50877.david-b@pacbell.net> <3efb10970803050317k68da7154w334561cc5efed637@mail.gmail.com>
In-Reply-To: <3efb10970803050317k68da7154w334561cc5efed637@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803050506.04291.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2008, Remy Bohmer wrote:
> Hello David,
> 
> > Could you elaborate on where that 50-100 usec gets spent?
> 
> Attached I have put a screendump of my ETM debugger. It shows a
> complete flow of kernel function-calls of what happens on a timer
> interrupt. In this example the complete sequence takes about 154 us.

Thanks -- this is quite informative.  (Presumably it'd look similar
using NO_HZ too:  hardly any overhead is hardware-specific.)

An ETM trace is really nice for this kind of stuff; it'd be nice
if such tech were more widely available!  (Built into most ARM cores
and all that ... but the hardware and software tools to access the
data aren't as available.)  


> Notice that the ETM is non-intrusive, and that the times are real and
> accurate in this trace. (you can even see the effects of CPU-caches,
> sometimes the same code just runs faster)

Yeah, the intrusive schemes (like automatic probe insertion) perturb
timings at this level.


> > Does the same issue happpen with the $SUBJECT patch (if you tweak the
> >  clocksource ratings to use its clockevents on rm9200)?
> 
> not tested yet, but I will generate a trace for it, I will post it later.

Based on how little of that time was spent in the rm9200 clockevent
code -- I'll be generous and call it 10 usec -- I'd can't imagine that
could make much of a real difference.


> There is more to it than just the genIRQ mechanism. The softirqs are
> kicked, the scheduler is triggered and so on. It is a waterfall of
> events that happen, just by having a timer interrupt.

Right.


> > Should the min_delta_ns be increased in at91rm9200_time.c then?
> 
> Maybe it should be configurable for these kinds of CPUs?

It shouldn't require tweaking individual clockevent devices, or
IMO be specific to e.g. lower powered CPUs ... but a global
min_delta_ns would be easy to implement, and might help.

That'd resemble what the init_timer_deferrable() mechanism
achieves, but the scale for bunching timers would be fine
not coarse.


> Notice that I also fell in this pitfall while using HRT, and I only
> wanted an application that made a 1ms accurate timer... Other
> processes/daemons in the system also uses timers, which eventually
> resulted in intervals in the sub-millisec range, and thus due to the
> overhead that will bring tot the system, the CPU-load just goes
> sky-high, doing actually nothing really special.

In your case, maybe a global min_delta_ns of 1000 * 1000 would
help ... combine with NO_HZ and you'd get the accuracy you need,
with reduced scheduling overhead.  Sound about right?

- Dave


> So, hires timestamps -> really really welcome.
> hires timers -> there should be a (configurable) minimal resolution
> that fits the hardware to not overload the CPU.
> 
> >  Right now, as you probably recall, it's at the lowest value
> >  needed for correctness:  a smidgeon over two ticks (~ 72 nsec).
> 
> I remember...
> 
> Kind Regards,
> 
> Remy
> 


